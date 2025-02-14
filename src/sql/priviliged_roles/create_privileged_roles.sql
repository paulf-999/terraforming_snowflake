CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_DATABASE_ROLE COMMENT = 'Role for managing databases, including creating and modifying databases.';

CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_WAREHOUSE_ROLE COMMENT = 'Role for managing warehouses, including creating and modifying warehouses.';

CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_STAGE_ROLE COMMENT = 'Role for managing stages, including creating and modifying stages.';

CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_TAG_ROLE COMMENT = 'Role for managing tags, including creating and modifying tags.';

CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_ROLE_ROLE COMMENT = 'Role for managing other roles, including creating and modifying roles.';

CREATE ROLE IF NOT EXISTS PRIV_MANAGE_GRANTS_ROLE COMMENT = 'Role for managing grants and privileges across Snowflake.';

CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_USER_ROLE COMMENT = 'Role for managing users, including creating and modifying user accounts.';

CREATE ROLE IF NOT EXISTS PRIV_CREATE_MODIFY_TASK_ROLE COMMENT = 'Role for managing tasks, including creating and modifying tasks.';

CREATE ROLE IF NOT EXISTS PRIV_ACCESS_SNOWFLAKE_DB_ROLE COMMENT = 'Role for managing access to the Snowflake database and its schemas.';
