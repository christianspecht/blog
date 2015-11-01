---
layout: post
title: "My home backup strategy, part 1: the basics" 
date: 2015/11/01 17:50:00
tags:
- backup
- batch-files
- roboshell-backup
codeproject: 1
---

Years ago, before NAS drives and cloud services were common, I had one single desktop computer and all my data was on its C: drive.

Even though I was already working in IT for years then *(including being responsible for database backups, and earlier, tape drive backups)* I never thought about backing up my computer at home. 

Until the day when it refused to boot. I don't remember the exact cause anymore, just that in the end, it was no big deal to get it to work again. But at that moment *(before I found out that it could be fixed)* I realized that I had only **one** single copy of all my data, and that it was on the hard drive of the computer that apparently just died.

The next day, I bought an external USB drive and set up a batch file with [Robocopy](https://en.wikipedia.org/wiki/Robocopy) to copy from my computer to the USB drive.

Fast forward a few years, and now I've got more than one computer at home, **and** a NAS drive, **and** I have data hosted in the cloud (email, for example) which I'd hate to lose as well.

In the next posts, I will describe my home backup strategy as it is now.  
It took me a few years until I was at the point where I'm now, and so far I have been lucky - I didn't lose or accidentally delete anything important for which I didn't have a backup.

Hopefully this helps a few people setting up backups of your important stuff **before** something bad happens.


---

## The basics

When I started taking regular backups on USB drives, I had just one desktop computer and one notebook. So I just connected the USB drive to each, and started a batch file with RoboCopy which mirrored a few important folders onto the USB drive.

This works in the beginning, but becomes more cumbersome, the more the number of devices grows.  
Plus, you can't just plug in an USB drive into any device - my smartphone, for example.  
*(Even if it was possible, I'd still need to find the equivalent of "batch file plus RoboCopy" for Android)*.

To get an idea - here are all the devices that we have at home and that need to be backed up:

- two notebooks (Windows 7 and 8, right now)
- two smartphones (Android)
- a tablet (Android)
- a NAS drive

So in my case, I decided to make use of the fact that we've got a NAS, and that virtually all our devices are able to connect to it:  
I can regularly backup data from all devices to the NAS, so in the end I just have to backup the whole NAS to the USB drive.

---

## 1. Backing up all devices to the NAS drive

It depends on the kind of device how easy (and how automated) backing it up works.

### a) Windows computers

For me, this was the main concern. Of course I have a smartphone as well, but I'm doing most of my important stuff on Windows computers, so that's where most of my important files are. 

First of all, a clarification:  
I just back up some *data files* on the machines.  
I do **not** make images of the whole drive, which means that in case a harddisk dies, I can **not** just buy a new disk and restore the complete drive including Windows and all installed programs. 

But that's a deliberate decision I made: harddisks don't die that often, so it's unlikely that I actually will have to re-install Windows and all applications.  
On the other hand, just robocopy'ing relatively few folders is *way* faster than making an image of the whole disk.

So what am I actually backing up?  
Even though I'm trying to save as much data as possible directly on the NAS, there's still a lot of stuff on the machines' local hard drives, most of which I can't avoid:

- Files on the desktop and in My Documents  
  (some applications save their settings in My Documents)  

- Some applications save important data in subfolders of my user folder.  
  On the machine where I'm writing this right now, there's for example:
  - `C:\Users\Christian\AndroidstudioProjects`
  - `C:\Users\Christian\AppData\Roaming\Thunderbird`
  - `C:\Users\Christian\Saved Games`
    
    I don't want to backup my whole user folder, though. It's nearly 20 GB and I only need backups of a very small part of that.

- Some applications use "special" folders outside my user folder, for example [XAMPP](https://www.apachefriends.org/), which installs in `C:\xampp\` by default and has a subfolder `htdocs` for the actual web content, which I want backed up as well.

In the beginning, I had batch files with a lot of `robocopy %source% %destination% *.* /mir /xxx /yyy /zzz` calls. But when the number of folders per machine increased, I started to look for a tool where I just could paste the new folder into a config file, without having to copy the whole RoboCopy call and getting all the parameters right.

I didn't find anything like that, so I wrote my own: [RoboShell Backup](http://christianspecht.de/roboshell-backup).  
It's a [PowerShell](http://en.wikipedia.org/wiki/Windows_PowerShell) script which basically loads [a list of folders from a config file](https://bitbucket.org/christianspecht/roboshell-backup/src/2d5dedf191593b1b84f33c045c45070ae6a36048/src/Config.xml?at=default&fileviewer=file-view-default#Config.xml-28) and copies each of them to a backup folder on a certain drive letter, which can be specified in the config file a well.

For example, here's the important part of the config file from the machine where I'm writing this:

	<nasdrive value="Z:\"/>
	<nasfolder value="Backup\Toshiba_Notebook\"/>

	<sourcefolder from="C:\Users\Christian\Documents" to="docs"/>
	<sourcefolder from="C:\Users\Christian\Desktop" to="desktop"/>
	<sourcefolder from="C:\Users\Christian\AndroidstudioProjects" to="dev_android" />
	<sourcefolder from="C:\xampp\htdocs" to="dev_xampp"/>
	<!-- ...and many more rows like these... -->


I thought about regularly starting the copying process via Windows Task Scheduler (for example when logging on), but in the end, I decided against it.

Our machines are notebooks, so they could be:

- outside our home network *(so no access to the NAS)*
- connected via Wi-Fi *(bad idea if you try to copy a few gigabytes of Thunderbird mail files)*

Plus, the NAS doesn't run 24/7 anyway, we only switch it on when we need it.

So I just have a red icon on my desktop which says "START BACKUP", and so far I managed to regularly remember to double-click it when I'm home and the NAS is switched on.


### b) Smartphones and tablets

At least for us, the phones are not as important as the Windows computers, because the only kind of files that need to be backed up from our phones are pictures.  
*(and the pictures are not **that** important either, because if we're planning to take pictures that we'd like to keep, we use a "real" camera most of the time, not our phone cameras)*

At first, I occasionally used an "explorer-type" app ([ES File Explorer](https://play.google.com/store/apps/details?id=com.estrongs.android.pop)) to copy the pictures manually from the phone to the NAS.  
Then my last phone died and took a few pictures with it, before I had a chance to back them up.

After that, I looked for a better alternative and found **Upload 2 NAS** ([free version](https://play.google.com/store/apps/details?id=com.rcreations.upload2nasUpgrade) / [paid version](https://play.google.com/store/apps/details?id=com.rcreations.upload2nas)).  
This app syncs the phone's camera pictures *(and optionally additional directories which you can add in the settings menu)* to an FTP destination.  
Starting the synchronization manually (by pressing a button) is supported by both the free and the paid version.

I purchased the paid version because it's supposed to be able to sync in the background automatically, but I couldn't get this to work. Still, the manual synchronization works great, so I just let it be - I have the app icon on my homescreen and just need to start it and tap one button, so it's unlikely that I forget to sync for a longer time.

In my case, I enabled the FTP service on my NAS and created a user and a corresponding FTP share for each device: my phone, my wife's phone and our tablet.  

Possible alternatives:  
I didn't test it yet, but I guess the app is able to connect to *any* FTP server.  
So when you don't have a NAS but some webspace/webserver instead, you could probably just create a new FTP account with a folder that's not visible from the web, and backup your pictures to that.


### c) Everything else

At the moment, "everything else" are just our (non-phone) cameras.  
Obviously, pictures made with those need to be backed up as well, but we just regularly put the SD cards into one of the computers and manually copy the pictures to the NAS.

Of course [it's possible to automate this as well](http://www.hanselman.com/blog/VideoReviewEyeFiWiFiSDCardForDigitalCamerasAndYourLifesWorkflow.aspx), but we didn't feel the need for it yet. Manual copying is good enough for now.

---

## 2. Backing up the NAS drive to USB drives

As mentioned above, this is also something that [RoboShell Backup](http://christianspecht.de/roboshell-backup) can do.  
I won't go into detail here how to set it up, you can read the documentation on the RoboShell Backup site if you're interested in using it.

Here's the short version of what it does. You need to:

0. Connect the USB drive to any of the machines which has RoboShell Backup installed
0. Run [`NasToUsb.bat`](https://bitbucket.org/christianspecht/roboshell-backup/src/2d5dedf191593b1b84f33c045c45070ae6a36048/src/NasToUsb.bat?at=default&fileviewer=file-view-default) on that machine

RoboShell Backup will know the drive letters of the NAS and the USB drives from its [config file](https://bitbucket.org/christianspecht/roboshell-backup/src/2d5dedf191593b1b84f33c045c45070ae6a36048/src/Config.xml?at=default&fileviewer=file-view-default), and start mirroring the whole NAS to that drive via RoboCopy.

It's also possible to [encrypt the drive via TrueCrypt]({% post_url 2012-04-30-roboshell-backup-1-1-now-with-truecrypt-integration %}), which is optional.  
If you're using this (like I do), RoboShell Backup will mount the TrueCrypt volume on the USB drive to a new drive letter *(the default is `X:`)* before starting the mirroring process, and when RoboCopy is finished, the drive will automatically be unmounted again.

---

## How many USB drives do you need?
 
Imagine your house burns down, or someone breaks into your house: when your NAS is gone, you don't want all backups to be gone as well.  
**So you want to have at least two USB drives, and you want at least one of them *always* to be far away from your NAS, i.e. outside your house.**  

In my case, I have two identical drives labeled `1` and `2`.  
One of them is at home, and the other one is in my desk at work. Every now and then, I'll take the drive from home to work, swap them and bring the other one home.


---

## Wrap up

This is the basic setup that I'm using.

Of course I'm actually backing up more than just the data from the devices we have at home, but I'll come to that in the next post, which will be about making offline backups of cloud services.
