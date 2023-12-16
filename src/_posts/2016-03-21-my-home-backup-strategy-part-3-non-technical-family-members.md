---
layout: post
title: "My home backup strategy, part 3: Non-technical family members" 
date: 2016/03/21 19:48:00
tags:
- backup
- command-line
externalfeeds: 1
series: "My home backup strategy"
---

I'm the only person in my extended family who works in IT, so I'm obviously "good with computers"...which means I'm implicitly responsible for other people's computers as well.  
There's a good chance that if you're reading this, you know this very well. Or, as Scott Hanselman [nailed it](http://www.hanselman.com/blog/OnLosingDataAndAFamilyBackupStrategy.aspx):

> As with, I'm sure, all of you Dear Readers, I am the Chief IT Dude for "Team Hanselman." That pretty much means if you have a last name of Hanselman and you're on the West Coast, I'm your IT guy. (Not really, but close.)

Of course, non-technical family members don't literally think about backups. But if anything goes wrong, they **do** expect me to "make it work again", so technically I **am** responsible for taking backups.

So I'll take my parents as an example: They live in a different town, and they have a single desktop computer and a smartphone at home.

It's just a 20 minute drive away, but neither do I want to drive there just to plug in a backup USB drive, nor do I want to have to spend time doing "backup stuff" each time when I'm visiting them anyway.

This leaves only one option: automating everything via the Internet.

Because of the work already done in the [previous]({% post_url 2015-11-01-my-home-backup-strategy-part-1-the-basics %}) [posts]({% post_url 2016-01-17-my-home-backup-strategy-part-2-online-services %}), there's just one big task left to do:

---

## Files from their computer

I wanted to get the files from their computer either to my computer or directly to my NAS, in order to backup them together with my own files.  
At the beginning, I tried using Google Drive to sync from their machine to mine, but it didn't work out for me:

0. I wanted to use Google Drive for my own stuff as well.  
At the time when I was experimenting with this, there was no support for  cleanly separating their files from my files.  
So I had to use a different product for my own files, and I started experimenting with Dropbox and SkyDrive, among others.  
But this still left me with **two** file synchronization clients installed on my machine, which I didn't like.

0. I had synchronization errors with Google Drive.  
I never noticed this while using Google Drive for my own files, but I was only using it for a few folders with a few small files. My parents have multiple gigabytes of photos in lots of subfolders.

So in the end, I settled for a different solution. I figured that having two-way synchronization was not necessary - one way from their computer to my computer is sufficient.  
Because of this, and because I'm paying for webspace anyway *(most of which is empty)*, I'm using FTP now.

There's a lot of FTP software out there which is able to run largely unattended and synchronize between your local machine and a remote server (one-way, though).

I already knew how to automate [WinSCP](http://winscp.net/) because I'm using it [to upload this blog to my server](http://stackoverflow.com/a/21223950/6884), so I used it to backup files from my parents machine.

You just need two files, plus the [portable version of WinSCP](http://winscp.net/eng/download.php#download2) in a subfolder:

#### `backup.bat`:

	del %~dp0\backup.log
	timeout 1
	"%~dp0\winscp\winscp.com" /script=backup.txt /log=backup.log

This just starts WinSCP from a subfolder *(`%~dp0` is the current folder)* and tells it to execute the commands inside `backup.txt` and to log the results to `backup.log`, both in the current folder.

#### `backup.txt`:

This contains the actual WinSCP commands:

	option batch abort
	option confirm off
	open backupparents
	
	# one line per folder that needs to be backed up
	synchronize remote -delete "C:\Users\MyParents\Documents" "/documents"
	synchronize remote -delete "C:\Users\MyParents\Desktop" "/desktop"
	synchronize remote -delete "C:\FtpBackup" "/ftpbackup"
	
	close
	exit

The line `open backupparents` opens a FTP connection named `backupparents`, which must be setup in WinSCP once.  
This is already enough to synchronize those folders from my parents' machine to my webspace.

I created a scheduled task for this, so it runs each time on startup.

*Note that the last directory I'm backing up (`C:\FtpBackup`) is the directory with the batch and command file shown above, so that I have a backup of those (and the log file!) as well.*

A few notes about setting up the FTP account in the webspace:

- Of course, the folder where the backups go to should not be accessible from the Internet.  
I solved this by pointing all my domains to subfolders, so I can create new folders at the root level which are "invisible to the web".

- I created a root level folder `ftpbackup` with a subfolder `my_parents`.
  - The FTP account I created for my parents has `my_parents` as its root folder, so their backups will go there and the account doesn't have access to the whole webspace.
  - This way, I can backup other machines to additional subfolders with their own FTP accounts (like `my_wifes_parents`, for example)
 
- To pull all backups to my machine, I just need one account which has  `ftpbackup` as its root folder.

The batch file and WinSCP command file to pull the backups to my machine are very similar to those on my parents' machine:

#### `backupdownload.bat`:

	del %~dp0\backupdownload.log
	timeout 1
	"%~dp0\winscp\winscp.com" /script=%~dp0\backupdownload.txt /log=%~dp0\backupdownload.log

#### `backupdownload.txt`:
	
	option batch abort
	option confirm off
	open backupdownload
	synchronize local -delete "C:\FtpBackup" "/" -filemask="|desktop.ini"
	close
	exit

After running this, all their files are in `C:\FtpBackup` on my machine, and of course I'm backing up that folder via RoboShell Backup to my NAS.

---
 
## Images from their phone

As [described before, I'm using **Upload 2 NAS**]({% post_url 2015-11-01-my-home-backup-strategy-part-1-the-basics %}#b-smartphones-and-tablets) to save pictures from my phone to my NAS.  
This is done via FTP...so it's not just limited to a NAS in my local network, but works with *any* FTP server anywhere in the world.

So I installed Upload 2 NAS on my parents' phone, and configured it to connect to my webspace, like described in the previous paragraph:  
Similar to `ftpbackup/my_parents` *(where the data from their computer goes)*, there's now `ftpbackup/my_parents_phone` as well, with its own FTP account.

Of course the upload speed is slower than from my own phone to my NAS, but that doesn't matter. My parents know to start this only when they are connected to their Wi-Fi, and they are aware that it will take some time.

---

## Their emails

My parents are using Thunderbird via IMAP, so all their emails are still in their mail account on the server, which means I don't actually need to backup their local Thunderbird mail database.

As [described in the last post]({% post_url 2016-01-17-my-home-backup-strategy-part-2-online-services %}#email), I'm regularly running Thunderbird on my machine anyway, to make offline backups of my own emails.  
So I just set up my parents' email account in my Thunderbird as well, which means that their mails are backed up together with mine.

The only thing which is **only** on their machine is their Thunderbird address book.  
Thunderbird address books are [`*.mab` files stored in their profile folder](http://kb.mozillazine.org/Moving_address_books_between_profiles), but I don't want to backup their whole profile folder via WinSCP as shown above.  
So I just added a line to the WinSCP batch file, which copies all `*.mab` files from their profile folder to a subfolder of the `Documents` folder, right before starting WinSCP.

---

## Wrap up for the whole series (or: how do I run all this?)

Manually, most of it.

There are two shortcuts at a prominent place on my desktop, one for Thunderbird and one to a batch file (more on this below).
I don't have that many other icons on the desktop, so I regularly notice the existence of those two and remember to run them :-)

So when I'm working on my computer anyway, I start Thunderbird, minimize it and continue working.  
After some time, I'll check if it has finished, and then I start the batch file.

The batch file is inside a `backuptools` folder on my machine, which contains subfolders with [all the](http://christianspecht.de/bitbucket-backup/) [tools I](https://github.com/christianspecht/google-calendar-backup) [mentioned in](http://winscp.net/) [this series](http://christianspecht.de/roboshell-backup/) before.  
It looks like this:

    cd %~dp0\bitbucket-backup\
    call BitbucketBackup.exe

    cd %~dp0\google-calendar-backup\
    call Backup-Calendar.bat

    cd %~dp0\ftpbackupdownload\
    call backupdownload.bat

    cd %~dp0\roboshell-backup\
    call pctonas.bat

So it first executes everything which downloads stuff from the internet to my machine, and at the end, it runs RoboShell Backup, which copies everything to the NAS.

That's pretty much it.  
The approach described here (internet ⇒ local machine ⇒ NAS ⇒ USB drive) has served me well for multiple years now.  
No matter which tool/service, it's possible to integrate almost everything into this workflow.

For example, I'm evaluating [Wunderlist](https://www.wunderlist.com) at the moment, and I already found a tool [which backups all my Wunderlist to-dos into a JSON file](https://github.com/bernd/wunderlist-backup). If I continue using Wunderlist, I will probably add wunderlist-backup to my toolbox.

