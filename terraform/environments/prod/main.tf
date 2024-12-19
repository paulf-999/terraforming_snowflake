# Roles & Grants
module "roles_and_grants" {
  source    = "./1_roles_and_grants"
  providers = { snowflake = snowflake }

  db_name_prod_db     = "PROD"
}

# Databases
module "example_db" {
  source    = "./2_account_level_objects/database/prod_db"
  providers = { snowflake = snowflake }
}
