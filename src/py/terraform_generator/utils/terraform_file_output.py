import os
import utils.file_utils as file_utils
import utils.common_utils as common

# Use your shared logger
logger = common.get_logging_utils()
renderer = common.get_jinja_renderer()

config = common.setup()
project = config.get("project")


def write_all_staged_files_to_disk(staged_files, env):
    """
    Writes all staged Terraform files to disk and handles symlinks for relevant object types.
    Also renders main.tf at the environment level.
    """

    has_database = False
    has_warehouse = False

    for (object_type_dir, filename), meta in staged_files.items():
        content = meta["content"]
        sf_object_type = meta.get("sf_object_type")

        output_path = _resolve_output_path(env, project, object_type_dir, sf_object_type)

        full_file_path = os.path.join(output_path, filename)
        with open(full_file_path, "w") as f:
            f.write(content)
        logger.debug(f"✅ Generated {full_file_path}")

        # Add symlink for certain object types
        if sf_object_type in {"databases", "warehouses"}:
            file_utils.create_symlink(source="src/templates/provider.tf", destination_dir=output_path)

        if sf_object_type == "databases":
            has_database = True
        if sf_object_type == "warehouses":
            has_warehouse = True

    _render_main_tf(env, project, has_database, has_warehouse)


def _resolve_output_path(env, project, object_type_dir, sf_object_type):
    """
    Resolve the output path for a Terraform file based on environment,
    object type, and project. Ensures directories exist.
    """
    subdir_map = {
        "databases": "database",
        "warehouses": "warehouse",
    }

    base_path = f"tmp/environments/{env}/{object_type_dir}"
    subfolder = subdir_map.get(sf_object_type)
    path = os.path.join(base_path, subfolder, project).lower() if subfolder else base_path.lower()

    os.makedirs(path, exist_ok=True)
    return path


def _render_main_tf(env, project, has_database, has_warehouse):
    """
    Renders and writes the main.tf file for the environment.
    """

    rendered = renderer.render_jinja_template(
        ip_jinja_template_file="main.tf.j2",
        env=env,
        project=project,
        has_database=has_database,
        has_warehouse=has_warehouse,
    ).strip()

    output_path = f"tmp/environments/{env}/"
    os.makedirs(output_path, exist_ok=True)

    full_path = os.path.join(output_path, "main.tf")
    with open(full_path, "w") as f:
        f.write(rendered + "\n")

    logger.debug(f"🧩 Staged main.tf for environment: {env}")
