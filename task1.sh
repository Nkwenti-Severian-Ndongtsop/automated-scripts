#!/bin/bash
echo "input the extension (.extension): "
read extension
echo "input the absolute path to the file: "
read path_to_file
# Store the output of the find command in a variable
output=$(find "$path_to_file" -type f -name ."$extension" 2>/dev/null)
# Check if any files were found
if [[ -n "$output" ]]; then
    echo "I found the following files: "
    echo "$output"
    echo "Are you sure you want to delete these files? (y/n): "
    read answer
    if [[ "$answer" == "y" ]]; then
        # Delete the files
        echo "$output" | xargs sudo rm -r
        echo "The files were successfully deleted."
    else
        echo "The files were not deleted."
    fi
else
    echo "There are no files with the $ext extension."
fi
