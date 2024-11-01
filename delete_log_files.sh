#Store the output of the find command in a variable
output=$(find /var/log/ -type f -size +1M -name "*.log" 2>/dev/null)

#Check if any files were found
if [[ -n "$output" ]]; then
    echo "Found the following files larger than 1MB:"
    echo "$output"
    echo "Are you sure you want to delete these files? (y/n)"
    read answer

    if [[ "$answer" == "y" ]]; then
        # Delete the files
        echo "$output" | xargs sudo rm -r
        echo "The files were successfully deleted."
    else
        echo "The files were not deleted."
    fi
else
    echo "There are no files larger than 10MB with the .log extension."
fi