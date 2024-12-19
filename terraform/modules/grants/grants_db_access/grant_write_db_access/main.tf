# Grant ALL on the database
resource "snowflake_grant_privileges_to_account_role" "grant_database_usage" {
  account_role_name = var.role_name
  privileges        = ["ALL"]

  on_account_object {
    object_type = "DATABASE"
    object_name = var.db_name
  }
}

# Grant ALL on all schemas in the database
resource "snowflake_grant_privileges_to_account_role" "grant_schema_usage" {
  account_role_name = var.role_name
  privileges        = ["ALL"]

  on_schema {
    all_schemas_in_database = var.db_name
  }

  depends_on = [snowflake_grant_privileges_to_account_role.grant_database_usage]
}

# Grant ALL on all tables/views
resource "snowflake_grant_privileges_to_account_role" "grant_all_on_tables_and_views" {
  for_each = toset(["TABLES", "VIEWS"])

  account_role_name = var.role_name
  privileges        = ["ALL"]

  on_schema_object {
    all {
      object_type_plural = each.key
      in_database        = var.db_name
    }
  }

  depends_on = [snowflake_grant_privileges_to_account_role.grant_database_usage]
}

# Grant ALL on procedures and functions (procedures & functions require a number of perms)
resource "snowflake_grant_privileges_to_account_role" "grant_execute_on_procedures_and_functions" {
  for_each = toset(["PROCEDURES", "FUNCTIONS"])

  account_role_name = var.role_name
  privileges        = ["ALL"]

  on_schema_object {
    all {
      object_type_plural = each.key
      in_database        = var.db_name
    }
  }

  depends_on = [snowflake_grant_privileges_to_account_role.grant_database_usage]
}

# ------------------------------------------------------
# Future USAGE grants
# ------------------------------------------------------
# Grant USAGE on future schemas in the database
resource "snowflake_grant_privileges_to_account_role" "grant_usage_on_future_schemas" {

  # Grant the input role
  account_role_name = var.role_name
  privileges        = ["ALL"]

  on_schema {
    future_schemas_in_database = var.db_name
  }

  depends_on = [snowflake_grant_privileges_to_account_role.grant_database_usage]
}

# Grant USAGE on future tables and views in the database
resource "snowflake_grant_privileges_to_account_role" "grant_usage_on_future_tables_and_views" {
  # Grant the input role
  account_role_name = var.role_name
  privileges        = ["ALL"]
  for_each          = toset(["TABLES", "VIEWS"])
  on_schema_object {
    future {
      object_type_plural = each.key
      in_database        = var.db_name
    }
  }
  depends_on = [snowflake_grant_privileges_to_account_role.grant_database_usage]
}
