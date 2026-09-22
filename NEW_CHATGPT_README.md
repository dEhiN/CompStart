# CompStart

> **Automate the setup of your Windows workspace.**
<br>

Have you ever sat down at your computer after turning it on and thought:

*"Okay... now I need to open my browser, load these sites, open this document, and start this application just to get everything set up."*

That was the problem that led me to create CompStart.

CompStart is a Windows automation tool that helps restore your working environment automatically after you turn on your computer. Instead of manually opening the same collection of applications, documents, and websites every time you start working, you can have CompStart do it for you.

[**Ready to try it?** Jump to Installation](#installation)

[**Want to know how it works?** Jump to How It Works](#how-it-works)

## Table of Contents

#### Background
- [What is CompStart?](#what-is-compstart)
- [How is this different from Windows startup?](#how-is-this-different-from-windows-startup)
- [Who might find CompStart useful?](#who-might-find-compstart-useful)
- [Why did I build it?](#why-did-i-build-it)

#### Setup & Technical Details
- [Installation](#installation)
- [How it Works](#how-it-works)
- [Workspace Configuration](#workspace-configuration)
- [The CompStart CLI: A Configuration Tool](#the-compstart-cli-a-configuration-tool)

#### Project Information
- [Development](#project-development)
- [Documentation](#project-documentation)

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

1. Load several sites in a Chrome window
2. Open a PDF file with Adobe Acrobat
3. Launch a web application

The goal isn't simply to start a collection of programs. The goal is to recreate a **working environment**.

[Jump back to Table of Contents](#table-of-contents)

## How is this different from Windows startup?

Windows already has several ways to launch applications automatically when you log in. Those tools are useful, but they generally answer the question:

> **"What programs should I start?"**

CompStart is trying to answer a slightly different question:

> **"What should my working environment look like when I sit down at my computer?"**

The distinction is small, but it is the reason CompStart exists:

**_It's about restoring context, not just starting applications._**

[Jump back to Table of Contents](#table-of-contents)

## Who might find CompStart useful?

CompStart isn't intended to be something everyone needs.

It's most likely to be useful if you regularly return to a fairly complex Windows workspace and find yourself repeating the same setup process.

That might include:

* IT support and helpdesk technicians
* system administrators
* software developers
* other power users
* anyone with a repetitive Windows workflow involving several applications or resources

CompStart can also be useful if you use a desktop computer that is always on but suffers from scheduled Windows Update restarts.

However, you don't need to work in IT or development to use CompStart. The important thing is simply that you have a workspace you want to recreate.

[Jump back to Table of Contents](#table-of-contents)

## Why did I build it?

CompStart started as a PowerShell script I wrote for myself while working helpdesk at an MSP.

I had a collection of applications and websites that I needed to open every day before I could actually start working. Windows already provided ways to start applications automatically, but as mentioned earlier, those tools couldn't help to solve my issue.

I didn't just want my programs to start. I wanted my **workspace** to be automatically ready once I logged in.

So I wrote a script to do it.

Later, when I moved into client support at a SaaS company, I found myself dealing with the same issue again. So, I updated my script.

That made me think beyond the original script and start turning the idea into something more flexible and reusable.

At that point, CompStart became more than just a solution to my own automation problem. It also became an opportunity to build something, improve my programming skills, and see where the idea could go.

[Jump back to Table of Contents](#table-of-contents)

## Installation

CompStart currently includes an installer for Windows.

The installer places CompStart in:

```
%LocalAppData%\CompStart
```

For example, if your Windows profile name is _JohnDoe_, you will find CompStart at _C:\Users\JohnDoe\AppData\Local\CompStart_. A shortcut to start CompStart on login is then placed in the Windows Startup folder.

When you log in to Windows, CompStart starts and asks whether you want to restore your configured workspace. You can choose to run the startup process or skip it.

The installer is also designed to preserve your existing startup data when upgrading versions.

To install CompStart, download a release from the [Releases](https://github.com/dEhiN/CompStart/releases) page and follow the `instructions.txt` file included with the release package.

[Jump back to Table of Contents](#table-of-contents)

## How It Works

CompStart uses a JSON configuration file to describe the workspace that should be restored.

When Windows starts CompStart, the startup process:

1. Prompts you to decide whether to run the configured startup routine.
2. Reads your startup configuration.
3. Processes each startup item.
4. Starts the configured programs with any specified arguments.

CompStart was created using the following programming languages and technologies:

* **Batch** for Windows entry points
* **PowerShell** for the startup and installation processes
* **JSON** for startup configuration
* **JSON Schema** for configuration structure and validation
* **Python** for the configuration management CLI
* **PyInstaller** to package the Python CLI as a Windows executable for releases

For more information about the implementation, see [`TECHNICAL-DETAILS.md`](documentation/TECHNICAL-DETAILS.md).

[Jump back to Table of Contents](#table-of-contents)

## Workspace Configuration

CompStart stores the definition of your workspace in JSON. There is a configuration directory containing two JSON files:

* `startup_data.json` — your current startup configuration
* `default_startup.json` — the default configuration used as a starting point

When CompStart is first installed, if there is no existing `startup_data.json` file, one is supplied with the default configuration.

The default configuration currently opens Windows Calculator, Windows Notepad, and Google Chrome. Chrome is opened to the Google homepage in a new window using the default profile.

CompStart also includes JSON Schema files that define the structure of the startup data. These are used to ensure the JSON data always remains correctly formed and valid.

For normal use, you can manage your startup configuration through the included `CompStart.exe` command-line tool rather than editing the JSON by hand.

[Jump back to Table of Contents](#table-of-contents)

## The CompStart CLI: A Configuration Tool

CompStart includes a command-line configuration tool called `CompStart.exe`.

The CLI provides a text-based menu for managing the startup configuration. Among other things, it can be used to create a startup file, view the current startup configuration, and edit existing startup data.

The CLI tool is written in Python. Because of this, it is packaged into the executable `CompStart.exe` for releases. This way, users do not need to deal with the Python source code.

[Jump back to Table of Contents](#table-of-contents)

## Project Development

CompStart is primarily a personal project, but the repository is public because I want to share what this tool I've created so others can benefit from it.

The repository contains the development source code as well as the supporting configuration, experimental work, testing data, and release tooling.

I also welcome people who want to look through the project, experiment with it, or contribute improvements.

For information about the development structure and workflow, see the project documentation.

[Jump back to Table of Contents](#table-of-contents)

## Project Documentation

The repository documentation is divided into the following Markdown files:

- [`CHANGELOG.md`](documentation/CHANGELOG.md) provides a high-level history of significant CompStart changes.

- [`DIRECTORY-STRUCTURE.md`](documentation/DIRECTORY-STRUCTURE.md) explains how the repository is organized.

- [`TECHNICAL-DETAILS.md`](documentation/TECHNICAL-DETAILS.md) provides more technical information on how CompStart works.

Additional release-specific information can be found with the individual releases in the `production/releases` directory or on the [Releases](https://github.com/dEhiN/CompStart/releases) page.

[Jump back to Table of Contents](#table-of-contents)


## What's Next?

CompStart is still evolving. 

I have several ideas I'd like to explore, including:

* making CompStart cross-platform, potentially using **PowerShell Core**
* reworking the CLI into a more polished command-line experience
* supporting Windows virtual desktops so startup items can optionally be opened on specific desktops
* adding profiles or workspace configurations for different kinds of work

There is still plenty to experiment with, so if you want to help with this project, reach out to me via [LinkedIn](https://www.linkedin.com/in/david-h-watson/) or create a new [project issue](https://github.com/dEhiN/CompStart/issues) and let me know!

---

*Last Updated: 2026-09-20*
