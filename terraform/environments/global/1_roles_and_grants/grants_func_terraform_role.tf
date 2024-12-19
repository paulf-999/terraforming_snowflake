# Grant WRITE access to PROD db to FUNC_TERRAFORM_ROLE. But only once ownership of the prod db has been transferred to the PROD_WRITE role
module "grant_func_terraform_role_write_access_to_operations_db" {
  source = "../../../modules/grants/grants_db_access/grant_write_db_access"

  db_name   = var.prod_db
  role_name = "FUNC_TERRAFORM_ROLE"

  # ensure the schemas are created before changing ownership
  depends_on = [var.grant_ownership_dep_prod_db]
}
