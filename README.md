# SSH Key Converter
Simple SSH Key Converter Script

## Requirements :

The script requires puttygen which is part of the putty-tools package on most Linux distributions. On macOS, it can be installed via Homebrew.

- On Debian/Ubuntu systems, install with: ```sudo apt-get install putty-tools```
- On RHEL/CentOS systems, install with: ```sudo yum install putty```
- On macOS, install with: ```brew install putty```

This script should work on any Unix-like system with bash and puttygen installed.


## Usage Examples :

### Generate a OpenSSH keygen pair:
```
$ ssh-keygen
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/shadab/.ssh/id_ed25519): SampleOpenSSH.priv
Enter passphrase for "SampleOpenSSH.priv" (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in SampleOpenSSH.priv
Your public key has been saved in SampleOpenSSH.priv.pub
The key fingerprint is:
SHA256:QA9uBv5uK5V4s1fa2r55HqNF/N8UxXMYkMpluCzUDQc shadab@Shadabs-MacBook-Pro.local
The key's randomart image is:
+--[ED25519 256]--+
|    . o  .E=oo.  |
|   . + o. o.=  + |
|    . =..o =  ..+|
|     + .. =.    +|
|     ...S.  o  . |
|    ..=   .. .  .|
|     ooo +  + . .|
|    ....o..+.o o.|
|     ....o*+.   o|
+----[SHA256]-----+

$ mv SampleOpenSSH.priv.pub SampleOpenSSH.pub
```

### Check the Help Commands
```
./ssh_key_converter.sh --help
```

#### [1] Convert OpenSSH private key to PuTTY format
```
./ssh_key_converter.sh -t private -f openssh SampleOpenSSH.priv -o SamplePutty.ppk
```

```SampleOpenSSH.priv``` is the private key in OpenSSH format

```SamplePutty.ppk``` is the private key output in PuTTY format


#### [2] Convert OpenSSH public key to PuTTY format
```
./ssh_key_converter.sh -t public -f openssh SampleOpenSSH.pub -o SamplePutty.pub
```

```SampleOpenSSH.pub ``` is the public key in OpenSSH format

```SamplePutty.pub``` is the public key output in PuTTY format


#### [3] Convert PuTTY private key to OpenSSH format
```
./ssh_key_converter.sh -t private -f putty  SamplePutty.ppk -o SampleOpenSSH-New.priv
```

```SamplePutty.ppk`` is the private key in PuTTY format

```SampleOpenSSH-New.priv``` is the private key output in OpenSSH format


#### [4] Convert PuTTY public key to OpenSSH format
```
./ssh_key_converter.sh -t public -f putty SamplePutty.pub -o SampleOpenSSH-New.pub
```

```SamplePutty.pub``` is the public key in PuTTY format

```SampleOpenSSH-New.pub``` is the public key output in OpenSSH format


#### [5] Verbose output
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
