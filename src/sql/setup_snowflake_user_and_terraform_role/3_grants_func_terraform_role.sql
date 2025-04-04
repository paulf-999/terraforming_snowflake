------------------------------
-- 1. warehouse permissions
------------------------------
GRANT USAGE, OPERATE ON WAREHOUSE DEV_WH TO ROLE FUNC_TERRAFORM_ROLE;

------------------------------
-- 2. role permissions
------------------------------
-- database & schema permissions
GRANT ROLE PRIV_CREATE_MODIFY_DATABASE_ROLE TO ROLE FUNC_TERRAFORM_ROLE;
-- grants, user & role permissions
GRANT ROLE PRIV_CREATE_MODIFY_ROLE_ROLE TO ROLE FUNC_TERRAFORM_ROLE;
GRANT ROLE PRIV_MANAGE_GRANTS_ROLE TO ROLE FUNC_TERRAFORM_ROLE;
GRANT ROLE PRIV_CREATE_MODIFY_USER_ROLE TO ROLE FUNC_TERRAFORM_ROLE;

-- remaining
GRANT ROLE PRIV_CREATE_MODIFY_WAREHOUSE_ROLE TO ROLE FUNC_TERRAFORM_ROLE;
GRANT ROLE PRIV_CREATE_MODIFY_TASK_ROLE TO ROLE FUNC_TERRAFORM_ROLE;
-- GRANT ROLE SNOWFLAKE_STAGE_ADMIN_ROLE TO ROLE FUNC_TERRAFORM_ROLE;
GRANT ROLE PRIV_CREATE_MODIFY_TAG_ROLE TO ROLE FUNC_TERRAFORM_ROLE;

-- read-only access to the PROD db (DQ views query PROD.DQ_FRAMEWORK)
GRANT ROLE PRD_ALL_SEL_ROLE TO ROLE FUNC_TERRAFORM_ROLE;

------------------------------
-- 3. user permissions
------------------------------
GRANT ROLE FUNC_TERRAFORM_ROLE TO USER SVC_CICD;
