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

1. **Install Terraform**

   You will need to install Terraform on your machine.

2. **Create Privileged Snowflake Roles**

   A number of 'privileged' Snowflake roles will need to exist/be created for managing Snowflake resources such as databases, warehouses, and tasks.

3. **Create Snowflake Service Account User & (Snowflake) Terraform Role**

    To enable Terraform to interact & manage Snowflake resources, you’ll need a dedicated Snowflake-CICD service account user (`SVC_CICD`) and a Snowflake-Terraform functional role (`FUNC_TERRAFORM_ROLE`).

4. **Configure CICD Pipeline**

   Once the Snowflake user and functional role are configured, you can set up the CICD pipeline to automatically deploy changes and manage Terraform state.

---

## Step-by-Step Setup Instructions

| **Step**                                      | **Description**                                                                                                                                                                                                                                                                                                                                                         | **Action & Commands**                          |
|-----------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|
| **1. Install Terraform**                      | - Install Terraform on your machine.<br/>- The script used (`src/sh/install_terraform.sh`) supports automated installation for Debian-based Linux distributions and macOS (via Homebrew). | **Command**: `bash src/sh/install_terraform` |
| **2. Prerequisite: Create Privileged Snowflake Roles** | The following privileged roles must exist in Snowflake before proceeding with step 3:<br/><br/>- `PRIV_CREATE_MODIFY_DATABASE_ROLE` <br> - `PRIV_CREATE_MODIFY_WAREHOUSE_ROLE` <br> - `PRIV_CREATE_MODIFY_STAGE_ROLE` <br> - `PRIV_CREATE_MODIFY_TAG_ROLE` <br> - `PRIV_CREATE_MODIFY_ROLE_ROLE` <br> - `PRIV_MANAGE_GRANTS_ROLE` <br> - `PRIV_CREATE_MODIFY_TASK_ROLE`. | Execute the provided SQL script to create these roles. You will need `ACCOUNTADMIN` privileges to execute the script.<br/><br/>**Command**: `make create_snowflake_privileged_roles` |
| **3. Create Snowflake `SVC_CICD` User & Snowflake-Terraform Role** | <br> 1. **Create the Service Account User (`SVC_CICD`)**: This user is used exclusively by the CICD pipeline to interact with Snowflake. <br> 2. **Create the `FUNC_TERRAFORM_ROLE`**: This role is responsible for managing Snowflake resources. Ensure it has the necessary privileges based on your organization's policies. | A `Makefile` target has been created to execution of these commands.<br/><br/>**Command**: `make -s create_snowflake_svc_user_and_terraform_role` |
| **4. Configure CICD Pipeline**               | Ensure your CICD pipeline is configured to: <br> 1. Use the correct Snowflake credentials. <br> 2. Deploy Terraform plans automatically for approved changes. <br> 3. Track Terraform state remotely (e.g., in AWS S3, Azure Blob, or a Snowflake database). <br> Verify that the Terraform state storage is set up (`terraform/environments`). | N/A : this will need to be created, per-CICD technology |
| **5. Verify Setup**                           | After completing the setup, test deploying a dummy Snowflake object (e.g., a simple table or view) using Terraform in a non-production environment to ensure everything is working as expected. | - |
