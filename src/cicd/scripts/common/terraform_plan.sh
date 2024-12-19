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

# Function to create a Terraform plan for the specific environment
plan_terraform() {

    echo && print_section_header "${DEBUG_DETAILS}" "Creating Terraform plan for ${ENV_NAME_UPPER}. Command: 'terraform plan -out=tfplan -input=false'"

    # Generate Terraform plan and capture the output
    TERRAFORM_PLAN_CMD_OUTPUT=$(terraform plan -out=tfplan -input=false | grep -v "Refreshing state...\|Reading...\|Read complete after")  # Run the Terraform plan command and capture its output

    # Print out the output of the command
    echo "${TERRAFORM_PLAN_CMD_OUTPUT}"

    log_message "${DEBUG_DETAILS}" "Terraform plan succeeded for ${ENV_NAME_UPPER}."
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

# Call the terraform plan function
plan_terraform
