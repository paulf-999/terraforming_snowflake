import os
import yaml
import utils.file_utils as file_utils
from utils.jinja_utils import JinjaTemplateRenderer
from utils.logging_utils import LoggingUtils


def setup():
    """Load and return the parsed config.yaml from the inputs directory."""
    # Find the absolute path to the project root by locating the 'inputs' folder
    project_root = file_utils.find_project_root(anchor="inputs")

    # Construct the full path to the config.yaml file
    config_path = os.path.join(project_root, "inputs", "config.yaml")

    # Open and parse the YAML config file
    with open(config_path, "r") as f:
        config = yaml.safe_load(f)

    return config  # Return the parsed config as a dictionary


def get_logging_utils():
    """Return the LoggingUtils object."""
    # Instantiate and configure the logging utility
    logging_utils = LoggingUtils()
    logger = logging_utils.configure_logging()

    return logger  # Return the configured logger


def get_jinja_renderer():
    """Return the JinjaTemplateRenderer object."""
    # Instantiate the Jinja template renderer
    jinja_utils = JinjaTemplateRenderer()

    return jinja_utils  # Return the renderer instance
