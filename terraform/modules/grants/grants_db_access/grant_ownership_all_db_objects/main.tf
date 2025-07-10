# Grant ownership of each of the Snowflake objects to the role desired role
resource "snowflake_grant_ownership" "grant_ownership_db_objs_to_role" {

  for_each = toset(["SCHEMAS", "TABLES", "SEQUENCES"])

  # Grant OWNERSHIP to the input role
  account_role_name   = var.role_name
  outbound_privileges = "COPY"

  on {
    all {
      object_type_plural = each.key
      in_database        = var.db_name
    }
  }

  depends_on = [
    # Schemas
    var.schema_names
  ]
}

# Grant ownership of the db schemas
resource "snowflake_grant_ownership" "grant_ownership_db_schemas_to_role" {

  # Grant OWNERSHIP to the input role
  account_role_name = var.role_name

  # of the all schemas in the input database
  on {
    all {
      object_type_plural = "SCHEMAS"
      in_database        = var.db_name
    }
  }

  # ensure the schemas are created before changing ownership
  depends_on = [snowflake_grant_ownership.grant_ownership_db_objs_to_role]
}

# Grant ownership of the db
resource "snowflake_grant_ownership" "grant_ownership_db_to_role" {

  # Grant OWNERSHIP to the input role
  account_role_name   = var.role_name
  outbound_privileges = "COPY"

  # of the input database
  on {
    object_type = "DATABASE"
    object_name = var.db_name
  }

  # Ensure all schemas and schema-level objects (tables, views, stored procedures, and functions) are created
  depends_on = [snowflake_grant_ownership.grant_ownership_db_objs_to_role]
}
