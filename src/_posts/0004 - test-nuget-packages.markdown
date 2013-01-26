---
title: How to test NuGet packages without polluting the NuGet package listings
date: 2012/05/28 18:10:42
categories: .NET, NuGet, Visual Studio
---

I just published [my first NuGet package](https://nuget.org/packages/Recordset.Net) a few days ago.
 
The [documentation about creating and publishing packages](http://docs.nuget.org/docs/creating-packages/creating-and-publishing-a-package) is good, but I didn’t feel comfortable with releasing my package into the wild without testing it myself a few times (read: install the published package in a project on my machine to see if everything is the way I wanted).

The documentation didn’t say anything about this, except that [they don’t support deleting because someone might depend on the package you are trying to delete](http://docs.nuget.org/docs/creating-packages/creating-and-publishing-a-package#Deleting_packages).  
Basically this is a good idea, but…I’m just testing my first package, I **know** that no one except me knows about the existence of my package, let alone depends on it!

After some googling, I found a [discussion on the NuGet discussion board](http://nuget.codeplex.com/discussions/284211) where someone mentioned [https://preview.nuget.org](https://preview.nuget.org).

So apparently there is a preview site. I didn’t find anything in the docs about it, so I tried to figure out myself how to use this site to test my package.

First I tried to upload a package from the web site, but that returned a 404 error.  
So I had to use the command line tool to upload my package.  
The [command line reference](http://docs.nuget.org/docs/reference/command-line-reference) says that all the commands have a `-Source` (or `-s`) option to specify the server URL.

So all you have to do to publish a package to the preview server is this:

	nuget setapikey xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -s https://preview.nuget.org
 
	nuget push MyPackage.nupkg -s https://preview.nuget.org

Now to the second part: installing the package in the [Package Manager Console in Visual Studio](http://docs.nuget.org/docs/start-here/using-the-package-manager-console).

To install from the preview site, all you have to do is adding the preview site as a new package source.

You can do this in the Package Manager Settings:

![NuGet settings](/img/nuget-settings1.png "NuGet settings")  
*(I deduced the correct URL, which is [https://preview.nuget.org/api/v2/](https://preview.nuget.org/api/v2/) as of now, from the URL of the official package source)*

Now you can select your new package source in the Package Manager Console:

![Package Manager Console](/img/nuget-console.png "Package Manager Console")

That’s it! When you now run `Install-Package`, the packages will be loaded from the preview site.  
I uploaded quite a few test packages to the preview site this way, until I was sure that the package did exactly what I wanted.  
Only then I committed my changes and pushed the package to the real site.

This is very useful if you don’t want your version history on the real site to look like this:

![NuGet version history](/img/nuget-history.png "NuGet version history")

Of course you could push your test packages to the real site instead and [unlist](http://docs.nuget.org/docs/creating-packages/creating-and-publishing-a-package#Deleting_packages) them afterwards, but I didn’t like the idea of “polluting” the real site.

Even if the packages are unlisted, someone could still (hypothetically, I know!) get one of my test packages by specifying the exact version number and work with an unfinished version of my library.

Just pushing the package to the preview site and forgetting about it afterwards looks more convenient to me.
