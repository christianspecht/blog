---
order: 13
title: "SCM Backup"
site: https://scm-backup.org/
logo: https://scm-backup.org/img/logo128x128.png
desc: "Makes offline backups of your cloud hosted source code repositories"
sidebar: 1
featured: 1
---

**What I needed:**

An improved version of [Bitbucket Backup]({{< ref "/bitbucket-backup.html" >}}), a previous tool of mine.  
Bitbucket Backup supports Bitbucket only, and I needed something to backup my GitHub repos. [There were some more reasons]({{< ref "/posts/2018-08-01-goodbye-bitbucket-backup-hello-scm-backup/index.md" >}}), all of them together made me decide to start a new project from scratch.

**What I learned:**

- Writing a command-line app with [.NET Core](https://dotnet.github.io/), updating multiple times from beta to 3.1, encountering the [usual]({{< ref "/posts/2017-11-29-fixing-resourcedesignercs-generation-in-net-core/index.md" >}}) [quirks](https://stackoverflow.com/q/34580599/6884) of a brand-new language/toolset 
- More unit/[integration testing](https://softwareengineering.stackexchange.com/q/343013/3826), again with [xUnit.net](https://xunit.github.io/) and without a mocking library *(.NET Core was so new that there was no other testing library available, and no mocking library at all)*
- More [Dependency Injection](https://stackoverflow.com/q/37911971/6884) *(this time with [Simple Injector](https://simpleinjector.org), the only DI container for .NET Core available at the time)* and some [software](https://stackoverflow.com/q/34635740/6884) [architecture](https://stackoverflow.com/q/42149291/6884)
- Using [Git](https://git-scm.com/)/[GitHub](https://github.com/) regularly and solving [all kinds]({{< ref "/posts/2017-08-18-deleting-ssh-key-from-git-gui/index.md" >}}) of [weird issues](https://stackoverflow.com/a/46123180/6884) which probably most first-time Git users run into
- Building [a website](https://scm-backup.org/) with [GitHub Pages](https://pages.github.com/), [documentation](http://docs.scm-backup.org/) with [Read the Docs](http://readthedocs.org/projects/scm-backup-docs/) and [setting up custom (sub-)domains for both]({{< ref "/posts/2017-02-26-dns-settings-for-github-pages-read-the-docs-with-only-one-a-record/index.md" >}})
- Setting up [CI on AppVeyor](https://github.com/christianspecht/scm-backup/blob/master/appveyor.yml), including automatic deployment to [GitHub Releases](https://github.com/christianspecht/scm-backup/releases) when pushing tags
