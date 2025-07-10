#!/bin/bash
# shellcheck disable=all

#=======================================================================
# Variables
#=======================================================================
source src/sh/shell_utilities.sh # fetch common shell script vars

# Path to the .env file
ENV_FILE="$1"

ENV_VARS_TO_VALIDATE=("SNOWFLAKE_ACCOUNT" "SNOWFLAKE_USER" "SNOWFLAKE_PASSWORD" "SNOWFLAKE_DATABASE" "SNOWFLAKE_SCHEMA" "SNOWFLAKE_WAREHOUSE" "SNOWFLAKE_ROLE")
#=======================================================================
# Functions
#=======================================================================

# Function to validate the existence of an environment variable
verify_env_var_exists() {
    local env_var_name="$1"
    local env_var_value="${!env_var_name}" # Retrieve the value of the environment variable

    if [ -z "$env_var_value" ]; then
        log_message ${ERROR} "Error: Environment variable '$env_var_name' is not set or is empty."
        exit 1
    fi
}

# Function to validate the existence of an .env file
verify_env_file_exists() {
    if [ ! -f "$ENV_FILE" ]; then
        echo -e "${ERROR}Error: .env file not found.\nRun 'make gen_env_template' to generate the required .env file.\n${COLOUR_OFF}"
        exit 1
    fi
}

# Function to verify that the required env vars have been populated in the .env file
validate_env_file() {
    for var in "${ENV_VARS_TO_VALIDATE[@]}"; do
        if [ -z "${!var}" ]; then
            echo && echo -e "${ERROR}Error: .env file error - '$var' is not populated in .env file.${COLOUR_OFF}" && echo
            exit 1
        fi
    done
}

#=======================================================================
# Main Script Logic
#=======================================================================

# Check if the script is being executed directly or sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being executed directly

    # Step 1: Verify the .env file exists
    ENV_FILE="$1"
    verify_env_file_exists "$ENV_FILE"

    # Step 2: Load environment variables from the .env file
    echo "Loading environment variables from '$ENV_FILE'..."
    set -a
    source "$ENV_FILE"
    set +a

    # Step 3: Validate the .env file
    echo "Validating contents of '$ENV_FILE'..."
    validate_env_file

    # Print success message
    echo "Required environment variables found."
fi
