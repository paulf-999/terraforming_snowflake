# For full details of the config options available for snowflake views, see https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/view


resource "snowflake_view" "view_<NAME HERE>" {

  # View attributes
  database = var.<VAR STORING DB NAME HERE>
  schema   = "<SCHEMA NAME HERE>"
  name     = "<VIEW NAME HERE>"

  # The SQL used to create the view
  statement = file("${path.module}/<PATH TO SQL FILE HERE>.sql")
}
