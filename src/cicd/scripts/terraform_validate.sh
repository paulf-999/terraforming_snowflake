#!/bin/bash

# the environment name for the Terraform config
ENV_NAME=${1}
ENV_NAME_UPPER=${ENV_NAME^^}

# Source common shell script variables and functions
source src/sh/shell_utilities.sh

# Source common terraform functions
source src/cicd/scripts/common/terraform_utilities.sh

#=======================================================================
# Functions
#=======================================================================

# Function to validate Terraform configuration for a specific environment
validate_terraform() {

    echo && print_section_header "${DEBUG_DETAILS}" "Validating Terraform Config Files for ${ENV_NAME_UPPER}. Command: 'terraform validate'"

    echo && terraform validate || {
        log_message "${ERROR}" "Error: Terraform validation failed for ${ENV_NAME_UPPER}."
        exit 1
    }

    log_message "${DEBUG_DETAILS}" "Terraform validation succeeded for ${ENV_NAME_UPPER}."
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

# Call the terraform validate function
validate_terraform
