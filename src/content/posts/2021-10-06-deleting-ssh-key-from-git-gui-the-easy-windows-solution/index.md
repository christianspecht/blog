---
title: "Deleting an SSH key from Git Gui: the easy Windows solution"
slug: "deleting-ssh-key-from-git-gui-the-easy-windows-solution"
date: 2021-10-06T08:00:00
tags:
- source-control
- ssh
externalfeeds: 1
---


About four years ago, I wrote a blog post about [deleting a SSH key from Git GUI]({{< ref "/posts/2017-08-18-deleting-ssh-key-from-git-gui/index.md" >}}).


At the time of writing this, I was a new Git user and just played around with SSH for the first time.  
As a long-time Windows user, SSH was "this scary Unix authentication thing" to me...so I didn't question the fact that I apparently needed to type Unix commands into Git Bash to get rid of my SSH key.

Turns out that the solution in my old post is the solution for people on Unix/Linux who use the command line.  
If you're on Windows like me, there's a much easier way.

Here's the screenshot from Git Gui with the filename again:

![Git Gui screen](/img/git-ssh-2.png)

Four years ago, I didn't know where to find the `~/.ssh` directory.  
Now I know that on Unix/Linux, `~` means the user's home directory, which is `%userprofile%` or `c:\Users\USERNAME` on Windows. `.ssh` is just a subdirectory there.

**So on a Windows machine, the `~/.ssh` directory is just `c:\Users\USERNAME\.ssh`.**

**`id_rsa` and `id_rsa.pub` are just files in this directory and can simply be deleted via Windows Explorer.**


