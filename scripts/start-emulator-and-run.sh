#!/usr/bin/env bash
set -euo pipefail

# Starts the AVD if not running, waits for boot, and runs flutter on emulator-5554
AVD_NAME=fbla_pixel_33
EMULATOR_BIN="$HOME/Library/Android/sdk/emulator/emulator"
ADB_BIN="$HOME/Library/Android/sdk/platform-tools/adb"

echo "Ensure ANDROID_SDK_ROOT is set: $ANDROID_SDK_ROOT"

# start emulator if not present
if ! "$ADB_BIN" devices | grep -q emulator-5554; then
  echo "Starting AVD: $AVD_NAME"
  "$EMULATOR_BIN" -avd "$AVD_NAME" -no-snapshot -no-boot-anim &>/tmp/emulator.log &
  EMU_PID=$!
  echo "Emulator pid: $EMU_PID"
else
  echo "Emulator already running"
fi

# wait for boot
set +e
BOOTED=0
echo "Waiting for emulator to be available via adb..."
for i in {1..120}; do
  if "$ADB_BIN" devices | grep -q emulator-5554; then
    # check boot completed
    BOOT_COMPLETED=$("$ADB_BIN" -s emulator-5554 shell getprop sys.boot_completed 2>/dev/null || echo "0")
    if [[ "$BOOT_COMPLETED" == "1" ]]; then
      BOOTED=1
      break
    fi
  fi
  sleep 1
done
set -e

if [[ "$BOOTED" == "1" ]]; then
  echo "Emulator booted"
  echo "Running flutter on emulator-5554"
  flutter run -d emulator-5554
else
  echo "Emulator failed to boot within timeout. Check /tmp/emulator.log for details"
  tail -n 200 /tmp/emulator.log || true
  exit 1
fi
