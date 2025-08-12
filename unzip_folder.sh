#!/bin/bash
# Find all zip files in source folder and unzip them to destination folder

# Initialize variables
REMOVE_ZIP_FILES=false
SOURCE_FOLDER=""
DEST_FOLDER=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --remove-zip|-r)
            REMOVE_ZIP_FILES=true
            shift
            ;;
        -*)
            echo "Unknown option $1"
            echo "Usage: $0 [--remove-zip|-r] <source_folder> [destination_folder]"
            echo "Example: $0 --remove-zip /path/to/source /path/to/destination"
            echo "Example: $0 -r /path/to/source"
            echo "If destination folder is not provided, extracts to current directory"
            echo "Use --remove-zip or -r to delete zip files after extraction"
            exit 1
            ;;
        *)
            if [ -z "$SOURCE_FOLDER" ]; then
                SOURCE_FOLDER="$1"
            elif [ -z "$DEST_FOLDER" ]; then
                DEST_FOLDER="$1"
            else
                echo "Too many arguments"
                echo "Usage: $0 [--remove-zip|-r] <source_folder> [destination_folder]"
                exit 1
            fi
            shift
            ;;
    esac
done

# Check if source folder is provided
if [ -z "$SOURCE_FOLDER" ]; then
    echo "Usage: $0 [--remove-zip|-r] <source_folder> [destination_folder]"
    echo "Example: $0 --remove-zip /path/to/source /path/to/destination"
    echo "Example: $0 -r /path/to/source"
    echo "If destination folder is not provided, extracts to current directory"
    echo "Use --remove-zip or -r to delete zip files after extraction"
    exit 1
fi
# Check if source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
    echo "Error: Source folder '$SOURCE_FOLDER' does not exist"
    exit 1
fi

# Create destination folder if it was provided and doesn't exist
if [ -n "$DEST_FOLDER" ]; then
    mkdir -p "$DEST_FOLDER"
fi
# Find and process all zip files
zip_count=0

# Use find to locate all .zip files recursively
while IFS= read -r -d '' zip_file; do
    # Determine extraction directory
    if [ -n "$DEST_FOLDER" ]; then
        extract_dir="$DEST_FOLDER"
    else
        extract_dir="$(dirname "$zip_file")"
    fi
    
    echo "Extracting '$(basename "$zip_file")' to '$extract_dir'..."
    if unzip -o -q "$zip_file" -d "$extract_dir"; then
        ((zip_count++))
    else
        echo "Warning: Failed to extract '$(basename "$zip_file")'"
    fi
    if [ "$REMOVE_ZIP_FILES" = true ]; then
        echo "Removing zip file '$zip_file'..."
        rm -f "$zip_file"
    fi
done < <(find "$SOURCE_FOLDER" -type f -name "*.zip" -print0)

if [ $zip_count -eq 0 ]; then
    echo "No zip files found in '$SOURCE_FOLDER' or its subdirectories"
else
    if [ -n "$DEST_FOLDER" ]; then
        echo "Successfully extracted $zip_count zip file(s) to '$DEST_FOLDER'"
    else
        echo "Successfully extracted $zip_count zip file(s) to their respective directories"
    fi
fi