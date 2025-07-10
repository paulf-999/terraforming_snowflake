#!/bin/bash

# Exit on any error
set -e

#=======================================================================
# Variables
#=======================================================================

# the environment name for the Terraform config
ENV_NAME=${1}
ENV_NAME_UPPER=${ENV_NAME^^}

# Define the output file path for the private key
SNOWFLAKE_KEY_FILE="$HOME/.ssh/snowflake_key.p8"

# Source common utility scripts/functions
source src/sh/shell_utilities.sh  # for common shell script functions
source src/sh/terraform_utilities.sh  # for common Terraform functions

#=======================================================================
# Functions
#=======================================================================

# Function to create a Terraform plan for the specific environment
plan_terraform() {

    echo && print_section_header ${DEBUG} "Creating Terraform plan for ${ENV_NAME_UPPER}. Command: 'terraform plan -out=tfplan -input=false'"

    # Run terraform init (Note: terraform_init() comes from src/sh/terraform_utilities.sh)
    log_message ${DEBUG_DETAILS} "Initializing Terraform..."
    terraform_init || {
        log_message ${ERROR} "Error: Terraform initialization failed."
        exit 1
    }

    # Generate Terraform plan and capture the output
    TERRAFORM_PLAN_CMD_OUTPUT=$(terraform plan -out=tfplan -input=false | grep -v "Refreshing state...\|Reading...\|Read complete after")  # Run the Terraform plan command and capture its output

    # Print out the output of the command
    echo "${TERRAFORM_PLAN_CMD_OUTPUT}"

    log_message ${DEBUG_DETAILS} "Terraform plan succeeded for ${ENV_NAME_UPPER}."
}

# Trap interruptions (e.g., Ctrl+C)
trap handle_interruption SIGINT

#=======================================================================
# Main script logic
#=======================================================================

# Prepare the Snowflake private key for Terraform (Note: prepare_snowflake_private_key() comes from src/sh/terraform_utilities.sh)
prepare_snowflake_private_key "TF_VAR_SNOWFLAKE_PRIVATE_KEY" "$SNOWFLAKE_KEY_FILE"

# Change to the environment-specific Terraform config directory
cd terraform/environments/${ENV_NAME} || {
    log_message ${ERROR} "Error: Failed to change directory to terraform/environments/${ENV_NAME}."
    exit 1
}

# Call the terraform plan function
plan_terraform || {
    log_message ${ERROR} "Error: Terraform plan failed."
    exit 1
}
