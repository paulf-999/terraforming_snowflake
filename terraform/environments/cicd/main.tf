# Roles & Grants
module "roles_and_grants" {
  source    = "./1_roles_and_grants"
  providers = { snowflake = snowflake }

  db_name_cicd_db     = "CICD"
}
