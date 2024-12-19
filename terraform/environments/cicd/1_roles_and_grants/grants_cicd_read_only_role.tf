# Assign default grants to the CICD_READ_ONLY role
module "default_grants_for_cicd_all_sel_role" {
  source    = "../../../modules/grants/default_grants_new_role"
  role_name = snowflake_account_role.role_cicd_read_only.name
}

# Grant READ-ONLY access to the CICD database to the CICD_READ_ONLY role
module "grant_cicd_all_sel_role_read_only_access_to_cicd_dbs" {
  source = "../../../modules/grants/grants_db_access/grant_read_only_db_access"

  # apply this to all input dbs listed below
  for_each = toset([var.db_name_cicd_db])

  db_name   = each.value
  role_name = snowflake_account_role.role_cicd_read_only.name
}
