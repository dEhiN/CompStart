# CompStart/releases

Parent folder to store all release data. Each release will be set up using the structure outlined below. The folder itself is called _releases_.

## Directories

Under the parent folder _releases_ are the following folders:

- _release-versions_: A directory containing all the release-specific folders and files (see the next section for details)
- _release-templates_: A directory containing templates of static content to include in each release
- _release-scripts_: A directory containing scripts for creating new releases
- _README.md_: This README file

The _release-templates_ directory has a master copy of the _instructions.txt_ file and the _release_notes.md_ file. These are meant to be copied over to each release folder. When these master copies are updated, previous release folders should keep the copies that were created at the time of release. Only future releases should use the updated versions of the two files.

The _release-scripts_ directory contains scripts that can be run to automate the process of creating a new release. This includes creating the folder structure for a new release, copying over all relevant files, and generating the Python executable for the CLI tool.

## Directory Structure for Releases

### Major Versions

Major versions will have a directory that starts with _v_ followed by the version number. For example, _v1_ is for all releases related to version `1`.

### Minor Versions

Minor versions will have a directory that starts with _m_ followed by the version number, and will be a subdirectory to the major version. For example, _v1/m1_ would be for all content related to version `1.1`.

### Tags

Currently, there is no plan to add a third level of versioning, but tags might be added for a release, such as _alpha_. Tags should be added to the end of the release version number and preceded by a hyphen. For example, the very first release of `CompStart` was version `1.1-alpha`.

### Subdirectories

 Within each major-minor directory tree structure, a subdirectory will be created for each release. This will be considered the release folder. The subdirectory will be named the same as the release, including the tag, if there is one. For example, release `1.1-alpha` is located at `/releases/v1/m1/1.1-alpha`.

### Artifacts

Each release folder will generally contain the following artifacts:

- _CompStart_: A directory holding the scripts, config files, executables, etc. that make up the _CompStart_ tool
- _release-notes_: A directory holding any information related to the release
- _py-tool_: A directory holding all scripts and files pertaining to the Python CLI tool
- _instructions.txt_: A text file containing any relevant instructions

## Release Contents and Packaging
The _CompStart_ folder will have the directory structure that's necessary for the tool to work. For example, the files `CompStart.bat`, `CompStart.ps1`, and `CompStart.exe` should all be inside this folder at what would be considered the root level. There should be a `config` folder also at this root level, and that folder should house the `startup_data.json` file, as well as any other config related data. This makes it so that, in order to make the tool work, the user only needs to copy the _CompStart_ folder to a path of their choosing and then follow the _instructions.txt_ file.

The _release-notes_ directory will contain a Markdown file with release information, including a link to the download page for the associated release package. This may seem redundant, but this file will be posted to GitHub as the release notes.

The _py-tool_ directory will be where the Python module _PyInstaller_ is run to generate the single executable for the CLI tool. This executable will need to be placed in the _CompStart_ directory. In general, the _py-tool_ directory will store a copy of `CompStart.py`, the `dependencies` folder with all the dependent Python scripts, and any files and folders that _PyInstaller_ creates.

The _instructions.txt_ file currently (as of 2024-12-14) contains information on how to manually copy the _CompStart_ folder to a location of the user's choosing, how to create a Windows symlink or shortcut to the `Batch` file, how to then move that shortcut to the Windows Start Menu Run folder, and how to modify the startup data.

A release package should only contain the following artifacts: 

1. _CompStart_
2. _release_notes_
3. _instructions.txt_