#!/bin/bash
# Usage: ./repack_adg.sh "Mars 909 Kit.xml"
# Compresses the edited .xml back into a valid Ableton .adg

set -e
XML="$1"
[[ -z "$XML" ]] && { echo "Usage: $0 <file.xml>"; exit 1; }

BASE="${XML%.xml}"

echo "📦 Recompressing $XML → ${BASE}.gz"
gzip -c "$XML" > "${BASE}.gz"

echo "🔁 Renaming .gz → .adg"
mv "${BASE}.gz" "${BASE}_patched.adg"

echo "✅ Done. Created: ${BASE}_patched.adg"

