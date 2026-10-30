#!/usr/bin/env bash
# store_screenshots.sh — phone screenshots and short gameplay clips for the
# store page (olin.now), taken from the real app in an iOS simulator.
#
#   tool/store_screenshots.sh <out-dir> [skin ...]
#
# One debug build is installed; each shot sets the app's preferences
# (`flutter.settings.skin`, and `flutter.shots.screen` which a debug build
# honours, see main.dart) and relaunches it, so nothing has to be tapped.
# Writes <out-dir>/NN-<name>.png and <out-dir>/clip-<skin>.mp4.
set -euo pipefail

OUT="${1:?usage: $0 <out-dir> [skin ...]}"
shift
if [ $# -gt 0 ]; then SHOT_SKINS=("$@"); else SHOT_SKINS=(classic cyberpunk kawaii christmas popart sumie); fi
CLIP_SKINS=(kawaii cyberpunk christmas)
SIM="Kaceny-Shots-iPhone"
BUNDLE="com.ol1n.kaceny"
cd "$(dirname "$0")/.."
mkdir -p "$OUT"

udid="$(xcrun simctl list devices available | awk -v n="$SIM" -F '[()]' 'index($0, "    " n " (") == 1 { print $2; exit }')"
if [ -z "$udid" ]; then
  # newest iOS runtime that accepts the device type (a fresh beta may not)
  for runtime in $(xcrun simctl list runtimes available | awk '/^iOS/ { print $NF }' | sort -rV); do
    udid="$(xcrun simctl create "$SIM" "iPhone 18 Pro Max" "$runtime" 2>/dev/null)" && break
  done
  [ -n "$udid" ] || { echo "error: could not create $SIM" >&2; exit 1; }
fi
xcrun simctl boot "$udid" 2>/dev/null || true
xcrun simctl bootstatus "$udid" -b >/dev/null
xcrun simctl status_bar "$udid" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularBars 4 --wifiBars 3 --dataNetwork wifi

flutter build ios --simulator --debug >/dev/null
xcrun simctl install "$udid" build/ios/iphonesimulator/Runner.app

# The app reads NSUserDefaults from its own data container. Write that plist
# by path, through the simulator's own cfprefsd (a host-side write is not seen).
PLIST="$(xcrun simctl get_app_container "$udid" "$BUNDLE" data)/Library/Preferences/$BUNDLE"

# launch <screen|-> <skin> <seconds to wait>
launch() {
  xcrun simctl terminate "$udid" "$BUNDLE" 2>/dev/null || true
  if [ "$1" = "-" ]; then xcrun simctl spawn "$udid" defaults delete "$PLIST" flutter.shots.screen 2>/dev/null || true
  else xcrun simctl spawn "$udid" defaults write "$PLIST" flutter.shots.screen -string "$1"; fi
  xcrun simctl spawn "$udid" defaults write "$PLIST" flutter.settings.skin -string "$2"
  xcrun simctl launch "$udid" "$BUNDLE" >/dev/null
  sleep "$3"
}

shot() { xcrun simctl io "$udid" screenshot --type=png "$OUT/$1.png" >/dev/null; echo "  $1.png"; }

# first launch after an install compiles the Dart code; let it finish
launch - classic 20
n=1
launch - classic 6;      shot "$(printf %02d $n)-menu";  n=$((n + 1))
launch skins kawaii 6;   shot "$(printf %02d $n)-skiny"; n=$((n + 1))
for skin in "${SHOT_SKINS[@]}"; do
  # ducks need a few seconds to fill the sky
  launch game "$skin" 14; shot "$(printf %02d $n)-$skin"; n=$((n + 1))
done

for skin in "${CLIP_SKINS[@]}"; do
  launch game "$skin" 5
  xcrun simctl io "$udid" recordVideo --codec=h264 --force "$OUT/clip-$skin.mp4" 2>/dev/null &
  rec=$!
  sleep 9
  kill -INT "$rec"; wait "$rec" 2>/dev/null || true
  echo "  clip-$skin.mp4"
done

xcrun simctl terminate "$udid" "$BUNDLE" 2>/dev/null || true
xcrun simctl spawn "$udid" defaults delete "$PLIST" flutter.shots.screen 2>/dev/null || true
echo "done -> $OUT"
