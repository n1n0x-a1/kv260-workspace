# 1. Reset KubeEdge (using the correct --force flag) & clean config
keadm reset --force || true
rm -rf /etc/kubeedge/

# 2. Mount cgroups (Yocto environment)
mkdir -p /sys/fs/cgroup
mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup 2>/dev/null || true
for sys in $(awk '!/^#/ { if ($4 == 1) print $1 }' /proc/cgroups); do
  mkdir -p /sys/fs/cgroup/$sys
  mount -t cgroup -o $sys cgroup /sys/fs/cgroup/$sys 2>/dev/null || true
done

# 3. Sync time to prevent TLS handshake failures
ntpd -q -g -p pool.ntp.org || date -s "2026-06-12 10:30:00"

# 4. Install & configure CNI plugins (ARM64)
mkdir -p /opt/cni/bin
cp -r /usr/lib/cni/* /opt/cni/bin/ 2>/dev/null || true
cp -r /usr/libexec/cni/* /opt/cni/bin/ 2>/dev/null || true
if [ ! -f /opt/cni/bin/bridge ]; then
  wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-arm64-v1.1.1.tgz
  tar -xzvf cni-plugins-linux-arm64-v1.1.1.tgz -C /opt/cni/bin
fi

mkdir -p /etc/cni/net.d
cat >/etc/cni/net.d/10-containerd-net.conflist <<EOF
{
  "cniVersion": "1.0.0",
  "name": "containerd-net",
  "plugins": [
    {
      "type": "bridge",
      "bridge": "cni0",
      "isGateway": false,
      "ipMasq": false,
      "ipam": {
        "type": "host-local",
        "ranges": [
          [{"subnet": "10.88.0.0/16"}]
        ],
        "routes": [
          {"dst": "0.0.0.0/0"}
        ]
      }
    }
  ]
}
EOF

# 5. Restart containerd to apply CNI & cgroup mounts
killall containerd 2>/dev/null || true
sleep 1
containerd &
sleep 2

# 6. Create systemd configuration placeholder directory
mkdir -p /etc/systemd/system


