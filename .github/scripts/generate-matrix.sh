#!/bin/bash
set -e

images_dir="images"
matrix="[]"
build_all=true
changed_dirs=()

if [ "$1" != "--all" ] && git rev-parse --git-dir > /dev/null 2>&1; then
  if git rev-parse --verify HEAD~1 >/dev/null 2>&1; then
    build_all=false
    changed_files=$(git diff --name-only HEAD~1)
    for file in $changed_files; do
      if [[ "$file" =~ ^images/([^/]+)/ ]]; then
        dir_name="${BASH_REMATCH[1]}"
        if [[ ! " ${changed_dirs[@]} " =~ " ${dir_name} " ]]; then
          changed_dirs+=("$dir_name")
        fi
      fi
    done
    
    if [ ${#changed_dirs[@]} -eq 0 ]; then
      echo '{"include": []}'
      exit 0
    fi
  fi
fi

if [ -d "$images_dir" ]; then
  for dir in "$images_dir"/*; do
    if [ -d "$dir" ] && [ -f "$dir/manifest.json" ]; then
      image_name=$(basename "$dir")
      
      if [ "$build_all" = false ]; then
        found=false
        for c_dir in "${changed_dirs[@]}"; do
          if [ "$c_dir" = "$image_name" ]; then
            found=true
            break
          fi
        done
        if [ "$found" = false ]; then
          continue
        fi
      fi
      
      manifest="$dir/manifest.json"
      
      jobs=$(jq -c --arg img "$image_name" '
        . as $manifest
        | [
            .versions[] as $ver
            | {
                image: $img,
                version: ($ver | tostring),
                platforms: ($manifest.platforms | join(",")),
                latest: ($ver == $manifest.latest_version)
              }
          ]
      ' "$manifest")
      
      matrix=$(jq -c --argjson new_jobs "$jobs" '. + $new_jobs' <<< "$matrix")
    fi
  done
fi

jq -c -n --argjson inc "$matrix" '{include: $inc}'
