# Grant OWNERSHIP of all specified DB object types (e.g., TABLES, SEQUENCES) to the target role
resource "snowflake_grant_ownership" "grant_ownership_db_obj_types_to_role" {
  # Loop through the list of object types to grant
  for_each = toset(var.db_object_types)

  # Role that will receive ownership
  account_role_name = var.role_name

  # Copy existing privileges to new owner
  outbound_privileges = "COPY"

  on {
    all {
      # Type of objects to grant (plural)
      object_type_plural = each.key
      # Limit to this database
      in_database = var.db_name
    }
  }
}

# Grant OWNERSHIP of all schemas in the DB to the target role
resource "snowflake_grant_ownership" "grant_ownership_db_schemas_to_role" {
  account_role_name = var.role_name

  on {
    all {
      # Grant for all schemas in the database
      object_type_plural = "SCHEMAS"
      in_database        = var.db_name
    }
  }

  # Run after object-level grants complete
  depends_on = [
    snowflake_grant_ownership.grant_ownership_db_obj_types_to_role
  ]
}

# Grant OWNERSHIP of the database itself to the target role
resource "snowflake_grant_ownership" "grant_ownership_db_to_role" {
  account_role_name   = var.role_name
  outbound_privileges = "COPY"

  on {
    # Grant for the database
    object_type = "DATABASE"
    object_name = var.db_name
  }

  # Run after schema-level grants complete
  depends_on = [
    snowflake_grant_ownership.grant_ownership_db_schemas_to_role
  ]
}
