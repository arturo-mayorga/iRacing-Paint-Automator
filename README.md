# iRacing Paint Automator

This project provides a set of scripts to automate the export of paint files for iRacing using GIMP. The automation includes monitoring specified files for changes, updating environment variables, and exporting the necessary paint files. The project is designed to streamline the process of managing and exporting paint schemes for multiple drivers in iRacing.

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Scripts Overview](#scripts-overview)
- [Contributing](#contributing)

## Features
- Monitors specified files for changes and triggers export processes.
- Configures environment variables for iRacing paint directory and active driver details.
- Uses GIMP in non-interactive mode to automate the export of paint files.
- Handles visibility of driver-specific layers and spec layers.
- Supports multiple drivers with ease.

## Prerequisites
- GIMP 2.10 or later
- Bash (for running the scripts)
- iRacing installed and configured

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/arturo-mayorga/iRacing-Paint-Automator.git
   cd iracing-paint-automator
2. Ensure GIMP is installed and accessible via the command line:
```bash
gimp-2.10 --version
```
3.  Configure your environment variables: Edit the `env.sh` file to set the iRacing paint directory and the active driver details.
## Usage

1. Open `paint_template.xcf` with GIMP
2. Start the file monitoring and export process:
```bash
 ./start.sh 
   ```
2.  The script will monitor the specified files and trigger the export process when changes are detected.
3.  Open the car model for the car that you want to paint
4.  Edit `paint_template.xcf` and note the car model pickup your paint automatically.

## Scripts Overview

### `monitor.sh`

This script monitors specified files for changes and triggers the export process when modifications are detected. It includes functions to initialize the modification date map, check for file modifications, and handle the export process.

### `env.sh`

This script sets up environment variables for the iRacing paint directory and active driver details. It allows toggling between different drivers by commenting/uncommenting the appropriate line.

### `export.sh`

This script automates the export process using GIMP. It reads the `export.scm` file and executes it using GIMP in non-interactive mode.

### `export.scm`

This Scheme script for GIMP automates the process of exporting paint files. It defines functions to hide layers, check if a layer belongs to a specific driver, control visibility of spec layers, and the main function to export the paint file for a given driver.

## Contributing

Contributions are welcome! Please fork the repository and use a feature branch. Pull requests should be made against the main branch.