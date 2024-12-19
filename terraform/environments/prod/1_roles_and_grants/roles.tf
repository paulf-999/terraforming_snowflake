resource "snowflake_account_role" "role_prod_read_only" {

  name    = "PROD_READ_ONLY"
  comment = "Read-only equivalent of the PROD_WRITE role"
}
