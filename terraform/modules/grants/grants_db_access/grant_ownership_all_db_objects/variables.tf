variable "db_name" {
  description = "The name of the Snowflake database."
  type        = string
}

variable "role_name" {
  description = "The name of the Snowflake role to grant privileges to."
  type        = string
}

variable "db_object_types" {
  description = "List of object types to grant ownership for."
  type        = list(string)
  default     = ["TABLES", "SEQUENCES"]
}
