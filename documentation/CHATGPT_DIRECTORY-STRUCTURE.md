# CompStart Directory Structure

This document provides an overview of the CompStart repository structure and where to find the different parts of the project.

For information about how CompStart works and how its components interact, see [`TECHNICAL-DETAILS.md`](TECHNICAL-DETAILS.md).

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

The project root contains the main repository documentation and the three primary areas of the project:

* **`development/`** — Source code, configuration, development resources, and testing data.
* **`documentation/`** — Documentation covering the project, development process, and production/release processes.
* **`production/`** — Files and resources used to build, package, and release CompStart.

## Development

The `development/` directory contains the files used to develop and test CompStart.

### `config/`

Contains the JSON configuration files and their associated schemas.

The `schema/` subdirectory contains JSON Schema definitions used to validate CompStart configuration data.

### `data/`

Contains testing data and other development-related data.

### `dependencies/`

Contains the Python modules and dependencies used by the CompStart CLI.

See [`TECHNICAL-DETAILS.md`](TECHNICAL-DETAILS.md) for additional information about the Python components.

### `experimental-content/`

Contains experimental code and other content that is not currently part of the primary CompStart implementation.

See the development documentation for additional information.

### `features/`

Contains feature-related development information and planning.

See the development documentation for additional information.

### Development Scripts

The primary development scripts are located directly under `development/`:

* **`CompStart.bat`** — Batch entry point for the CompStart startup process.
* **`CompStart.ps1`** — PowerShell startup process.
* **`CompStart.py`** — Python CLI used to manage CompStart startup configuration.

See [`TECHNICAL-DETAILS.md`](TECHNICAL-DETAILS.md) for information about how these components work together.

## Documentation

The `documentation/` directory contains project documentation.

### `development/`

Documentation related to development, including experimental work, features, and other development processes.

### `production/`

Documentation related to production, packaging, and release processes.

### Documentation Files

* **`CHANGELOG.md`** — High-level history of significant CompStart changes.
* **`DIRECTORY-STRUCTURE.md`** — Overview of the repository structure.
* **`TECHNICAL-DETAILS.md`** — Detailed information about the architecture and implementation of CompStart.

## Production

The `production/` directory contains resources used to prepare and manage CompStart releases.

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
