# Grant USAGE on the database
resource "snowflake_grant_privileges_to_account_role" "grant_db_usage_to_role" {

  # Grant the input role
  account_role_name = var.role_name
  privileges        = ["USAGE"]

  on_account_object {
    object_type = "DATABASE"
    object_name = var.db_name
  }
}

# Grant USAGE on all schemas in the database
resource "snowflake_grant_privileges_to_account_role" "grant_schema_usage_to_role" {

  # Grant the input role
  account_role_name = var.role_name
  privileges        = ["USAGE"]

  on_schema {
    all_schemas_in_database = var.db_name
  }

  depends_on = [snowflake_grant_privileges_to_account_role.grant_db_usage_to_role]
}

# Grant SELECT privileges on all tables and views
resource "snowflake_grant_privileges_to_account_role" "grant_select_on_tables_and_views" {

  # Grant the input role
  account_role_name = var.role_name
  privileges        = ["SELECT"]

  for_each = toset(["TABLES", "VIEWS"])

  on_schema_object {
    all {
      object_type_plural = each.key
      in_database        = var.db_name
    }
  }

  depends_on = [snowflake_grant_privileges_to_account_role.grant_db_usage_to_role]
}

# ------------------------------------------------------
# Future USAGE grants
# ------------------------------------------------------
# Grant USAGE on future schemas in the database
resource "snowflake_grant_privileges_to_account_role" "grant_usage_on_future_schemas" {

  # Grant the input role
  account_role_name = var.role_name
  privileges        = ["USAGE"]

  on_schema {
    future_schemas_in_database = var.db_name
  }

  depends_on = [snowflake_grant_privileges_to_account_role.grant_db_usage_to_role]
}

# Grant USAGE on future tables and views in the database
resource "snowflake_grant_privileges_to_account_role" "grant_usage_on_future_tables_and_views" {
  # Grant the input role
  account_role_name = var.role_name
  privileges        = ["SELECT"]
  for_each          = toset(["TABLES", "VIEWS"])
  on_schema_object {
    future {
      object_type_plural = each.key
      in_database        = var.db_name
    }
  }
  depends_on = [snowflake_grant_privileges_to_account_role.grant_db_usage_to_role]
}
