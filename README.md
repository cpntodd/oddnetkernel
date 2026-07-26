# oddnetkernel

Custom Linux kernel builds with Zen patches for Debian 13 (Trixie).

## Current Build: `7.1.5-zen1-oddnetkernel-zen`

- **Base:** Linux 7.1.5
- **Patches:** Zen kernel v7.1.5-zen1
- **Compiler:** Clang 21.1.8 (LLVM 21)
- **Linker:** LLD 21.1.8
- **Target:** AMD Ryzen 5 2600 (Zen+) — x86_64
- **Preemption:** PREEMPT_DYNAMIC (PREEMPT_LAZY)
- **Scheduler:** EEVDF
- **Tick rate:** 1000Hz

## Features
- CIFS/SMB client & server support
- AMDGPU (RX 470/480/570/580/590)
- Realtek r8169 Gigabit Ethernet
- KVM virtualization
- Btrfs, XFS, NTFS3, exFAT, OverlayFS
- NFS client & server
- WireGuard
- Bridge/VXLAN networking
- All Debian 13 base modules

## Build Instructions

```bash
# Clone the zen-kernel source
git clone --depth 1 --branch v7.1.5-zen1 https://github.com/zen-kernel/zen-kernel.git linux-7.1.5

# Copy this config
cp config-7.1.5-zen1-oddnetkernel-zen linux-7.1.5/.config

# Install build dependencies (Debian)
sudo apt install clang-21 lld-21 llvm-21 build-essential flex bison \
  libelf-dev libssl-dev libncurses-dev bc rsync cpio dwarves

# Build with Clang
cd linux-7.1.5
export PATH="/usr/lib/llvm-21/bin:$PATH"
make LLVM=1 olddefconfig
make LLVM=1 -j$(nproc)

# Install
sudo make modules_install
sudo cp arch/x86/boot/bzImage /boot/vmlinuz-7.1.5-zen1-oddnetkernel-zen
sudo cp System.map /boot/System.map-7.1.5-zen1-oddnetkernel-zen
sudo cp .config /boot/config-7.1.5-zen1-oddnetkernel-zen
sudo update-initramfs -c -k 7.1.5-zen1-oddnetkernel-zen
sudo update-grub
```

## Hardware
- **CPU:** AMD Ryzen 5 2600 (6C/12T, Zen+)
- **GPU:** AMD Radeon RX 570/580 (Ellesmere/Polaris)
- **NIC:** Realtek RTL8111/8168/8411 Gigabit Ethernet
- **Storage:** NVMe + SATA SSD
- **Motherboard:** ASUS (WMI)

## Previous Builds
- 7.1.3-custom-zen (GCC 14.2.0)
