#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function usage() {
  cat <<EOM
  $1
  Usage:
    $(basename $0) <input_folder> <output_folder>
EOM
  exit 0
}

input_folder=${1:-}
output_folder=${2:-}

[[ -d "$input_folder" ]] || usage "Input Folder invalid!"
[[ -d "$output_folder" ]] || usage "Output Folder invalid!"

command -v rsvg-convert >/dev/null 2>&1 || { 
  echo >&2 usage "RsvgConvert missing - Install using \"brew install librsvg\"."; exit 1;
}

svg_list=($(ls $input_folder/*.svg))
json="{\"images\":[{\"idiom\":\"universal\",\"filename\":\"##FILE_NAME##\"}],\"info\":{\"version\":1,\"author\":\"xcode\"},\"properties\":{\"preserves-vector-representation\":true}}"
asset_folder="$(mktemp -d)/Assets.xcassets"

for SVG in "${svg_list[@]}"; do
  id=$(echo $(basename $SVG) | cut -d. -f1)
  imageset="$asset_folder/$id.imageset"

  mkdir -p $imageset
  rsvg-convert -f pdf -o $imageset/$id.pdf $SVG
  echo ${json/"##FILE_NAME##"/"$id.pdf"} > "$imageset/Contents.json"
done

mv $asset_folder $output_folder
