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

clean_demo:
	rm -rf terraform/environments/prod/tfplan
# -----------------------------------------------------------------------
# Demo
# -----------------------------------------------------------------------
demo1_terraform_cli:
	@Rename the DB
	@# 1. Update PROD db entry (terraform/environments/prod/main.tf)
	@# 2. Navigate to the dir in the terminal (cd terraform/environments/prod)
	@# 3. Rm tfplan (rm -rf tfplan)
	@# 4. Run
	@	  - terraform validate
	@	  - terraform plan (bash terraform_plan.sh)
	@	  - terraform apply (terraform apply -auto-approve tfplan)

demo2_cicd:
	@Rename the DB
	@# 1. Update PROD db entry (terraform/environments/prod/main.tf)
	@# 2. Navigate to the dir in the terminal (cd terraform/environments/prod)
	@# 3. Git steps
	@	  - git checkout -b feature/demo2_cicd
	@	  - git add main.tf
	@	  - git commit -m "Demo - renamed PROD db to ANALYTICS_PROD"
	@	  - git push origin feature/demo2_cicd
	@# 4. Create PR
	@ 	  - Highlight commands
	@# 5. Merge PR
	@ 	  - Highlight commands
	@     - Show renamed db
	@     - Mention tfstate in repo - just for demo


# Phony targets
.PHONY: all deps install run test clean

# .PHONY tells Make that these targets don't represent files
# This prevents conflicts with any files named "all" or "clean"

# cd ~/git/snowflake/terraforming_snowflake/terraform/environments/prod
