#!/bin/bash
# Usage: ./flatten_adg_smart.sh "Mars 909 Kit.adg" "909 HI"
# Fully automates unpack → smart flatten SampleRef paths → repack

set -euo pipefail

ADG="$1"
NEWPATH="$2"

[[ -z "$ADG" || -z "$NEWPATH" ]] && {
  echo "Usage: $0 <file.adg> <new_relative_dir>"
  exit 1
}

BASE="${ADG%.adg}"
WORK="${BASE}_work"
EDITED="${BASE}_flat.xml"
FINAL="${BASE}_patched.adg"

echo "📄 Copying $ADG → ${WORK}.gz"
cp "$ADG" "${WORK}.gz"

echo "🔧 Decompressing..."
gunzip -f "${WORK}.gz"

echo "✏️  Renaming to XML..."
mv "${WORK}" "${WORK}.xml"

echo "🪄 Flattening sample paths inside <SampleRef> blocks to '$NEWPATH'..."
LC_ALL=C perl -0777 -pe '
  my $newdir = "'"$NEWPATH"'";

  # For each SampleRef block that contains a FileRef with RelativePathType 1 or 6
  s{
    (<SampleRef>[\s\S]*?<FileRef>[\s\S]*?
     <HasRelativePath\s+Value="true"\s*/>[\s\S]*?
     <RelativePathType\s+Value="(?:1|6)"\s*/>[\s\S]*?
     <RelativePath>)([\s\S]*?)(</RelativePath>)
  }{
    my ($head, $inner, $tail) = ($1, $2, $3);
    my @ids = ($inner =~ /Id="(\d+)"/g);
    my $min_id = @ids ? (sort { $a <=> $b } @ids)[0] : undef;

    my $replacement;
    if (defined $min_id) {
      $replacement = qq{  <RelativePathElement Id="$min_id" Dir="$newdir" />};
    } else {
      $replacement = qq{  <RelativePathElement Dir="$newdir" />};
    }

    # normalize RelativePathType to 1
    $head =~ s/<RelativePathType\s+Value="6"\s*\/>/<RelativePathType Value="1" \/>/g;

    "$head\n$replacement\n$tail"
  }egx;
' "${WORK}.xml" > "$EDITED"

echo "📦 Recompressing → ${FINAL}"
gzip -c "$EDITED" > "${BASE}.gz"
mv "${BASE}.gz" "$FINAL"

echo "🧹 Cleaning up temp files..."
rm -f "${WORK}.xml" "$EDITED"

echo "✅ Done! Created: $FINAL"
