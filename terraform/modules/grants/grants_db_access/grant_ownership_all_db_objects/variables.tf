variable "db_name" {
  description = "The name of the Snowflake database."
  type        = string
}

variable "schema_names" {
  description = "value"
  type        = list(any)
}

variable "role_name" {
  description = "The name of the Snowflake role to grant privileges to."
  type        = string
}
