variable "SNOWFLAKE_ORGANIZATION_NAME" {
  description = "The Snowflake organisation name"
  type        = string
}

variable "SNOWFLAKE_ACCOUNT_NAME" {
  description = "The Snowflake account name"
  type        = string
}

variable "SNOWFLAKE_USER" {
  description = "The Snowflake username"
  type        = string
}

variable "SNOWFLAKE_PASSWORD" {
  description = "The Snowflake password"
  type        = string
  sensitive   = true
}

variable "SNOWFLAKE_ROLE" {
  description = "The Snowflake role"
  type        = string
}

variable "SNOWFLAKE_WAREHOUSE" {
  description = "The Snowflake warehouse"
  type        = string
}
