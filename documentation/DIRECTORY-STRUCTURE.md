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
<hr>

## Root Directory

The project root is divided into three primary areas:

* **`development/`** — Contains the source code, configuration, development resources, and testing data used to build and test CompStart.
* **`documentation/`** — Contains documentation for the project, including development and production documentation.
* **`production/`** — Contains the resources and scripts used to prepare, package, and manage CompStart releases.

The root directory also contains the primary repository-level files:

* **`.gitattributes`** — GitHub configuration attributes.
* **`.gitignore`** — Files and directories excluded from Git.
* **`README.md`** — Main project documentation.

## Development

The primary CompStart scripts are located here:

* **`CompStart.bat`** — Batch entry point for the CompStart startup process.
* **`CompStart.ps1`** — PowerShell startup process.
* **`CompStart.py`** — Python CLI used to manage CompStart startup configuration; also referred to as the CompStart CLI.

See [`TECHNICAL-DETAILS.md`](TECHNICAL-DETAILS.md) for information about how these components work together.

The following folders are found here: 

### `config/`

Contains the JSON configuration files and their associated schemas.

The `schema/` subdirectory contains the JSON Schema definitions used by the CompStart CLI to validate startup configuration data.

### `data/`

Contains archive files representing data that's being kept for posterity, such as testing data from a feature branch.

### `dependencies/`

Contains the Python modules and dependencies used by the CompStart CLI.

See [`TECHNICAL-DETAILS.md`](TECHNICAL-DETAILS.md) for additional information about the Python components.

### `experimental-content/`

Contains content that is not currently part of the primary CompStart implementation but is being looked at for viability of inclusion. 

See the development documentation for additional information.

### `features/`

Contains feature-related development information and planning.

See the development documentation for additional information.

## Documentation

This folder is divided into two primary areas:

* **`development/`** — Documentation related to development, including experimental work, features, and other development processes.
* **`production/`** — Documentation related to production, packaging, and release processes.

The directory also contains the following project-level documentation files:

* **`CHANGELOG.md`** — High-level history of significant CompStart changes.
* **`DIRECTORY-STRUCTURE.md`** — Overview of the repository structure.
* **`TECHNICAL-DETAILS.md`** — Detailed information about the architecture and implementation of CompStart.

## Production

Production and release related content is split into four folders.

The production documentation contains detailed information about the release process.

### `assets/`

Contains production-related assets.

### `packages/`

Contains release packages.

### `releases/`

Contains release content.

### `scripts/`

Contains scripts used to create a release.

---

*Last updated: 2026-09-16*
