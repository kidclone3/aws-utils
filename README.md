# AWS Utilities

## Requirements
- Linux or MacOS
- AWS CLI installed
## Usage



- Download S3 file/folder

    ```bash
    ./download_s3_folder BUCKET_URL [DESTINATION_FOLDER]
    ```
    Example:

    ```bash
    ./download_s3_folder s3://data-test/model-results/simulation/12345 12345
    ./download_s3_folder s3://data-test/model-results/operation/12346 12346
    ```

    Pre-requisites:
    - To use the `download_s3_folder` script, you need to have the AWS CLI installed and configured with the necessary permissions to access the S3 bucket.
        - Use can use AWS environment variables to set your credentials:
        ```bash
        export AWS_ACCESS_KEY_ID=your_access_key_id
        export AWS_SECRET_ACCESS_KEY=your_secret_access_key
        export AWS_SESSION_TOKEN=your_session_token
        ```
        - And some other ways I won't mention here.

- Unzip folder

    ```bash
    ./unzip_folder.sh SIM_ID

    ./unzip_folder.sh -d SIM_ID # Also delete the zip files if extracted in the same folder

    ./unzip_folder.sh -d SIM_ID DESTINATION_FOLDER # Extracted in the destination folder
    ```


## Example:

I normally use these scripts in the following way:

1. Add AWS environment variables
    ```bash
    export AWS_ACCESS_KEY_ID=your_access_key_id
    export AWS_SECRET_ACCESS_KEY=your_secret_access_key
    export AWS_SESSION_TOKEN=your_session_token # If using temporary credentials
    ```

2. Run Scripts

    ```bash
    export SIM_ID=12345
    ./download_s3_folder s3://data-test/model-results/simulation/$SIM_ID $SIM_ID && ./unzip_folder.sh -d $SIM_ID
    ```