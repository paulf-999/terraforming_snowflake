# How to Use this Repo

| Step   | Action                                                                              | Description |
|--------|-------------------------------------------------------------------------------------|-------------|
| Step 1 | **Edit `main.tf` to declare your desired Snowflake resources.**                | As an example, see [terraform/environments/uat/main.tf](terraform/environments/uat/main.tf) which has been used to the simple `UAT_ALL_SEL_ROLE`. |

> [!NOTE]
>
> **What are the files `main.tf`, `outputs.tf`, `provider.tf` and `variables.tf`?**
>
> See [Core Terraform Files](terraform_background/core_terraform_files.md).
>
> **How can I develop/test my Terraform code locally?**
>
> See [Local Development Instructions for 'Terraforming Snowflake'](local_dev_instructs_terraforming_snowflake.md).

</details>

| Step   | Action                                                                              | Description |
|--------|-------------------------------------------------------------------------------------|-------------|
| Step 2 | **Create a Pull Request (PR) to the `main` branch**                              | <ul><li>Once you're happy with your proposed code, create a PR to the `main` branch</li><li>If the CICD checks are passed, you can merge your PR.</li></ul> |
| Step 3 | **Code Deployment Pipeline Triggered Upon Merge**                                   | Upon merge, the code deployment pipeline will be triggered to create/amend your Snowflake object.             |
