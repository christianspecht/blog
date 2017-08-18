---
layout: post
title: "Deleting an SSH key from Git Gui"
date: 2017/08/18 15:23:00
tags:
- command-line
- source-control
codeproject: 1
---

For my [current hobby project](http://scm-backup.org), I'm using Git and GitHub regularly for the first time.

I don't like using source control via the command line *(for Mercurial, I'm using [TortoiseHG](https://tortoisehg.bitbucket.io/))*, so I'm still experimenting with several GUI clients in order to find the one I like best.

At the moment I'm evaluating the "official" GUI tools which come with the [Git for Windows](https://git-for-windows.github.io/) download ([git-gui](https://git-scm.com/docs/) and [gitk](https://git-scm.com/docs/gitk)), **and** I started [connecting to GitHub with SSH](https://help.github.com/articles/connecting-to-github-with-ssh/) instead of user/password via https.

So I created my first SSH key in Git GUI via **Help** ⇒ **Show SSH key** and then **Generate Key**:

![before generating the key](/img/git-ssh-1.png)

...and then tried to delete it again, because I created it [with passphrase](https://help.github.com/articles/working-with-ssh-key-passphrases/), but I wanted to try a new one *without* passphrase instead.

But Git GUI didn't let me delete it. Generating a key disables the **Generate Key** button, and there's no **Delete Key** button:

![trying to delete the key](/img/git-ssh-2.png)

It's obvious from the screenshot that the key is in a file named `id_rsa.pub`, which is in a folder `.ssh` somewhere on my machine, and that I apparently just needed to delete this file. 

This is probably easy to solve for regular Git Bash / Linux users, but as a Windows user with no Git/Bash/Linux experience, it took me some time to find out how to do it.


Here's the solution:

### 1. List all keys

[Show the content of the `.ssh` folder](https://help.github.com/articles/checking-for-existing-ssh-keys/) in Git Bash:

    ls -al ~/.ssh

![all keys](/img/git-ssh-3.png)

Apparently a SSH key consists of two files, in this case `id_rsa` and `id_rsa.pub`.  
*(the two `github_rsa` files are probably left from a previous [GitHub Desktop](https://desktop.github.com/) installation some time ago)*

### 2. Delete the `id_rsa` files

The Bash command for deleting files [is `rm -f`](https://stackoverflow.com/a/31301093/6884), so I needed to do this:

    rm -f ~/.ssh/id_rsa*

After this, the files are gone:

![4](/img/git-ssh-4.png)

...and I can create a new SSH key by clicking **Generate Key** in the previously shown Git GUI window. 