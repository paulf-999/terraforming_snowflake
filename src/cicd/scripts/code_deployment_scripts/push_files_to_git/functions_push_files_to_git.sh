#!/bin/bash

#=======================================================================
# Variables
#=======================================================================
# Import utility functions
source src/sh/shell_utilities.sh

GIT_BOT_EMAIL="git-bot@payroc.com"
GIT_BOT_USERNAME="gitbot-dmt-payroc"

#=======================================================================
# Functions
#=======================================================================

# Configure the Git user
configure_git_user() {
    git config user.email "${GIT_BOT_EMAIL}" || {
        log_message "${ERROR}" "Error: Failed to set Git user email."
        exit 1
    }
    git config user.name "${GIT_BOT_USERNAME}" || {
        log_message "${ERROR}" "Error: Failed to set Git user name."
        exit 1
    }
}

# Ensure we're on the correct branch
checkout_branch() {
    log_message "${DEBUG}" "Ensuring we're on branch: ${SOURCE_GIT_BRANCH_NAME}"
    log_cmd_message "${DEBUG_DETAILS} "cmd: git checkout -B ${SOURCE_GIT_BRANCH_NAME}"
    git checkout -B "${SOURCE_GIT_BRANCH_NAME}" || {
        log_message "${ERROR}" "Error: Failed to checkout or create the branch ${SOURCE_GIT_BRANCH_NAME}."
        exit 1
    }
}

# Fetch latest changes from remote Git branch
fetch_remote() {
    log_cmd_message "${DEBUG_DETAILS} "cmd: git fetch origin >/dev/null 2>&1"
    git fetch origin >/dev/null 2>&1 || {
        log_message "${ERROR}" "Error: Failed to fetch from remote."
        exit 1
    }
}

# Merge changes from remote and resolve conflicts
merge_remote_branch() {
    log_cmd_message "${DEBUG_DETAILS} "cmd: git merge -X ours origin/${SOURCE_GIT_BRANCH_NAME} --no-edit >/dev/null 2>&1"
    git merge -X ours origin/"${SOURCE_GIT_BRANCH_NAME}" --no-edit >/dev/null 2>&1 || {
        log_message "${DEBUG}" "Merge conflict detected. Resolving conflicts..."
        resolve_git_merge_conflicts # see function below
    }
}

# Resolve Git merge conflicts - I think this function is now redundant, but would need to be confirmed
resolve_git_merge_conflicts() {
    log_cmd_message "${DEBUG_DETAILS} "Resolving merge conflicts. Cmd: git ls-files -u | awk '{ print $4 }' | while read -r conflicted_file; do"
    git ls-files -u | awk '{ print $4 }' | while read -r conflicted_file; do
        if [[ "${conflicted_file}" != "${FILENAME}" ]]; then
            log_message "${DEBUG}" "Importing remote version for unedited file: ${conflicted_file}"
            log_cmd_message "${DEBUG_DETAILS} "cmd: git checkout --theirs ${conflicted_file}"
            git checkout --theirs "${conflicted_file}"
            log_cmd_message "${DEBUG_DETAILS} "cmd: git add "${conflicted_file}""
            git add "${conflicted_file}"
        else
            log_message "${DEBUG}" "Keeping local version for edited file: ${FILENAME}"
            log_cmd_message "${DEBUG_DETAILS} "cmd: git checkout --ours ${FILENAME}"
            git checkout --ours "${FILENAME}"
            log_cmd_message "${DEBUG_DETAILS} "cmd: git add ${FILENAME}"
            git add "${FILENAME}"
        fi
    done

    log_cmd_message "${DEBUG_DETAILS} "cmd: git commit -m Resolved merge conflicts by keeping local or remote versions as needed. >/dev/null'"
    git commit -m "Resolved merge conflicts by keeping local or remote versions as needed."
    log_message "${DEBUG}" "Conflicts resolved."
}
