#!/bin/bash
# Find all files in source folder and zip each file individually

# Check if correct number of arguments provided
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Usage: $0 <source_folder> [destination_folder]"
    echo "Example: $0 /path/to/source /path/to/destination"
    echo "If destination folder is not provided, creates zip files in the same directory as source files"
    exit 1
fi

SOURCE_FOLDER="$1"
DEST_FOLDER="$2"
# Check if source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
    echo "Error: Source folder '$SOURCE_FOLDER' does not exist"
    exit 1
fi

# Create destination folder if it was provided and doesn't exist
if [ -n "$DEST_FOLDER" ]; then
    mkdir -p "$DEST_FOLDER"
fi

# Find and process all non-zip files
file_count=0

# Use find to locate all files (excluding .zip files) recursively
while IFS= read -r -d '' file_path; do
    # Skip if it's already a zip file
    if [[ "$file_path" == *.zip ]]; then
        continue
    fi
    
    # Get the filename without path and extension
    filename=$(basename "$file_path")
    filename_no_ext="${filename%.*}"
    
    # Determine zip file destination (replace extension with .zip)
    if [ -n "$DEST_FOLDER" ]; then
        # Use absolute path for destination folder
        zip_file="$(realpath "$DEST_FOLDER")/${filename_no_ext}.zip"
    else
        # Use absolute path for same directory as source file
        zip_file="$(dirname "$(realpath "$file_path")")/${filename_no_ext}.zip"
    fi
    
    echo "Zipping '$filename' to '$(basename "$zip_file")'..."
    
    # Change to the directory containing the file to avoid including full path in zip
    original_dir=$(pwd)
    cd "$(dirname "$file_path")"
    
    if zip -q "$zip_file" "$filename"; then
        ((file_count++))
    else
        echo "Warning: Failed to zip '$filename'"
    fi
    
    # Return to original directory
    cd "$original_dir"
done < <(find "$SOURCE_FOLDER" -type f -print0)

if [ $file_count -eq 0 ]; then
    echo "No files found in '$SOURCE_FOLDER' or its subdirectories"
else
    if [ -n "$DEST_FOLDER" ]; then
        echo "Successfully zipped $file_count file(s) to '$DEST_FOLDER'"
    else
        echo "Successfully zipped $file_count file(s) to their respective directories"
    fi
fi