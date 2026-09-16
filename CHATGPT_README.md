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

## How is it different from Windows startup?

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

CompStart has two main pieces.

### Startup Execution Engine

`CompStart.ps1` (invoked through `CompStart.bat`) reads your startup configuration when you log in and launches the applications, websites, browser layouts, and other tools you've configured.

### Startup Data Manager

`CompStart.exe` provides an interactive CLI for managing that configuration.

Instead of having to edit the JSON configuration by hand, you can use the manager to add, update, view, and remove startup entries.

The idea is to keep the configuration declarative while making it practical to manage.

## Installation

### For users

CompStart includes an installer that handles the setup for you.

If you're upgrading an existing installation, the installer is designed to preserve your existing startup data.

Go to the [Releases](https://github.com/dEhiN/CompStart/releases) page to download the latest version and follow the included setup instructions.

### For developers

You can also clone or fork the repository if you'd like to experiment with the project or contribute to it.

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

CompStart started as a script written to make one person's daily work a little less repetitive.

It's gradually becoming a more general-purpose tool for rebuilding a Windows workspace automatically.

There's still plenty of room to improve it, whether that's making the CLI better, improving workspace and virtual desktop handling, or expanding what CompStart can automate.

If you work with Windows and like automation, I'd be interested to see what you think.

---

*Built from a PowerShell script born in IT support.*
