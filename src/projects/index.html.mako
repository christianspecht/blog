﻿<%inherit file="_templates/site.mako" />
<%def name="title()">Projects</%def>

<h1>${self.title()}</h1>

<div class="row spacer25"></div>
<p><%self:filter chain="markdown">
Like many other developers, I have been creating small tools and tryout projects in my spare time for years, but I didn't ever publish one until 2011. Most of them were either not in a state to be published, or not of any practical use. Or both.

After seeing more and more people linking their personal GitHub/Bitbucket/CodePlex projects in their blogs and Stack Overflow profiles, I thought: I can do this, too! After all, having actual projects viewable online [can't hurt](https://twitter.com/jeresig/status/33968704983138304).

The projects listed here were created either because of an actual problem that I had *(like [taking backups of my personal stuff](${bf.util.site_path_helper('roboshell-backup')}))* or just because I found something cool that I wanted to play around with *(like [controlling an USB Missile Launcher](${bf.util.site_path_helper('missilesharp')}))*.  

I also try to use some new libraries/tools/technologies in each project that I'm not familiar with, for [learning purposes](http://norvig.com/21-days.html). And I've seen too many projects that look interesting, but [lack even the simplest "how to get started" example](http://www.codinghorror.com/blog/2007/01/if-it-isnt-documented-it-doesnt-exist.html)...so I always create full documentation, installers etc. for my projects whenever possible.

Here is everything I created so far, in reverse chronologial order (newest first):
</%self:filter></p>
<div class="row spacer25"></div>

<div class="container">

<% projects = { 'empty': empty, 'rsb': roboshellbackup, 'bbb': bitbucketbackup, 'rsn': recordsetnet, 'site12': site2012, 'mss': missilesharp, 'vbah': vbahelpers, 'site13': site2013, 'tasko': tasko } %>

## IMPORTANT: the total number of items in the next line MUST be even - if it's odd, put one item named 'empty' at the end!
% for project in ['tasko', 'site13', 'vbah', 'mss', 'site12', 'rsn', 'bbb', 'rsb']:

    %if loop.even:
    
        <div class="row">
        
            <div class="span4">
                ${projects[project]()}
            </div><!--/span-->
            
            <div class="row visible-phone spacer25"></div>
            
    %else:
    
            <div class="span4">
                ${projects[project]()}
            </div><!--/span-->
            
        </div><!--/row-->
        
        <div class="row spacer25"></div>
        
    %endif
    
%endfor
    
</div><!--/container-->

<div class="row visible-phone spacer25"></div>


## EMPTY TEMPLATE (filler when the number of projects is odd)
    <%def name="empty()">
        &nbsp;
    </%def>


## ROBOSHELL BACKUP
    <%def name="roboshellbackup()">
        <h2><a href="${bf.util.site_path_helper('roboshell-backup')}"><img src="https://bitbucket.org/christianspecht/roboshell-backup/raw/tip/img/head35x35.png" class="img-polaroid" /> RoboShell Backup</a></h2>
        <%self:filter chain="markdown">
**What I needed:**  
Convert existing batch files for [Robocopy](http://en.wikipedia.org/wiki/Robocopy) backups (*computer&rarr;NAS* and *NAS&rarr;USB disk*) to a more comfortable tool, with all settings in a config file.

**What I learned:**

- [Windows PowerShell](http://en.wikipedia.org/wiki/Windows_PowerShell) basics
- Building a setup with [WiX](http://wixtoolset.org/)
- Using [TrueCrypt](http://www.truecrypt.org/) and [integrating it into RoboShell Backup](${bf.util.site_path_helper('2012/04/30/roboshell-backup-1-1-now-with-truecrypt-integration')})
        </%self:filter>
    </%def>


## BITBUCKET BACKUP
    <%def name="bitbucketbackup()">
            <h2><a href="${bf.util.site_path_helper('bitbucket-backup')}"><img src="https://bitbucket.org/christianspecht/bitbucket-backup/raw/tip/img/logo35x35.png" class="img-polaroid" /> Bitbucket Backup</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
Automate creating local backups of all my private and public [Bitbucket](https://bitbucket.org) repositories, running without user interaction after being set up once.
  
**What I learned:**

- Calling [Bitbucket's API](https://api.bitbucket.org/) with [RestSharp](http://restsharp.org/) and [Json.NET](http://json.codeplex.com/)
- Cloning/pulling [Mercurial](http://mercurial.selenic.com/) and [Git](http://git-scm.com/) repositories with C#
- Dependency Injection with [Ninject](http://ninject.org/)
- Setting assembly version from build script with [MSBuild Community Tasks](https://github.com/loresoft/msbuildtasks)
            </%self:filter>
    </%def>


## RECORDSET.NET
    <%def name="recordsetnet()">
            <h2><a href="${bf.util.site_path_helper('recordset-net')}"><img src="https://bitbucket.org/christianspecht/recordset.net/raw/tip/img/logo35x35.png" class="img-polaroid" /> Recordset.Net</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
Convert .NET POCOs into `ADODB.Recordsets`, in order to gradually migrate existing MS Access applications to .NET *(Access client needs to read data coming from .NET)*.

**What I learned:**

- Reflection basics
- Writing unit tests with [xUnit.net](http://xunit.codeplex.com/)
- Creating a [NuGet package](https://nuget.org/packages/Recordset.Net) (and [testing it on the preview site](${bf.util.site_path_helper('2012/05/28/how-to-test-nuget-packages-without-polluting-the-nuget-package-listings')}))
            </%self:filter>
    </%def>

 
## SITE 2012
    <%def name="site2012()">
            <h2><a href="${bf.util.site_path_helper()}"><img src="${bf.util.site_path_helper('img/site2012.png')}" class="img-polaroid" /> This site (2012)</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
A web site to feature my projects and *(maybe)* a blog. I registered the domain years ago, but never had a site until then.

**What I learned:**

- Setting up [WordPress](http://wordpress.org/) on rented webspace
- Displaying [Markdown files from my Bitbucket projects in WordPress](${bf.util.site_path_helper('2012/03/09/how-to-display-markdown-files-from-other-sites-in-wordpress')})
            </%self:filter>
    </%def>

 
## MISSILESHARP
    <%def name="missilesharp()">
            <h2><a href="${bf.util.site_path_helper('missilesharp')}"><img src="https://bitbucket.org/christianspecht/missilesharp/raw/tip/img/logo35x35.png" class="img-polaroid" /> MissileSharp</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
Send commands to an [USB Missile Launcher](http://www.dreamcheeky.com/thunder-missile-launcher) from my own code, without using the control software that came with it.

**What I learned:**

- Communicating with an USB device with [Hid Library](https://github.com/mikeobrien/HidLibrary)
- Building a WPF app *(the [MissileSharp Launcher](${bf.util.site_path_helper('missilesharp#launcher')}))* with MVVM and [MahApps.Metro](http://mahapps.com/MahApps.Metro/)
- More Dependency Injection, this time with [Autofac](http://autofac.org)
- More unit testing, this time with [NUnit](http://nunit.org/) and [Moq](http://code.google.com/p/moq/)
- Building a [ClickOnce](http://msdn.microsoft.com/en-us/library/t71a733d.aspx) installer
            </%self:filter>
    </%def>

 
## VBA HELPERS
    <%def name="vbahelpers()">
            <h2><a href="${bf.util.site_path_helper('vba-helpers')}"><img src="https://bitbucket.org/christianspecht/vba-helpers/raw/tip/img/logo35x35.png" class="img-polaroid" /> VBA Helpers</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
A reusable library of VBA helper functions, to avoid having slight variations of the same functions duplicated across several projects.

**What I learned:**

- Unit testing in VBA with [AccUnit](http://accunit.access-codelib.net/) and [SimplyVBUnit](http://sourceforge.net/projects/simplyvbunit/)
            </%self:filter>
    </%def>

 
## SITE 2013
    <%def name="site2013()">
            <h2><a href="${bf.util.site_path_helper()}"><img src="${bf.util.site_path_helper('img/site2013.png')}" class="img-polaroid" /> This site (2013)</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
Migrate existing WordPress site/blog to a static site generator *(I decided to use [Blogofile](http://blogofile.com/), but I [evaluated](http://octopress.org/) [others](http://getpelican.com/) as well)*.

**What I learned:**

- [Setting up a new site](${bf.util.site_path_helper('2013/01/29/switched-from-wordpress-to-blogofile')}) with [Blogofile](http://blogofile.com/) *(source code [here](https://bitbucket.org/christianspecht/blog))*
- Creating a responsive HTML template with [Twitter Bootstrap](http://twitter.github.com/bootstrap/)
- Writing custom [Mako](http://www.makotemplates.org/) templates in [Python](http://www.python.org/)
- Displaying [Markdown files from my Bitbucket projects (again)](${bf.util.site_path_helper('2013/02/17/how-to-display-markdown-files-from-other-sites-this-time-in-blogofile/')})
- Automating FTP uploads with [WinSCP](http://winscp.net/)
            </%self:filter>
    </%def>


## TASKO
    <%def name="tasko()">
            <h2><a href="${bf.util.site_path_helper('tasko')}"><img src="https://bitbucket.org/christianspecht/tasko/raw/tip/img/logo35x35.png" class="img-polaroid" /> Tasko</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
A ToDo app for my Android phone. I could have used an existing one, but decided to write one myself for learning purposes (mobile app with web service backend)

**What I learned:**

- Creating a web service with [ASP.NET Web API](http://www.asp.net/web-api) *(and [Basic Authentication](/2013/08/02/basic-authentication-in-asp-net-web-api/))* and hosting it on [AppHarbor](https://appharbor.com/)
- Using a [NoSQL database](http://en.wikipedia.org/wiki/NoSQL), in this case [RavenDB](http://ravendb.net/)
- Writing a native [Android](http://www.android.com/) app
            </%self:filter>
    </%def>


