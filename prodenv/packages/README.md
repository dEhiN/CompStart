# CompStart/prodenv/packages

Parent folder to store all released packages. A release package should just be a single file, for example, either a _zip_ or _msi_ file. This is what will be distributed to GitHub.

## Packaging

For now, a ZIP archive will be created with the content for each release. Until an installer is created, this will serve as the release package. The archive will be generated from the release folder found in `/releases/versions`. See the `README.md` file in `/releases` for more information.

## Directory Structure

### Major Versions

Major versions will have a directory that starts with _v_ followed by the version number. For example, _v1_ is for all content related to `version 1`.

### Minor Versions

Minor versions will have a directory that starts with _m_ followed by the version number, and will be a subdirectory to the major version. For example, _v1/m1_ would be for all content related to `version 1.1`.

### Artifacts

Each minor version folder will have one or more files associated with that version that will be considered a release package. A release package file itself will either be an archive or installer file. The naming pattern for a release package file is as follows: 

1. _CompStart_
2. Hyphen 
3. Release name

## Released Packages

- _CompStart-1.1-beta.zip_
<br>The second release of _CompStart_ and it also requires manual installation as it contains only the `Batch` script, the `Powershell` script, the `JSON config` file, and `CompStart.exe` - the new Python CLI tool. This Python tool will make it easier to modify the startup data. The _instructions.txt_ file for this release includes directions on how to use the CLI tool.

- _CompStart-1.1-alpha.zip_
<br>The first ever release of _CompStart_ and requires manual installation as it contains only the `Batch` script, the `Powershell` script, and the `JSON` config file. The _instructions.txt_ file for this release includes directions on how to manually alter the `JSON` config file.

## Recalled Packages

- Currently there are no recalled packages