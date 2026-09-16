# CompStart

> **Declarative Workspace Bootstrapper for Windows & Power Users**

CompStart is a lightweight workspace bootstrapper designed for IT support technicians, MSP specialists, software developers, and power users who need to restore complete working context—not just launch background programs—at system startup.

## Why CompStart?

Native Windows startup options and browser tab groups only go halfway. While native startup launches raw executables and pinned tabs hog memory across every browser window, CompStart deterministically rebuilds your exact multi-monitor working environment upon login.

* **Context over Binaries:** Launch specific Chrome window layouts pre-populated with designated SaaS tabs, targeted PWAs, and working documents rather than bare applications.
* **Declarative Configuration:** Define your desired end-state in a structured config file without writing custom scripts or risking manual JSON syntax errors.
* **Zero Session Bloat:** Enjoy the system performance of a clean shutdown every night while returning to your exact digital workspace every morning.

## Architecture

* **Startup Execution Engine:** A PowerShell script (`CompStart.ps1`, invoked via a Batch wrapper `CompStart.bat`) that reads your JSON configuration data and spawns applications, web tools, and browser layouts on login.
* **Startup Data Manager:** An interactive CLI management utility (`CompStart.exe`) that lets you safely add, modify, and remove startup entries without editing raw configuration files.

## Target Audience

CompStart is built by and for people who manage complex digital workflows—including helpdesk techs, systems administrators, developers, and power users[cite: 1, 3, 4]. By automating daily setup tasks for support professionals, CompStart supports those who keep everything else running smoothly.

---

## Contributing

CompStart is open-source and actively seeking contributors! Whether you want to refine the CLI, improve virtual desktop routing, or build new UI features, check out our active issues or read `documentation/TECHNICAL-DETAILS.md` to get started.