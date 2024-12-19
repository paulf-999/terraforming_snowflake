#!/bin/bash

#=======================================================================
# Variables
#=======================================================================

# Source common shell script variables and functions
source src/sh/shell_utilities.sh

#=======================================================================
# Main script logic
#=======================================================================
if [ -z "$SYSTEM_PULLREQUEST_SOURCEBRANCH" ]; then
  BUILD_SOURCE_BRANCH=${BUILD_SOURCEBRANCH#refs/heads/}
  echo "##vso[task.setvariable variable=SOURCE_GIT_BRANCH_NAME]$BUILD_SOURCE_BRANCH"
  echo && log_message "${DEBUG_DETAILS}" "Debug: Source Git Branch Name set to the value of the variable 'BUILD_SOURCEBRANCHNAME'"
  echo && log_message "${DEBUG}" "Value of SOURCE_GIT_BRANCH_NAME: ${BUILD_SOURCE_BRANCH}"
else
  PR_SOURCE_BRANCH=${SYSTEM_PULLREQUEST_SOURCEBRANCH#refs/heads/}
  echo "##vso[task.setvariable variable=SOURCE_GIT_BRANCH_NAME]${PR_SOURCE_BRANCH}"
  echo && log_message "${DEBUG_DETAILS}" "Debug: Source Git Branch Name is set to the value of the variable 'SYSTEM_PULLREQUEST_SOURCEBRANCH'"
  echo && log_message "${INFO}" "Value of SOURCE_GIT_BRANCH_NAME: ${PR_SOURCE_BRANCH}"
fi
