from diagrams import Diagram, Cluster
from diagrams.programming.language import Python
from diagrams.custom import Custom

with Diagram("Snowflake Terraform Generator", direction="LR", show=False):

    # Input
    with Cluster("Inputs"):
        config_file = Custom("config.yaml", "yaml.png")

    # Generation phase
    with Cluster("Generate 'staged' Terraform Files (main.py)"):
        generator = Python("snowflake_terraform_file_writer.py")

    # Copying phase
    with Cluster("Copy/Append Files to Terraform Project"):
        file_utils = Python("file_utils.copy_generated_tf_files()")

    # Final output
    with Cluster("Terraform Files are Added to our Terraform Project"):
        final_dir = Custom("Target dir: `terraform/environments/<env>/`", "terraform.png")

    # Flow
    config_file >> generator
    generator >> file_utils
    file_utils >> final_dir
