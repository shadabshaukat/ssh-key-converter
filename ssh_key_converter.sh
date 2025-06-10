#!/bin/bash

# SSH Key Format Converter
# Converts between OpenSSH and PuTTY key formats (both private and public keys)
# Requires: putty-tools package (contains puttygen)

VERSION="1.0.0"
SCRIPT_NAME=$(basename "$0")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if puttygen is installed
check_dependencies() {
    if ! command -v puttygen >/dev/null 2>&1; then
        echo -e "${RED}Error: puttygen is not installed.${NC}"
        echo "On Debian/Ubuntu systems, install with: sudo apt-get install putty-tools"
        echo "On RHEL/CentOS systems, install with: sudo yum install putty"
        echo "On macOS, install with: brew install putty"
        exit 1
    fi
}

# Display help information
show_help() {
    echo -e "${GREEN}SSH Key Format Converter ${VERSION}${NC}"
    echo "Converts between OpenSSH and PuTTY key formats (both private and public keys)"
    echo
    echo "Usage: ${SCRIPT_NAME} [options] <input_key_file>"
    echo
    echo "Options:"
    echo "  -t, --type <key_type>     Specify key type: 'private' or 'public' (required)"
    echo "  -f, --format <format>     Specify input format: 'openssh' or 'putty' (required)"
    echo "  -o, --output <file>       Specify output file (optional)"
    echo "  -v, --verbose             Enable verbose output"
    echo "  -h, --help                Show this help message"
    echo
    echo "Examples:"
    echo "  Convert OpenSSH private key to PuTTY format:"
    echo "    ${SCRIPT_NAME} -t private -f openssh id_rsa"
    echo
    echo "  Convert PuTTY public key to OpenSSH format:"
    echo "    ${SCRIPT_NAME} -t public -f putty key.ppk"
    echo
    echo "  Convert with custom output filename:"
    echo "    ${SCRIPT_NAME} -t private -f openssh -o converted_key.ppk id_rsa"
    exit 0
}

# Function to convert private key
convert_private_key() {
    local input_file=$1
    local output_file=$2
    local from_format=$3
    local verbose=$4

    if [ "$from_format" = "openssh" ]; then
        [ "$verbose" = "true" ] && echo -e "${BLUE}Converting OpenSSH private key to PuTTY format...${NC}"
        puttygen "$input_file" -o "$output_file" -O private
    elif [ "$from_format" = "putty" ]; then
        [ "$verbose" = "true" ] && echo -e "${BLUE}Converting PuTTY private key to OpenSSH format...${NC}"
        puttygen "$input_file" -O private-openssh -o "$output_file"
    fi

    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to convert private key${NC}"
        exit 1
    fi

    [ "$verbose" = "true" ] && echo -e "${GREEN}Private key successfully converted and saved to: ${output_file}${NC}"
    chmod 600 "$output_file"
}

# Function to convert public key
convert_public_key() {
    local input_file=$1
    local output_file=$2
    local from_format=$3
    local verbose=$4

    if [ "$from_format" = "openssh" ]; then
        [ "$verbose" = "true" ] && echo -e "${BLUE}Converting OpenSSH public key to PuTTY format...${NC}"
        puttygen "$input_file" -L -o "$output_file"
    elif [ "$from_format" = "putty" ]; then
        [ "$verbose" = "true" ] && echo -e "${BLUE}Converting PuTTY public key to OpenSSH format...${NC}"
        puttygen "$input_file" -O public-openssh -o "$output_file"
    fi

    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to convert public key${NC}"
        exit 1
    fi

    [ "$verbose" = "true" ] && echo -e "${GREEN}Public key successfully converted and saved to: ${output_file}${NC}"
    chmod 644 "$output_file"
}

# Main script execution
main() {
    check_dependencies

    # Initialize variables
    local key_type=""
    local key_format=""
    local input_file=""
    local output_file=""
    local verbose="false"

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -t|--type)
                key_type="$2"
                shift 2
                ;;
            -f|--format)
                key_format="$2"
                shift 2
                ;;
            -o|--output)
                output_file="$2"
                shift 2
                ;;
            -v|--verbose)
                verbose="true"
                shift
                ;;
            -h|--help)
                show_help
                ;;
            -*)
                echo -e "${RED}Error: Unknown option: $1${NC}"
                show_help
                exit 1
                ;;
            *)
                input_file="$1"
                shift
                ;;
        esac
    done

    # Validate input parameters
    if [ -z "$input_file" ]; then
        echo -e "${RED}Error: No input key file specified${NC}"
        show_help
        exit 1
    fi

    if [ ! -f "$input_file" ]; then
        echo -e "${RED}Error: Input file does not exist: $input_file${NC}"
        exit 1
    fi

    if [ -z "$key_type" ]; then
        echo -e "${RED}Error: Key type not specified (use -t or --type)${NC}"
        show_help
        exit 1
    fi

    if [ "$key_type" != "private" ] && [ "$key_type" != "public" ]; then
        echo -e "${RED}Error: Invalid key type. Must be 'private' or 'public'${NC}"
        show_help
        exit 1
    fi

    if [ -z "$key_format" ]; then
        echo -e "${RED}Error: Key format not specified (use -f or --format)${NC}"
        show_help
        exit 1
    fi

    if [ "$key_format" != "openssh" ] && [ "$key_format" != "putty" ]; then
        echo -e "${RED}Error: Invalid key format. Must be 'openssh' or 'putty'${NC}"
        show_help
        exit 1
    fi

    # Determine output filename if not specified
    if [ -z "$output_file" ]; then
        local input_basename=$(basename "$input_file")
        if [ "$key_format" = "openssh" ]; then
            # Converting from OpenSSH to PuTTY
            if [ "$key_type" = "private" ]; then
                output_file="${input_basename}.ppk"
            else
                output_file="${input_basename}.putty"
            fi
        else
            # Converting from PuTTY to OpenSSH
            if [ "$key_type" = "private" ]; then
                output_file="${input_basename%.*}" # Remove extension
                output_file="${output_file}_openssh"
            else
                output_file="${input_basename%.*}.pub"
            fi
        fi
        output_file=$(dirname "$input_file")/"$output_file"
    fi

    # Check if output file exists
    if [ -f "$output_file" ]; then
        echo -e "${YELLOW}Warning: Output file already exists: $output_file${NC}"
        read -p "Overwrite? (y/n): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            echo "Operation canceled."
            exit 0
        fi
    fi

    # Perform the conversion
    if [ "$key_type" = "private" ]; then
        convert_private_key "$input_file" "$output_file" "$key_format" "$verbose"
    else
        convert_public_key "$input_file" "$output_file" "$key_format" "$verbose"
    fi

    exit 0
}

main "$@"
