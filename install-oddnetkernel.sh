#!/bin/bash
# oddnetkernel install script
# Adds the oddnetkernel apt repo and installs the kernel
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()  { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

REPO_URL="https://cpntodd.github.io/oddnetkernel"
KEYRING_PATH="/etc/apt/keyrings/oddnetkernel-archive-keyring.gpg"
APT_LIST="/etc/apt/sources.list.d/oddnetkernel.list"

# Must be root
if [[ $EUID -ne 0 ]]; then
    err "This script must be run as root. Use: curl -s 'https://...' | sudo bash"
fi

# Must be amd64
ARCH=$(dpkg --print-architecture 2>/dev/null || uname -m)
if [[ "$ARCH" != "amd64" ]]; then
    err "oddnetkernel only supports amd64 (x86_64). Detected: $ARCH"
fi

# Must be Debian
if ! grep -qi 'debian' /etc/os-release 2>/dev/null && ! command -v apt-get &>/dev/null; then
    err "This system does not appear to be Debian-based. oddnetkernel currently only supports Debian."
fi

echo ""
echo "  ⚡ oddnetkernel — Oddsoul's custom Zen kernel for Debian ⚡"
echo "     AMD Zen/Polaris tuned | Clang-built | PREEMPT_DYNAMIC"
echo ""

# Install prerequisites
log "Installing prerequisites..."
apt-get update -qq
apt-get install -y -qq curl gpg apt-transport-https 2>/dev/null

# Create keyrings directory
mkdir -p /etc/apt/keyrings

# Import GPG key
log "Importing oddnetkernel GPG key..."
curl -fsSL "${REPO_URL}/oddnetkernel-archive-keyring.gpg" | \
    gpg --dearmor --yes -o "$KEYRING_PATH" 2>/dev/null

# Add apt source
log "Adding oddnetkernel apt repository..."
cat > "$APT_LIST" << EOF
deb [arch=amd64 signed-by=${KEYRING_PATH}] ${REPO_URL}/repo stable main
EOF

# Update and install
log "Updating package lists..."
apt-get update -qq

log "Installing oddnetkernel..."
apt-get install -y 'linux-image-*-oddnetkernel-zen' 'linux-headers-*-oddnetkernel-zen'

# Update GRUB
log "Updating GRUB..."
update-grub 2>/dev/null || grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null || true

echo ""
echo -e "${GREEN}✓ oddnetkernel installed successfully!${NC}"
echo ""
echo "  Reboot to use the new kernel:"
echo "    sudo reboot"
echo ""
echo "  After reboot, verify with:"
echo "    uname -r"
echo ""
