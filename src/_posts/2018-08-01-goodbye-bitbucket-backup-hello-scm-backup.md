---
layout: post
title: "Goodbye Bitbucket Backup, hello SCM Backup"
date: 2018/08/01 19:55:00
tags:
- backup
- bitbucket-backup
- source-control
externalfeeds: 0
---

Almost 7 years after the first public release, I'm retiring my most successful open source project so far:  
[Bitbucket Backup](https://christianspecht.de/bitbucket-backup/) will be superseded by [SCM Backup](https://scm-backup.org/).

There will be no further development on Bitbucket Backup, and users are encouraged to switch to SCM Backup instead (*which can do everything that Bitbucket Backup could, and much more)*.

There's even a special page in the SCM Backup docs, [to help longtime Bitbucket Backup users getting started with SCM Backup](http://docs.scm-backup.org/en/latest/bitbucket-backup-users/).

I know that [big rewrites are generally considered evil](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/), and I thought a lot about it before finally making that decision. And yes, I'm confident that a rewrite made sense in this case.

There were multiple reasons that made me consider it:

---

## Bitbucket only

I wrote the first version of Bitbucket Backup in 2011, when I was using Mercurial/Bitbucket only (at the time, Bitbucket supported Mercurial only).

Later, Bitbucket added Git support, so I added Git support to Bitbucket Backup as well, but didn't really use Git myself (although [others did](https://bitbucket.org/christianspecht/bitbucket-backup/issues/22/backup-completed-but-no-actual-files#comment-10989403)).

Nowadays, most people are using Git and GitHub, and I started using both, too.  
So a) I needed something to backup my GitHub repos anyway and b) probably a lot of other GitHub users need this too, so supporting GitHub would make sense.

But then, the tool is called **Bitbucket** Backup. So either I'd have to rename it, or else it wouldn't be clear that it now supports GitHub as well.

Plus, everything in the code is closely tied to Bitbucket, and wasn't designed for the possibility to support multiple hosters later.

---

## Unattended execution is difficult

I created Bitbucket Backup to support **my** personal backup workflow, [which I explained here before]({% post_url 2016-01-17-my-home-backup-strategy-part-2-online-services %}#source-code) - I'm running backups by starting a batch file while sitting in front of my machine. So I didn't consider the possibility that other people might run Bitbucket Backup unattended.

Some people [had problems with that](https://bitbucket.org/christianspecht/bitbucket-backup/issues/20/not-running-when-scheduled), some with [setting their password](https://bitbucket.org/christianspecht/bitbucket-backup/issues/18/configuration-is-not-loaded-when-run-as) *(Bitbucket Backup asks for it at runtime and [saves in encrypted in the AppData folder](https://bitbucket.org/christianspecht/bitbucket-backup/src/default/src/BitbucketBackup/Config.cs))*, and others needed a way to tell whether their backup was successful or not, so [someone made a pull request and added sending info mails](https://bitbucket.org/christianspecht/bitbucket-backup/pull-requests/7/adding-option-to-send-log-via-email/).

I *could* just have added some more logging...but I'd probably have to rewrite the whole configuration thing anyway, because if I really supported multiple hosters *(see above)*, entering the credentials for all of them on startup wouldn't be practical anymore.

---

## Windows only

At the time when I wrote Bitbucket Backup, "cross platformness" wasn't as important as it is today.  
Plus, getting started writing cross-platform .NET code wasn't [as easy as it is today](https://dotnet.github.io/), and I'm not sure whether I even knew about the existence of Mono back then, so I didn't consider cross-platform at all.

In the meantime, some people have tried to run Bitbucket Backup on Mono, and [ran into some problems](https://bitbucket.org/christianspecht/bitbucket-backup/issues/38/fails-on-linux-when-using-mono-due-to). To fix this, I would either need to try to fix things until Bitbucket Backup runs on Mono, or port it to .NET Core.

---

## No tests

Last but not least, Bitbucket Backup doesn't have any unit or integration tests. Back then, I was just starting to learn about automated testing, and I didn't feel comfortable enough with it yet to write tests for Bitbucket Backup.

Especially because an application like Bitbucket Backup *(which calls APIs and 3rd party command line tools which download stuff from the Internet)* isn't the easiest thing to test when you have no idea what you're doing.

And adding tests later, in an application that wasn't designed for testability in the first place, isn't a great idea either.

---

## Conclusion

All of this made me think that starting from a blank slate would probably be best.

The alternative would have been to gradually add support for **everything** mentioned above...which is basically the same like a big rewrite.

So I wrote SCM Backup from scratch, trying to fulfill all the points mentioned above:

- Support for multiple hosters (at the moment: GitHub/Bitbucket), and it's [designed for adding more hosters](http://docs.scm-backup.org/en/latest/contribute-app-hoster/)
- it has a [YAML config file](http://docs.scm-backup.org/en/latest/config/) and [logging](http://docs.scm-backup.org/en/latest/output-logging/) / [email output](http://docs.scm-backup.org/en/latest/output-email/) to make unattended execution easier
- .NET Core, so it's cross-platform *(although I didn't try to run it on a non-Windows machine yet, [I still need to test that](https://github.com/christianspecht/scm-backup/issues/6))*
- it has lots of [unit](https://github.com/christianspecht/scm-backup/tree/master/src/ScmBackup.Tests) and [integration](https://github.com/christianspecht/scm-backup/tree/master/src/ScmBackup.Tests.Integration) tests
