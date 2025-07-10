import utils.common_utils as common

from classes.snowflake_terraform_resource_generator import SnowflakeTerraformResourceGenerator

# Set up the Jinja template renderer object
jinja_utils = common.get_jinja_renderer()


terraform_generator = SnowflakeTerraformResourceGenerator()


def generate_tf_blocks_for_snowflake_objects(project, env, config):
    """Generate Terraform for different Snowflake object types."""
    snowflake_objects = {
        "databases": [],
        "schemas": [],
        "warehouses": [],
        "roles": [],
    }

    if config.get("create_database", False):
        terraform_generator._add_database_and_schemas(snowflake_objects, project, env, config)

    terraform_generator._add_warehouses(snowflake_objects, config)
    terraform_generator._add_roles(snowflake_objects, config, project, env)

    return snowflake_objects


def generate_tf_blocks_for_db_schemas(project, env, schema_names):
    """Generate Terraform resource block for Snowflake schemas."""
    jinja_utils = common.get_jinja_renderer()

    project_env = f"{project}_{env}"
    ip_values_jinja_template = {
        "local_name": f"{project_env}_schema_names".lower(),
        "schemas": schema_names,
        "project": project,
        "env": env,
        "database": f"db_{project_env}".lower(),
    }

    schema_resource_block = jinja_utils.render_jinja_template(
        ip_jinja_template_file="schema_resource_block.tf.j2",
        **ip_values_jinja_template,
    )

    return schema_resource_block.strip() + "\n"
