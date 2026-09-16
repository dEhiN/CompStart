# CompStart

> A Declarative Workspace Bootstrapper for Windows & Power Users

CompStart is a lightweight automation tool designed to restore complete digital working context at system login. Rather than simply launching bare executables, CompStart deterministically rebuilds multi-monitor workspace environments—opening target web applications, specific browser window layouts, PWAs, and local documents.

It is built specifically for IT support specialists, MSP technicians, software developers, and power users who need to automate complex daily startup routines without the performance penalty of keeping a computer in sleep or hibernate mode.

## Why CompStart?

Standard Windows startup methods and browser session restores often fall short when setting up daily work context:

* **Context over Binaries:** Native Windows startup shortcuts open applications in default states. CompStart launches programs with exact parameters, routing specific URLs to isolated browser windows and loading working documents directly.
* **Declarative Configuration:** Startup entries are defined in structured JSON configuration files. Users can define their desired end-state without writing custom scripts or risking manual syntax errors.
* **No Resource Bloat:** Features like browser pinned tabs duplicate heavy memory loads across every window you open. CompStart loads your morning tabs once on boot, allowing you to shut down your machine nightly for optimal system performance.

## System Components

CompStart consists of two primary components:

1. **Startup Execution Engine (`CompStart.ps1` / `CompStart.bat`)**
   * Reads the active startup configuration on login and sequentially executes designated applications, URLs, and tools.
2. **Startup Data Manager (`CompStart.exe` / `CompStart.py`)**
   * An interactive CLI tool that allows users to safely view, add, update, and remove entries in the configuration file without directly editing raw JSON.

## Target Audience

CompStart is designed for anyone who manages multi-tool environments daily. By automating context setup for helpdesk technicians, sysadmins, and developers, CompStart supports the people who keep everything else running smoothly.

## How to Help

If you'd like to contribute to CompStart, please get in touch! You can reach me via my GitHub profile page at [github.com/dEhiN](https://github.com/dEhiN).

To get familiar with the project:
1. Read **TECHNICAL_DETAILS.md** and **DIRECTORY_STRUCTURE.md** in the `documentation/` folder.
2. Check out the project board and familiarize yourself with the open issues and planned work.

All work contributed is well documented. If there is anything you're not sure about, feel free to connect with me.