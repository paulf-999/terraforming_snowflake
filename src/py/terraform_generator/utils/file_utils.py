import os
import shutil
import utils.common_utils as common


def get_logger():
    """Initialise logger for debug/info logging throughout the script"""
    return common.get_logging_utils()


def find_project_root(anchor="inputs"):
    """Return the absolute path to the project root by locating a given anchor directory or file."""

    # Start at current script's directory
    current = os.path.abspath(os.path.dirname(__file__))

    # Loop until reaching filesystem root
    while current != os.path.dirname(current):
        if os.path.exists(os.path.join(current, anchor)):

            # Found the anchor directory/file → return as project root
            return current
        current = os.path.dirname(current)

    # Anchor not found → raise error
    raise RuntimeError(f"❌ Could not find project root using anchor '{anchor}'")


def copy_generated_tf_files(source_dir="tmp/environments", target_dir="terraform/environments", dry_run=False, on_file_exists="prompt"):
    """
    Copy or append .tf files from tmp/environments/* to terraform/environments/*
    - Behaviour when file exists is controlled by  the var `on_file_exists`
    - param: 'overwrite', 'append', 'skip', or 'prompt'
    - Ensures Terraform files (including main.tf) are safely copied per environment.
    """

    # initialise logger
    logger = get_logger()

    # Walk through all files under source_dir
    for root, _, files in os.walk(source_dir):

        for file in files:
            if not file.endswith(".tf"):
                # Only process Terraform files (i.e., skip non-Terraform files)
                continue

            src_path, dest_path = get_source_and_destination_paths(root, file, source_dir, target_dir)

            # Create destination directories if they don’t exist
            os.makedirs(os.path.dirname(dest_path), exist_ok=True)

            # Handle dry-run
            if dry_run:
                action_preview = f"would copy" if not os.path.exists(dest_path) else f"would {on_file_exists} existing"
                logger.info(f"📝 Dry-run: {action_preview} file: {src_path} → {dest_path}")
                continue

            # If the destination file already exists, handle it based on the chosen behaviour
            if os.path.exists(dest_path):
                handle_existing_file(src_path, dest_path, on_file_exists)
            # If the destination file does not exist, simply copy it over
            else:
                shutil.copy2(src_path, dest_path)
                logger.debug(f"📁 Copied new file: {src_path} → {dest_path}")

            logger.info(f"✅ Generated content for: {dest_path}")


def get_source_and_destination_paths(root, file, source_dir, target_dir):
    """Given a file and its root, return the full source path, relative path, and destination path."""

    # Full path to source file
    src_path = os.path.join(root, file).lower()

    # Relative path from source_dir (e.g., env name + file)
    rel_path = os.path.relpath(src_path, start=source_dir)

    # Full path to destination file
    dest_path = os.path.join(target_dir, rel_path).lower()

    return src_path, dest_path


def handle_existing_file(src_path, dest_path, on_file_exists):
    """Handle copying/appending/skipping when the destination file already exists."""

    # initialise logger
    logger = get_logger()

    # Start with the action passed in (e.g., 'overwrite', 'append', 'skip', or 'prompt')
    action = on_file_exists

    # If 'prompt', interactively ask the user what to do
    if on_file_exists == "prompt":
        logger.info(f"⚠️ File already exists: {dest_path}")

        # Prompt the user for action
        response = input("   Choose action: [o]verwrite / [a]ppend / [s]kip (default: skip): ").strip().lower()
        # Map the user input to a valid action, default to 'skip'
        action = {"o": "overwrite", "a": "append", "s": "skip"}.get(response, "skip")

    if action == "overwrite":
        # Overwrite the destination file with the source file
        shutil.copy2(src_path, dest_path)
        logger.info(f"✏️ Overwritten: {dest_path}")

    elif action == "append":
        # Read the source file content
        with open(src_path, "r") as src_file:
            new_content = src_file.read()

        # Append the new content to the destination file
        with open(dest_path, "a") as dest_file:
            dest_file.write("\n")  # Ensure new content starts on a new line
            dest_file.write(new_content)
        logger.info(f"📎 Appended content to: {dest_path}")

    elif action == "skip":
        # Do nothing, just log that the file was skipped
        logger.info(f"⏭️ Skipped: {dest_path}")


def create_symlink(source, destination_dir, link_name=None):
    """
    Create a symlink from source to destination_dir/link_name.
    If link_name is None, the symlink will use the source's basename.
    """

    # initialise logger
    logger = get_logger()

    # Determine the name of the symlink file
    if link_name is None:
        link_name = os.path.basename(source)

    # Build the full symlink path
    symlink_path = os.path.join(destination_dir, link_name)

    if not os.path.exists(symlink_path):
        try:
            os.symlink(os.path.abspath(source), symlink_path)
            logger.debug(f"🔗 Created symlink: {symlink_path} → {source}")
        except OSError as e:
            logger.warning(f"⚠️ Could not create symlink: {e}")
