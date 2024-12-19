terraform {
  required_version = ">= 1.0.0"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.99.0"
    }
  }
}

provider "snowflake" {
  organization_name = var.SNOWFLAKE_ORGANIZATION_NAME
  account_name      = var.SNOWFLAKE_ACCOUNT_NAME
  user              = var.SNOWFLAKE_USER
  password          = var.SNOWFLAKE_PASSWORD
  role              = var.SNOWFLAKE_ROLE
  warehouse         = var.SNOWFLAKE_WAREHOUSE
}
