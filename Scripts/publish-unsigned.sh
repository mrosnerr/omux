#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
DIST_DIR="${DIST_DIR:-"$ROOT_DIR/dist"}"
CONFIGURATION="${CONFIGURATION:-release}"
APP_NAME="${APP_NAME:-OpenMUX.app}"
BUNDLE_IDENTIFIER="${BUNDLE_IDENTIFIER:-dev.fingergun.omux}"
BUNDLE_VERSION="${BUNDLE_VERSION:-1}"
SHORT_VERSION="${SHORT_VERSION:-0.1.0}"
GHOSTTY_XCFRAMEWORK="$ROOT_DIR/Vendor/ghostty/macos/GhosttyKit.xcframework"
LIGHT_ICON_SOURCE="$ROOT_DIR/assets/icon-light.png"
DARK_ICON_SOURCE="$ROOT_DIR/assets/icon-dark.png"
ICON_FILE_NAME="OpenMUX.icns"
ICONSET_DIR="$(mktemp -d "${TMPDIR:-/tmp}/openmux-iconset.XXXXXX")/OpenMUX.iconset"

cleanup() {
  rm -rf "$(dirname "$ICONSET_DIR")"
}

trap cleanup EXIT INT TERM

cd "$ROOT_DIR"

if [ ! -d "$GHOSTTY_XCFRAMEWORK" ]; then
  ./Scripts/build-ghostty.sh
fi

swift build -c "$CONFIGURATION" --product OpenMUXApp >/dev/null
BIN_DIR="$(swift build -c "$CONFIGURATION" --show-bin-path)"
APP_BIN="$BIN_DIR/OpenMUXApp"

if [ ! -x "$APP_BIN" ]; then
  echo "error: missing built app binary at $APP_BIN" >&2
  exit 1
fi

BUNDLE_PATH="$DIST_DIR/$APP_NAME"
CONTENTS_DIR="$BUNDLE_PATH/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

rm -rf "$BUNDLE_PATH"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

cp "$APP_BIN" "$MACOS_DIR/OpenMUXApp"
chmod +x "$MACOS_DIR/OpenMUXApp"

find "$BIN_DIR" -maxdepth 1 -name '*.bundle' -exec cp -R {} "$RESOURCES_DIR"/ \;

if [ ! -f "$LIGHT_ICON_SOURCE" ]; then
  echo "error: missing light icon source at $LIGHT_ICON_SOURCE" >&2
  exit 1
fi

mkdir -p "$ICONSET_DIR"
for size in 16 32 128 256 512; do
  sips -z "$size" "$size" "$LIGHT_ICON_SOURCE" --out "$ICONSET_DIR/icon_${size}x${size}.png" >/dev/null
  double_size=$((size * 2))
  sips -z "$double_size" "$double_size" "$LIGHT_ICON_SOURCE" --out "$ICONSET_DIR/icon_${size}x${size}@2x.png" >/dev/null
done
iconutil -c icns "$ICONSET_DIR" -o "$RESOURCES_DIR/$ICON_FILE_NAME"

cp "$LIGHT_ICON_SOURCE" "$RESOURCES_DIR/"
if [ -f "$DARK_ICON_SOURCE" ]; then
  cp "$DARK_ICON_SOURCE" "$RESOURCES_DIR/"
fi

cat > "$CONTENTS_DIR/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleDisplayName</key>
    <string>OpenMUX</string>
    <key>CFBundleExecutable</key>
    <string>OpenMUXApp</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_IDENTIFIER</string>
    <key>CFBundleIconFile</key>
    <string>$ICON_FILE_NAME</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>OpenMUX</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$SHORT_VERSION</string>
    <key>CFBundleVersion</key>
    <string>$BUNDLE_VERSION</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

plutil -lint "$CONTENTS_DIR/Info.plist" >/dev/null

printf 'Unsigned app bundle created at %s\n' "$BUNDLE_PATH"
