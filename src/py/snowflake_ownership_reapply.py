#!/usr/bin/env python3
"""
Sweep Snowflake schemas and grant OWNERSHIP on ALL object types
to align with Terraform ownership policy.
"""

import os

import snowflake_client  # Use entire module namespace for clarity

logger = snowflake_client.get_logger()

# === Config from env vars ===
SNOWFLAKE_ACCOUNT = os.getenv("SNOWFLAKE_ACCOUNT_NAME")
SNOWFLAKE_USER = os.getenv("SNOWFLAKE_USER")
SNOWFLAKE_WAREHOUSE = os.getenv("SNOWFLAKE_WAREHOUSE")
SNOWFLAKE_DATABASE = os.getenv("SNOWFLAKE_DATABASE")
SNOWFLAKE_ROLE = os.getenv("SNOWFLAKE_ROLE")
TARGET_ROLE = os.getenv("TARGET_ROLE")
private_key = os.getenv("PRIVATE_KEY")


def get_snowflake_schemas(conn):
    """Fetch all user-defined schemas (excludes system schemas)."""
    with conn.cursor() as cs:
        sql = f"""
            SELECT schema_name
            FROM "{SNOWFLAKE_DATABASE}".INFORMATION_SCHEMA.SCHEMATA
            WHERE schema_name NOT IN ('INFORMATION_SCHEMA', 'PUBLIC')
        """
        schemas_result = snowflake_client.execute_snowflake_command(cs, sql)
        schemas = [row[0] for row in schemas_result]
        return schemas


def grant_ownership_all_in_schema(object_type_plural, conn):
    """Grant OWNERSHIP on ALL objects of the given type in each schema."""
    schemas = get_snowflake_schemas(conn)
    logger.info(f"Found {len(schemas)} schemas for {object_type_plural}.")

    with conn.cursor() as cs:
        for schema in schemas:
            grant_sql = f"""
                GRANT OWNERSHIP ON ALL {object_type_plural}
                IN SCHEMA "{SNOWFLAKE_DATABASE}"."{schema}"
                TO ROLE {TARGET_ROLE} COPY CURRENT GRANTS;
            """
            snowflake_client.execute_snowflake_command(cs, grant_sql)


def main():
    # Validate all required env vars exist
    snowflake_client.validate_env_vars(snowflake_client.REQUIRED_ENV_VARS)

    # Snowflake connection params
    conn_params = {
        "account": SNOWFLAKE_ACCOUNT,
        "user": SNOWFLAKE_USER,
        "private_key": private_key,
        "warehouse": SNOWFLAKE_WAREHOUSE,
        "database": SNOWFLAKE_DATABASE,
        "role": SNOWFLAKE_ROLE,
    }

    # Use context manager for Snowflake connection
    with snowflake_client.create_snowflake_connection(conn_params) as conn:
        grant_ownership_all_in_schema("TABLES", conn)
        grant_ownership_all_in_schema("VIEWS", conn)
        grant_ownership_all_in_schema("SEQUENCES", conn)
        grant_ownership_all_in_schema("FUNCTIONS", conn)


if __name__ == "__main__":
    main()
