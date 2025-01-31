# CompStart/prodenv/releases

Parent folder to store all release data. Each release will be set up using the structure outlined below.

## Directories

- _versions_: A directory containing all the specific folders and files for a release version
- _README.md_: This README file

The _versions_ directory is where the subdirectories related to each release version is located. See the next section for details.

## Directory Structure for Releases

### Major Versions

Major versions will have a directory that starts with _v_ followed by the version number. For example, _v1_ is for all releases related to `version 1`.

### Minor Versions

Minor versions will have a directory that starts with _m_ followed by the version number, and will be a subdirectory to the major version. For example, _v1/m1_ would be for all content related to `version 1.1`.

### Tags

There is no third level of versioning, but tags might be added to a release, such as _alpha_. Tags should be added to the end of the release version number and preceded by a hyphen. For example, the very first release of `CompStart` was `version 1.1-alpha`.

### Subdirectories

 Within each major-minor directory tree structure, a subdirectory will be created for each release version. This will be considered the release folder. The subdirectory will be named the same as the release version, including the tag, if there is one. For example, `version 1.1-alpha` is located at `/releases/v1/m1/1.1-alpha`.
<br>
<br>

 # The following needs to be updated and is old information as of 2025-01-30

## Directory Structure for Releases

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
2. _instructions.txt_

## <a name="create-release"></a>Creating a Release
To automate the process for creating a release, as mentioned above, there is a subfolder called `scripts` that contains 3 _PowerShell_ scripts, a _PowerShell_ module, and a _Batch_ script (as of 2024-12-23). They are:

- _new-release.bat_
- _CreateReleaseFolder.ps1_
- _GeneratePythonTool.ps1_
- _CopyReleaseContent.ps1_
- _SetStartDirectory.psm1_

To create a new release folder from scratch, run the _Batch_ script. This will call the 3 _PowerShell_ scripts in the order listed above. The _PowerShell_ module contains a function that all 3 scripts use to set the project root directory correctly. This ensures that you can run the _Batch_ script from anywhere as long it's a subdirectory under the project root folder.

The automation process was broken into 3 main scripts so that each script could be run separately as needed. For example, if a release folder has already been created, and all that's needed it to generate (or re-generate) the _Python_ tool, then one can just run `GeneratePythonTool.ps1`.

Note that the second script, `GeneratePythonTool.ps1`, just generates the `CompStart.exe` file within the `py-tools` folder. It's the third script, `CopyReleaseContent.ps1` that copies over everything necessary for creating a release package, including the _Python_ executable.

Finally, if one is using VS Code as their editor, the _Batch_ script will need to be run manually from the integrated terminal (or another terminal shell) as the editor Run button uses the Output tab which doesn't allow for user input. However, the _PowerShell_ scripts can usually be run from the editor window by first clicking on 3 horizontal ellipsis and then selecting _Run_ as the Run button initially will also use the Output tab. Once the _Run_ command is selected from the ellipsis menu, then the Run button will work as the script is then started from the integrated terminal.