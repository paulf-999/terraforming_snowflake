import utils.common_utils as common

# Set up the Jinja template renderer object
jinja_utils = common.get_jinja_renderer()

# Container for all generated Snowflake Terraform blocks
snowflake_objects = {
    "databases": [],
    "schemas": [],
    "warehouses": [],
    "roles": [],
}


class SnowflakeTerraformResourceGenerator:
    """Renders Terraform for Snowflake resources based on input values provided within config."""

    def __init__(self):
        # Common Jinja template settings used across all resources
        self.common_jinja_args = {"ip_jinja_template_file": "tf_block.tf.j2"}

    def _add_database_and_schemas(self, snowflake_objects, project, env, config):
        """Helper function to generate Terraform for Snowflake databases."""

        # Generate Terraform block for the database
        snowflake_objects["databases"].append(
            jinja_utils.render_jinja_template(
                **self.common_jinja_args,
                resource_type="snowflake_database",
                resource_name=f"db_{project}_{env}".lower(),
                attributes={"name": f"{project}_{env}"},
            )
        )

        # Generate schema blocks for the database
        snowflake_objects["schemas"].append(
            jinja_utils.render_jinja_template(
                ip_jinja_template_file="schema_resource_block.tf.j2",
                local_name=f"{project}_{env}_schema_names".lower(),
                schemas=config.get("schemas", []),
                project=project,
                env=env,
                database=f"db_{project}_{env}".lower(),
            )
        )

    def _add_warehouses(self, snowflake_objects, config):
        """Helper function to generate Terraform for Snowflake warehouses."""
        for wh in config.get("warehouses", []):
            wh_name = wh.lower()  # Normalize name for resource block
            snowflake_objects["warehouses"].append(
                jinja_utils.render_jinja_template(
                    **self.common_jinja_args,
                    resource_type="snowflake_warehouse",
                    resource_name=f"wh_{wh_name}",
                    attributes={"name": wh.upper()},  # Uppercase name in Snowflake
                )
            )

    def _add_roles(self, snowflake_objects, config, project, env):
        """Helper function to generate Terraform for Snowflake roles."""

        # Base role: ALL_ROLE  (e.g., <project>_<env>_ALL_ROLE)
        snowflake_objects["roles"].append(
            jinja_utils.render_jinja_template(
                ip_jinja_template_file="snowflake_role_all_and_sel_roles.tf.j2",
                env=env,
                project=project,
            )
        )

        # Functional roles (e.g., FUNC_<project>_<env>_<role>)
        for role in config.get("functional_roles", []):
            snowflake_objects["roles"].append(
                jinja_utils.render_jinja_template(
                    ip_jinja_template_file="snowflake_role_functional_roles.tf.j2",
                    env=env,
                    project=project,
                    role_name=role.lower(),
                )
            )
