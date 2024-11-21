# CompStart/releases

Parent folder to store all release branches. Each release will be set up using the structure outlined below. The folder itself is called _releases_.

## Directory Structure

### Major Versions

Major versions will have a directory that starts with _v_ followed by the version number. For example, _v1_ is for all releases related to version 1.

### Minor Versions

Minor versions will have a directory that starts with _m_ followed by the version number. For example, _v1/m1_ would be for all content related to version 1.1.

### Extra Info

Currently, there is no plan to add a third level of versioning, such as 1.1.1 for patches. Within the minor version folder will be any and all files laid out in the directory structure needed for that particular release. That is, for example, act as if _v1/m1_ is the root folder for all content related to version 1.1.

### Packaging

For now, a ZIP archive should be created with the content. Until an installer is created, this will serve as the release package. The content should have an instructions file at the release root level since manual installation will need to be done. See the file _instructions.txt_ contained in this parent folder.

### Subdirectories

Within each minor version folder will be subdirectories for each actual release version. Although there is no third level of versioning, if there's a need to add a tag to the minor version, such as _-alpha_, a new subdirectory will be created for the release. This subdirectory will have the full release version as its name. For example, within _v1/m1_ there is a subdirectory for the release _1.1-alpha_. If there is no tag that's needed, a subdirectory will still be created for the actual release with the same naming structure of the release version.

### Artifacts

Each release version folder will generally contain the following artifacts:

- _CompStart_: A directory holding all the files and folders that will be packaged for the release
- _release-notes_: A directory holding any information related to the release
- _py-tool_: A directory holding all scripts and files pertaining to the Python CLI tool
- _instructions.txt_: A text file containing instructions for manual installation when needed

The _py-tool_ directory will be where the Python tool _PyInstaller_ will be run to generate the single executable for the CLI tool. This executable will then be placed in the _CompStart_ directory. Within the _release-notes_ directory is a Markdown file with release information, including a link to the download page for the associated package.