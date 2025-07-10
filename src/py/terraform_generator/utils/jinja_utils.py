#!/usr/bin/env python3
"""
Description: Jinja utility functions to be imported by other python scripts
Date created: 2024-01-20
"""

__author__ = "Paul Fry"
__version__ = "1.0"

import os
import sys
import utils.common_utils as common
import utils.file_utils as file_utils
from jinja2 import Environment
from jinja2 import FileSystemLoader


class JinjaTemplateRenderer:

    def setup_jinja_template(self, ip_jinja_template_file, jinja_templates_dir="src/templates/py_terraform_generator"):
        """Set up/get the Jinja template."""

        # Resolve the full path to the templates directory under the project root
        project_root = file_utils.find_project_root(anchor="inputs")
        jinja_templates_path = os.path.join(project_root, jinja_templates_dir)

        # Full path to the actual Jinja file
        file_template = os.path.join(jinja_templates_path, ip_jinja_template_file)

        # Validate the Jinja template exists
        if not os.path.exists(file_template):
            print(f"Error: Jinja template not found. Path to Jinja template:\n\n{file_template}.")
            sys.exit(1)

        # Set up the Jinja environment
        jinja_env = Environment(loader=FileSystemLoader(jinja_templates_path), autoescape=True)
        return jinja_env.get_template(ip_jinja_template_file)

    def render_jinja_template(self, ip_jinja_template_file, jinja_templates_dir="src/templates/py_terraform_generator", **kwargs):
        """Render an input Jinja template"""

        # Set up the Jinja template
        template = self.setup_jinja_template(ip_jinja_template_file, jinja_templates_dir)

        # Render the template with provided values
        rendered_template = template.render(**kwargs)

        # Ensure a trailing newline
        return rendered_template if rendered_template.endswith("\n") else rendered_template + "\n"
