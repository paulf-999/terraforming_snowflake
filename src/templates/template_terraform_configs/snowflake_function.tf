# For full details of the config options available for snowflake functions, see https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/function

resource "snowflake_function" "function_<NAME HERE>" {

  # Function attributes
  name     = "<NAME HERE>"
  database = var.<VAR STORING DB NAME HERE>
  schema   = "<SCHEMA NAME HERE>"
  arguments {
    name = "<UPDATE>"
    type = "<UPDATE>"
  }
  return_type     = "<UPDATE>"
  language        = "<UPDATE>"
  runtime_version = "<UPDATE>"
  packages        = ["<UPDATE>"]
  handler         = "<UPDATE>"
  statement       = file("${path.module}/<PATH TO PY FILE HERE>.py")
}
