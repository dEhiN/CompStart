# CompStart

> **Automate the setup of your Windows workspace.**

Have you ever sat down at your computer to start working and thought:

*"Okay... now I need to open Chrome, load these tabs, open this document, start this application, and get everything set up."*

That was the problem that led me to create CompStart.

CompStart is a Windows automation tool that helps restore the working environment I use when I sit down at my computer. Instead of manually opening the same collection of applications, documents, websites, and browser windows every time I start working, I can have CompStart do it for me.

[**Ready to try it?** Jump to Installation](#installation)

[**Want to know how it works?** Jump to How It Works](#how-it-works)

## Table of Contents

#### Background
- [What is CompStart?](#what-is-compstart)
- [Why did I build it?](#why-did-i-build-it)
- [How is this different from Windows startup?](#how-is-this-different-from-windows-startup)
- [Who might find CompStart useful?](#who-might-find-compstart-useful)

#### Setup & Technical Details
- [Installation](#installation)
- [How it Works](#how-it-works)
- [Workspace Configuration](#workspace-configuration)
- [The CompStart CLI: A Configuration Tool](#the-compstart-cli-a-configuration-tool)
- [Project Documentation](#project-documentation)
- [Development](#development)

#### Future Plans
- [What's Next](#whats-next)

## What is CompStart?

CompStart is a workspace startup automation tool for Windows.

The idea is simple: define the things you want available when you first log in to Windows and let CompStart open them for you.

That can include things such as:

* applications
* documents
* websites
* browser windows and tabs
* web applications and PWAs

For example, I might want my computer to automatically:

* Open a specific document
* Start a Chrome window with several particular tabs
* Launch a web application

The goal isn't simply to start a collection of programs. The goal is to recreate a **working context**.

[Jump back to Table of Contents](#table-of-contents)

## Why did I build it?

CompStart started as a PowerShell script I wrote for myself while working helpdesk at an MSP.

I had a collection of applications and websites that I needed to open every day before I could actually start doing useful work. Windows already provided ways to start applications automatically, but those tools didn't really solve the problem I was trying to solve.

I didn't just want my programs to start.

I wanted my **workspace** to be automatically ready once I logged in.

So I wrote a script to do it.

Later, when I moved into client support at a SaaS company, I found myself dealing with many of the same problems again. That made me think beyond the original script and start turning the idea into something more flexible and reusable.

At that point, CompStart became more than just a solution to my own automation problem. It also became an opportunity to build something, improve my programming skills, and see where the idea could go.

I've kept developing it because I enjoy working on it—and because I think other people may find it useful too.

[Jump back to Table of Contents](#table-of-contents)

## How is this different from Windows startup?

Windows already has several ways to launch applications automatically when you log in.

Those tools are useful, but they generally answer a question like:

> **"What programs should I start?"**

CompStart is trying to answer a slightly different question:

> **"What should my working environment look like when I sit down at my computer?"**

For example, instead of simply starting Chrome, CompStart can start Chrome with particular arguments so that it opens the windows, profiles, tabs, or URLs that are part of your workflow.

It can do the same thing for other applications and files that need to be opened with particular settings or arguments.

The distinction is small, but it is the reason CompStart exists:

**It's about restoring context, not just starting applications.**

[Jump back to Table of Contents](#table-of-contents)

## Who might find CompStart useful?

CompStart isn't intended to be something everyone needs.

It's most likely to be useful if you regularly return to a fairly complex Windows workspace and find yourself repeating the same setup process.

That might include:

* IT support and helpdesk technicians
* MSP technicians
* system administrators
* software developers
* other power users
* anyone with a repetitive Windows workflow involving several applications or resources

You don't need to work in IT or development to use CompStart. The important thing is simply that you have a workspace you regularly want to recreate.

[Jump back to Table of Contents](#table-of-contents)

## Installation

CompStart currently includes an installer for Windows.

The installer places CompStart in:

```text
%LocalAppData%\CompStart
```

and creates a shortcut to the CompStart startup process in the Windows Startup folder.

When you log in to Windows, CompStart starts and asks whether you want to restore your configured workspace. You can choose to run the startup process or skip it.

The installer is also designed to preserve your existing startup data when upgrading an installation.

To install CompStart, download a release from the [Releases](https://github.com/dEhiN/CompStart/releases) page and follow the `instructions.txt` file included with the release package.

[Jump back to Table of Contents](#table-of-contents)

## How It Works

CompStart uses a JSON configuration file to describe the workspace that should be restored.

When Windows starts CompStart, the startup process:

1. Prompts you to decide whether to run the configured startup routine.
2. Reads your startup configuration.
3. Processes each startup item.
4. Starts the configured programs with any specified arguments.

The current implementation uses:

* **Batch** for Windows entry points
* **PowerShell** for the startup and installation processes
* **JSON** for startup configuration
* **JSON Schema** for configuration structure and validation
* **Python** for the configuration management CLI
* **PyInstaller** to package the Python CLI as a Windows executable for releases

For more information about the implementation, see [`TECHNICAL-DETAILS.md`](documentation/TECHNICAL-DETAILS.md).

[Jump back to Table of Contents](#table-of-contents)

## Workspace Configuration

CompStart stores the definition of your workspace in JSON.

The installed program uses a configuration directory containing:

* `startup_data.json` — your current startup configuration
* `default_startup.json` — the default configuration used as a starting point

The default configuration currently demonstrates opening Windows Calculator, Windows Notepad, and Google Chrome. The Chrome example includes arguments demonstrating how CompStart can pass additional information to an application.

CompStart also includes JSON Schema files that define the structure of the startup data.

For normal use, you can manage your startup configuration through the included `CompStart.exe` command-line tool rather than editing the JSON file by hand.

[Jump back to Table of Contents](#table-of-contents)

## The CompStart CLI: A Configuration Tool

CompStart includes a command-line configuration tool called `CompStart.exe`.

The CLI provides a text-based menu for managing the startup configuration. Among other things, it can be used to create a startup file, view the current startup configuration, and edit existing startup data.

The CLI is packaged into `CompStart.exe` for releases so that users do not need to install Python or work directly with the Python source code.

[Jump back to Table of Contents](#table-of-contents)

## Project Documentation

The documentation in this repository is divided by purpose.

[`CHANGELOG.md`](documentation/CHANGELOG.md) provides a high-level history of significant CompStart changes.

[`DIRECTORY-STRUCTURE.md`](documentation/DIRECTORY-STRUCTURE.md) explains how the repository is organized.

[`TECHNICAL-DETAILS.md`](documentation/TECHNICAL-DETAILS.md) provides a more detailed overview of how CompStart works.

Additional release-specific information can be found with the individual releases in the `production/releases` directory.

[Jump back to Table of Contents](#table-of-contents)

## Development

CompStart is primarily a personal project, but the repository is public because I'm happy to share what I'm building and how I'm building it.

The repository contains the development source code as well as the supporting configuration, experimental work, testing data, and release tooling.

I also welcome people who want to look through the project, experiment with it, or contribute improvements.

For information about the development structure and workflow, see the project documentation.

[Jump back to Table of Contents](#table-of-contents)

## What's Next?

CompStart is still evolving.

Part of the fun of this project is that I don't have every future feature planned out in advance. I have several ideas I'd like to explore, including:

* making CompStart cross-platform, potentially using **PowerShell Core**
* reworking the CLI into a more polished command-line experience
* supporting Windows virtual desktops so startup items can optionally be opened on specific desktops
* adding profiles or workspace configurations for different kinds of work

The idea of profiles is particularly interesting to me.

My work environment might look very different from the environment I use for personal projects, or from the workspace I might want when troubleshooting something for a client. It would be useful to define those different contexts and choose the one I want when I need it.

There is still plenty to experiment with, and that's a big part of why I enjoy working on CompStart.

---

*Last Updated: 2026-09-20*
