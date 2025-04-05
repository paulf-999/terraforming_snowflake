# CI/CD Pipelines for Terraforming Snowflake

Described below are the two CI/CD pipelines used within the repo.

## Pull Request (PR) Pipeline

<img src="img/cicd/pr_pipeline.png" alt="PR Pipeline" width="400">

### Purpose:

* Validate the proposed Terraform code, using the commands:
  * `terraform validate`
  * `terraform plan`
* The PR pipeline is triggered when a PR is opened.

### Steps (PR Pipeline):

1. **Set up Terraform**: Initializes the Terraform CLI environment.
2. **Terraform Validate**: Runs the `terraform_validate.sh` script to validate the Terraform config files.
3. **Terraform Plan**: Executes the `terraform_plan.sh` script to generate an execution plan for the proposed changes.

The scripts used for this pipeline can be found here: [../.github/actions/pr_pipeline_terraform_validate_and_plan/action.yml](../.github/actions/pr_pipeline_terraform_validate_and_plan/action.yml).

---

## Code Deployment Pipeline

<img src="img/cicd/code_deployment_pipeline.png" alt="Code Deployment Pipeline" width="600">

### Purpose:

* Deploy Snowflake changes using the command `terraform apply`
* The pipeline is triggered when code is merged into the main branch.

### Steps:

1. **Trigger**: Activated on code merge.
2. **Terraform Plan**: Confirms changes to be applied.
3. **Terraform Apply**: Applies infrastructure changes.
4. **Snowflake Deployment**: Deploys updates to Snowflake.
5. **Push Terraform State**: Updates the Terraform state file via a bash script.

The scripts used for this pipeline can be found here: [../.github/actions/code_deployment_terraform_apply/action.yml](../.github/actions/code_deployment_terraform_apply/action.yml).
