# How to Create a New Snowflake Database Using Terraform

The instructions below describe the steps needed to create a new Snowflake database using the Terraform repo. These steps can be applied to create or amend any Snowflake object. For more details, refer to [How to Use this Repo](https://github.com/payroc/dmt-scripts-snowflake/blob/main/docs/how_to_use_this_repo.md).

---

## 1. Background

For an introduction to Terraform, see [Terraform - Background](terraform_background/terraform_background.md).

---

## 2. Steps to Create a New Snowflake Object Using Terraform

> [!NOTE]
> The Terraform Snowflake files are stored under the `terraform/` directory.

### **Step 1: Create a Feature Branch**

1. Navigate to the `main` branch.
2. Create a feature branch from `main`:

   ```bash
   git checkout -b feature/my_tf_db_eg
   ```

---

### **Step 2: Amend the `main.tf` Terraform File for the Database**

#### 2.1: Open the `DEV` `main.tf` File

1. Navigate to `terraform/environments/dev/2_account_level_objects`.
2. As databases are account-level objects, create a new file:

   ```plaintext
   example_db.tf
   ```

> [!NOTE]
> Ensure your Terraform configuration contains the required `providers` block:

```hcl
terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.92.0"
    }
  }
}
```

#### 2.2: Declare the Snowflake Database Resource

Add the following configuration to create the database:

```hcl
resource "snowflake_database" "db" {
  name = "ZZZ_EXAMPLE_DB_<YOUR_INITIALS>"
}

output "db_id" {
  value = snowflake_database.db.id
}
```

> Including an output block allows the database to be referenced by other Terraform resources, such as when assigning grants.

---

### **Step 3: Raise a Pull Request (PR) to the `main` Branch**

#### 3.1: Raise a PR

- Raise a PR in the GitHub UI to the `main` branch.

#### 3.2: Verify PR Tests Pass

When raising a PR, two checks are performed:

- **`terraform validate`**: Validates syntax and logical issues without altering resources.
- **`terraform plan`**: Previews changes by generating an execution plan, helping identify issues.

---

### **Step 4: Merge the Pull Request**

- Merge the PR as usual.
- Upon merge, the CICD build pipeline will be triggered and execute `terraform apply` to create or update the Snowflake objects.

---

### **Step 5: Verify the Database in Snowflake**

- In the Snowflake UI, confirm that the newly created database exists:

  ```plaintext
  ZZZ_EXAMPLE_DB_<YOUR_INITIALS>
  ```

> **Note**: The database will be owned by the `FUNC_TERRAFORM_ROLE`. Ensure you use this role to view the database.

---

## 4. Next Steps

- Explore the Terraform-Snowflake provider documentation to learn how to create other Snowflake objects and their corresponding syntax.
  [Terraform Snowflake Provider Docs](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs).

---
