# CompStart

## Purpose

CompStart is a tool that allows you to have programs open automatically when your computer starts. It currently only works on Windows. But doesn't Windows already allow that through Task Manager and the startup folders, you ask? Well, here's how CompStart is different: you can open up specific tabs and browser windows alongside the installed programs. For example, you could open up a specific Word document, a Chrome window with 3 tabs, and the Google Chat Chrome app, all instantaneously after you log in.

CompStart will also allow you to quickly and easily change the programs and sites you want to open. Using the previous example, let's say you finished working on the Word document. You can easily remove that from the startup list, so CompStart will only open the Chrome window with 3 tabs and the Google Chat Chrome app.

## Installation

#### For non-devs

Currently, the installation process is manual. If you want to use this tool for yourself, you will need to be comfortable with using the command line, editing the Windows startup folder, and changing JSON configuration files manually. See the [releases](https://github.com/dEhiN/CompStart/releases) section to find the files to download. There will be setup instructions included. Follow them and you can start using CompStart for yourself!

#### For devs

The installation instructions are essentially the same as above if you just want to use the tool. However, if you want to install CompStart to work on it, depending on what you want to do, you have 2 options:

1. If you want to contribute to this program, read the **How to help** section first. Once you get in touch with me, let me know what you want to do, and I can add you as a contributor to the repository.

2. If you want to play around with what I've created on your own, you can fork this repository. I encourage you to read the **How to help** section. I also ask that if you publish anything you create based on this project, please credit me as applicable. Finally, it would be nice if you let me know.

## How to help

#### First Steps

If you'd like to contribute to this program, please get in touch! On my GitHub profile page, you'll find how to reach me. My profile page is: https://github.com/dEhiN.

Next, read through the following sections:

1. **Technical Details**
2. **Listing of Files and Folders**

Finally, check out the project board at https://github.com/users/dEhiN/projects/4, and familiarize yourself with the open issues and work.

All work I've contributed is well documented and my commits are pretty detailed. However, if there's something you're not sure about, you can always connect with me.

#### Technical Details

CompStart consists of a Batch file, a PowerShell script, and a JSON config file. The Batch file starts off the whole process. A shortcut to the Batch file will be put into the Windows Start Menu folder, and it will run the Powershell script. The Batch file is interactive, and first asks the user if they want to run the script. This ensures that a user could start their computer without having all their startup programs run whenever they want.
