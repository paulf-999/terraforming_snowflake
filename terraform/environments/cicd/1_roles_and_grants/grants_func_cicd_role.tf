# -----------------------------------------------
# Roles granted to the FUNC_CICD role
# -----------------------------------------------

# Allow the FUNC_CICD role read-only access to dbs A & B
resource "snowflake_grant_account_role" "grant_roles_to_cicd_all_role" {

  # Allow the FUNC_CICD role read-only access to dbs A & B
  for_each = toset(["ROLE_A", "ROLE_B"])

  role_name        = each.value
  parent_role_name = "FUNC_CICD"
}
