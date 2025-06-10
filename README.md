# SSH Key Converter
Simple SSH Key Converter Script

## Requirements :

The script requires puttygen which is part of the putty-tools package on most Linux distributions. On macOS, it can be installed via Homebrew.

- On Debian/Ubuntu systems, install with: ```sudo apt-get install putty-tools```
- On RHEL/CentOS systems, install with: ```sudo yum install putty```
- On macOS, install with: ```brew install putty```

This script should work on any Unix-like system with bash and puttygen installed.


## Usage Examples :

Convert OpenSSH private key to PuTTY format:
```
./ssh_key_converter.sh -t private -f openssh ~/.ssh/id_rsa
```

Convert PuTTY public key to OpenSSH format:
```
./ssh_key_converter.sh -t public -f putty key.ppk
```

Convert with custom output filename:
```
./ssh_key_converter.sh -t private -f openssh -o mykey.ppk ~/.ssh/id_rsa
```

Verbose output:
```
./ssh_key_converter.sh -v -t public -f putty key.ppk
```


## Features :

- Robust error handling: Checks for dependencies, validates inputs, and handles errors gracefully.

- Flexible input/output: Can accept custom output filenames or generate them automatically.

- Supports both key types: Handles both private and public key conversions.

- Verbose mode: Provides detailed output when requested.

- Safety checks: Asks before overwriting existing files.

- Help system: Comprehensive help information with examples.

- Proper permissions: Sets appropriate file permissions on output files.
