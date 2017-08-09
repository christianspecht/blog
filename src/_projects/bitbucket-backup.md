---
order: 2
name: Bitbucket Backup
site: /bitbucket-backup/
logo: /php/cache/img/bitbucket-backup-logo128x128.png
desc: A backup tool which clones all your Bitbucket repositories to your local machine
sidebar: 1
featured: 1
---

#### What I needed:

Automate creating local backups of all my private and public [Bitbucket](https://bitbucket.org) repositories, running without user interaction after being set up once.

#### What I learned:

- Calling [Bitbucket's API](https://api.bitbucket.org/) with [RestSharp](http://restsharp.org/) and [Json.NET](http://www.newtonsoft.com/json)
- Cloning/pulling [Mercurial](https://www.mercurial-scm.org/) and [Git](http://git-scm.com/) repositories with C#
- Dependency Injection with [Ninject](http://ninject.org/)
- Setting assembly version from build script with [MSBuild Community Tasks](https://github.com/loresoft/msbuildtasks)