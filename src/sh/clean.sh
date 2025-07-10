rm terraform/environments/dev/1_roles_and_grants/roles.tf
rm -rf terraform/environments/dev/2_account_level_objects/database
rm -rf terraform/environments/dev/2_account_level_objects/warehouse
git restore terraform/environments/dev/main.tf
rm -rf tmp

git rm -rf terraform/environments/dev/2_account_level_objects/database
git rm -rf terraform/environments/dev/2_account_level_objects/warehouse
