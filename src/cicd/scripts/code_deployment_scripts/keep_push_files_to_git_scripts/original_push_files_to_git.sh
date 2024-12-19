#!/bin/bash

#=======================================================================
# Script Name: push_files_to_git.sh
# Description: This script automates the process of committing and pushing
#              updated Terraform state files to a specified Git branch.
#
# Usage: ./push_files_to_git.sh <branch_name>
#        <branch_name> - The target Git branch to push changes to.
#
# Author: Paul Fry
# Date: 27th June 2024
#=======================================================================

#=======================================================================
# Variables
#=======================================================================

# Source common shell script variables and functions
source src/sh/shell_utilities.sh
source src/cicd/scripts/common/terraform_utilities.sh

# Ensure a branch name is provided as the first argument
if [ -z "$1" ]; then
    echo "Error: No branch name provided."
    exit 1
fi

# Set the source Git branch name from the first argument
SOURCE_GIT_BRANCH_NAME=${1}
GIT_REPO="TODO - update me"
GIT_BOT_EMAIL="TODO - update me"
GIT_BOT_USERNAME="gitbot-UPDATE-ME"

# Terraform state files
GLOBAL_STATE_FILE="terraform/terraform.tfstate"
GLOBAL_STATE_BKP_FILE="terraform/terraform.tfstate.backup"

ENVIRONMENTS=("dev" "uat" "cicd" "prod")
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
        for environment in "${ENVIRONMENTS[@]}"; do
            TF_STATE_FILE="terraform/environments/${environment}/terraform.tfstate"
            TF_STATE_BKP_FILE="terraform/environments/${environment}/terraform.tfstate.backup"
            if [ -f "${TF_STATE_FILE}" ]; then
                git add "${TF_STATE_FILE}" -f
                if [ -f "${TF_STATE_BKP_FILE}" ]; then
                    git add "${TF_STATE_BKP_FILE}" -f
                fi
            else
                echo "Skipping environment '${environment}' as no state file exists."
            fi
        done

        # Add global state file if it exists
        if [ -f "${GLOBAL_STATE_FILE}" ]; then
            git add "${GLOBAL_STATE_FILE}" -f
            git add "${GLOBAL_STATE_BKP_FILE}" -f
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

    # Add all Terraform state files for commit
    for environment in "${ENVIRONMENTS[@]}"; do
        TF_STATE_FILE="terraform/environments/${environment}/terraform.tfstate"
        TF_STATE_BKP_FILE="terraform/environments/${environment}/terraform.tfstate.backup"
        if [ -f "${TF_STATE_FILE}" ]; then
            git add "${TF_STATE_FILE}" -f
            if [ -f "${TF_STATE_BKP_FILE}" ]; then
                git add "${TF_STATE_BKP_FILE}" -f
            fi
        else
            echo "Skipping environment '${environment}' as no state file exists."
        fi
    done

    # Add global state file if it exists
    if [ -f "${GLOBAL_STATE_FILE}" ]; then
        git add "${GLOBAL_STATE_FILE}" -f
        git add "${GLOBAL_STATE_BKP_FILE}" -f
    fi

    # Commit the changes
    git commit -m "Git service account: upload latest Terraform state files."

    # Attempt to pull with rebase
    attempt_pull_with_rebase

    # Push the changes to the remote branch
    git push origin HEAD:"${SOURCE_GIT_BRANCH_NAME}" || { echo "git push failed"; exit 1; }
}

#=======================================================================
# Main script logic
#=======================================================================
log_message "${INFO}" "Script execution started."

# Trap interruptions (e.g., Ctrl+C)
trap handle_interruption SIGINT

# Push the generated Terraform state files up to the Git repo
push_updated_version_to_git

log_message "${INFO}" "Script execution completed."
