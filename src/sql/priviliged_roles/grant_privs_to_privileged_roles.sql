USE ROLE ACCOUNTADMIN;

--------------------------------
-- 1. Account-level grants
--------------------------------

-- database
GRANT CREATE DATABASE ON ACCOUNT TO ROLE FUNC_PRIV_CREATE_MODIFY_DATABASE_ROLE;

-- warehouse
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE FUNC_PRIV_CREATE_MODIFY_WAREHOUSE_ROLE;
GRANT MONITOR USAGE ON ACCOUNT TO ROLE FUNC_PRIV_CREATE_MODIFY_WAREHOUSE_ROLE;

-- tags
GRANT CREATE TAG ON ACCOUNT TO ROLE FUNC_PRIV_CREATE_MODIFY_TAG_ROLE;

----------------------------------------------------------------
-- 2. Grants for managing users/roles/users
----------------------------------------------------------------

-- Grants & Roles
GRANT MANAGE GRANTS ON ACCOUNT TO ROLE FUNC_PRIV_MANAGE_GRANTS_ROLE;
GRANT CREATE ROLE ON ACCOUNT TO ROLE FUNC_PRIV_CREATE_MODIFY_ROLE_ROLE;

----------------------------------------------------------------
-- 3. Other grants
----------------------------------------------------------------

-- Snowflake DB
-- Grant IMPORTED PRIVILEGES on the imported database to a role
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE FUNC_PRIV_ACCESS_SNOWFLAKE_DB_ROLE;
