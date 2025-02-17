#!/bin/bash

# the environment name for the Terraform config
ENV_NAME=${1}
ENV_NAME_UPPER=$(echo "$ENV_NAME" | tr '[:lower:]' '[:upper:]')

# Source common shell script variables and functions
source src/sh/shell_utilities.sh

# Source common terraform functions
source src/cicd/scripts/common/terraform_utilities.sh

# Source the .env file and export variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found."
    exit 1
fi

#=======================================================================
# Functions
#=======================================================================

# Function to apply Terraform changes for the specific environment
apply_terraform() {

    # Apply Terraform changes
    echo && print_section_header "${DEBUG_DETAILS}" "Applying Terraform changes for ${ENV_NAME_UPPER}. Command: 'terraform apply -auto-approve'"

    terraform apply -auto-approve tfplan || {
        log_message "${ERROR}" "Error: Terraform apply failed for ${ENV_NAME_UPPER}." >&2
        exit 1
    }

    log_message "${DEBUG_DETAILS}" "End of Terraform processing for ${ENV_NAME_UPPER}."
}

#=======================================================================
# Main script logic
#=======================================================================

# Trap interruptions (e.g., Ctrl+C)
trap handle_interruption SIGINT

# Change to the environment-specific Terraform config directory
cd terraform/environments/${ENV_NAME}

# Run terraform init (Note: terraform_init() comes from src/cicd/scripts/terraform/terraform_utilities.sh)
terraform_init

# Call the terraform apply function
apply_terraform
