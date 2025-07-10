# Create a Snowflake warehouse with the specified configuration
resource "snowflake_warehouse" "module_snowflake_warehouse" {

  # Mandatory fields
  name           = var.sf_warehouse_name # Warehouse name
  warehouse_size = var.sf_warehouse_size # Warehouse size (e.g., XSMALL, SMALL, MEDIUM)

  # Optional fields
  comment               = var.comment               # Comment for the warehouse
  max_cluster_count     = var.max_cluster_count     # Maximum number of clusters
  min_cluster_count     = var.min_cluster_count     # Minimum number of clusters
  scaling_policy        = var.sf_wh_scaling_policy  # Scaling policy (STANDARD or ECONOMY)
  max_concurrency_level = var.max_concurrency_level # Maximum concurrent SQL statements

  # Default warehouse behavior
  auto_suspend        = 60   # Suspend after 60 seconds of inactivity
  auto_resume         = true # Resume automatically on query execution
  initially_suspended = true # Start in a suspended state
}

# Grant ownership of the Snowflake warehouse to the desired role
resource "snowflake_grant_ownership" "module_grant_ownership_snowflake_warehouse" {


  # Grant OWNERSHIP to the input role
  account_role_name   = var.role_name_ownership_perms
  outbound_privileges = "COPY"


  on {
    object_type = "WAREHOUSE"
    # object_name = "\"${snowflake_warehouse.module_snowflake_warehouse.name}\""
    object_name = snowflake_warehouse.module_snowflake_warehouse.name
  }

  depends_on = [snowflake_warehouse.module_snowflake_warehouse]
}

# Grant USAGE of the Snowflake warehouse to the desired role
resource "snowflake_grant_privileges_to_account_role" "module_grant_usage_snowflake_warehouse" {

  account_role_name = var.role_name_usage_perms

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.module_snowflake_warehouse.name
  }
  privileges = ["USAGE"]
}
