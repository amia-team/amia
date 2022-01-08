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

## Workflow
### General Workflow
The general workflow for the module is: 
- **Pull** the latest version of the module first.
- Pack the module using Nasher. There is a .bat file called `pack_mod_windows` that you can click in the directory as a shortcut. Keep in mind that this can take some time, so let it finish.
- Copy the packed module file to your `modules` directory in `Documents\Neverwinter Nights\`.
- Open the module in the toolset.
- Make the desired changes.
- Save.
- Copy the module from your modules folder back to the repository.
- Unpack the module using Nasher. Like packing the module, there is a .bat file called `unpack_mod_windows` in the repo that can be used as a shortcut.
- **Pull** the latest version again, to make sure there were no conflicts.
- **Commit** your changes with an adeuqately descriptive message.
- **Push** your changes.

Keep in mind that unless there were recent changes you need reflected in your working version of the module (that is, the one you have opened in the toolset), there is no need to re-pack the mod every time there is a change.
### Script Editing
- Editing and adding scripts is a simpler process. You can just add `.nss` files to the `src/nss` directory. Do not upload .ncs files.
## Other resources
