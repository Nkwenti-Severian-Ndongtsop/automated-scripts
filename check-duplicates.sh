#!/bin/bash

# Function to show usage instructions
usage() {
  echo "Usage: $0 <directory> [--fix]"
  echo "  <directory>  The directory to scan for duplicate files."
  echo "  --fix        Optional flag to delete duplicate files."
  exit 1
}

# Check if a directory is provided
if [ -z "$1" ]; then
  usage
fi

DIRECTORY="$1"
REMOVE=false

# Check if the --fix option is provided
if [ "$2" == "--fix" ]; then
  REMOVE=true
fi

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
  echo "Error: Directory '$DIRECTORY' does not exist."
  exit 1
fi

# Create a temporary file to store checksums
TEMP_FILE=$(mktemp)
find "$DIRECTORY" -type f -exec md5sum {} + | sort > "$TEMP_FILE"

# Print table header
echo -e "File                | Duplicate"
echo "--------------------------------"

PREVIOUS_HASH=""
PREVIOUS_FILE=""

# Process the checksums to find duplicates
while read -r HASH FILE; do
  if [ "$HASH" == "$PREVIOUS_HASH" ]; then
    echo -e "$(basename "$FILE")           | Yes ($(basename "$PREVIOUS_FILE"))"
    if $REMOVE; then
      rm "$FILE"
    fi
  else
    if [ -n "$PREVIOUS_FILE" ]; then
      echo -e "$(basename "$PREVIOUS_FILE")           | No"
    fi
    PREVIOUS_HASH="$HASH"
    PREVIOUS_FILE="$FILE"
  fi
done < "$TEMP_FILE"

# Print the last file in the list
if [ -n "$PREVIOUS_FILE" ]; then
  echo -e "$(basename "$PREVIOUS_FILE")           | No"
fi

# Clean up
rm -f "$TEMP_FILE"
