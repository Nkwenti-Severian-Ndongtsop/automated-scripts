#!/bin/bash

echo "🛠️  VirtualBox Kernel Driver Fixer for Ubuntu"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root (use: sudo $0)"
  exit 1
fi

echo "🔍 Step 1: Checking required packages..."
REQUIRED_PKGS=(build-essential dkms linux-headers-$(uname -r))
for pkg in "${REQUIRED_PKGS[@]}"; do
  if dpkg -s "$pkg" &>/dev/null; then
    echo "✅ $pkg is installed"
  else
    echo "📦 Installing $pkg..."
    apt install -y "$pkg" || { echo "❌ Failed to install $pkg. Exiting."; exit 1; }
  fi
done

echo "⚙️ Step 2: Running /sbin/vboxconfig..."
/sbin/vboxconfig
if [ $? -eq 0 ]; then
  echo "✅ VirtualBox kernel modules configured successfully!"
  exit 0
else
  echo "⚠️  /sbin/vboxconfig failed. Continuing with checks..."
fi

echo "🔎 Step 3: Checking for loaded kernel modules..."
MISSING_MODULES=()
for mod in vboxdrv vboxnetflt vboxnetadp; do
  if lsmod | grep "$mod" &>/dev/null; then
    echo "✅ $mod is loaded"
  else
    echo "❌ $mod is missing"
    MISSING_MODULES+=("$mod")
  fi
done

if [ ${#MISSING_MODULES[@]} -gt 0 ]; then
  echo "📥 Trying to manually load missing modules..."
  for mod in "${MISSING_MODULES[@]}"; do
    modprobe "$mod" && echo "✅ Loaded $mod" || echo "❌ Failed to load $mod"
  done
fi

echo "🔐 Step 4: Checking Secure Boot status..."
if command -v mokutil &>/dev/null; then
  SECURE_BOOT=$(mokutil --sb-state | grep enabled)
  if [[ "$SECURE_BOOT" == *"enabled"* ]]; then
    echo "⚠️  EFI Secure Boot is ENABLED."
    echo "❗ Secure Boot blocks unsigned kernel modules like VirtualBox's."
    echo "👉 You have two options:"
    echo "   1. Disable Secure Boot from your BIOS/UEFI settings."
    echo "   2. Manually sign the VirtualBox kernel modules. (Advanced)"
    echo
    echo "📚 See: https://wiki.ubuntu.com/UEFI/SecureBoot for guidance."
  else
    echo "✅ Secure Boot is disabled."
  fi
else
  echo "⚠️  mokutil is not installed. Cannot check Secure Boot status."
  echo "   You can install it using: sudo apt install mokutil"
fi

echo
echo "🚀 Done. Try launching VirtualBox again with: virtualbox"
