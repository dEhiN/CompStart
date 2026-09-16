# CompStart Changelog

This file provides a high-level history of significant changes to CompStart.

For detailed release notes, installation instructions, issues, and pull requests, see the corresponding [GitHub Releases](https://github.com/dEhiN/CompStart/releases).

## CompStart-1.2

Release date: 2026-09-10

### Fixed

* Fixed the installer so existing user startup data is not overwritten.
* Updated the PowerShell startup process to allow applications to be opened without command-line arguments.
* Updated the Notepad program path in the default startup configuration.

### Changed

* Updated the Python CLI menu description for option 1.
* Updated the installation instructions in the main repository README.

## CompStart-1.1

Release date: 2026-07-22

### Fixed

* Fixed an issue with the PowerShell startup process that prevented applications such as Visual Studio Code from opening correctly.

## CompStart-1.0

Release date: 2026-06-29

### Added

* Added an automated PowerShell-based installer.
* Added automated release packaging using PyInstaller.
* Added a PowerShell release deployment script for building and packaging releases.

### Changed

* Restructured the release package to separate installer scripts from core installation files.
* Updated the installation instructions for the automated installer.

## CompStart-0.1-beta

Release date: 2026-04-02

*Originally released on 2024-11-21 as `CompStart-1.1-beta`. The version was retroactively changed to `0.1-beta` in March 2026.*

### Added

* Added an interactive Python CLI tool for managing startup configuration.
* Added JSON Schema validation for startup data.
* Added experimental development for a PowerShell installer, PyInstaller executable generation, and a Tkinter GUI.

### Changed

* Separated default startup configuration from user-specific startup data.
* Reorganized the repository structure.
* Standardized script and file naming conventions.

## CompStart-0.1-alpha

Release date: 2026-03-31

*Originally released on 2024-03-11 as `CompStart-1.1-alpha`. The version was retroactively changed to `0.1-alpha` in March 2026.*

### Added

* Initial CompStart release.
* Added the PowerShell and Batch scripts used by the startup process.
* Added the JSON startup configuration and JSON Schema files.
* Added a default startup configuration.

### Changed

* Refactored the PowerShell startup process to load startup settings dynamically from JSON rather than relying on hardcoded paths.

_Last Updated: 2026-09-16_