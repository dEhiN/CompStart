# CompStart Directory Structure

This document provides an overview of the CompStart repository structure and where to find the different parts of the project.

For information about how CompStart works and how its components interact, see [`TECHNICAL_DETAILS.md`](TECHNICAL_DETAILS.md).

## Repository Structure

```text
CompStart/
├── development/
│   ├── config/
│   │   └── schema/
│   ├── data/
│   ├── dependencies/
│   ├── experimental-content/
│   ├── features/
│   ├── CompStart.bat
│   ├── CompStart.ps1
│   └── CompStart.py
│
├── documentation/
│   ├── development/
│   ├── production/
│   ├── CHANGELOG.md
│   ├── DIRECTORY-STRUCTURE.md
│   └── TECHNICAL_DETAILS.md
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

The project root is divided into three primary areas:

* **`development/`** — Contains the source code, configuration, development resources, and testing data used to build and test CompStart.
* **`documentation/`** — Contains documentation for the project, including development and production documentation.
* **`production/`** — Contains the resources and scripts used to prepare, package, and manage CompStart releases.

The root directory also contains the primary repository-level files:

* **`.gitattributes`** — Git attributes configuration.
* **`.gitignore`** — Files and directories excluded from Git.
* **`README.md`** — Main project documentation.

## Development

The `development/` directory contains the source code, configuration, and other resources used to develop and test CompStart.

### Development Scripts

The primary CompStart scripts are located directly under `development/`:

* **`CompStart.bat`** — Batch entry point for the CompStart startup process.
* **`CompStart.ps1`** — PowerShell startup process.
* **`CompStart.py`** — Python CLI used to manage CompStart startup configuration.

See [`TECHNICAL_DETAILS.md`](TECHNICAL_DETAILS.md) for information about how these components work together.

The development directory also contains the following subdirectories:

### `config/`

Contains the JSON configuration files and their associated schemas.

The `schema/` subdirectory contains the JSON Schema definitions used to validate CompStart configuration data.

### `data/`

Contains testing data and other development-related data.

### `dependencies/`

Contains the Python modules and dependencies used by the CompStart CLI.

See [`TECHNICAL_DETAILS.md`](TECHNICAL_DETAILS.md) for additional information about the Python components.

### `experimental-content/`

Contains experimental code and other content that is not currently part of the primary CompStart implementation.

See the development documentation for additional information.

### `features/`

Contains feature-related development information and planning.

See the development documentation for additional information.

## Documentation

The `documentation/` directory contains documentation for the CompStart project.

It is divided into two primary areas:

* **`development/`** — Documentation related to development, including experimental work, features, and other development processes.
* **`production/`** — Documentation related to production, packaging, and release processes.

The directory also contains the following project-level documentation files:

* **`CHANGELOG.md`** — High-level history of significant CompStart changes.
* **`DIRECTORY-STRUCTURE.md`** — Overview of the repository structure.
* **`TECHNICAL_DETAILS.md`** — Detailed information about the architecture and implementation of CompStart.

## Production

The `production/` directory contains the resources used to prepare, package, and manage CompStart releases.

The production directory contains the following subdirectories:

### `assets/`

Contains production-related assets.

See the production documentation for additional information.

### `packages/`

Contains release packages and related files.

### `releases/`

Contains release-related files and resources.

### `scripts/`

Contains scripts used for production and release processes.

---

*Last updated: 2026-09-16*
