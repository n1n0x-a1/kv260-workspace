# KubeEdge Hardware & Device Twin Integration Guide

This guide details how to model the Kria KV260 FPGA hardware overlays (bitstreams) and DPU/Vitis-AI application states using **KubeEdge Device Twins** and Custom Resource Definitions (CRDs).

---

## 1. Custom Resource Definitions (CRDs)

In KubeEdge, devices are declared as Kubernetes resources. We define a **DeviceModel** representing the KV260 capabilities, and a **DeviceInstance** representing the physical board.

### Step 1: Define the Device Model (`device-model.yaml`)
This file defines the properties we want to control (like `active-bitstream` and `running-model`):

```yaml
apiVersion: devices.kubeedge.io/v1alpha2
kind: DeviceModel
metadata:
  name: kv260-smartplatform-model
  namespace: default
spec:
  properties:
    - name: active-bitstream
      description: "The name of the currently active FPGA bitstream loaded via xmutil"
      type:
        string:
          accessMode: ReadWrite
          defaultValue: "kv260-ispMipiRx_vcu_DP"
    - name: running-model
      description: "The name of the Vitis-AI model running on the DPU (e.g. resnet18, yolov3)"
      type:
        string:
          accessMode: ReadWrite
          defaultValue: "resnet18"
```

### Step 2: Define the Device Instance (`device-instance.yaml`)
This instantiates the KV260 device and links it to our edge node:

```yaml
apiVersion: devices.kubeedge.io/v1alpha2
kind: DeviceInstance
metadata:
  name: kv260-board-01
  namespace: default
spec:
  deviceModelRef:
    name: kv260-smartplatform-model
  nodeSelector:
    nodeName: worker # The KubeEdge node name of your KV260
status:
  twins:
    - propertyName: active-bitstream
      desired:
        value: "kv260-ispMipiRx_vcu_DP"
      reported:
        value: "kv260-ispMipiRx_vcu_DP"
    - propertyName: running-model
      desired:
        value: "resnet18"
      reported:
        value: "resnet18"
```

Apply these files on the Master Node:
```bash
$ kubectl apply -f device-model.yaml
$ kubectl apply -f device-instance.yaml
```

---

## 2. The KubeEdge EventBus (MQTT)

`edgecore` runs an internal MQTT broker (EventBus) on the KV260. The Device Twin updates are published to local MQTT topics.
By subscribing to these topics, we can listen for desired changes (e.g., a request to change the bitstream) and execute them.

### MQTT Topic Patterns
* **Update Twin Desired State (Cloud -> Edge)**:
  `$hw/events/device/<device_id>/twin/update/document`
* **Update Twin Reported State (Edge -> Cloud)**:
  `$hw/events/device/<device_id>/twin/update`

---

## 3. Creating a Custom Python Mapper

We can write a lightweight Python mapper running on the KV260 that listens to the local MQTT broker, calls `xmutil` to load the requested bitstream, and updates the reported status back to the cloud.

### `kv260-mapper.py`
```python
import json
import subprocess
import paho.mqtt.client as mqtt

DEVICE_ID = "kv260-board-01"
MQTT_BROKER = "127.0.0.1"
MQTT_PORT = 1883

def load_bitstream(bitstream_name):
    print(f"[Mapper] Loading FPGA Bitstream: {bitstream_name}")
    try:
        # 1. Unload current bitstream
        subprocess.run(["xmutil", "unloadapp"], check=True)
        # 2. Load requested bitstream
        subprocess.run(["xmutil", "loadapp", bitstream_name], check=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"[Error] Failed to load bitstream: {e}")
        return False

def on_connect(client, userdata, flags, rc):
    print("[Mapper] Connected to EdgeCore EventBus.")
    # Subscribe to twin updates
    client.subscribe(f"$hw/events/device/{DEVICE_ID}/twin/update/document")

def on_message(client, userdata, msg):
    try:
        payload = json.loads(msg.payload.decode('utf-8'))
        print(f"[Mapper] Received update document: {payload}")
        
        # Check if desired state contains 'active-bitstream'
        twin = payload.get("twin", {})
        bitstream_twin = twin.get("active-bitstream", {})
        desired_bitstream = bitstream_twin.get("desired", {}).get("value")
        reported_bitstream = bitstream_twin.get("reported", {}).get("value")
        
        if desired_bitstream and desired_bitstream != reported_bitstream:
            # Action: swap bitstream
            success = load_bitstream(desired_bitstream)
            
            if success:
                # Report back new state to Cloud
                report_payload = {
                    "event_id": "",
                    "timestamp": 0,
                    "twin": {
                        "active-bitstream": {
                            "actual": {
                                "value": desired_bitstream
                            },
                            "metadata": {
                                "type": "updated"
                            }
                        }
                    }
                }
                client.publish(
                    f"$hw/events/device/{DEVICE_ID}/twin/update",
                    json.dumps(report_payload)
                )
                print(f"[Mapper] Reported state updated to: {desired_bitstream}")
    except Exception as e:
        print(f"[Mapper] Error handling message: {e}")

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_forever()
```

---

## 4. Declaring State Changes natively via `kubectl`

Once the mapper is running on the KV260, you no longer need the custom socket command execution. You can patch the Device Twin directly from standard Kubernetes:

```bash
# Update the desired bitstream state
kubectl patch deviceinstance kv260-board-01 --type merge -p '{"status":{"twins":[{"propertyName":"active-bitstream","desired":{"value":"custom-dpu-overlay"}}]}}'
```

KubeEdge will synchronize this desired state down to `edgecore`, the Python mapper will catch the MQTT message, execute `xmutil loadapp custom-dpu-overlay`, and update the reported state in Kubernetes automatically.
