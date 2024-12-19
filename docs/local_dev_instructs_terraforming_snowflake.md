# Local Development Instructions for 'Terraforming Snowflake'

Follow the steps described below to set up and run the Terraform commands (that are used in the CI/CD pipeline) locally on your machine.

## Prerequisites

1. **Rename the `.env_template` file**
    And populate the relevant environment variables.

## Setup Steps

1. **Install Terraform locally**
    From the root of the repo, run: `bash src/sh/install_terraform.sh`

2. **Execute Terraform locally**:
    - Execute the local bash script, i.e., run `bash local_terraform_dev.sh`
    - Feel free to use Terraform commands as needed (e.g., `terraform init`, `terraform validate`, `terraform plan`, `terraform apply`, etc.).
