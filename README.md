# FlatCAM Setup Script

This repository contains a bash script that automates the setup and launch of FlatCAM on macOS.

## What the Script Does

The `setup_and_run_flatcam.sh` script performs the following steps:

1. **Checks for Python 3.10**: Installs Python 3.10 using Homebrew or pyenv if it's not already available.
2. **Clones the FlatCAM Repository**: Downloads the FlatCAM beta repository from Bitbucket if it doesn't exist.
3. **Creates a Virtual Environment**: Sets up a Python virtual environment using Python 3.10.
4. **Installs Dependencies**: Installs the required Python packages from the FlatCAM requirements.txt file.
5. **Launches FlatCAM**: Starts the FlatCAM application.

## Prerequisites

- macOS operating system
- Homebrew (https://brew.sh) or pyenv for installing Python 3.10 if not already installed

## How to Execute the Script

1. Download or clone this repository.
2. Open a terminal and navigate to the directory containing the script.
3. Make the script executable (if not already):
   ```
   chmod +x setup_and_run_flatcam.sh
   ```
4. Run the script:
   ```
   ./setup_and_run_flatcam.sh
   ```

The script will handle the entire setup process automatically and launch FlatCAM when ready.

## Notes

- The script creates directories in your home folder: `~/flatcam-env` for the virtual environment and `~/flatcam_beta` for the repository.
- Ensure you have sufficient permissions to install software and create directories in your home folder.