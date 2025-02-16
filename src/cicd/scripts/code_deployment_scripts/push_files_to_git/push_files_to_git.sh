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
# supporting functions for this script are stored within functions_push_files_to_git.sh
source src/cicd/scripts/code_deployment_scripts/push_files_to_git/functions_push_files_to_git.sh

# Check if required arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    log_message "${ERROR}" "Error: Missing arguments."
    log_message "${DEBUG}" "Usage: $0 <branch_name> <environment>"
    exit 1
fi

# post-env var validation, assign the 2 vars below
SOURCE_GIT_BRANCH_NAME=$1 # Source Git branch name (e.g., main)
ENV_NAME=$2 # Target environment (e.g., dev, uat, prod)

# other variables used
ENV_NAME_UPPER=${ENV_NAME^^}
TF_STATE_FILE="terraform/environments/${ENV_NAME}/terraform.tfstate" # the Terraform state file to be added, per-env
CHANGES_MADE=false # flag used to detect whether Git has detected any new/changed files

#=======================================================================
# Functions
#=======================================================================

# Push changes to remote branch
push_changes() {
    if [ "$CHANGES_MADE" = true ]; then
        RETRY_LIMIT=3
        RETRY_DELAY=5  # in seconds
        RETRIES=0

        while [ $RETRIES -lt $RETRY_LIMIT ]; do

            # If RETRIES is not 0, pull the latest changes before pushing
            if [ $RETRIES -gt 0 ]; then
                log_message "${DEBUG}" "Step 4.1: Pulling latest changes from remote to resolve potential conflicts."
                log_cmd_message "${DEBUG_DETAILS} "cmd: git pull --rebase origin ${SOURCE_GIT_BRANCH_NAME}"
                git pull --rebase origin "${SOURCE_GIT_BRANCH_NAME}" || {
                    log_message "${ERROR}" "Error: Pull failed. Retrying pull attempt... (Attempt #$((RETRIES + 1)))"
                    sleep $RETRY_DELAY
                    RETRIES=$((RETRIES + 1))
                    continue
                }
            fi

            # Attempt the push
            log_message "${DEBUG}" "Step 4: Pushing the local changes to the remote Git branch."
            log_cmd_message "${DEBUG_DETAILS} "cmd: git push origin HEAD:${SOURCE_GIT_BRANCH_NAME}"
            git push origin HEAD:"${SOURCE_GIT_BRANCH_NAME}"

            if [ $? -eq 0 ]; then
                if [ $RETRIES -eq 0 ]; then
                    log_message "${DEBUG_DETAILS}" "Changes successfully pushed to remote."
                else
                    log_message "${DEBUG_DETAILS}" "Changes successfully pushed to remote after ${RETRIES} retry(ies)."
                fi
                return 0  # Exit the function if push is successful
            else
                log_message "${ERROR}" "Error: Push failed. Retrying... (Attempt #$((RETRIES + 1)))"
                sleep $RETRY_DELAY
                RETRIES=$((RETRIES + 1))
            fi
        done


        # If we reach here, all retries failed
        log_message "${ERROR}" "Error: Push failed after $RETRY_LIMIT attempts. Please check the pipeline."
        exit 1
    else
        log_message "${DEBUG}" "No changes to push to remote."
    fi
}

# Check if file has local changes and commit if necessary
commit_changes() {
    log_message "${DEBUG}" "Step 3: Check if any changes are detected for this env, as part of this code deployment."

    log_cmd_message "${DEBUG_DETAILS} "cmd: git diff --quiet ${TF_STATE_FILE}"

    # no changes detected, skip commit
    if git diff --quiet "${TF_STATE_FILE}"; then
        log_message ${NEUTRAL} "INFO: No changes detected in ${TF_STATE_FILE}. Skipping commit."

    # changes detected, commit them to the remote branch
    else
        log_message ${NEUTRAL} "INFO: Changes detected in ${TF_STATE_FILE}!"
        log_message "${DEBUG}" "Step 3.1: Run 'git add <filename>'"

        # run 'git add' for both the terraform state file & it's corresponding backup file
        for FILE in "${TF_STATE_FILE}" "${TF_STATE_FILE}.backup"; do
            log_cmd_message "${DEBUG_DETAILS} "cmd: git add ${FILE} -f"
            git add "${FILE}" -f
        done

        log_cmd_message "${DEBUG_DETAILS} "cmd: git commit -m 'Automated commit: Updated Terraform state file for ${ENV_NAME_UPPER} environment.'"
        git commit -m "Automated commit: Updated Terraform state file for ${ENV_NAME_UPPER} environment."

        # set 'CHANGES_MADE' to true, to capture that Git has detected any new/changed files
        log_message "${DEBUG}" "Step 3.2: Flag changes have been made."
        log_cmd_message "${DEBUG_DETAILS} "cmd: CHANGES_MADE=true"
        CHANGES_MADE=true
    fi
}

# fetch and merge any changes detected on the remote Git branch
check_for_updates_on_remote_branch_and_merge() {

    # Fetch latest changes from remote Git branch (see functions_push_files_to_git.sh)
    log_message "${DEBUG}" "Step 1: Fetch latest changes from remote branch."
    fetch_remote

    # Check for incoming changes from the remote branch
    log_message "${DEBUG}" "Step 2: Check for incoming changes from the remote branch"
    log_cmd_message '${DEBUG_DETAILS} "cmd: git diff --quiet HEAD..origin/${SOURCE_GIT_BRANCH_NAME}'

    # Merge any incoming changes from the remote branch
    if git diff --quiet HEAD..origin/${SOURCE_GIT_BRANCH_NAME}; then
        log_message ${NEUTRAL} "INFO: No incoming changes detected from the remote branch."
    else
        log_message "${DEBUG_DETAILS}" "Incoming changes detected from remote branch. Merging with local branch..."

        # Merge changes from remote and resolve conflicts (see functions_push_files_to_git.sh)
        merge_remote_branch
    fi
}

# Initial Git setup required for interacting with Git within the CI/CD job
git_setup() {

    # Configure the Git user (see functions_push_files_to_git.sh)
    configure_git_user

    # Ensure we're on the correct branch (see functions_push_files_to_git.sh)
    checkout_branch
}

trap handle_interruption SIGINT  # Handle interruptions gracefully

#=======================================================================
# Main script logic
#=======================================================================
log_message "${INFO}" "Script execution started for environment: ${ENV_NAME_UPPER}"

# Do some initial Git setup for the CICD job before proceeding
git_setup

# fetch and merge any changes detected on the remote Git branch
check_for_updates_on_remote_branch_and_merge

# Check if there are any local changes and commit the changes
commit_changes

# Push local changes to remote branch
push_changes
