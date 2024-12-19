#!/bin/bash

#=======================================================================
# Script Name: push_files_to_git.sh
# Description: Automates committing and pushing updated Terraform state files
#              for a specific environment to a specified Git branch.
#
# Usage: ./push_files_to_git.sh <branch_name> <environment>
#        <branch_name> - The target Git branch to push changes to.
#        <environment> - The environment being processed (e.g., dev, uat, prod).
#
# Author: Paul Fry
# Date: 27th June 2024 (Revised: [Insert Today's Date])
#=======================================================================

#=======================================================================
# Variables
#=======================================================================

# Source common shell script variables and functions
source src/sh/shell_utilities.sh

# Source common terraform functions
source src/cicd/scripts/common/terraform_utilities.sh

# Ensure a branch name and environment are provided as arguments
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: Missing arguments. Usage: ./push_files_to_git.sh <branch_name> <environment>"
    exit 1
fi

# Set variables
SOURCE_GIT_BRANCH_NAME=${1}
TARGET_ENVIRONMENT=${2}
GIT_REPO="payroc/dmt-scripts-snowflake.git"
GIT_BOT_EMAIL="git-bot@payroc.com"
GIT_BOT_USERNAME="gitbot-dmt-payroc"

# Target state files
TF_STATE_FILE="terraform/environments/${TARGET_ENVIRONMENT}/terraform.tfstate"
TF_STATE_BKP_FILE="terraform/environments/${TARGET_ENVIRONMENT}/terraform.tfstate.backup"

#=======================================================================
# Functions
#=======================================================================

# Function to attempt a git pull with rebase and handle conflicts if any
attempt_pull_with_rebase() {
    # Try to pull with rebase
    git pull --rebase origin "${SOURCE_GIT_BRANCH_NAME}" || {
        echo "git pull failed, attempting to resolve conflicts automatically";

        # Abort the rebase to start fresh
        git rebase --abort

        # Fetch the latest changes from remote
        git fetch origin

        # Reset to the remote branch state
        git reset --hard origin/"${SOURCE_GIT_BRANCH_NAME}"

        # Reapply local changes
        if [ -f "${TF_STATE_FILE}" ]; then
            git add "${TF_STATE_FILE}" -f
            if [ -f "${TF_STATE_BKP_FILE}" ]; then
                git add "${TF_STATE_BKP_FILE}" -f
            fi
        else
            echo "No state file found for environment '${TARGET_ENVIRONMENT}'. Skipping."
        fi

        # Commit changes
        git commit -m "Git service account: upload latest Terraform state files."

        # Attempt to pull with merge strategy preferring theirs
        git pull origin "${SOURCE_GIT_BRANCH_NAME}" --strategy-option theirs || {
            echo "Merge failed, manual intervention required";
            exit 1;
        }

        # Add all changes
        git add -A

        # Commit the merge resolution
        git commit -m "Resolve merge conflicts by preferring remote changes"
    }
}

# Function to push updated version to git
push_updated_version_to_git() {
    # Configure the Git user
    git config user.email ${GIT_BOT_EMAIL}
    git config user.name ${GIT_BOT_USERNAME}

    # Remove any existing rebase applications
    rm -rf .git/rebase-apply

    # Debug: Print the current remote URL to verify
    echo "started: git remote command"
    git remote -v

    # Add state files for the specified environment
    if [ -f "${TF_STATE_FILE}" ]; then
        git add "${TF_STATE_FILE}" -f
        if [ -f "${TF_STATE_BKP_FILE}" ]; then
            git add "${TF_STATE_BKP_FILE}" -f
        fi
    else
        echo "No state file found for environment '${TARGET_ENVIRONMENT}'. Exiting."
        exit 0
    fi

    # Commit the changes
    git commit -m "Git service account: upload latest Terraform state files for environment '${TARGET_ENVIRONMENT}'."

    # Attempt to pull with rebase
    attempt_pull_with_rebase

    # Push the changes to the remote branch
    git push origin HEAD:"${SOURCE_GIT_BRANCH_NAME}" || { echo "git push failed"; exit 1; }
}

#=======================================================================
# Main script logic
#=======================================================================
log_message "${INFO}" "Script execution started for environment '${TARGET_ENVIRONMENT}'."

# Trap interruptions (e.g., Ctrl+C)
trap handle_interruption SIGINT

# Push the generated Terraform state files for the target environment
push_updated_version_to_git

log_message "${INFO}" "Script execution completed for environment '${TARGET_ENVIRONMENT}'."
