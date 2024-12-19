# Roles & Grants
module "roles_and_grants" {
  source    = "./1_roles_and_grants"
  providers = { snowflake = snowflake }

  db_name_uat_db     = "UAT"
}
