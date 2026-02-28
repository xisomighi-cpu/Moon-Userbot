#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="${1:-$ROOT_DIR/dist}"
PACKAGE_NAME="Dexbot-ready"
TEMP_DIR="$(mktemp -d)"
STAGE_DIR="$TEMP_DIR/$PACKAGE_NAME"

cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

mkdir -p "$OUT_DIR"

rsync -a "$ROOT_DIR/" "$STAGE_DIR/" \
  --exclude '.git/' \
  --exclude '.venv/' \
  --exclude 'venv/' \
  --exclude '__pycache__/' \
  --exclude '*.pyc' \
  --exclude '*.session' \
  --exclude '*.session-old' \
  --exclude '.env' \
  --exclude 'dist/' \
  --exclude 'downloads/'

chmod +x "$STAGE_DIR/start" "$STAGE_DIR/install.sh" "$STAGE_DIR/termux-install.sh" "$STAGE_DIR/cloud.sh" "$STAGE_DIR/build_zip.sh" || true

(
  cd "$TEMP_DIR"
  zip -qr "$OUT_DIR/${PACKAGE_NAME}.zip" "$PACKAGE_NAME"
)

echo "ZIP siap jalan berhasil dibuat: $OUT_DIR/${PACKAGE_NAME}.zip"
echo "Cara pakai cepat:"
echo "1) unzip ${PACKAGE_NAME}.zip"
echo "2) cd ${PACKAGE_NAME}"
echo "3) bash install.sh"
