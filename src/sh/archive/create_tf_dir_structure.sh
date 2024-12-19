#!/bin/bash

mkdir -p terraform/.env

# Create the main directory structure
mkdir -p terraform/global
mkdir -p terraform/environments/{dev,uat,cicd,prod}

# Create .gitkeep files for main directories
touch terraform/.env/.gitkeep
touch terraform/global/.gitkeep
touch terraform/environments/{dev,uat,cicd,prod}/.gitkeep

# Create global-level subdirectories and files
mkdir -p terraform/global/{1_roles_and_grants,2_account_level_objects}
touch terraform/global/1_roles_and_grants/.gitkeep
touch terraform/global/2_account_level_objects/.gitkeep
touch terraform/global/{main.tf,.tf,variables.tf}

# Create environment-level subdirectories and files
for env in dev uat cicd prod; do
    mkdir -p terraform/environments/$env/{1_roles_and_grants,2_account_level_objects/database}
    touch terraform/environments/$env/1_roles_and_grants/.gitkeep
    touch terraform/environments/$env/2_account_level_objects/.gitkeep
    touch terraform/environments/$env/{main.tf,provider.tf,variables.tf}
    touch terraform/environments/$env/database/.gitkeep
    touch terraform/environments/$env/database/{provider.tf,variables.tf}
done

# Create environment-specific subdirectories for roles and grants, then add files
for env in dev uat cicd prod; do
    mkdir -p terraform/environments/$env/1_roles_and_grants/{roles.tf,grants.tf,outputs.tf,provider.tf,variables.tf}
done
