# Define the folder
OUTPUT_FOLDER=${1:-../operation_56488}
# SELECTED_FILE=${2:-inventories}
DATA_SOURCE=${2:-../lambda_response.json}
# Get the URL from JSON and download the file
# url=$(cat $DATA_SOURCE | jq -r '.body.output_split.inventories') && \
# curl -L "$url" -o $OUTPUT_FOLDER/inventories.zip

# # Optional: Unzip the downloaded file
# unzip $OUTPUT_FOLDER/inventories.zip
# # Optional: Remove the zip file after extraction
# rm $OUTPUT_FOLDER/inventories.zip

# Get the URL from JSON and download the file
url=$(cat $DATA_SOURCE | jq -r '.body.output_split.ordering_schedule') && \
curl -L "$url" -o "$OUTPUT_FOLDER/ordering_schedule.zip"

# Optional: Unzip the downloaded file
unzip "$OUTPUT_FOLDER/ordering_schedule.zip" -d "$OUTPUT_FOLDER"
# Optional: Remove the zip file after extraction
rm "$OUTPUT_FOLDER/ordering_schedule.zip"