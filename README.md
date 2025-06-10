# SSH Key Converter
Simple SSH Key Converter Script

## Requirements :

The script requires puttygen which is part of the putty-tools package on most Linux distributions. On macOS, it can be installed via Homebrew.

This script should work on any Unix-like system with bash and puttygen installed.


## Features :

    [1] Robust error handling: Checks for dependencies, validates inputs, and handles errors gracefully.

    [2] Flexible input/output: Can accept custom output filenames or generate them automatically.

    [3] Supports both key types: Handles both private and public key conversions.

    [4] Verbose mode: Provides detailed output when requested.

    [5] Safety checks: Asks before overwriting existing files.

    [6]  Help system: Comprehensive help information with examples.

    [7]  Proper permissions: Sets appropriate file permissions on output files.


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
