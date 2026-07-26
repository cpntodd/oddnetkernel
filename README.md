# ⚡ oddnetkernel

**Oddsoul's custom Linux kernel — tuned to squeeze maximum performance from AMD Zen/Polaris hardware on Debian.**

Built from mainline Linux with Zen-kernel interactive tuning patches and compiled with Clang 21 + LLD. Every option is chosen with one goal: make a Ryzen desktop running Debian feel as responsive and fast as the silicon allows.

---

## INSTALL

**Debian 13 (Trixie):**

```bash
curl -s 'https://raw.githubusercontent.com/cpntodd/oddnetkernel/master/install-oddnetkernel.sh' | sudo bash
```

Or manually:

```bash
# Add the apt repo
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://cpntodd.github.io/oddnetkernel/oddnetkernel-archive-keyring.gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/oddnetkernel-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/oddnetkernel-archive-keyring.gpg] https://cpntodd.github.io/oddnetkernel/repo stable main' | \
    sudo tee /etc/apt/sources.list.d/oddnetkernel.list
sudo apt update
sudo apt install 'linux-image-*-oddnetkernel-zen' 'linux-headers-*-oddnetkernel-zen'
sudo reboot
```

---

## MAJOR FEATURES

### 🧠 Zen Interactive Tuning
Zen-kernel patchset tunes the kernel for desktop responsiveness — process scheduling, memory reclaim, I/O, and CPU frequency scaling are all adjusted to favor low-latency interactivity over throughput.

### 🎯 AMD Zen+ / Polaris Optimized
Built on and for AMD hardware: Ryzen 5 2600 (Zen+) CPU and Radeon RX 570/580 (Polaris/Ellesmere) GPU. Kernel configured with full `amdgpu` driver, Southern Islands (SI) and Sea Islands (CIK) support, and Display Core (DC) for HDMI/DP audio.

### ⚙️ Performance Tuning

| Setting | Value |
|---|---|
| **CPU Scheduler** | EEVDF (Earliest Eligible Virtual Deadline First) |
| **Preemption** | `PREEMPT_DYNAMIC` — lazy preemption for desktop |
| **Timer tick** | 1000 Hz — low-jitter scheduling |
| **I/O Scheduler** | mq-deadline (multiqueue-aware) |
| **TCP Congestion** | CUBIC |

### 🔧 Built with Clang 21 + LLD
Compiled with LLVM/Clang 21.1.8 and linked with LLD 21 — producing a thinner, faster-linking kernel than GCC builds.

### 📦 Broad Hardware & Filesystem Support

| Category | What's Included |
|---|---|
| **Filesystems** | CIFS/SMB, Btrfs, XFS, NTFS3, exFAT, OverlayFS, NFS client & server |
| **Networking** | WireGuard, Bridge, VXLAN |
| **Virtualization** | KVM, VIRTIO |
| **GPU** | AMDGPU (RX 400/500 series, SI, CIK, DC) |
| **Network** | Realtek r8169 (built-in) |
| **Storage** | NVMe (built-in), SATA |
| **Debian base** | All expected Debian 13 modules included |

---

## Current Build: `7.1.5-zen1-oddnetkernel-zen`

| | |
|---|---|
| **Base** | Linux 7.1.5 |
| **Patches** | Zen kernel v7.1.5-zen1 |
| **Compiler** | Clang 21.1.8 (LLVM 21) |
| **Linker** | LLD 21.1.8 |
| **Hardware** | AMD Ryzen 5 2600, Radeon RX 570/580, RTL8111 NIC, NVMe |
| **OS target** | Debian 13 (Trixie), amd64 |

---

## Building from Source

```bash
# Clone zen-kernel
git clone --depth 1 --branch v7.1.5-zen1 https://github.com/zen-kernel/zen-kernel.git

# Copy config
cp config-7.1.5-zen1-oddnetkernel-zen linux-7.1.5/.config

# Build deps (Debian)
sudo apt install clang-21 lld-21 llvm-21 build-essential flex bison \
  libelf-dev libssl-dev libncurses-dev bc rsync cpio dwarves

# Build as .deb packages
cd linux-7.1.5
export PATH="/usr/lib/llvm-21/bin:$PATH"
make LLVM=1 olddefconfig
make LLVM=1 bindeb-pkg -j$(nproc)
# Packages appear in ../
```

---

## Release History

| Version | Kernel | Date | |
|---|---|---|---|
| [v1](https://github.com/cpntodd/oddnetkernel/releases/tag/v1) | 7.1.5-zen1 | 2026-07-26 | Clang 21, initial release |


## Previous Builds
- 7.1.3-custom-zen (GCC 14.2.0)
