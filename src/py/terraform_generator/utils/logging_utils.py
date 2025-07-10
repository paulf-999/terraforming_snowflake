#!/usr/bin/env python3
"""
Description: Logging utility functions to be imported by other python scripts
Date created: 2025-01-13
"""

__author__ = "Paul Fry"
__version__ = "1.0"

import logging

import colorlog

# Define two new logging levels VERBOSE and TRACE
VERBOSE = 15
TRACE = 5
logging.addLevelName(VERBOSE, "VERBOSE")
logging.addLevelName(TRACE, "TRACE")


class LoggingUtils:
    def __init__(self):
        self.logger = self.configure_logging()
        self.set_log_level(logging.INFO)  # Set default log level to INFO

    def configure_logging(self):
        """Set up logging with coloured formatting"""

        logger = logging.getLogger("application_logger")

        # Add coloured formatting to the logger - if the handler is not already set
        if not logger.handlers:
            self._add_colored_handler(logger)

        return logger

    def _add_colored_handler(self, logger):
        """Add a colored handler to the logger."""

        # Required to apply colour formatting to the logger
        handler = colorlog.StreamHandler()

        # Add colour formatting to the logger
        handler.setFormatter(
            colorlog.ColoredFormatter(
                "%(log_color)s%(message)s",
                log_colors={
                    "TRACE": "blue",
                    "VERBOSE": "purple",
                    "DEBUG": "green",
                    "INFO": "cyan",
                    "WARNING": "yellow",
                    "ERROR": "red",
                    "CRITICAL": "bold_red",
                },
            )
        )
        logger.addHandler(handler)

    def set_log_level(self, log_level=logging.INFO):
        """Set the log level for the logger and its handlers"""

        # Set the log level
        self.logger.setLevel(log_level)

        # Set the log level for each handler
        for handler in self.logger.handlers:
            handler.setLevel(log_level)
