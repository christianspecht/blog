---
layout: post
title: "Executing wunderlist-backup with Portable Jekyll's Ruby version" 
date: 2016/09/15 22:20:00
tags:
- backup
- jekyll
- ruby
codeproject: 1
---

Just a few months ago,  I posted [the last part of my "backup" series]({% post_url 2016-03-21-my-home-backup-strategy-part-3-non-technical-family-members %}). At the bottom I mentioned that I'm evaluating [Wunderlist](https://www.wunderlist.com) and that I need to take backups of it, should I really use it.

In the meantime I actually **did** start using it, so here's how I'm backing it up.

---

## Enter wunderlist-backup

I already mentioned in the linked post that I found a nice backup script: [wunderlist-backup](https://github.com/bernd/wunderlist-backup).

It's written in Ruby. I'm on Windows, and I already happen to have a Ruby version on my machine because I'm using [Jekyll](https://jekyllrb.com/) *(which is written in Ruby)* to build websites including this one.

On my last computer, I installed my Ruby version using [Ruby Installer](http://rubyinstaller.org/), but when I bought my current computer, I decided to switch to [Portable Jekyll](https://github.com/madhur/PortableJekyll).  
The idea was that with a portable (and copyable) solution, it's easier to keep the two computers in sync so I can work on the same project on both, with the exact same Ruby and Jekyll versions.

Now with wunderlist-backup, I had a new problem: how to get it to work with the Ruby version that comes with Portable Jekyll?

---

## Patching Portable Jekyll

At the time when I was evaluating this, Portable Jekyll's "default" mode consisted of [a batch file named `setpath.cmd`](https://github.com/madhur/PortableJekyll/blob/8b34f0d95b4fe7bcfb915e00bef183154f6ebfa3/setpath.cmd), which opened a command prompt via `cmd /k`.

It's no problem to execute Ruby scripts from that prompt by typing `ruby foo.rb`, but my problem was that the `/k` switch [causes the command window to stay open](http://ss64.com/nt/cmd.html).

However, I needed it to execute a script and then terminate, so I could call it from another batch file.   
So [I submitted a pull request](https://github.com/madhur/PortableJekyll/pull/25) for it. As of now, it has not been merged to the main Portable Jekyll repository yet, though.

With my change, it's now possible to call `setpath.cmd` from, say, a batch file and pass a command to it:

    "c:\PathToPortableJekyll\setpath.cmd" "jekyll serve"
    
For example, I can now create a batch file with that content in the main folder of a Jekyll site and run `jekyll serve` *(using Portable Jekyll's Ruby version)* by double-clicking the batch file.

Or a batch file which executes a Ruby script:

    "c:\PathToPortableJekyll\" "ruby hello.rb"

With this prerequisite, calling wunderlist-backup in an automated backup script becomes possible.

---

## Automating wunderlist-backup

The actual [usage instructions](https://github.com/bernd/wunderlist-backup#usage) on GitHub are quite simple - create an application in Wunderlist, set two environment variables and call `ruby wunderlist-backup.rb > wunderlist-backup.json`.

My batch file is a bit longer, because I wanted to put each backup file in a new time-stamped subfolder.

Here it is:

    @echo off
    echo Executing Wunderlist Backup...

    rem actual backup folder with current date/time
    set backupfolder=c:\backup\wunderlist\%date:~6,4%-%date:~3,2%-%date:~0,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%
    
    md "%backupfolder%"

    set backupfile=%backupfolder%\%folder%\christian.json

    set WUNDERLIST_ACCESS_TOKEN=xxxxxxxxxxxxxxxx
    set WUNDERLIST_CLIENT_ID=yyyyyyyyy

    set command=ruby wunderlist-backup.rb
    call "c:\PathToPortableJekyll\setpath.cmd" "%command%" > "%backupfile%"


I think the `%date:~6,4%-%date:~3,2%...` part needs some explanation:

`%date%` and `%time%` return the current date/time.  
We can then use [substrings](http://ss64.com/nt/syntax-substring.html) to [extract parts of it](http://superuser.com/a/512489/2985).

This depends on your machine's date and time format though, which depends on the language settings.

The date and time format of my machine is `dd.mm.yyyy` and `hh:mm:ss`.  
`%date:~6,4%` skips the first 6 characters and returns the next four, so for today (Sep 15, 2016) it would return `2016`.

This way, we can build a folder name like `2016-09-15-21-56-09` as follows:

    set folder=%date:~6,4%-%date:~3,2%-%date:~0,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%
    
---

## Usage

As already mentioned at the bottom of [the last post of my "backup" series]({% post_url 2016-03-21-my-home-backup-strategy-part-3-non-technical-family-members %}#wrap-up-for-the-whole-series-or-how-do-i-run-all-this), I'm running a backup script (a batch file) in regular intervals anyway.

The batch file shown in this post is just executed as a part of running the "main" backup batch file:

	cd %~dp0\wunderlist-backup\
	call wunderlist-backup.bat
