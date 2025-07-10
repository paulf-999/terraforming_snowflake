# How to Create a New Read-Only Role in Snowflake Using Terraform

This guide provides quick steps to create a **read-only** Snowflake role using Terraform.

> [!NOTE]
> **Example Pull Request**: For a real-world example, refer to this PR: [example PR for new 'read-only' role](https://github.com/payroc/dmt-scripts-snowflake/pull/281).
>
> **Update the placeholder `<UPDATE>` value throughout**
> As you follow this guide, make sure to **update the placeholder `<UPDATE>`** wherever it appears in the script.

---

## Steps

### 1. Identify the Environment for the New Role (`dev`, `uat`, `cicd`, or `prod`)

---

### 2. Add the New Role

Update the `roles.tf` file in the relevant environment directory (`terraform/environments/<ENV>/1_roles_and_grants/roles.tf`) to include the new read-only role:

```hcl
resource "snowflake_account_role" "role_<UPDATE>_sel_role" {
  name    = "<UPDATE>_SEL_ROLE"
  comment = "<UPDATE>"
}
```

> [!NOTE]
> **Update the values for `<UPDATE>`** as needed to match your specific role name and description.

---

### 3. Add Database Variables

Define the database names in the `variables.tf` file (`terraform/environments/<ENV>/1_roles_and_grants/variables.tf`) for the databases you want to give the new role read-only access to:

```hcl
variable "db_name_src_<UPDATE>_db" {
  description = "The name of the <UPDATE> database"
  type        = string
}
```

> [!NOTE]
> **Update the values for `<UPDATE>`** to match your specific database name.

---

### 4. Define Grants

Create a grants file for the new role (`terraform/environments/<ENV>/1_roles_and_grants/grants_<role_name>.tf`):

```hcl
# Default grants
module "default_grants_for_<UPDATE>_sel_role" {
  source    = "../../../modules/grants/default_grants_new_role"
  role_name = snowflake_account_role.role_<UPDATE>.name
}

# Read-only access to databases
module "grant_<UPDATE>_sel_role_read_only_access_to_dbs" {
  source = "../../../modules/grants/grants_db_access/grant_read_only_db_access"

  for_each = toset([var.db_name_src_<UPDATE>_db])
  db_name   = each.value
  role_name = snowflake_account_role.role_<UPDATE>_sel_role.name
}
```

> [!NOTE]
> **Update the values for `<UPDATE>`** as needed to match your role and database names.
> **Update `role_name`**: the value passed to role_name should match whatever you use for "role_<UPDATE>_sel_role" (line 29 above).
> **Update value passed to `toset()`**: this should match whatever you use for "db_name_src_<UPDATE>_db" above (line 45).

---

### 5. Update `main.tf`

Pass the database variables into the `roles_and_grants` module in `terraform/environments/<ENV>/main.tf`:

```hcl
module "roles_and_grants" {
  source    = "./1_roles_and_grants"
  providers = { snowflake = snowflake }

  db_name_<UPDATE>_db = "<UPDATE>"
}
```

> [!NOTE]
> **Update the values for `<UPDATE>`** with the correct database name.

---

## Test Changes

Run the following script to validate and plan the changes: `bash local_terraform_dev.sh`.

This script runs `terraform validate` and `terraform plan` to test the proposed changes.

---

## Apply Changes

1. **Raise a Pull Request**: Once the changes are validated, create a pull request to merge the changes into the main branch.

2. **Apply Changes**: After the PR is reviewed and merged, the changes will be applied to the environment.

3. **Verify**: Ensure the role and permissions are correctly applied in Snowflake.

---

**Done!** 🎉 You’ve successfully created a new **read-only** role.
