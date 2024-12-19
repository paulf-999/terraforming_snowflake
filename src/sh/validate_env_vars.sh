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
# Main script logic
#=======================================================================

# Step 1: Verify .env file exists
# echo -e "${DEBUG}1. Check if .env file exists.\n${COLOUR_OFF}"
verify_env_file_exists

# Load environment variables from .env file, once we know it now exists
source .env

# Step 2: validate .env file
# echo -e "${DEBUG}2. Validate contents of .env file.${COLOUR_OFF}"
validate_env_file

# Print "Required environment variables found" message
echo -e "${DEBUG}Required environment variables found.${COLOUR_OFF}"
