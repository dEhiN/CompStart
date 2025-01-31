The following was taken from an older version of the releases README file. It doesn't pertain to that README file anymore, but it may be useful for other subdirectories under /prodenv:

    ## Directories

    Under the parent folder _releases_ are the following folders:

    - _scripts_: A directory containing scripts for creating new releases
    - _templates_: A directory containing templates of static content to include in each release
    - _versions_: A directory containing all the specific folders and files for a release version
    - _README.md_: This README file

    The _scripts_ directory contains scripts that can be run to automate the process of creating a new release. This includes creating the folder structure for a new release, copying over all relevant files, and generating the Python executable for the CLI tool. For instructions on how to automatically create a release, see the section [_Creating a Release_](#create-release).

    The _templates_ directory has a master copy of the _instructions.txt_ file and the _release_notes.md_ file. These are meant to be copied over to each release folder. When these master copies are updated, previous release folders should keep the copies that were created at the time of release. Only future releases should use the updated versions of the two files.

    The _versions_ directory is where the subdirectories related to each release version is located. See the next section for details.


The following was taken from a pre-merged version of the main README file and is a description of the assets folder, currently found in /prodenv and previously found in /releases:

    All the static files related to production, such as a template for release notes or an installation instructions text file


The following was taken from a pre-merged version of the main README file and contains some descriptions that may be useful to add to other folder README files:

    - D _cs-installer_ A folder containing all assets related to the installer for _CompStart_
    - D _release-assets_ A folder containing assets pertaining to release versions

    #### Folder: /prodenv/assets/cs-installer -- L4

    - D _installer-files_ A blank folder that will contain all the actual program files that the installer needs to work with; a copy of this folder will be created for each actual release
    - F _install.ps1_ A PowerShell script that's being used as the program installer

    #### Folder: /prodenv/assets/release-assets -- L4

    - F _instructions.txt_ A file containing the instructions and is currently included in every release; this "template" file is what will be updated whenever the instructions need to be updated, and then copied for a release version
    - F _release-notes.md_ A Markdown file to use as the template for what is posted on GitHub for each release version