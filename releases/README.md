# Demord/releases

Parent folder to store all release branches. Each release will be set up using the structure outlined below. The folder itself is called *releases*.

## Directory Structure

### Major Versions
Major versions will have a directory that starts with _v_ followed by the version number. For example, _v1_ is for all releases related to version 1.

### Minor Versions
Minor versions will have a directory that starts with _m_ followed by the version number. For example, _m1_ is for all releases related to version x.1, where x would be the parent _v_ directory. So, a directory structure like _/releases/v1/m1_ would be for all content related to version 1.1.

### Extra Info
Currently, there is no plan to add a third level of versioning, such as 1.1.1 for patches. Within the minor version folder will be a folder called **Demord**. This will act as the program folder, and within it will be any and all files needed for that particular release, structured as necessary. For example, for version 1.1, the root folder for all content will be _/releases/v1/m1/Demord_.

### Packaging
For now, a ZIP archive should be created with the content. Until an installer is created, this will serve as the release package. The content should have an instructions.txt file at the root level since manual installation will need to be done. This file can be found in the _/releases_ directory, at the same level as this README. Please consider this the master copy and copy-paste it verbatim into a release folder. If the instructions change, the one in the _releases_ directory will be updated.

## List of Releases

### 1.1-alpha

This is the first official release of Demord. It consists of the startup.ps1 file, the startup.bat file, and a config folder. In development, the _data_ folder will be used for storing JSON data among other things. But, in production, the folder will be called _config_ and will contain startup_data.json for now. This release also contains the instructions.txt file.