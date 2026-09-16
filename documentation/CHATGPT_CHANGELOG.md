# CompStart Changelog

This file provides a high-level history of significant changes to CompStart.

For detailed release notes, installation instructions, issue history, and pull requests, see the corresponding [GitHub Releases](https://github.com/dEhiN/CompStart/releases).

## [1.2] - 2026-09-10

### Fixed

- Fixed the installer so existing user startup data is not overwritten.
- Updated `CompStart.ps1` to allow applications to be opened without command-line arguments.
- Updated the Notepad path in the default startup configuration.

### Changed

- Updated the Python CLI menu descriptions.
- Updated installation documentation.

## [1.1] - 2026-07-22

### Fixed

- Fixed an issue with `CompStart.ps1` that prevented applications such as Visual Studio Code from opening correctly.

## [1.0] - 2026-06-29

### Added

- Added an automated PowerShell-based installer.
- Added automated release packaging using PyInstaller.
- Added a release deployment script for building and packaging releases.

### Changed

- Restructured the release package and installation process.
- Updated installation instructions for the new automated installer.

## [0.1-beta] - 2026-04-02

### Added

- Added the Python CLI for managing startup configuration.
- Added JSON Schema validation for startup data.

### Changed

- Separated default startup configuration from user startup data.
- Reorganized the repository structure.
- Standardized script and file naming.

## [0.1-alpha] - 2026-03-31

### Added

- Initial CompStart release.
- Added PowerShell and Batch startup scripts.
- Added JSON startup configuration and JSON Schema files.
- Added a default startup configuration.

### Changed

- Refactored the PowerShell startup script to load startup settings dynamically from JSON rather than relying on hardcoded paths.