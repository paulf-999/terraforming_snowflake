# Grant ownership of each of the Snowflake objects to the role 'PROD_WRITE role'
resource "snowflake_grant_ownership" "grant_ownership_to_prod_write_role" {
  for_each = toset(["SCHEMAS", "TABLES", "SEQUENCES"])

  account_role_name   = var.prod_write_role
  outbound_privileges = "COPY"

  on {
    all {
      object_type_plural = each.key
      in_database        = snowflake_database.db_prod.name
    }
  }

  depends_on = [
    # Schemas
    snowflake_schema.db_prod_schemas,
    # Tables
    module.table
  ]
}

# Grant ownership of the PROD db schemas
resource "snowflake_grant_ownership" "grant_ownership_prod_db_schemas_to_prod_write_role" {

  # Grant OWNERSHIP to the the PROD_WRITE role
  account_role_name = var.prod_write_role

  # of the PROD database
  on {
    all {
      object_type_plural = "SCHEMAS"
      in_database        = snowflake_database.db_prod.name
    }
  }

  # ensure the schemas are created before changing ownership
  depends_on = [snowflake_grant_ownership.grant_ownership_to_prod_write_role]
}

# Grant ownership of the PROD db
resource "snowflake_grant_ownership" "grant_ownership_prod_db_to_prod_write_role" {

  # Grant OWNERSHIP to the the PROD_WRITE role
  account_role_name   = var.prod_write_role
  outbound_privileges = "COPY"

  # of the PROD database
  on {
    object_type = "DATABASE"
    object_name = snowflake_database.db_prod.name
  }

  # Ensure all schemas and schema-level objects (tables, views, stored procedures, and functions) are created
  depends_on = [snowflake_grant_ownership.grant_ownership_to_prod_write_role]
}
