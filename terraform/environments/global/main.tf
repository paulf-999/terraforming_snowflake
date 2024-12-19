# Reference the remote state of the prod environment
data "terraform_remote_state" "prod" {
  backend = "local"

  config = {
    path = "../prod/terraform.tfstate" # Correct path to the prod terraform state file
  }
}

# Roles & Grants

# Use the referenced outputs in the roles_and_grants module
module "roles_and_grants" {
  source    = "./1_roles_and_grants"
  providers = { snowflake = snowflake }

  # We need to capture the dependency, whereby we can only grant FUNC_TERRAFORM_ROLE 'usage' of the PROD db schemas once ownership has been passed to the DQ_ALL_ROLE
  prod_db                     = data.terraform_remote_state.prod.outputs.prod_db
  grant_ownership_dep_prod_db = data.terraform_remote_state.prod.outputs.grant_ownership_prod_db_schemas
}
