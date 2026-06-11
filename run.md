# Running the KV260 Yocto/PetaLinux Build Environment

### 1. Build the Docker Image

First, build the Docker image from the `Dockerfile` we created. Run this from your workspace directory:

```bash
cd /home/syvesdh/NinoxWorkspace/kv260-workspace
docker build -t kv260-build-env:24.04 .
```

### 2. Run the Container

Next, run the container. It's highly recommended to map your actual workspace into the container at the **exact same path**. This prevents absolute path issues with Yocto's shared state (sstate-cache) and BitBake.

*Note: Since you already have a container named `kv260-builder` running, we will call this one `kv260-yocto-env`, or you can remove the old one using `docker rm -f kv260-builder`.*

```bash
docker run -it \
  --name kv260-yocto-env \
  --net host \
  --security-opt seccomp=unconfined \
  -v $(pwd):$(pwd) \
  -v ~/Downloads:/home/syvesdh/Downloads \
  kv260-build-env:24.04 /bin/bash
```

**Explanation of arguments:**
- `--name kv260-yocto-env`: Names the container so you can easily restart and re-attach to it later.
- `--net host`: Uses the host's network stack (good for fetching git repos and resolving internal addresses during bitbake).
- `--security-opt seccomp=unconfined`: **CRITICAL FOR YOCTO.** Allows `pseudo` (fakeroot) to use the `clone3` syscall without being blocked by Docker. Without this, BitBake will fail with a "Broken pipe" error.
- `-v /home/syvesdh/NinoxWorkspace/...`: Mounts your workspace directly into the container at the *exact same path*.
- `-v ~/Downloads:...`: Mounts your host's Downloads folder, just in case you need installers or tarballs.

### 3. Re-attaching to the Container

If you exit the container, it will stop. You can restart and re-attach to it without creating a new one:

```bash
docker start kv260-yocto-env
docker exec -it kv260-yocto-env /bin/bash
```

### 4. Running the Build

Once you are inside the container's shell (`root@...` or `syvesdh@...`), you need to navigate to the Yocto directory, source the build environment, and run the `bitbake` command.

Based on your project documentation, here are the exact commands:

```bash
# 1. Navigate to your yocto directory
cd /home/syvesdh/NinoxWorkspace/kv260-workspace/yocto-xilinx/kv260-yocto

# 2. Source the environment setup script (this drops you into the build directory)
source poky/oe-init-build-env poky/build

# 3. Start the build
bitbake petalinux-image-minimal
```

*Note: The first build will take several hours as it downloads and compiles the entire OS and all dependencies. Subsequent builds will be much faster because of the sstate-cache.*
