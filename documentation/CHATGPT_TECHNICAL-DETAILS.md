# CompStart Technical Details

This document describes the major components of CompStart, how they interact, and the role each component plays in the project.

For a general overview of the project and how to get started, see the [README](../README.md).

For an overview of where files and directories are located in the repository, see [`DIRECTORY-STRUCTURE.md`](DIRECTORY-STRUCTURE.md).

## Architecture Overview

CompStart currently consists of two main processes:

1. **The startup process** — responsible for reading the user's startup configuration and launching the requested applications and other startup items when Windows starts.
2. **The configuration management process** — responsible for allowing the user to view and modify the startup configuration without manually editing the JSON file.

The startup process uses a Batch file and PowerShell script, while the configuration management tool is written in Python and distributed as a compiled executable.

### Startup Process

The general startup flow is:

```text
Windows Startup
      │
      ▼
CompStart.bat
      │
      ▼
CompStart.ps1
      │
      ├── Prompt user whether to continue
      │
      ├── Read startup_data.json
      │
      ├── Process each startup item
      │
      └── Start configured applications and resources
```

The Batch file provides the entry point from the Windows Startup folder. It launches the PowerShell script, which handles the actual startup process.

Before reading the startup configuration, the PowerShell script prompts the user to decide whether the startup routine should run. This allows the user to start Windows normally without restoring the configured workspace when it is not needed.

### Configuration Management Process

The configuration management flow is:

```text
User
  │
  ▼
CompStart.exe
  │
  ▼
Python CLI
  │
  ├── Read startup_data.json
  ├── Validate changes
  └── Write updated startup_data.json
```

The Python CLI provides a menu-driven interface for viewing, adding, modifying, and removing startup items.

The Python source code is packaged into a single executable during the release process using PyInstaller.

## Components

### Batch Script — `CompStart.bat`

`CompStart.bat` is the entry point for the CompStart startup process.

A shortcut to this Batch file is placed in the Windows Startup folder by the installer. When Windows starts and the shortcut is executed, the Batch file launches the PowerShell startup script.

The Batch file is intentionally simple; its primary role is to provide a convenient Windows startup entry point for the PowerShell process.

### PowerShell Script — `CompStart.ps1`

`CompStart.ps1` is the core of the CompStart startup process.

When launched, the script first prompts the user to determine whether CompStart should restore the configured workspace. If the user declines, the script exits without launching anything.

If the user chooses to continue, the script reads `startup_data.json` and processes each configured startup item.

The script uses a main loop to ensure that the response to the startup prompt is valid. It then uses functions to process each startup item and determine whether command-line arguments have been configured for that item.

The startup item is ultimately launched using the PowerShell `Start-Process` cmdlet.

Arguments associated with a startup item make it possible to do more than simply launch a program. For example, they can be used to open a browser with specific tabs or open a document using a particular application.

### JSON Configuration

CompStart uses JSON to define the user's startup configuration.

The configuration is separated into user-specific startup data and a default configuration template.

#### `startup_data.json`

`startup_data.json` contains the startup items that CompStart will process.

Each startup item follows the structure defined by the JSON Schema files described below.

The PowerShell startup process reads this file and processes each startup item in sequence.

Startup items can also include arguments. This allows a configuration to describe more specific actions, such as opening a browser window with particular URLs or opening a document with a specific application.

#### `default_startup.json`

`default_startup.json` contains the default startup configuration provided with CompStart.

The initial `startup_data.json` is based on this file.

The default configuration provides a simple example consisting of:

* Windows Calculator
* Google Chrome
* Windows Notepad

The Chrome startup item includes arguments that open Chrome using the default profile, open a new window, and navigate to the Google homepage.

The default configuration also provides an example of how startup data is structured, which is particularly useful when working with the project or creating a new configuration.

### JSON Schema

JSON Schema is used to describe and validate the structure of CompStart's configuration data.

#### `startup_data.schema.json`

Defines the structure of the overall `startup_data.json` file.

#### `startup_item.schema.json`

Defines the structure of an individual startup item within `startup_data.json`.

These schemas are stored in the `development/config/schema/` directory.

The Python CLI uses the schema information when validating configuration changes before they are written to `startup_data.json`.

## Python Command-Line Tool

### Source — `CompStart.py`

`CompStart.py` is the main Python file for the CompStart configuration management tool.

The CLI allows users to manage their startup configuration without manually editing the JSON file.

The current interface is menu-driven and provides options for viewing, adding, modifying, and removing startup entries.

The Python implementation is organized in a modular, functional style. `CompStart.py` serves as the starting point for the tool and uses additional Python modules located in the `development/dependencies/` directory.

### Distributed Executable — `CompStart.exe`

Users receive the CLI as `CompStart.exe` rather than having to run the Python source directly.

During the release process, the Python source and its modules are packaged into a single executable using **PyInstaller**.

This allows users to launch the CLI directly without needing to work with the Python source files or invoke Python themselves.

## Installation

The installation process is also PowerShell-based.

The installer places the CompStart files in:

```text
%LocalAppData%\CompStart
```

It then creates a shortcut for the CompStart Batch startup file and places that shortcut in the Windows Startup folder.

The installer preserves the user's existing startup data when upgrading an existing installation.

The installer is invoked through a Batch file so that it can be launched easily from Windows.

## Release and Build Process

The project includes a PowerShell-based release deployment process.

The release process prepares the release files, invokes **PyInstaller** to package the Python CLI into `CompStart.exe`, performs the required release directory and packaging operations, and creates the release archive.

This keeps the files used during development separate from the files distributed to end users.

For more information about the production and release structure, see the documentation in the `documentation/production/` directory.

## Current Implementation

CompStart is currently Windows-specific and uses PowerShell, Batch, Python, and JSON/JSON Schema.

The current implementation is intentionally relatively lightweight:

* PowerShell handles the startup automation.
* Batch provides Windows entry points.
* JSON defines the desired startup configuration.
* JSON Schema describes and validates the configuration structure.
* Python provides the configuration management CLI.
* PyInstaller packages the Python CLI for distribution.

The current CLI is functional but intentionally simple. Future development may expand the command-line interface, support additional workspace and context features, and move toward a cross-platform implementation using PowerShell Core.

---

*Last updated: 2026-09-16*
