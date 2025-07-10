#!/bin/bash
# shellcheck disable=all

source src/sh/validate_env_vars.sh
source src/sh/private_key_utilities.sh

#=======================================================================
# Functions
#=======================================================================

# Function to initialize the Terraform working directory
terraform_init() {

    # Run 'terraform init' command to initialize the Terraform project
    TERRAFORM_INIT_CMD_OUTPUT=$(terraform init -upgrade 2>&1)

    # Check if initialization was successful by looking for the success message
    if echo "${TERRAFORM_INIT_CMD_OUTPUT}" | grep -q "Terraform has been successfully initialized!"; then
        # Initialization succeeded, no output needed
        return 0
    else
        # Log and report initialization errors
        echo "${TERRAFORM_INIT_CMD_OUTPUT}" >&2
        echo "Error: Terraform initialization failed." >&2
        exit 1
    fi
}

# Function to prepare the Snowflake private key for Terraform
prepare_snowflake_private_key() {
    local private_key_env_var="$1"
    local key_file_path="$2"

    # Uncomment this line to enable debugging
    # echo && print_section_header ${DEBUG} "Prepare/reformat the Snowflake private key for Terraform..."

    # Check if the environment variable for the private key is set
    verify_env_var_exists "$private_key_env_var"

    # Ensure the directory for the key file exists
    mkdir -p "$(dirname "$key_file_path")"

    # Reformat the private key and write it to the file
    reformat_private_key "${!private_key_env_var}" "$key_file_path"

    # Verify the private key file format
    verify_private_key_format "$key_file_path"

    # Export the private key file path for Terraform
    export SNOWFLAKE_PRIVATE_KEY_PATH="$key_file_path"
}
