SHELL = /bin/sh

# Include child Makefiles
include src/make/terminal_colour_formatting.mk

# Variables
# snowflake script and file path
SNOWFLAKE_CLIENT_SCRIPT=src/py/snowflake_client.py
CREATE_USER_ROLE_SCRIPTS_DIR=src/sql/setup_snowflake_user_and_terraform_role

# Targets
validate_env_vars:
	@echo && echo "${INFO}Called makefile target 'validate_env_vars'. Verify the contents of required env vars.${COLOUR_OFF}"
	@./src/sh/validate_env_vars.sh .env

install_terraform:
	@echo && echo "${INFO}Called makefile target 'install_terraform'. Install Terraform.${COLOUR_OFF}"
	@./src/sh/install_terraform.sh

create_snowflake_privileged_roles:
	@bash src/sql/create_privileged_roles.sql
	@bash src/sql/grant_privs_to_privileged_roles.sql

create_snowflake_svc_user_and_terraform_role:
	@echo && echo "${INFO}Target 'create_snowflake_svc_user_and_terraform_role': create Snowflake service account user & Terraform functional role.${COLOUR_OFF}" && echo
	@echo "1. Create the Snowflake CICD service account user 'SVC_CICD'"
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file ${CREATE_USER_ROLE_SCRIPTS_DIR}/1_create_user_svc_cicd.sql
	@echo && echo "2. Create the Terraform functional role, 'FUNC_TERRAFORM_ROLE'"
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file ${CREATE_USER_ROLE_SCRIPTS_DIR}/2_create_role_func_terraform_role.sql
	@echo && echo "3. Assign the grants needed for 'FUNC_TERRAFORM_ROLE'"
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file ${CREATE_USER_ROLE_SCRIPTS_DIR}/3_grants_func_terraform_role.sql
	@echo && echo "4. Change the ownership of the new user and role"
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file ${CREATE_USER_ROLE_SCRIPTS_DIR}/4_grant_ownership_and_parent_roles_func_terraform_role.sql

# Phony targets
.PHONY: gen_env_template create_svc_cicd_user_and_role
# .PHONY tells Make that these targets don't represent files
# This prevents conflicts with any files named "all" or "clean"
