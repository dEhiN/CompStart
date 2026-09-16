# CompStart Changelog

All notable changes to the CompStart project are documented in this file.

## [Unreleased] - 2026-09-16
### Changed
* Overhauled main `README.md` (`CHATGPT_FINAL_README.md`) to reframe CompStart as a workspace bootstrapper.

---

## [1.2] - 2026-09-10
### Fixed
* Fixed installer script to prevent overwriting existing user startup data.
* Updated `CompStart.ps1` to allow opening applications without command-line arguments.
* Updated Notepad program path in default startup data files across `0.1-beta`, `1.0`, and `1.1`.

### Changed
* Updated Python CLI tool description for option 1 on the main menu.
* Updated installation instructions in the main repository `README.md`.

### Issues & PRs
* **Issues Addressed:** #113, #118, #120, #124
* **Merged PRs:** #121, #122, #125, #126

---

## [1.1] - 2026-07-22
### Added
* Created `/development/qa-debug` folder and `QA-DEBUG-BRANCHES.md` tracking file.

### Fixed
* Resolved `CompStart.ps1` script execution issue where applications like Visual Studio Code locked the startup window open.

### Issues & PRs
* **Issues Addressed:** #56, #89, #90, #104, #111
* **Merged PRs:** #110, #115, #117

---

## [1.0] - 2026-06-29
### Added
* Formalized PyInstaller generation to compile `CompStart.py` into `CompStart.exe`.
* Added PowerShell installer script (`install.ps1`) to copy files to `%LocalAppData%\CompStart` and set up Start Menu startup folder shortcuts.
* Created automated release deployment PowerShell script to handle packaging, directory management, PyInstaller compilation, build artifact cleanup, and zip archive generation.

### Changed
* Restructured release directory contents to separate installer scripts from core installation files.
* Rewrote `instructions.txt` to reflect automated installation procedures.

### Issues & PRs
* **Issues Addressed:** #2, #10, #11, #18, #24, #28, #45, #46, #47, #50, #52, #53, #56, #64, #65, #66, #70, #75, #78, #80, #82, #84, #93, #97, #98, #100, #101, #102
* **Merged PRs:** #51, #54, #55, #58, #59, #60, #61, #62, #63, #67, #68, #69, #71, #72, #73, #74, #76, #77, #79, #83, #85, #87, #91, #92, #95, #99, #103, #105, #106, #107, #109

---

## [0.1-beta] - 2026-04-02
*Note: Originally developed under version tag `1.1-beta` before retroactive versioning adjustments were made in March 2026.*

### Added
* Introduced interactive Python CLI tool (`CompStart.py`) with modular helper scripts.
* Implemented new JSON configuration schema for startup data validation.
* Conducted experimental development on PowerShell installer, PyInstaller executable generation, and TKinter GUI.

### Changed
* Separated JSON startup data into default values (`default_startup.json`) and user-specific data (`startup_data.json`).
* Reorganized repository structure into `/config` and `/experimental_content` folders.
* Standardized script and file naming conventions for proper project branding.

### Issues & PRs
* **Issues Addressed:** #4, #5, #13, #14, #20, #21, #22, #25, #26, #31, #33, #36, #38, #42, #43
* **Merged PRs:** #23, #27, #29, #30, #32, #35, #37, #39, #40, #41, #48, #49

---

## [0.1-alpha] - 2026-03-31
*Note: Original development date March 9, 2024; retroactively re-tagged from `1.1-alpha` in March 2026.*

### Added
* Initial creation of CompStart repository and baseline commit structure.
* Designed initial JSON configuration schema and populated default startup JSON file.

### Changed
* Refactored PowerShell startup script from hardcoded paths to dynamic JSON variable parsing.

### Issues Addressed
* **Issues Addressed:** #3, #6, #7, #8, #9, #12, #15, #16, #17, #19