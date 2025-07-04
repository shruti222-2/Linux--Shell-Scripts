#!/bin/bash

# Smart Organizer Script

# Define file type categories and their extensions
declare -A categories
categories=(
  ["Images"]="jpg jpeg png gif bmp svg webp"
  ["Documents"]="pdf doc docx txt odt xls xlsx ppt pptx"
  ["Videos"]="mp4 mkv mov avi wmv flv"
  ["Audio"]="mp3 wav m4a flac aac ogg"
  ["Archives"]="zip tar gz rar 7z tar.gz"
  ["Scripts"]="sh py js java cpp c html css php"
  ["Executables"]="exe bin deb rpm run appimage"
)

# Create folders and move files
for category in "${!categories[@]}"; do
  folder="$category"
  mkdir -p "$folder"

  for ext in ${categories[$category]}; do
    # Move files of this type to the folder
    shopt -s nocaseglob
    for file in *.$ext; do
      [ -e "$file" ] || continue  # Skip if no match
      mv "$file" "$folder/"
      echo "Moved $file to $folder/"
    done
    shopt -u nocaseglob
  done
done

# Move uncategorized files to "Others"
mkdir -p "Others"
for file in *; do
  [ -f "$file" ] || continue
  case "$file" in
    *.jpg|*.jpeg|*.png|*.gif|*.bmp|*.svg|*.webp|\
    *.pdf|*.doc|*.docx|*.txt|*.odt|*.xls|*.xlsx|*.ppt|*.pptx|\
    *.mp4|*.mkv|*.mov|*.avi|*.wmv|*.flv|\
    *.mp3|*.wav|*.m4a|*.flac|*.aac|*.ogg|\
    *.zip|*.tar|*.gz|*.rar|*.7z|*.tar.gz|\
    *.sh|*.py|*.js|*.java|*.cpp|*.c|*.html|*.css|*.php|\
    *.exe|*.bin|*.deb|*.rpm|*.run|*.appimage)
      # Already moved
      ;;
    *)
      mv "$file" "Others/"
      echo "Moved $file to Others/"
      ;;
  esac
done

echo -e "\n✅ Organization Complete!"

