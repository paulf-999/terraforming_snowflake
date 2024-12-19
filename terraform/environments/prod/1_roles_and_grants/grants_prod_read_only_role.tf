# Assign default grants to role PROD_READ_ONLY
module "default_grants_for_prod_read_only_role" {
  source    = "../../../modules/grants/default_grants_new_role"
  role_name = snowflake_account_role.role_prod_read_only.name
}

# Grant READ-ONLY access to UAT databases to PROD_READ_ONLY
module "grant_prod_read_only_role_read_only_access_to_uat_dbs" {
  source = "../../../modules/grants/grants_db_access/grant_read_only_db_access"

  # apply this to all input dbs listed below
  for_each = toset([var.db_name_prod_db])

  db_name   = each.value
  role_name = snowflake_account_role.role_prod_read_only.name
}
