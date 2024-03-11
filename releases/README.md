# CompStart/releases

Parent folder to store all release branches. Each release will be set up using the structure outlined below. The folder itself is called _releases_.

## Directory Structure

### Major Versions

Major versions will have a directory that starts with _v_ followed by the version number. For example, _v1_ is for all releases related to version 1.

### Minor Versions

Minor versions will have a directory that starts with _m_ followed by the version number. For example, _m1_ is for all releases related to version x.1, where x would be the parent _v_ directory. So, a directory structure like _/releases/v1/m1_ would be for all content related to version 1.1.

### Extra Info

Currently, there is no plan to add a third level of versioning, such as 1.1.1 for patches. Within the minor version folder will be any and all files laid out in the directory structure needed for that particular release. That is, for example, act as if _/releases/v1/m1_ is the root folder for all content related to version 1.1.

### Packaging

For now, a ZIP archive should be created with the content. Until an installer is created, this will serve as the release package. The content should have an instructions.txt file at the root level since manual installation will need to be done.
