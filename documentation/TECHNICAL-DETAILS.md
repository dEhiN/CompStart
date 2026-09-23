# CompStart Technical Details

This document provides an overview of the main components of CompStart and their roles.

For a general overview of the project, see the [README](../README.md).

For the repository structure, see [`DIRECTORY-STRUCTURE.md`](DIRECTORY-STRUCTURE.md).

## Main Components

CompStart currently uses the following programming languages and technologies:

- **Batch** — provides Windows entry points.
- **PowerShell** — handles the startup process, the installation, and the release deployment.
- **JSON** — stores startup configuration.
- **JSON Schema** — defines and validates the configuration structure.
- **Python** — provides the configuration management CLI.
- **PyInstaller** — packages the Python CLI as a Windows executable.
- **Bash Shell** — automates certain Git tasks.

## Startup Process

#### `CompStart.bat`

Launches the PowerShell startup script. A shortcut to `CompStart.bat` is placed in the Windows Startup folder during installation.

#### `CompStart.ps1`

The main program script and is responsible for restoring the configured startup items. The script reads the `startup_data.json` file, processes each startup item, and uses the PowerShell cmdlet `Start-Process` to launch each item.

## Installer

#### `install.bat`

The Batch file that users need to double click to run the PowerShell installer script.

#### `install.ps1`

The main installer script which does the following:

- Installs CompStart to `%LocalAppData%\CompStart`.
- Creates a shortcut for `CompStart.bat`.
- Places the shortcut in the Windows Startup folder.
- Preserves existing `startup_data.json` when upgrading an installation.

The installation process first checks to confirm if the target folder exists, and if not, creates it. The process continues by then copying the files from the `installer-files` folder - found in the release package - to the target folder. During the copy process, if there are existing files, they are deleted except for the `startup_data.json` file. This ensures that if a user has modified their `startup_data.json` file, it doesn't get overwritten with the standard one shipped with each release.

## Configuration

Throughout the implementation of CompStart, there are two terms used for the configuration:

- _startup data_ - refers to the full user workspace configuration.
- _startup item_ - refers to a single application defined in the configuration.

The configuration is defined by two JSON Schema files that are used by the Python CLI to keep the JSON correctly formed and validated.

### JSON

#### `startup_data.json`

Contains the user's startup data.

#### `default_startup.json`

Provides the default startup data that is used when CompStart is installed. The default data contains 3 startup items:

- Windows Calculator
- Google Chrome
- Windows Notepad

The Google Chrome entry opens a new window using the default profile and loads the Google homepage. This demonstrates the use of arguments, and in particular, the ability for CompStart to load specific sites.

### JSON Schema

#### `startup_data.schema.json`

Defines the structure of the overall startup data.

#### `startup_item.schema.json`

Defines the structure of an individual startup item.

## Python CLI

#### `CompStart.py`

The source for the CompStart configuration management CLI. The full program is split across multiple Python modules with `CompStart.py` containing the main code that is initially run. This keeps the source code manageable. The Python code is written in a functional programming style.

#### `CompStart.exe`

For releases, the `CompStart.py` and its dependency modules are bundled into a runnable file using **PyInstaller**. **PyInstaller** is a Python package that creates Windows executables out of Python code. This allows users to run the CLI without needing to work directly with the Python source or install Python themselves. See https://pyinstaller.org/ for more details.

## Templates

#### `instructions.txt`

Instructions for the user that are included with every release. They include installation instructions among other useful information. There is a master copy from which a copy is created for every release.

#### `release-notes.md`

A template to use for creating the release notes to use on GitHub for every release. There is a master copy from which a copy is also created for every release. The copy is then completed with the release specific details. This ensures release specific notes are kept as part of the project repository.

## Release Deployment

#### `DeployRelease.ps1`

A release deployment script created to automate the release process. The script is split into the following workflow:

1. Get the release details - version number
2. Create the necessary release-specific folders
3. Copy over the necessary development files
4. Copy over the template files
5. Invoke **PyInstaller** to create the CLI executable
6. Create a production package to upload to GitHub
7. Clean up

#### `synchronise-branches.sh`

A simple Bash script to ???

---

_Last updated: 2026-09-23_