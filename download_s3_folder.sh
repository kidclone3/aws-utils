#!/bin/bash
# filepath: /home/delus/Documents/code/something/aws_utils/download_s3_folder.sh

set -e  # Exit on any error

# Function to display usage
usage() {
    echo "Usage: $0 <s3-uri> [local-destination]"
    echo "Example: $0 s3://my-bucket/folder/subfolder ./downloads"
    echo "Example: $0 s3://my-bucket/folder/subfolder"
    echo "If local-destination is not provided, downloads to current directory"
    exit 1
}

# Function to validate S3 URI format
validate_s3_uri() {
    local uri="$1"
    if [[ ! "$uri" =~ ^s3://[^/]+/.* ]]; then
        echo "Error: Invalid S3 URI format. Expected: s3://bucket-name/path"
        echo "Provided: $uri"
        exit 1
    fi
}

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed or not in PATH"
    exit 1
fi

# Check minimum required arguments
if [ $# -lt 1 ]; then
    echo "Error: Missing required S3 URI argument"
    usage
fi

S3_URI="$1"
LOCAL_DEST="${2:-.}"  # Default to current directory if not provided

# Validate S3 URI format
validate_s3_uri "$S3_URI"

# Remove trailing slash from S3 URI if present
S3_URI="${S3_URI%/}"

# Create local destination directory if it doesn't exist
mkdir -p "$LOCAL_DEST"

echo "Downloading S3 folder: $S3_URI"
echo "Destination: $LOCAL_DEST"

# Download the folder recursively
aws s3 cp "$S3_URI" "$LOCAL_DEST" --recursive

# Check if download was successful
if [ $? -eq 0 ]; then
    echo "Download completed successfully!"
    echo "Files downloaded to: $LOCAL_DEST"
    # number of files downloaded
    FILE_COUNT=$(find "$LOCAL_DEST" -type f | wc -l)
    echo "Total files downloaded: $FILE_COUNT"
else
    echo "Download failed!"
    exit 1
fi