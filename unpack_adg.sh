#!/bin/bash
# Usage: ./unpack_adg.sh "Mars 909 Kit.adg"
# Copies, renames, and unzips an Ableton .adg into an editable .xml

set -e
ADG="$1"
[[ -z "$ADG" ]] && { echo "Usage: $0 <file.adg>"; exit 1; }

BASE="${ADG%.adg}"

echo "📄 Copying $ADG → ${BASE}.gz"
cp "$ADG" "${BASE}.gz"

echo "🔧 Decompressing..."
gunzip -f "${BASE}.gz"

echo "✏️  Renaming to XML..."
mv "${BASE}" "${BASE}.xml"

echo "✅ Done. Editable XML at: ${BASE}.xml"

