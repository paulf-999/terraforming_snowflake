# For full details of the config options available for snowflake views, see https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/view

resource "snowflake_view" "view_dq_current_long_running_queries" {

  # View attributes
  database = var.operations_prod_db
  schema   = "DQ_DATA_LAKE"
  name     = "DQ_CURRENT_LONG_RUNNING_QUERIES"

  # The SQL used to create the view
  statement = file("${path.module}/sql/dq_data_lake_views/dq_long_running_queries.sql")
}
