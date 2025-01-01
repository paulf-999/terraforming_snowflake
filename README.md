# Version Control Snowflake using Terraform and CI/CD

This repository contains Terraform configuration files used to version control Snowflake objects.

> [!TIP]
>
> See [What is Terraform?](docs/terraform_background/terraform_background.md) for a high-level overview of Terraform.

---

## 2. How to Use this Repo

See [How to use this repo](docs/how_to_use_this_repo.md).

> [!TIP]
>
> For an example, see [How to Create Snowflake Objects using Terraform](docs/example_how_to_create_sf_db_using_terraform.md).

---

## 3. Snowflake Object Types

Shown below are the different Snowflake object types as described here: [Database Change Management with Snowflake](https://jeremiahhansen.medium.com/a-new-approach-to-database-change-management-with-snowflake-8e3f0fee281).

![alt text](docs/img/sf_obj_types.png)

This object structure is replicated underneath `terraform/environments/<ENV>/`.

---

## 4. Prerequisites for Repository Setup (For Repo Maintainers)

If you're setting up this repository for the first time or maintaining it, refer to the [setup prerequisites](docs/setup.md).

End-users can skip this section; it’s for maintainers only.

---

## 5. Help

**How do I set up a local Terraform dev environment?**

See [Local Development Instructions for 'Terraforming Snowflake'](docs/local_dev_instructs_terraforming_snowflake.md).
