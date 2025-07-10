locals {

  # List of Snowflake 'system' roles to assign as parents to any custom role
  system_roles = [
    "SYSADMIN",
    "SECURITYADMIN",
    "ACCOUNTADMIN"
  ]
}

# Assign Snowflake's system roles as parent roles to the input role
resource "snowflake_grant_account_role" "module_grant_role_to_system_roles" {
  for_each         = toset(local.system_roles) # iterate through the entries in the list role_grants
  role_name        = var.role_name
  parent_role_name = each.value
}

# Allow the role to use the warehouse 'DEV_WH'
resource "snowflake_grant_privileges_to_account_role" "module_grant_dev_warehouse_usage_to_role_v1" {

  account_role_name = var.role_name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = "DEV_WH"
  }
  privileges = ["USAGE"]

  # Ignore changes to the privileges attribute to prevent unnecessary updates
  lifecycle {
    ignore_changes = [privileges]
  }
}
