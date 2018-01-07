---
layout: post
title: "VeraCrypt integration for RoboShell Backup"
date: 2018/01/07 16:25:00
tags:
- backup
- roboshell-backup
codeproject: 0
---

Before TrueCrypt development ceased in 2014, I [added support for TrueCrypt encryption]({% post_url 2012-04-30-roboshell-backup-1-1-now-with-truecrypt-integration %}) to [RoboShell Backup](/roboshell-backup/).  
In the meantime, multiple TrueCrypt forks have been developed based on the last "good" version.

Until now, I was still using that last TrueCrypt version for my personal backup USB drives.  
I recently purchased a set of new (larger) ones, so I decided to encrypt them with [VeraCrypt](https://www.veracrypt.fr), one of the new forks.

The good news is that VeraCrypt's command line usage hasn't changed compared to TrueCrypt, so we can just swap TrueCrypt for VeraCrypt, without making any code changes in RoboShell Backup.

Here's a new version of the instructions, updated for VeraCrypt usage:

---

## Setting up your USB drives

First, you need to set up VeraCrypt on each of your USB drives, by following these steps:

1. Go to the [download page](https://www.veracrypt.fr/en/Downloads.html), download the installer and run it.
 
2. After accepting the license terms, choose that you want to *extract* VeraCrypt, not install it:

	![VeraCrypt setup](/img/veracrypt01.png "VeraCrypt setup")

3. Extract it to your USB drive, into a folder called `VeraCrypt`.

4. Go through the [Beginner's tutorial](https://www.veracrypt.fr/en/Beginner%27s%20Tutorial.html) to create a new VeraCrypt volume, using the `VeraCrypt.exe` that you just copied to the USB drive.  
You can follow the tutorial exactly as written, including creating an "encrypted file container" in this screen:  

	![Create an encrypted file container](/img/veracrypt02.png "Create an encrypted file container")

	Create a "Standard VeraCrypt volume" *(not a "Hidden VeraCrypt volume")*.  
	When you are asked for the volume's location, put it into the root directory of your USB drive *(in my case, it's drive `Q:`)* and call it `Backup`:

	![Volume Location](/img/veracrypt03.png "Volume Location")

	You can change the location and name of the volume as you like.  
	If you do this, don't forget to alter the config file, because `Backup` in the root directory is the default value there:

		volume="Backup"

	Note that creating the volume on a moderately large disk (1.8 TB in my case) seems to take forever, so take your time :-)

	![Only 1 day left!](/img/veracrypt04.png "Only 1 day left!")


---

## Changing the config file

This is the relevant part of Roboshell Backup's config file:

	<!--
	TrueCrypt/VeraCrypt settings, to enable RoboShell Backup to write to an TrueCrypt-/VeraCrypt-encrypted USB drive (both are free and open source)
	You have to set up each USB drive once in order for this to work.
	Read this for more instructions:
    - TrueCrypt: http://christianspecht.de/2012/04/30/roboshell-backup-1-1-now-with-truecrypt-integration/
    - VeraCrypt: http://christianspecht.de/2018/01/07/veracrypt-integration-for-roboshell-backup/
	If you don't want to encrypt your USB drive, just don't touch these settings.
	
	Values:
	"enabled": set to 1 to enable encryption mode
	"exepath": folder and path of TrueCrypt.exe/VeraCrypt.exe on USB drive (without drive letter - this will be taken from the "usbdrive" value above)
	"volume": folder and path of TrueCrypt/VeraCrypt volume on USB drive (again, without drive letter)
	"mountto": drive letter to mount the volume to (with backslash, must be unused)
	-->
	<truecrypt enabled="0" exepath="truecrypt\truecrypt.exe" volume="Backup" mountto="X:\"/>

If you followed the instructions above to set up your USB drives for VeraCrypt, you need to change the last line to this: 

	<truecrypt enabled="1" exepath="veracrypt\veracrypt.exe" volume="Backup" mountto="X:\"/>

Note: As the drive letter for the USB disk is defined in the config file as well (in the `usbdrive` property), you should [assign this drive letter to all your USB drives](https://www.howtogeek.com/96298/assign-a-static-drive-letter-to-a-usb-drive-in-windows-7/) to make sure that they always get this drive letter when you plug them in.
