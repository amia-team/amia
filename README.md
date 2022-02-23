# Introduction
This is a guide on how to pull, pack, develop, and unpack the mod so that your changes can be pushed to version control. Familiarity with how git and docker work are not required to be able to complete this guide. If there are any questions, do not hesitate to ask them on the forums or on the discord.

## Contribution Guidelines
There are some things that should be kept in mind for potential contributors:
- Do not add binary files. These include .utc, .uti, .ncs, .gff, .are, etc. 
- Use descriptive, concise messages to describe commits.
- Do not abuse your access to the module and its resources to add cheats (i.e: hide gold, epics, etc in areas you're working on).
- Do not distribute, copy, or leak the contents of the repository to any outside parties. Only staff (developers, testers, dms, admins) should be privy to the contents of the module.
- Do not deliberately sabotage the work of others.
- Commit sizes must be reasonable, with some exceptions, or they will be reverted. This can be avoided by committing work in small batches.

## Requirements
- [Docker Desktop](https://www.docker.com/products/docker-desktop). For instructions on how to install this, [refer to this documentation](https://docs.docker.com/desktop/windows/install/). You will need to enable Windows Subsystem for Linux (WSL) and Virtualization. Enabling virtualization may require you to go into your BIOS and enable it from there.
- Git. You will either need to install [Git Bash](https://git-scm.com/downloads), a program like [MobaXterm](https://mobaxterm.mobatek.net/), or a GUI based program like [Github Desktop](https://desktop.github.com/). Recommendations are that absolute beginners start with Github Desktop. MobaXterm doubles as both a graphical FTP/SSH/SFTP client and a shell.
- WSL must be enabled on your computer. You can see the instructions [here](https://www.windowscentral.com/install-windows-subsystem-linux-windows-10). Only complete the first part of this. You don't need to download a Linux distro. Stop after checking the boxes as instructed on this page.
- Virtualization must be enabled on your computer. You can see the instructions [here](https://www.minitool.com/news/enable-virtualization-windows-10.html). This requires enabling Virtualization in your BIOS, but don't be afraid of doing that. Just follow the steps and ask for help from your fellow devs if you're unsure.

## Workflow
### General Workflow
The general workflow for the module is: 
- Open GitHub Desktop and **Pull** the latest version of the module first.
- Pack the module. There is a .bat file called `pack_mod_windows` that you can click in the directory as a shortcut. Keep in mind that this can take some time, so let it finish - even if it seems to be taking forever.
- Copy the packed module file (Amia.mod) to your `modules` directory in `Documents\Neverwinter Nights\`.
- Open the module in the toolset.
- Make the desired changes or import the changes you made in your Dev module if you use one.
- Save the module.
- Copy the module from your modules folder back to the repository (the folder where you copied Amia.mod).
- Unpack the module. Like packing the module, there is a .bat file called `unpack_mod_windows` in the repo that can be used as a shortcut.
- Open GitHub Desktop and **Pull** the latest version again, to make sure there were no conflicts.
- In GitHub Desktop, **Commit** your changes with an adequately descriptive message. Be concise, but explain all changes or additions.
- In GitHub Desktop, **Push** your changes.

Keep in mind that unless there were recent changes you need reflected in your working version of the module (that is, the one you have opened in the toolset), there is no need to re-pack the mod every time there is a change. So don't be worried too much about missing some area modifications someone else did unless you now also need those areas for your work. Always check missing commits before you start working, so you don't end up overwriting something someone else has done.
### Script Editing
- Editing and adding scripts is a simpler process. You can just add `.nss` files to the `src/nss` directory. Do not upload .ncs files or any other file type directly through this window. All other file types (areas, monsters, items, etc.) must be uploaded using the process above.
## Other resources
- You can read up on Nasher's documentation [here](https://github.com/squattingmonk/nasher).
- You can find NWNX's Documentation [here](https://nwnxee.github.io/unified/).
