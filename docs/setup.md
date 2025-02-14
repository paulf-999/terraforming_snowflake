# Repository Setup Prerequisites

> [!NOTE]
>
> **Setup Instructions for Maintainers Only**
>
> These instructions are intended for repository maintainers or administrators who are setting up the Terraform pipeline.
>
> If you are a Terraform **end-user**, refer to the main [README](../README.md) for usage instructions.

---

## Introduction

To set up this repository and get the Terraform pipeline working, you need to complete the following steps in order:

1. **Populate the `.env` File**

   Before proceeding, you need to create and populate a `.env` file with the necessary Snowflake credentials. This file is based on the provided template and is required for Terraform to authenticate and interact with Snowflake.

   **Action**:

   1. Navigate to the `src/templates/` directory.
   2. Copy the `.env_template` file and rename it to `.env`.
   3. Open the `.env` file and populate it with the required values.

   **Command**:

   ```sh
   cp src/templates/.env_template .env
   nano .env  # or use any text editor to update the values
   ```

2. **Install Terraform**

   You will need to install Terraform on your machine.

3. **Create Privileged Snowflake Roles**

   A number of 'privileged' Snowflake roles will need to exist/be created for managing Snowflake resources such as databases, warehouses, and tasks.

4. **Create Snowflake Service Account User & (Snowflake) Terraform Role**

   To enable Terraform to interact & manage Snowflake resources, you’ll need a dedicated Snowflake-CICD service account user (`SVC_CICD`) and a Snowflake-Terraform functional role (`FUNC_TERRAFORM_ROLE`).

5. **Configure CICD Pipeline**

   Once the Snowflake user and functional role are configured, you can set up the CICD pipeline to automatically deploy changes and manage Terraform state.

---

## Step-by-Step Setup Instructions

| **Step**                                                                   | **Description**                                                                                                                                                                                                                                                                                                                        | **Action & Commands**                                                                                                                                                      |
| -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Populate the `.env` File**                                           | - Copy the `.env_template` file from `src/templates/` and rename it to `.env`.<br>- Open the `.env` file and provide the required Snowflake credentials and configuration.<br>- This file is used by Terraform to authenticate with Snowflake.| **Command**:<br>`cp src/templates/.env_template .env`<br>Then open the `.env` file and provide the required Snowflake credentials. |
| **2. Install Terraform**                                                   | - Install Terraform on your machine.<br>- The script used (`src/sh/install_terraform.sh`) supports automated installation for Debian-based Linux distributions and macOS (via Homebrew).                                                                                                                                                   | **Command**:<br>`bash src/sh/install_terraform.sh`                                                                                                                         |
| **3. Prerequisite: Create Privileged Snowflake Roles**                     | The following privileged roles must exist in Snowflake before proceeding with step 4:<br>- `FUNC_CREATE_MODIFY_DATABASE_ROLE`<br>- `FUNC_CREATE_MODIFY_WAREHOUSE_ROLE`<br>- `FUNC_CREATE_MODIFY_STAGE_ROLE`<br>- `FUNC_CREATE_MODIFY_TAG_ROLE`<br>- `FUNC_CREATE_MODIFY_ROLE_ROLE`<br>- `FUNC_PRIV_MANAGE_GRANTS_ROLE`<br>- `FUNC_CREATE_MODIFY_TASK_ROLE`. | Execute the provided SQL script to create these roles. You will need `ACCOUNTADMIN` privileges to execute the script.<br>**Command**:<br>`make create_snowflake_privileged_roles` |
| **4. Create Snowflake `SVC_CICD` User & Snowflake-Terraform Role**         |  1. **Create the Service Account User (`SVC_CICD`)**: This user is used exclusively by the CICD pipeline to interact with Snowflake.<br>  2. **Create the `FUNC_TERRAFORM_ROLE`**: This role is responsible for managing Snowflake resources. Ensure it has the necessary privileges based on your organization's policies.                         | A `Makefile` target has been created for execution of these commands.<br>**Command**:<br>`make create_snowflake_svc_user_and_terraform_role`                               |
| **5. Configure CICD Pipeline**                                             | Ensure your CICD pipeline is configured to:<br> 1. Use the correct Snowflake credentials.<br> 2. Deploy Terraform plans automatically for approved changes.<br> 3. Track Terraform state remotely (e.g., in AWS S3, Azure Blob, or a Snowflake database).<br> Verify that the Terraform state storage is set up (`terraform/environments`). | N/A : this will need to be created, per-CICD technology                                                                                                                    |
| **6. Verify Setup**                                                        | After completing the setup, test deploying a dummy Snowflake object (e.g., a simple table or view) using Terraform in a non-production environment to ensure everything is working as expected.                                                                                                                                        | -                                                                                                                                                                          |
