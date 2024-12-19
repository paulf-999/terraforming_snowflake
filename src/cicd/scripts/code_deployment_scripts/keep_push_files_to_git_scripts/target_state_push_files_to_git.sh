#!/bin/bash

#=======================================================================
# Script Name: push_files_to_git.sh
# Description: Pushes updated Terraform state files to a Git branch for a specific environment.
#
# Usage: ./push_files_to_git.sh <branch_name> <environment>
#        <branch_name> - the target Git branch.
#        <environment> - the Terraform environment (dev, uat, cicd, prod).
#=======================================================================

#=======================================================================
# Variables
#=======================================================================
# Import utility functions
source src/sh/shell_utilities.sh
source src/sh/git_utilities.sh

# Check if required arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    log_message "${DEBUG}" "Error: Missing arguments."
    log_message "${DEBUG}" "Usage: $0 <branch_name> <environment>"
    exit 1
fi

# Variables for the script
SOURCE_GIT_BRANCH_NAME=$1       # Target Git branch name (e.g., main)
TARGET_ENVIRONMENT=$2           # Target environment (e.g., dev, uat, prod)
GIT_BOT_EMAIL="TODO - update me"
GIT_BOT_USERNAME="gitbot-UPDATE-ME"
CHANGES_MADE=false              # Flag to track if any changes were committed

add_and_commit_file() {
    local FILENAME=$1   # The file to process
    local MESSAGE=$2    # Commit message

    if [ -f "${FILENAME}" ]; then  # Check if the file exists
        # Check if there are changes to the file
        if git diff --quiet "${FILENAME}"; then
            echo "No changes to commit for ${FILENAME}"  # No changes detected
        else
            # Stage and commit the file
            git add "${FILENAME}" -f >/dev/null 2>&1
            git commit -m "Automated commit: ${MESSAGE}" >/dev/null 2>&1
            echo "Committed changes for ${FILENAME}"  # Notify that changes were committed
            CHANGES_MADE=true  # Flag to indicate changes were made
        fi
    else
        echo "Skipping: ${FILENAME} (file does not exist)."  # File doesn't exist, skip
    fi
}

# Pushes changes to the remote repository if there are any.
git_push() {
    local BRANCH_NAME=$1  # Branch to push changes to

    if [ "$CHANGES_MADE" = true ]; then  # Check if changes were made
        echo "Pushing changes to remote..."  # Notify push operation
        # Push changes to the remote repository
        git push origin HEAD:"${BRANCH_NAME}" >/dev/null 2>&1 || {
            echo "Error: git push failed"  # Handle push failure
            exit 1
        }
    else
        echo "No changes to push."  # No changes, nothing to do
    fi
}

#=======================================================================
# Functions
#=======================================================================
process_files_for_environment() {
    log_message "${DEBUG}" "Processing files for environment: ${TARGET_ENVIRONMENT}"

    if [[ "${TARGET_ENVIRONMENT}" == "global" ]]; then
        # Handle global environment files
        add_and_commit_file "terraform/global/terraform.tfstate" "Uploaded latest Global Terraform state file"
        add_and_commit_file "terraform/global/terraform.tfstate.backup" "Uploaded latest Global Terraform state backup file"
    else
        # Handle environment-specific files
        local TF_STATE_FILE="terraform/environments/${TARGET_ENVIRONMENT}/terraform.tfstate"
        add_and_commit_file "${TF_STATE_FILE}" "Uploaded latest ${TARGET_ENVIRONMENT} Terraform state file"
        add_and_commit_file "${TF_STATE_FILE}.backup" "Uploaded latest ${TARGET_ENVIRONMENT} Terraform state backup file"
    fi
}

#=======================================================================
# Main script logic
#=======================================================================
log_message "${INFO}" "Script execution started for environment: ${TARGET_ENVIRONMENT}"
trap handle_interruption SIGINT  # Handle interruptions gracefully

# Checkout (and rebase) the feature branch
git_checkout_and_rebase "${SOURCE_GIT_BRANCH_NAME}"
process_files_for_environment
git_push "${SOURCE_GIT_BRANCH_NAME}"

log_message "${INFO}" "Script execution completed for environment: ${TARGET_ENVIRONMENT}"
