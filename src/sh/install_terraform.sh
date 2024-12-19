#!/bin/bash

#=======================================================================
# Variables
#=======================================================================
source src/sh/shell_utilities.sh # fetch common shell script vars

#=======================================================================
# Functions
#=======================================================================

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run a command quietly
run_quietly() {
    "$@" >/dev/null 2>&1
}

# Check if Terraform is already installed
if command_exists terraform; then
    echo -e "${DEBUG}Terraform is already installed. Checking version:\n${COLOUR_OFF}"
    terraform --version
else
    # Detect the operating system
    os_name=$(uname -s)

    case "$os_name" in
        "Linux")
            # Check if it's a Debian-based system
            if [ -f "/etc/debian_version" ]; then
                echo -e "${DEBUG}Detected Debian-based Linux system${COLOUR_OFF}"

                # Print "Installing Terraform" message
                echo -e "${DEBUG}Installing Terraform...${COLOUR_OFF}"

                # Install Terraform on Debian quietly
                run_quietly wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
                sudo apt update && sudo apt install -y terraform

            else
                echo -e "${DEBUG}Unsupported Linux distribution${COLOUR_OFF}"
                exit 1
            fi
            ;;

        "Darwin")
            echo -e "${DEBUG}Detected macOS${COLOUR_OFF}"

            # Print "Installing Terraform" message
            echo -e "${DEBUG}Installing Terraform...${COLOUR_OFF}"

            # Install Terraform on macOS using Homebrew quietly
            run_quietly brew tap hashicorp/tap && brew install hashicorp/tap/terraform
            ;;

        *)
            echo -e "${DEBUG}Unsupported operating system: $os_name${COLOUR_OFF}"
            exit 1
            ;;
    esac

    # Verify the installation by checking the Terraform version
    echo -e "${DEBUG}\nVerifying Terraform installation:${COLOUR_OFF}"
    terraform --version
fi
