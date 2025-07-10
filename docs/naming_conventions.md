## 🧠 Naming Conventions

The script enforces consistent naming across Snowflake resources:

| Resource Type       | Naming Convention                  | Example (PROJECT=OPERATIONS, ENV=PROD)  |
| ------------------- | ---------------------------------- | --------------------------------------- |
| Database            | `<PROJECT>_<ENV>`                  | `OPERATIONS_PROD`                       |
| Schema              | As provided in YAML (no prefix)    | `DQ_PLATFORM`                           |
| Warehouse           | `<PROJECT>_<ENV>_WH`               | `OPERATIONS_PROD_WH`                    |
| DB 'Owner' Role     | `<PROJECT>_<ENV>_ALL_ROLE`         | `OPERATIONS_PROD_ALL_ROLE`              |
| DB 'Read-Only' Role | `<PROJECT>_<ENV>_SEL_ROLE`         | `OPERATIONS_PROD_SEL_ROLE`              |
| Functional Roles    | `FUNC_<PROJECT>_<ENV>_<NAME>_ROLE` | `FUNC_OPERATIONS_PROD_VIEW_RUNNER_ROLE` |

---

## 🏗️ Terraform Resource Naming

Generated Terraform resources follow the naming convention below:

| Object Type | Format                            | Example                  |
| ----------- | --------------------------------- | ------------------------ |
| Database    | `db_<database_name>`              | `db_dq_dev`              |
| Schema      | `db_<database_name>_schemas`      | `db_dq_dev_schemas`      |
| Role        | `role_<role_name>`                | `role_dq_dev_all_role`   |
| Warehouse   | `wh_<warehouse_name>` (if needed) | `wh_dq_dev_transform_wh` |
