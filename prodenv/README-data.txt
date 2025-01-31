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

