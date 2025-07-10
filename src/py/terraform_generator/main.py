#!/usr/bin/env python3
"""
Description: Generate Terraform files per environment based on config.yaml inputs
Date created: 2025-05-16
"""

__author__ = "Paul Fry"
__version__ = "1.0"

import argparse
import utils.common_utils as common
import utils.file_utils as file_utils
import utils.terraform_file_output as tf_output
from classes.snowflake_terraform_file_writer import SnowflakeTerraformFileWriter

# Initialise logger and Jinja template renderer
logger = common.get_logging_utils()


def parse_args():
    """Parse command-line arguments for Terraform generation."""
    parser = argparse.ArgumentParser(description="Generate and optionally copy Terraform files.")

    parser.add_argument(
        "--dry-run", action="store_true", help="Only simulate copying generated .tf files to terraform/environments/, do not actually copy."
    )

    parser.add_argument(
        "--on-file-exists",
        choices=["overwrite", "append", "skip", "prompt"],
        default="prompt",
        help="Default behaviour when a file already exists in the target directory. " "Options: overwrite, append, skip, prompt (default: prompt)",
    )

    return parser.parse_args()


def main(dry_run=False, on_file_exists="prompt"):
    """Main entry point for generating Terraform files per environment using inputs from the config.yaml file."""

    logger.debug("\n🔧 Starting Terraform generation process...\n")

    # Load shared config inputs from inputs/config.yaml
    config = common.setup()
    logger.debug(f"Loaded configuration: environments={config.get('environments', [])}, project={config.get('project')}")

    # Loop through all configured environments (e.g., DEV, UAT, PROD)
    for env in config.get("environments", []):
        env = env.upper()
        logger.info(f"\n📁 Processing environment: {env}\n")

        # Create a writer instance to manage Terraform generation for this environment
        tf_file_writer = SnowflakeTerraformFileWriter(env=env, config=config)

        # Generate Terraform blocks (in-memory) for all Snowflake object types
        logger.debug(f"Generating and staging Terraform content for environment: {env}")
        tf_file_writer.generate_and_stage_all_objects()

        # Write all generated blocks to the tmp/ directory
        logger.debug(f"Writing all staged .tf files for environment: {env}")
        tf_output.write_all_staged_files_to_disk(
            staged_files=tf_file_writer.staged_tf_file_contents,
            env=env,
        )

        logger.debug(f"✅ Completed Terraform file generation for environment: {env}\n")

    # After all environments have been processed, optionally copy results to terraform/ directory
    file_utils.copy_generated_tf_files(dry_run=dry_run, on_file_exists=on_file_exists)

    logger.info("\n🏁 All environments processed. Terraform generation complete.")


# Run the script if it's executed directly from the command line
if __name__ == "__main__":
    args = parse_args()
    main(dry_run=args.dry_run, on_file_exists=args.on_file_exists)
