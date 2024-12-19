USE ROLE SECURITYADMIN;

----------------------------------------------------------------------------------------------------------------
-- 1. Privileged roles for creating/modifying account-level objects (databases, warehouses, resource monitors)
----------------------------------------------------------------------------------------------------------------

-- Role for creating/modifying DBs
CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_DATABASE_ROLE COMMENT = 'Role for managing databases, including creating and modifying databases.';

-- Role for creating/modifying warehouses
CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_WAREHOUSE_ROLE COMMENT = 'Role for managing warehouses, including creating and modifying warehouses.';

-- Role for creating/modifying Snowflake stages
CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_STAGE_ROLE COMMENT = 'Role for managing stages, including creating and modifying stages.';

-- Role for creating/modifying Snowflake tags
CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_TAG_ROLE COMMENT = 'Role for managing tags, including creating and modifying tags.';

----------------------------------------------------------------------------------------------------------------
-- 2. Privileged roles for creating/modifying users/roles/grants
----------------------------------------------------------------------------------------------------------------

-- Role for creating/modifying roles
CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_ROLE_ROLE COMMENT = 'Role for managing other roles, including creating and modifying roles.';

-- Role for managing grants
CREATE ROLE IF NOT EXISTS PRIV_MANAGE_GRANTS_ROLE COMMENT = 'Role for managing grants and privileges across Snowflake.';

-- Role for creating/modifying users
-- CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_USER_ROLE COMMENT = 'Role for managing users, including creating and modifying user accounts.';

----------------------------------------------------------------------------------------------------------------
-- 3. Privileged roles for schema-level objects (tables/views/stored procs etc.)
----------------------------------------------------------------------------------------------------------------

-- Create the task admin role if it does not exist
CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_TASK_ROLE COMMENT = 'Role for managing tasks, including creating and modifying tasks.';

----------------------------------------------------------------------------------------------------------------
-- 4. Other
----------------------------------------------------------------------------------------------------------------

-- Privileged role for managing access to the Snowflake database
CREATE ROLE IF NOT EXISTS PRIV_ACCESS_SNOWFLAKE_DB_ROLE COMMENT = 'Role for managing access to the Snowflake database and its schemas.';
