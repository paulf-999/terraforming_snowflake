#!/bin/bash
# shellcheck disable=all

source src/sh/shell_utilities.sh # fetch common shell script vars

#=======================================================================
# Functions
#=======================================================================

# Function to reformat the value of private key

# It's needed as private key values stored in Azure Key Vault are stored in a single line format
# This function reformats the private key to a multi-line format
reformat_private_key() {
    local raw_key="$1"
    local output_file="$2"

    # Check if the raw key is set
    if [ -z "$raw_key" ]; then
        log_message ${ERROR} "Error: The private key variable is empty or not set."
        exit 1
    fi

    # Reformat the RAW private key by:
    # 1. adding a newline after the "-----BEGIN PRIVATE KEY-----" header,
    # 2. adding a newline before the "-----END PRIVATE KEY-----" footer,
    # 3. wrapping the key content to 64 characters per line for proper PEM formatting.

    # Note: Uncomment the following line to enable debugging
    # log_message ${DEBUG_DETAILS} "Reformatting the private key..."
    local formatted_key=$(echo "$raw_key" | sed 's/-----BEGIN PRIVATE KEY-----/-----BEGIN PRIVATE KEY-----\n/' | sed 's/-----END PRIVATE KEY-----/\n-----END PRIVATE KEY-----/' | fold -w 64)

    # Write the formatted key to the output file
    # Note: Uncomment the following line to enable debugging
    # log_message ${DEBUG_DETAILS} "INFO: Writing the formatted private key to $output_file..."
    echo -e "$formatted_key" > "$output_file"

    # Verify the output file
    if [ ! -s "$output_file" ]; then
        log_message ${ERROR} "Error: The output file $output_file is empty or was not created successfully."
        exit 1
    fi

    # Secure the private key file
    chmod 600 "$output_file"
    # Note: Uncomment the following line to enable debugging
    # log_message ${DEBUG_DETAILS} "INFO: Generated and secured Snowflake private key file at $output_file"
}

# Function to verify the private key file format
verify_private_key_format() {
    local key_file="$1"

    # Note: Uncomment the following line to enable debugging
    # log_message ${DEBUG_DETAILS} "INFO: Verifying the private key file format..."
    if ! grep -q -- "-----BEGIN PRIVATE KEY-----" "$key_file"; then
        log_message ${ERROR} "Error: The private key file does not contain a valid PEM header."
        exit 1
    fi

    if ! grep -q -- "-----END PRIVATE KEY-----" "$key_file"; then
        log_message ${ERROR} "Error: The private key file does not contain a valid PEM footer."
        exit 1
    fi
    # Note: Uncomment the following line to enable debugging
    # log_message ${DEBUG_DETAILS} "INFO: Private key file format verification passed."
}
