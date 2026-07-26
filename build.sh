#!/bin/bash
# oddnetkernel build script
# Builds Linux 7.1.5 with Zen patches using Clang 21
set -e

KERNEL_VERSION="7.1.5"
ZEN_TAG="v${KERNEL_VERSION}-zen1"
LOCALVERSION="-oddnetkernel-zen"
FULL_VERSION="${KERNEL_VERSION}-zen1${LOCALVERSION}"
JOBS=$(nproc)

echo "=== oddnetkernel build script ==="
echo "Version: ${FULL_VERSION}"
echo "Jobs: ${JOBS}"
echo

# Check for Clang
if ! command -v clang-21 &>/dev/null; then
    echo "ERROR: clang-21 not found. Install: sudo apt install clang-21 lld-21 llvm-21"
    exit 1
fi

export PATH="/usr/lib/llvm-21/bin:$PATH"

# Clone Zen kernel if not present
if [ ! -d "linux-${KERNEL_VERSION}" ]; then
    echo "Cloning Zen kernel ${ZEN_TAG}..."
    git clone --depth 1 --branch "${ZEN_TAG}" https://github.com/zen-kernel/zen-kernel.git "linux-${KERNEL_VERSION}"
fi

cd "linux-${KERNEL_VERSION}"

# Copy config
if [ -f "../config-${FULL_VERSION}" ]; then
    cp "../config-${FULL_VERSION}" .config
    echo "Using saved config: config-${FULL_VERSION}"
else
    echo "WARNING: No saved config found, using current system config"
    cp /boot/config-$(uname -r) .config 2>/dev/null || { echo "No config available"; exit 1; }
fi

# Update config for new kernel
make LLVM=1 olddefconfig

# Build
echo "Building kernel ${FULL_VERSION}..."
make LLVM=1 -j${JOBS}

# Install modules
echo "Installing modules..."
sudo make modules_install

# Install kernel
echo "Installing kernel to /boot..."
sudo cp arch/x86/boot/bzImage /boot/vmlinuz-${FULL_VERSION}
sudo cp System.map /boot/System.map-${FULL_VERSION}
sudo cp .config /boot/config-${FULL_VERSION}

# Update initramfs and GRUB
echo "Generating initramfs..."
sudo update-initramfs -c -k ${FULL_VERSION}
echo "Updating GRUB..."
sudo update-grub

echo
echo "=== Build complete: ${FULL_VERSION} ==="
echo "Reboot to use the new kernel."
