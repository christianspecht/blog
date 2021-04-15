---
layout: post
title: "My home backup strategy, part 2: Online services" 
date: 2016/01/17 13:24:00
tags:
- backup
- bitbucket-backup
- roboshell-backup
- source-control
externalfeeds: 1
---

In the [first part of this post]({% post_url 2015-11-01-my-home-backup-strategy-part-1-the-basics %}), I described my basic home backup strategy, i.e. how I'm making backups of the important data on all computers, smartphones and other devices at home.

But of course not all of my important data is actually on physical devices at home - I'm using some cloud services, and those need to be backed up as well.

Yes, the companies providing those services are supposed to do backups themselves, but any cloud provider could lose data (without backups), be hacked or go out of service for good.

Even if none of this happens, some companies don't make their internal backups available to their customers.
So you better don't rely on your email provider to restore that mail you accidentally deleted two weeks ago.

If you want to be **really** sure you don't lose anything, it's your own responsibility to backup your data from the cloud as well.

Here are the online services which I'm using (and actually backing up):

---

## Email

At the moment I'm using Gmail for all my mails, but the following applies to all email providers with IMAP support.

Before using Gmail, I always had [Mozilla Thunderbird](https://www.mozilla.org/en-US/thunderbird/) installed, pulled the mails via POP3 to my local machine and worked there, so I automatically had all my mails on my local machine. 

I stopped using Thunderbird when I switched to Gmail, from then I used the Gmail web interface only.  
But then I read the great post ["Is your identity in your own hands?"](http://hadihariri.com/2012/04/07/is-your-identity-in-your-own-hands/) by Hadi Hariri, where he writes about the possible pain points in case your free mail provider suddenly goes out of service or suspends your account *(he uses Gmail as an example, but this applies to all free mail providers)*. The two key points are:

- **Never rely on webmail only, make an offline backup in regular intervals**  
  Even if your email provider has "just a few hours" of outage, you're out of luck if you need that important mail just during that time. And if you're locked out of your account for good, you may not have had a chance to take a backup before.

- **You should have a mail address under a domain you control**  
  Your mail address is likely the key to most of your other online accounts. No access to your mail address may lock you out of a lot of other stuff in the long run. Passwort reset mails won't reach you anymore, and even if you know your password *(or use a password manager)* - some sites only let you change your mail address after you clicked on a link in a mail they sent to your old address. If you can't access that anymore...bad luck!


So I started to use Thunderbird again, exactly as described in Hadi's post:  
I still primarily use the Gmail web interface, but every now and then, I just manually open Thunderbird in the background and let it sync my whole Gmail accout via IMAP to my local machine.
  
The local Thunderbird folder is then [copied to the NAS drive via RoboShell Backup]({% post_url 2015-11-01-my-home-backup-strategy-part-1-the-basics %}), like everything else important on my machine.

---

## Gmail (including contacts and calendar)

The general approach described in the last paragraph backs up **only** mails, nothing else.

As I said above, I'm using Gmail, including contacts and calendar (both synced to my phone), and I want both of these backed up as well.

I described above how I'm making backups of my mails with Thunderbird via IMAP.   
However, there are other tools made especially for Gmail, for example:

- [GMVault](http://gmvault.org/)
	- free/OSS
	- syncs e-mails only
	- no synchronization of contacts/calendar
- [BackupGoo](http://www.backupgoo.com/)
	- 19€ / 24.90$ per year for private users
	- syncs e-mails, calendar and contacts *(and even more)*

Obviously, BackupGoo is the "all in one" solution. But I decided not to purchase it, because I'm thinking about completely switching away from Gmail again.  
Until then, I'm backing up my contacts and my calendar from Google as follows:


### Calendar

Backing up Google Calendar is relatively simple, because each Google Calendar has a [private address, which is the direct download link to the calendar in iCalendar format](https://support.google.com/calendar/answer/37648#view_only).

Thus, I wrote a Powershell script to automate the download. The code is [here on GitHub](https://github.com/christianspecht/google-calendar-backup).  
It's named "Google Calendar Backup", but actually it just downloads files from a bunch of URLs from a config file, so it can be used to download *anything* which has a public URL.


### Contacts

Unfortunately, there's no private address for Google Contacts, so it's not that easy. In fact, I didn't find any automated solution at all.  
There's the [Google Contacts API](https://developers.google.com/google-apps/contacts/v3/), but apparently authentication is only possible via OAuth, which IMO is a PITA for a command-line app which is supposed to run unattended.

So for now, I'm manually exporting the contacts via [Google Takeout](https://takeout.google.com/settings/takeout) in more-or-less-regular intervals.  
I know that everything done manual is a bad solution because you tend to forget to do it regularly, but for now I don't have a better solution for Google Contacts.

---

## Source code

As a programmer, I'm hosting my source code in the cloud as well, in my case most of it is [on Bitbucket](https://bitbucket.org/christianspecht) right now.

Bitbucket hosts distributed version control systems only ([Mercurial](https://www.mercurial-scm.org/) and [Git](https://git-scm.com/)), and backing up DVCS repositories is relatively easy: you just clone them to your local machine.

In other words, you automatically have a backup as soon as you're cloning a repository and start working on it locally.  
But if you have a lot of repositories, it gets tedious to regularly clone/pull them all.

I didn't want to do this manually all the time, so I wrote a tool that connects to the [Bitbucket API](https://confluence.atlassian.com/bitbucket/use-the-bitbucket-cloud-rest-apis-222724129.html), gets a list of all my repositories and clones/pulls all of them: [Bitbucket Backup](/bitbucket-backup/).  
It's a command line tool which needs to be setup once, then it will run unattended and pull all repositories to a central folder on my local machine *(which I'm then backing up to my NAS, of course)*.

This is enough for me right now.  
But there are a lot of other source code hosters that a lot of people are using (especially [GitHub](https://github.com/)), and at the moment, Bitbucket Backup supports Bitbucket only. But I'm thinking about changing that.

---

## Wrap up

In this post (and the [first one]({% post_url 2015-11-01-my-home-backup-strategy-part-1-the-basics %})) I explained everything I'm doing to make backups of my *own* data.  
But this series is not finished yet - there will be a third part about backing up the data of family members.