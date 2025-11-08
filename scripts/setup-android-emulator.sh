#!/usr/bin/env bash
set -euo pipefail

# FBLA Connect helper: install Android command-line tools, emulator, system image, and create an AVD
# Usage: bash scripts/setup-android-emulator.sh
# Review the script before running. It will download Android command-line tools from Google's servers

SDK_ROOT="$HOME/Library/Android/sdk"
CMDLINE_DIR="$SDK_ROOT/cmdline-tools/latest"
DOWNLOAD_DIR="/tmp/android-cmdline"
ZIP_URL="https://dl.google.com/android/repository/commandlinetools-mac-8512546_latest.zip"
# NOTE: If the above URL breaks in the future, download the latest command line tools manually from:
# https://developer.android.com/studio#command-line-tools

echo "Checking for existing sdkmanager/avdmanager..."
if command -v sdkmanager >/dev/null 2>&1 && command -v avdmanager >/dev/null 2>&1; then
  echo "sdkmanager and avdmanager already installed. Using existing SDK tools."
else
  echo "sdkmanager or avdmanager not found. Will install command-line tools into: $CMDLINE_DIR"
  mkdir -p "$DOWNLOAD_DIR"
  echo "Downloading Android command-line tools..."
  curl -L "$ZIP_URL" -o "$DOWNLOAD_DIR/cmdline.zip"
  rm -rf "$DOWNLOAD_DIR/extracted" || true
  mkdir -p "$DOWNLOAD_DIR/extracted"
  unzip -q "$DOWNLOAD_DIR/cmdline.zip" -d "$DOWNLOAD_DIR/extracted"
  # Many packages unzip to a folder named 'cmdline-tools'. Move to the expected path
  mkdir -p "$SDK_ROOT/cmdline-tools"
  # Remove existing 'latest' if any
  rm -rf "$CMDLINE_DIR"
  mv "$DOWNLOAD_DIR/extracted/cmdline-tools" "$CMDLINE_DIR"
  echo "Installed command-line tools to $CMDLINE_DIR"
fi

# Ensure PATH has sdkmanager/avdmanager/emulator/platform-tools for this session
export ANDROID_SDK_ROOT="$SDK_ROOT"
export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$PATH"

echo "SDK root: $ANDROID_SDK_ROOT"
which sdkmanager || true
which avdmanager || true

echo "Installing platform-tools, emulator, build-tools, and a system image (android-33). This may take several minutes..."
# Use API 33 as example; adjust if you want another API level.
PUB_PACKAGES=("platform-tools" "emulator" "build-tools;33.0.0" "platforms;android-33" "system-images;android-33;google_apis;x86_64")
for pkg in "${PUB_PACKAGES[@]}"; do
  echo "Installing $pkg"
  yes | sdkmanager --install "$pkg"
done

# Accept licenses
echo "Accepting licenses..."
yes | sdkmanager --licenses

# Create an AVD
AVD_NAME="fbla_pixel_33"
IMAGE_ID="system-images;android-33;google_apis;x86_64"

if avdmanager list avd | grep -q "$AVD_NAME"; then
  echo "AVD $AVD_NAME already exists."
else
  echo "Creating AVD $AVD_NAME with image $IMAGE_ID"
  echo "no" | avdmanager create avd -n "$AVD_NAME" -k "$IMAGE_ID" --device "pixel"
fi

cat <<EOF
Done. You can start the emulator with:

$ANDROID_SDK_ROOT/emulator/emulator -avd $AVD_NAME

Or simply run in a new terminal (after sourcing ~/.zshrc if modified):

emulator -avd $AVD_NAME
EOF
