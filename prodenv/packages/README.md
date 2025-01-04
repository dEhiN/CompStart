# CompStart/packages

Parent folder to store all released packages. A release package should be just a single file, for example, either a _zip_ or _msi_ file. This is what will be distributed to GitHub.

## <a name="packaging"></a>Packaging

For now, a ZIP archive will be created for each package file, or artifact. Since there is a _PowerShell_ installer script, the ZIP archive will contain the installer script as well as a folder that holds the rest of the files related to the release package. See the `README` file in `/prodenv/releases` for more information.

## Directory Structure

### Major Versions

Major versions will have a directory that starts with `v` followed by the version number. For example, `v1` would be for all content related to _release version 1_.

### Minor Versions

Minor versions will have a directory that starts with `m` followed by the version number, and will be a subdirectory to the major version. For example, `v1/m1` would be for all content related to _release version 1.1_.

### Artifacts

See the [Packaging](packaging) section for more information.

The naming pattern for a release artifact is as follows: `CompStart-<release-version>`

For example, `CompStart-1.1-alpha.zip` would be the artifact pertaining to _release version 1.1-alpha_. 

## Released Packages

- _CompStart-1.1-beta.zip_
<br>The second release of _CompStart_ and it also requires manual installation as it contains only the `Batch` script, the `Powershell` script, the `JSON config` file, and `CompStart.exe` - the new Python CLI tool. This Python tool will make it easier to modify the startup data. The _instructions.txt_ file for this release includes directions on how to use the CLI tool.

- _CompStart-1.1-alpha.zip_
<br>The first ever release of _CompStart_ and requires manual installation as it contains only the `Batch` script, the `Powershell` script, and the `JSON` config file. The _instructions.txt_ file for this release includes directions on how to manually alter the `JSON` config file.

## Recalled Packages

- Currently there are no recalled packages