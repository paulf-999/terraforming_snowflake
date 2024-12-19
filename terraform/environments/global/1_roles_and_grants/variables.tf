variable "prod_db" {
  description = "The name of the DQ_FRAMEWORK database"
  type        = string
}

variable "grant_ownership_dep_prod_db" {
  description = "List of DQ Framework DB schemas used as a dependency"
  type        = any
}
