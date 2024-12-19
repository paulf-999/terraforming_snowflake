resource "snowflake_account_role" "role_uat_read_only" {

  name    = "UAT_READ_ONLY"
  comment = "Read-only equivalent of the UAT_WRITE role"
}
