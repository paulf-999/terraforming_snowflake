output "prod_db" {
  value = snowflake_database.db_prod.name
}

output "grant_ownership_operations_db_to_prod_write_role" {
  value = snowflake_grant_ownership.grant_ownership_operations_db_to_prod_write_role
}
