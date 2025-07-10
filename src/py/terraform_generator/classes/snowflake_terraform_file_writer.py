import os
from utils import common_utils as common
import utils.terraform_helpers as terraform_helpers

# Initialise Jinja template renderer
renderer = common.get_jinja_renderer()


class SnowflakeTerraformFileWriter:
    """
    Generates and stages Terraform files based on Snowflake object types,
    and writes them to disk as final output for a given environment.
    """

    def __init__(self, env, config):
        # Set environment in both upper and lower case for flexibility
        self.env_lower = env.lower()
        self.env_upper = env.upper()
        self.config = config
        self.project = config["project"].lower()
        self.staged_tf_file_contents = {}  # Holds staged file content keyed by (dir, filename)

    @property
    def get_common_jinja_args(self):
        """Provides common Jinja context variables shared across render calls."""
        return {
            "env": self.env_lower,
            "project": self.project,
        }

    def _stage_tf_file_output(self, object_type_dir, filename, content, sf_object_type):
        # Store file content for later writing
        self.staged_tf_file_contents[(object_type_dir, filename)] = {
            "content": content,
            "sf_object_type": sf_object_type,
        }

    def generate_and_stage_all_objects(self):
        # Generate Terraform blocks for all Snowflake object types
        snowflake_objects = terraform_helpers.generate_tf_blocks_for_snowflake_objects(self.project, self.env_upper, self.config)

        # Stage each object type's file content
        for sf_object_type, file_contents in snowflake_objects.items():
            if file_contents:
                self._generate_tf_for_snowflake_object_type(sf_object_type, file_contents)

        # Stage ownership grants and variable declarations
        self._render_grant_ownership()

        # Stage default grants for new roles
        self._render_default_grants_for_new_roles()

    def _generate_tf_for_snowflake_object_type(self, sf_object_type, file_contents):

        # 1. databases
        if sf_object_type == "databases":
            filename = f"{self.project}_db.tf"
            self._stage_tf_file_output("2_account_level_objects", filename, "\n".join(file_contents), sf_object_type)

        # 2. schemas (added to same file as databases)
        # fmt: off
        elif sf_object_type == "schemas":
            filename = f"{self.project}_db.tf"
            schema_blocks = terraform_helpers.generate_tf_blocks_for_db_schemas(
                self.project,
                self.env_upper,
                self.config.get("schemas", [])
            )
            existing_content = self.staged_tf_file_contents.get(("2_account_level_objects", filename), {})
            combined_content = (existing_content.get("content", "") + "\n" + schema_blocks).strip()

            self._stage_tf_file_output(
                object_type_dir="2_account_level_objects",
                filename=filename,
                content=combined_content,
                sf_object_type="databases"
            )
        # fmt: on

        # 3. warehouses (one file per warehouse)
        elif sf_object_type == "warehouses":
            for warehouse_name in self.config.get("warehouses", []):
                self._stage_tf_file_output(
                    object_type_dir="2_account_level_objects",
                    filename=f"{warehouse_name}_wh.tf".lower(),
                    content="\n".join(file_contents),
                    sf_object_type="warehouses",
                )

        # 4. roles and their outputs
        elif sf_object_type == "roles":
            target_dir = "1_roles_and_grants"

            # Stage main roles definition file
            self._stage_tf_file_output(
                object_type_dir=target_dir,
                filename="roles.tf",
                content="\n".join(file_contents),
                sf_object_type="roles",
            )

            # Generate and stage output definitions for roles
            outputs_content = renderer.render_jinja_template(
                ip_jinja_template_file="outputs_roles.tf.j2",
                env=self.env_upper,
                project=self.project,
                functional_roles=self.config.get("functional_roles", []),
            )

            self._stage_tf_file_output(
                object_type_dir=target_dir,
                filename="outputs.tf",
                content=outputs_content.strip(),
                sf_object_type="roles",
            )

        # Default handling for other object types
        else:
            target_dir = "2_account_level_objects"
            self._stage_tf_file_output(
                object_type_dir=target_dir,
                filename=f"{sf_object_type}.tf".lower(),
                content="\n".join(file_contents),
                sf_object_type=None,
            )

    def _render_grant_ownership(self):

        # Directory for placing ownership and variable files
        target_dir = os.path.join("2_account_level_objects", "database", self.project)

        # Render and stage ownership grants
        grant_ownership_content = renderer.render_jinja_template(
            ip_jinja_template_file="grant_ownership_template.tf.j2",
            **self.get_common_jinja_args,
        )
        self._stage_tf_file_output(
            object_type_dir=target_dir,
            filename=f"grant_ownership_{self.env_lower}_{self.project}_db_objects.tf",
            content=grant_ownership_content.strip(),
            sf_object_type="grants",
        )

        # Render and stage variables file
        variables_content = renderer.render_jinja_template(ip_jinja_template_file="variables.tf.j2", **self.get_common_jinja_args)
        self._stage_tf_file_output(
            object_type_dir=target_dir,
            filename="variables.tf",
            content=variables_content.strip(),
            sf_object_type="grants",
        )

    def _render_default_grants_for_new_roles(self):

        # Directory for placing the default grants for new roles
        target_dir = "1_roles_and_grants"

        # Render and stage ownership grants
        default_grants_new_roles_content = renderer.render_jinja_template(
            ip_jinja_template_file="grants_default_grants.tf.j2", **self.get_common_jinja_args
        )

        self._stage_tf_file_output(
            object_type_dir=target_dir,
            filename=f"grants_default_grants_{self.env_lower}_{self.project}_roles.tf",
            content=default_grants_new_roles_content.strip(),
            sf_object_type="grants",
        )
