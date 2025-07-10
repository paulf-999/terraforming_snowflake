terraform {
  required_version = ">= 1.0.0"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 1.0.2"
    }
  }
}

provider "snowflake" {
  organization_name = var.SNOWFLAKE_ORGANIZATION_NAME
  account_name      = var.SNOWFLAKE_ACCOUNT_NAME
  user              = var.SNOWFLAKE_USER
  private_key       = file("~/.ssh/snowflake_key.p8")
  authenticator     = "SNOWFLAKE_JWT"
  role              = var.SNOWFLAKE_ROLE
  warehouse         = var.SNOWFLAKE_WAREHOUSE

  # some SF-Terraform features are still in preview - so we need to enable them
  preview_features_enabled = ["snowflake_table_resource", "snowflake_table_constraint_resource", "snowflake_sequence_resource", "snowflake_function_python_resource"]
}
