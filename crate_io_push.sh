#!/bin/bash

# Usage: ./publish_crate.sh <CRATE_DIRECTORY>
# Example: ./publish_crate.sh weather-app

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "❌ Usage: cratepush <CRATE_DIRECTORY>"
    exit 1
fi

# Read input argument for the crate directory
CRATE_DIR=$1

# Prompt the user for the Crates.io API token securely
read -s -p "🔑 Enter your Crates.io API token: " CRATES_IO_TOKEN
echo  # Move to a new line after input

# Move into the crate directory
if [ -d "$CRATE_DIR" ]; then
    cd "$CRATE_DIR" || { echo "❌ Failed to enter $CRATE_DIR"; exit 1; }
else
    echo "❌ Directory $CRATE_DIR does not exist!"
    exit 1
fi

# Authenticate with crates.io
echo "🔑 Logging into crates.io..."
cargo login "$CRATES_IO_TOKEN"

# Run dry run before actual publish
echo "🛠 Running cargo publish --dry-run..."
cargo publish --dry-run || { echo "❌ Dry run failed! Fix errors before publishing."; exit 1; }

# Publish the crate
echo "🚀 Publishing to crates.io..."
cargo publish || { echo "❌ Publish failed!"; }
echo "✅ Successfully published $CRATE_DIR to crates.io!"
echo "🔑 Remember to keep your Crates.io API token secure!"