#!/bin/bash

# Function to invoke Lambda and save the result
invoke_lambda_and_download() {
  # Replace these with your actual values
  LAMBDA_NAME="lscs-sco-get-result-pdm-non-release"
  REGION="us-east-2"
  OUTPUT_ZIP="downloaded_folder.zip"
  
  echo "Invoking Lambda function..."
  
  # Create payload JSON with proper escaping
  PAYLOAD='{
    "params": {
        "querystring": {
            "doe_id": "operation",
            "model_id": "56488",
            "run_type": "operation"
        }
    }
  }'

  # Invoke Lambda with the payload
  aws lambda invoke \
    --function-name "$LAMBDA_NAME" \
    --region "$REGION" \
    --payload "$PAYLOAD" \
    --cli-binary-format raw-in-base64-out ../lambda_response.json

}

# Main execution
invoke_lambda_and_download