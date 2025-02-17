SHELL = /bin/sh

.EXPORT_ALL_VARIABLES:

# Include child Makefiles
include src/make/terminal_colour_formatting.mk
include src/make/setup.mk

include .env

# Targets
all: deps install clean

deps: validate_env_vars
	@echo && echo "${INFO}Called makefile target 'deps'. Create virtualenv with required Python libs.${COLOUR_OFF}" && echo
	@echo "${DEBUG}1. Install Terraform${COLOUR_OFF}"
	@./src/sh/install_terraform.sh
	@echo && echo "${DEBUG}2. Create the required Snowflake user 'SVC_USER' and role 'FUNC_TERRAFORM_ROLE'${COLOUR_OFF}" && echo
	@# see src/make/setup.mk for the target 'create_snowflake_svc_user_and_terraform_role'
	@make -s create_snowflake_svc_user_and_terraform_role

install:
	@echo "${INFO}\nCalled makefile target 'install'. Run the setup & install targets.\n${COLOUR_OFF}"
	@echo "${DEBUG} Create Terraform File/Folder Structure${COLOUR_OFF}"
	@terraform init

run:
	@echo "${INFO}\nCalled makefile target 'run'. Launch service.${COLOUR_OFF}\n"

test:
	@echo "${INFO}\nCalled makefile target 'test'. Perform any required tests.${COLOUR_OFF}\n"

clean:
	@echo "${INFO}\nCalled makefile target 'clean'. Restoring the repository to its initial state.${COLOUR_OFF}\n"

demo1_terraform_cli:
	@# 1. Update PROD db entry (terraform/environments/prod/main.tf)
	@# 2. Run
	@	  - terraform validate
	@	  - terraform plan
	@	  - terraform apply


# Phony targets
.PHONY: all deps install run test clean

# .PHONY tells Make that these targets don't represent files
# This prevents conflicts with any files named "all" or "clean"
