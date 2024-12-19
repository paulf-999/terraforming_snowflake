locals {

  # List of Snowflake 'system' roles to assign as parents to any custom role
  system_roles = [
    "SYSADMIN",
    "SECURITYADMIN",
    "ACCOUNTADMIN"
  ]
}

# Assign Snowflake's system roles as parent roles to the input role
resource "snowflake_grant_account_role" "grant_input_role_to_system_roles" {
  for_each         = toset(local.system_roles) # iterate through the entries in the list role_grants
  role_name        = var.role_name
  parent_role_name = each.value
}

# Allow the role to use the warehouse 'DEV_WH'
resource "snowflake_grant_privileges_to_account_role" "grant_warehouse_usage_to_input_role" {

  account_role_name = var.role_name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = "DEV_WH"
  }
  privileges = ["USAGE"]
}
