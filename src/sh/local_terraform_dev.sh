#!/bin/bash

# Exit on any error
set -e

# Check if the .env file exists before exporting variables
if [ -f .env ]; then
    echo && echo "Loading environment variables from .env file..."
    export "$(grep -v '^#' .env | xargs)"
else
    echo "Error: .env file not found."
    echo "Rename the file '.env_template.j2' to '.env'"
    echo "  cp ../../../src/templates/jinja_templates/.env_template.j2 .env"
    exit 1
fi

# Initialize Terraform
echo && echo "Initializing Terraform..."
terraform init

# Validate the Terraform configuration
echo && echo "Validating Terraform configuration..."
terraform validate

# Create and display the Terraform plan
echo "Creating Terraform plan..."
terraform plan -out=tfplan -input=false | grep -v "Refreshing state...\|Reading...\|Read complete after"

echo && echo "Terraform plan validation complete."
