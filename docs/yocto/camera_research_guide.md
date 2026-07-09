# Kria KV260 Camera Connectivity, Local Display, and Network Streaming Guide

This guide details the physical setup, Linux driver verification, local DisplayPort/HDMI output, and network video streaming options for the **Xilinx Kria KV260 Vision AI Starter Kit** using the **AR1335 IAS Camera Module** (depicted in your hardware photo).

---

## 1. Physical Camera Connection

The camera module pictured is the **ON Semiconductor AR1335 IAS Camera Sensor** (typically included in the Kria KV260 Starter Kit).

### How to Connect
1. **Power Off the Board:** Always ensure the 12V power adapter is disconnected from the KV260 before handling the flex ribbon cables to prevent shorting pins.
2. **Locate the IAS 0 Connector (`J10`):** This connector is situated directly on the main board carrier, labeled as **IAS 0** (right next to the 12V-IN jack).
3. **Align and Press:** Align the ribbon connector of the camera module with the `IAS 0` socket. Guide the plastic alignment pegs on the board through the holes of the camera’s flex PCB. Gently press the connector straight down until it snaps securely into place.
4. **Alternative Connectors:**
   - **IAS 1 (`J9`):** Secondary IAS sensor slot.
   - **Raspberry Pi Camera Header (`J11`):** The 15-pin FPC connector on the edge of the board.
   - **USB Ports:** Standard UVC-compliant USB Webcams can be plugged into any of the four USB 3.0 Type-A ports.

---

## 2. Software Connection Verification (On the KV260 Board)

Once booted, the board uses the **Media Controller Framework** and **V4L2 (Video for Linux 2)** subdevices to manage the MIPI CSI-2 receiver, hardware ISP, and camera sensors.

### Step 1: Verify Linux Device Nodes
List all video and media control nodes:
```bash
ls -la /dev/video* /dev/media* /dev/v4l-subdev*
```

### Step 2: Query the Media Topology
Run `media-ctl` to print the hardware media pipeline topology. This verifies that the `ar1335` sensor driver is active and linked to the Xilinx ISP:
```bash
media-ctl -p -d /dev/media1
```
*Note: In some OS images, the media controller device could be `/dev/media0`. If one fails, try the other.*

### Step 3: Query V4L2 Device Details
Verify the active formats and capabilities of the video capture device (typically `/dev/video0` or `/dev/video1` linked to the capture interface):
```bash
v4l2-ctl -d /dev/video0 --list-formats-ext
```

---

## 3. Displaying Feed Natively on the Local Monitor (DP/HDMI)

The KV260 uses the Linux **DRM/KMS (Direct Rendering Manager / Kernel Mode Setting)** driver (`xlnx`) to output frames directly to the DisplayPort or HDMI monitor.

### Step 1: Probe Display Resources
To query the connected display, run `modetest` inside the container or host system:
```bash
modetest -M xlnx
```
Check the output for:
* **Connectors:** Identify the connector marked `connected` (e.g. `DP-1` with ID `45`).
* **CRTCs:** Identify the active display controller (e.g. ID `43`).
* **Planes:** Identify the display overlay plane IDs (e.g., primary plane `41` or overlay plane `39`).

### Step 2: Configure the Display Resolution
Configure the connector to display at a specific resolution (e.g., 1080p at 60Hz):
```bash
# syntax: modetest -M xlnx -s <connector-id>:<width>x<height>@<refresh-rate>
modetest -M xlnx -s 45:1920x1080@60
```

### Step 3: Run the Local GStreamer Display Pipeline
Capture the camera input using Xilinx's specialized `mediasrcbin` plugin (which wraps V4L2 and ISP configurations) and send it directly to the screen using `kmssink`:
```bash
gst-launch-1.0 mediasrcbin media-device=/dev/media1 ! \
  'video/x-raw, width=1920, height=1080, format=NV12, framerate=30/1' ! \
  queue ! \
  kmssink connector-id=45 plane-id=39 sync=false
```

---

## 4. Streaming Camera Data Over the Network

To display the camera feed onto the **Developer Workstation (Host Monitor)** over the local network, you must compress the video data (using the KV260's hardware-accelerated **VCU** H.264/H.265 encoders) and stream it using GStreamer.

### Option A: Unicast UDP / RTP Streaming (Simplest, Lowest Latency)

This method packages the compressed video into RTP packets and streams them directly to the developer workstation's IP address.

#### 1. Command to Run on the KV260 Board:
Replace `<developer-ip>` with the IP address of your workstation (e.g. `192.168.123.210` or your laptop's IP):
```bash
gst-launch-1.0 mediasrcbin media-device=/dev/media1 ! \
  'video/x-raw, width=1920, height=1080, format=NV12, framerate=30/1' ! \
  omxh264enc target-bitrate=4000 control-rate=low-latency gop-length=30 ! \
  'video/x-h264, profile=high' ! \
  rtph264pay ! \
  udpsink host=<developer-ip> port=5000 sync=false
```

#### 2. Command to Run on the Developer Workstation (Host Monitor):
On your workstation (assuming it has GStreamer installed), run the receiver pipeline:
```bash
gst-launch-1.0 udpsrc port=5000 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! \
  rtph264depay ! \
  h264parse ! \
  decodebin ! \
  autovideosink sync=false
```
*(Alternatively, you can save the incoming stream on the host or open the SDP network configuration in VLC).*

---

### Option B: RTSP Streaming (Standard Multi-Client Delivery)

RTSP creates a server on the KV260. The workstation pulls the feed dynamically.

#### 1. Start the RTSP Server on the KV260:
The reference VVAS smartcam application includes an embedded RTSP server. Using the command line interface or standard GStreamer RTSP Server:
```bash
# Inside the KV260 container, run the application configured for RTSP streaming output
./smart_model_select ...
```
Alternatively, launching a quick `test-launch` script using the hardware VCU encoder:
```bash
./test-launch "( mediasrcbin media-device=/dev/media1 ! video/x-raw,width=1920,height=1080,format=NV12,framerate=30/1 ! omxh264enc target-bitrate=4000 ! rtph264pay name=pay0 pt=96 )"
```

#### 2. View the Feed on the Developer Workstation:
* **Using VLC Media Player:** Open Network Stream and enter `rtsp://192.168.123.112:8554/test`.
* **Using GStreamer:**
  ```bash
  gst-launch-1.0 rtspsrc location=rtsp://192.168.123.112:8554/test latency=100 ! \
    rtph264depay ! \
    h264parse ! \
    decodebin ! \
    autovideosink
  ```

---

## 5. Summary Reference Table

| Goal | GStreamer Element / Command | Hardware Block Used | Key Parameters / Options |
|:---|:---|:---|:---|
| **Capture Input** | `mediasrcbin` | MIPI CSI-2 Rx, ISP | `media-device=/dev/media1`, `format=NV12` |
| **Local Output** | `kmssink` | DisplayPort Controller (DP/HDMI) | `connector-id`, `plane-id` (from `modetest`) |
| **VCU Compression**| `omxh264enc` or `omxh265enc` | Video Codec Unit (VCU) | `target-bitrate=4000`, `control-rate=low-latency` |
| **Network Send** | `udpsink` / `rtph264pay` | PS Gigabit Ethernet | `host=<target-ip>`, `port=5000` |
| **Network Receive**| `udpsrc` / `autovideosink` | Developer Host Workstation | Set `caps` matching the sender payloader |
