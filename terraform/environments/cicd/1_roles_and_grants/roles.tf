resource "snowflake_account_role" "role_cicd_read_only" {
  name    = "CICD_READ_ONLY"
  comment = "Read-only role, used to get read-only access to the CICD dbs."
}
