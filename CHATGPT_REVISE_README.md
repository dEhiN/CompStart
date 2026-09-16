# CompStart

> **Automate the setup of your Windows workspace.**

Have you ever logged into your computer in the morning and thought:

*"Okay... now I need to open Chrome, load these tabs, open this document, start this application, and put everything where I need it."*

That's the problem CompStart was built to solve.

## What is CompStart?

CompStart is a Windows automation tool that restores your working environment when you log in.

It's not just about launching programs. CompStart can open the **specific things you actually need to get back to work**: applications, documents, websites, browser windows, tabs, and PWAs.

For example, you might want your computer to automatically:

* Open a specific Word document
* Start a Chrome window with three particular tabs
* Launch a web application as a PWA
* Open the other tools you use every day

And the next day, you want all of that back without having to set it up again.

That's what CompStart does.

## Why did I build it?

CompStart started as a PowerShell script I wrote while working helpdesk at an MSP.

The problem was simple: every time I sat down to work, I had a collection of applications and websites that I needed to open before I could actually start doing anything useful.

Windows startup could launch the applications, but it couldn't really recreate my **working context**.

So I wrote a script to do it.

Later, when I moved into client support at a SaaS company, I found myself solving many of the same problems again. At that point I took the original script and started turning it into something more extensible and reusable.

CompStart is the result.

## Why is this different from Windows startup?

Windows already has startup folders, Task Manager startup entries, and other ways of launching applications automatically.

Those are useful, but they generally answer this question:

> **"What programs should I start?"**

CompStart is interested in a slightly different question:

> **"What should my working environment look like when I sit down at my computer?"**

That distinction is important.

Instead of simply starting Chrome, for example, CompStart can start Chrome with the particular windows and URLs you want. It can also launch documents, applications, and other tools as part of the same startup routine.

The goal is to restore your **context**, not just your applications.

## Who is CompStart for?

CompStart is probably not something everyone needs.

It's aimed more at people who have a lot of tools to open and a specific workflow they repeat every day.

That includes:

* IT support and helpdesk technicians
* MSP technicians
* System administrators
* Software developers
* Power users
* Anyone with a complicated daily Windows workflow

If opening your computer in the morning means opening ten different things before you're ready to work, CompStart may be useful to you.

## How it works

CompStart currently uses **PowerShell, Batch, Python, and JSON**.

The startup process is driven by PowerShell and Batch. A Batch file provides the entry point for Windows startup, while the PowerShell portion reads the configured startup data and launches the requested applications, websites, documents, and browser configurations.

There's also an important little piece of control built into the startup process: **CompStart asks whether you actually want to restore your workspace.**

That means you can start your computer normally without having CompStart open everything. Maybe you're troubleshooting something, using the machine for a different purpose, or simply don't need your usual workspace that day.

The configuration itself is stored as JSON.

The installation process is also PowerShell-based, with a Batch file provided as an easy way to launch the installer. The installer places CompStart under `%LocalAppData%\CompStart` and creates a shortcut in the Windows Startup folder so that CompStart can run automatically when you log in.

### Configuration

The CompStart directory contains the startup scripts and a `config` directory.

The configuration directory contains:

* `startup_data.json` — your actual startup configuration
* `default_startup.json` — a default configuration template

The initial `startup_data.json` is created from the default template.

The template provides a simple example by opening **Notepad, Calculator, and Google Chrome to the Google homepage**. It's intended to give you something you can start with and modify.

There's also a `schema` directory containing JSON Schema definitions for validating both the overall startup data and individual startup items.

### Managing startup data

The first release of CompStart required users to manually copy the application files into place and edit the JSON configuration themselves.

Starting with the second release, CompStart includes a Python-based CLI tool that makes managing that configuration much easier.

The CLI is currently a basic menu-driven interface that lets you view, add, modify, and remove startup entries.

It also validates changes before writing them to the configuration file, which helps prevent malformed or invalid JSON from being introduced through the tool.

The Python code is written in a modular, functional style, and the release process uses **PyInstaller** to package the CLI into an executable for distribution.

## Installation

### For users

CompStart includes an installer that handles the setup for you.

The installer places CompStart in:

```text
%LocalAppData%\CompStart
```

and creates a shortcut to the startup Batch file in the Windows Startup folder.

If you're upgrading an existing installation, the installer is designed to preserve your existing startup data.

Go to the [Releases](https://github.com/dEhiN/CompStart/releases) page to download the latest version and follow the included setup instructions.

### For developers

You can clone or fork the repository if you'd like to experiment with the project or contribute to it.

Before making changes, I'd recommend looking through the project documentation and getting familiar with the existing structure.

## Contributing

CompStart is open source, and I'd love to have other developers take a look at it.

If you're interested in contributing, start by reading:

1. **`TECHNICAL_DETAILS.md`** – an overview of how the project works
2. **`DIRECTORY_STRUCTURE.md`** – how the repository is organized
3. The project board and open issues – what's currently being worked on

A lot of the project is documented, and I try to keep the commits themselves reasonably detailed as well.

If you find something that isn't clear, feel free to get in touch through my [GitHub profile](https://github.com/dEhiN).

## What's next?

CompStart is still evolving.

What started as a PowerShell script for solving a very practical problem has grown into a more extensible tool, and I have ideas for taking it quite a bit further.

Some of the things I'm considering include:

* Making CompStart cross-platform, potentially using **PowerShell Core**
* Reworking the CLI into a more polished command-line experience, potentially using something like **Typer**
* Supporting Windows virtual desktops so a startup item can optionally be opened on a specific desktop
* Adding **profiles or workspace configurations**, so you could have different contexts for different kinds of work

The idea behind that last one is especially interesting to me.

Your "work" environment might be very different from your "personal" environment, or from the workspace you use when you're troubleshooting a client issue. Instead of maintaining one giant startup list, CompStart could eventually let you define the context you want and load that context when you need it.

There's still a lot to explore, and that's part of what makes the project fun to work on.

---

*Built from a PowerShell script born in IT support.*
