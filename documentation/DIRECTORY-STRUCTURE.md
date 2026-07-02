# CompStart Directory Structure

<hr>

The following is an outline of the project structure. Specifically, it is an outline of the physical directory structure from the project root level, which should be a folder called _CompStart_.

The outline is based on this legend:

- L = Folder level or the number of subdirectories down from the project root, which is level 1
- (DF) = Directory Folder
- (F) = File

## L1

### Folder: root (/)

- (DF) _development_: Development files.
- (DF) _documentation_: Specific Markdown files.
- (DF) _production_: Production files.
- (F) _.gitattributes_: GitHub attributes.
- (F) _.gitignore_: Project gitignore.
- (F) _README.md_: Project README.

## L2

### Folder: /development

- (DF) _config_: Configuration folder for the startup JSON files.
- (DF) _data_: Testing and other data.
- (DF) _dependencies_: Python module folder that holds all the dependencies for _CompStart.py_ - see **/documentation/TECHNICAL_DETAILS.md**.
- (DF) _experimental-content_: See **/documentation/development/EXPERIMENTAL-CONTENT.md**.
- (DF) _features_: See **/documentation/development/FEATURES.md**.
- (F) _CompStart.bat_: See **/documentation/TECHNICAL_DETAILS.md**.
- (F) _CompStart.ps1_: See **/documentation/TECHNICAL_DETAILS.md**.
- (F) _CompStart.py_: See **/documentation/TECHNICAL_DETAILS.md**.

### Folder: /documentation

- (DF) _development_: Markdown documentation related to development.
- (DF) _production_: Markdown documentation related to production.
- (F) _CHANGELOG.md_: Project changelog.
- (F) _DIRECTORY_STRUCTURE.md_: Description of the project directory structure.
- (F) _TECHNICAL_DETAILS.md_: Full technical details of _CompStart_ (how it works and the components involved).

### Folder: /production

- (DF) _assets_: See **/documentation/production/ASSETS.md**.
- (DF) _packages_: See **/documentation/production/PACKAGES.md**.
- (DF) _releases_: See **/documentation/production/RELEASES.md**.
- (DF) _scripts_: See **/documentation/production/SCRIPTS.md**.

## L3

### Folder: /development/config

- (DF) _schema_: Contains the JSON schema files - see **/documentation/TECHNICAL_DETAILS.md**.

### Folder: /development/data

- (DF) _test-data_: Contains data generated during testing.
- (F) _misc-data.tar.gz_: Gzipped tar file that contains non-code related files such as text files with planning information, etc.
- (F) _old-data.tar.gz_: Gzipped tar file that contains old or original code files designated to keep for posterity.

_Last Updated: 2026-05-28_
