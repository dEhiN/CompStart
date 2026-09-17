# CompStart Technical Details

This document provides an overview of the main components of CompStart and how they work.

For a general overview of the project, see the [README](../README.md).

For the repository structure, see [`DIRECTORY-STRUCTURE.md`](DIRECTORY-STRUCTURE.md).

## Main Components

CompStart currently uses:

- **Batch** — provides Windows entry points.
- **PowerShell** — handles the startup process.
- **JSON** — stores startup configuration.
- **JSON Schema** — defines and validates the configuration structure.
- **Python** — provides the configuration management CLI.
- **PyInstaller** — packages the Python CLI as a Windows executable.

## Startup Process

### `CompStart.bat`

A shortcut to `CompStart.bat` is placed in the Windows Startup folder during installation. The Batch file launches the PowerShell startup script.

### `CompStart.ps1`

`CompStart.ps1` is responsible for restoring the configured startup items.

When it runs, the user is prompted to decide whether the startup process should continue. If they decline, the script exits without launching anything.

If they continue, the script reads `startup_data.json` and processes each startup item. Startup items may include arguments, allowing CompStart to perform actions such as opening a browser with specific tabs or opening a document with a particular application.

Applications are launched using the PowerShell `Start-Process` cmdlet.

## Configuration

CompStart uses JSON to define the startup items to be restored.

### `startup_data.json`

Contains the user's startup configuration.

Each startup item follows the structure defined by the JSON Schema files.

### `default_startup.json`

Provides the default startup configuration used when CompStart is installed.

It contains example entries for:

- Windows Calculator
- Google Chrome
- Windows Notepad

The Chrome entry demonstrates the use of arguments to open a new window with the default profile and navigate to the Google homepage.

### JSON Schema

The configuration is defined by two JSON Schema files:

- **`startup_data.schema.json`** — defines the structure of the overall startup data.
- **`startup_item.schema.json`** — defines the structure of an individual startup item.

The schemas are stored in `development/config/schema/` and are used by the Python CLI to validate configuration changes.

## Python CLI

### `CompStart.py`

`CompStart.py` is the source for the CompStart configuration management CLI.

The CLI provides a menu-driven interface for viewing, adding, modifying, and removing startup items in `startup_data.json`.

The Python implementation is modular and uses additional Python modules stored in `development/dependencies/`.

### `CompStart.exe`

For releases, the Python CLI and its modules are packaged into `CompStart.exe` using **PyInstaller**.

This allows users to run the CLI without needing to work directly with the Python source or install Python themselves.

---

_Last updated: 2026-09-17_