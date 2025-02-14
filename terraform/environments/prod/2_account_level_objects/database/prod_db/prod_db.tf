resource "snowflake_database" "db_prod" {
  name = "PROD"

  # prevent this DB from being destroyed/recreated
  # recreating this DB is expensive due to the need to create dbt models within the schema `DBT_SNOWFLAKE_MONITORING`
  # as such, let's prevent Terraform from destroying the db
  lifecycle {
    prevent_destroy = true
  }
}

# DB Schemas
locals {

  # List of schema names
  prod_db_schema_names = [
    "AIRFLOW",
    "DBT_PROJECT_EVALUATOR",
    "DBT_SNOWFLAKE_MONITORING",
    "NEW_SCHEMA"
    "UTILITIES"
  ]
}
# generate a schema for each entry in the schema_names list
resource "snowflake_schema" "db_prod_schemas" {
  for_each = toset(local.prod_db_schema_names)
  database = snowflake_database.db_prod.name
  name     = each.value

  # same as the above, destroying the schemas can cause unnecessary issues - so let's prevent Terraform from doing so
  lifecycle {
    prevent_destroy = true
  }
}

# ---------------------------
# Schema-level objects
# ---------------------------

module "table" {
  source                         = "./table"
  providers                      = { snowflake = snowflake }
  db_name_prod_db          = snowflake_database.db_prod.name
  schema_name_prod_airflow = snowflake_schema.db_prod_schemas["AIRFLOW"].name
}
