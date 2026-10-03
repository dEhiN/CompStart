# CompStart Directory Structure

This document provides an overview of the CompStart repository structure and where to find the different parts of the project.

For information about how CompStart works and how its components interact, see [`TECHNICAL-DETAILS.md`](TECHNICAL-DETAILS.md).

## Repository Structure

```
CompStart/
├── .vscode/
│   ├── launch.json
│   └── settings.json
│
├── development/
│   ├── config/
│   │   └── schema/
│   ├── data/
│   ├── dependencies/
│   ├── experimental-content/
│   ├── features/
│   ├── qa-debug/
│   ├── CompStart.bat
│   ├── CompStart.ps1
│   └── CompStart.py
│
├── documentation/
│   ├── CHANGELOG.md
│   ├── DIRECTORY-STRUCTURE.md
│   └── TECHNICAL-DETAILS.md
│
├── production/
│   ├── assets/
│   ├── packages/
│   ├── releases/
│   └── scripts/
│
├── .gitattributes
├── .gitignore
└── README.md
```

## Root Directory

The project root contains three primary project areas:

* **`development/`** — Contains the source code, configuration, development resources, and testing data used to build and test CompStart.
* **`documentation/`** — Contains documentation for the project.
* **`production/`** — Contains the resources and scripts used to prepare, package, and manage CompStart releases.

The repository root also contains the following files and directories:

* **`.vscode/`** — Contains Visual Studio Code workspace settings and launch configuration files.
* **`.gitattributes`** — Git attributes configuration.
* **`.gitignore`** — Files and directories excluded from Git.
* **`README.md`** — Main project documentation.

## Development

The primary CompStart scripts are located here:

* **`CompStart.bat`** — Batch entry point for the CompStart startup process.
* **`CompStart.ps1`** — PowerShell startup process.
* **`CompStart.py`** — Python CLI used to manage CompStart startup configuration.

See [`TECHNICAL-DETAILS.md`](TECHNICAL-DETAILS.md) for information about how these components work together.

The following folders are also found here:

### `config/`

Contains the JSON configuration files used by CompStart.

The `schema/` subdirectory contains the JSON Schema definitions used by the CompStart CLI to validate startup configuration data.

### `data/`

Contains data used for development, testing, and archival purposes.

### `dependencies/`

Contains the supporting Python modules used by the CompStart CLI.

### `experimental-content/`

Directory to store experimental content that is being explored for possible future use in CompStart.

### `features/`

Directory to store temporary development content associated with feature work when needed.

### `qa-debug/`

Directory to store temporary development content associated with QA testing or debugging when needed.

## Documentation

The `documentation/` directory contains the project's primary documentation.

* **`CHANGELOG.md`** — High-level history of significant CompStart changes.
* **`DIRECTORY-STRUCTURE.md`** — Overview of the repository structure.
* **`TECHNICAL-DETAILS.md`** — Detailed information about the architecture and implementation of CompStart.

## Production

The `production/` directory contains the resources used to prepare and manage CompStart releases.

### `assets/`

Contains files used when preparing releases, including the installer scripts and master copies of release documentation templates.

### `packages/`

Contains the ZIP packages created for CompStart releases. Packages are organized by major version.

### `releases/`

Contains the contents and release-specific files for each CompStart release. Releases are organized by major version and release version.

### `scripts/`

Contains scripts used to automate release and repository management tasks, including `DeployRelease.ps1` and `synchronise-branches.sh`.

---

*Last updated: 2026-10-02*