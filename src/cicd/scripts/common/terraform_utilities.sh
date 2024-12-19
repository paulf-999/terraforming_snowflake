#!/bin/bash
# shellcheck disable=all

#=======================================================================
# Functions
#=======================================================================

# Function to initialize the Terraform working directory
terraform_init() {

    # Run 'terraform init' command to initialize the Terraform project
    TERRAFORM_INIT_CMD_OUTPUT=$(terraform init 2>&1)

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
