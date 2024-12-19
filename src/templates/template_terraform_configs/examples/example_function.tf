# For full details of the config options available for snowflake functions, see https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/function

variable "operations_prod_db" {
  description = "The name of the operations production database"
  type        = string
}

resource "snowflake_function" "function_sp_convert_crontab_into_datetime" {

  # Function attributes
  name     = "SP_CONVERT_CRONTAB_INTO_DATETIME"
  database = var.operations_prod_db
  schema   = "DQ_PLATFORM"
  arguments {
    name = "SCHEDULE"
    type = "VARCHAR"
  }
  return_type     = "TIMESTAMP_NTZ(9)"
  language        = "python"
  runtime_version = "3.10"
  packages        = ["snowflake-snowpark-python", "croniter"]
  handler         = "run"
  statement       = file("${path.module}/run.py")
}
