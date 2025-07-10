variable "sf_warehouse_name" {
  description = "The name of the Snowflake warehouse."
  type        = string
}

variable "comment" {
  description = "Comment for the Snowflake warehouse."
  type        = string
  default     = null
}

variable "sf_warehouse_size" {
  description = "The size of the Snowflake warehouse (e.g., XSMALL, SMALL, MEDIUM)."
  type        = string
}

variable "max_cluster_count" {
  description = "Maximum number of clusters for the warehouse."
  type        = number
  default     = 1
}

variable "min_cluster_count" {
  description = "Minimum number of clusters for the warehouse."
  type        = number
  default     = 1
}

variable "sf_wh_scaling_policy" {
  description = "The scaling policy for the Snowflake warehouse (e.g., STANDARD, ECONOMY)."
  type        = string
}

variable "max_concurrency_level" {
  description = "The maximum number of concurrent SQL statements that can be executed by the Snowflake warehouse."
  type        = number
  default     = 1
}

variable "role_name_ownership_perms" {
  description = "The name of the Snowflake role to grant privileges to."
  type        = string
}

variable "role_name_usage_perms" {
  description = "The name of the Snowflake role to grant USAGE privileges to."
  type        = string
}
