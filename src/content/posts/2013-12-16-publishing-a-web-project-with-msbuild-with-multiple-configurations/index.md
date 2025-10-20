---
title: Publishing a web project with MSBuild (with multiple configurations)
date: 2013-12-16T23:14:00
tags: [.net, msbuild, visual-studio]
externalfeeds: 1
---

Publishing a web project in Visual Studio is easy and well documented, but it gets complicated when you want to get the same result with MSBuild.

In my case, I'm trying to get MSBuild to do everything that Visual Studio's Publish wizard does *(web.config transforms etc.)*, but without really deploying anything.  
*(just generate the published package on my local machine/the build server, and then deploy by copying it to the server - `robocopy /mir` to the rescue!)*.

Plus, I'd like to build/publish multiple configurations *(for a start, `Debug` and `Release`)* in one single step.

---

## Publishing with MSBuild

Step one is to mimic the output of Visual Studio's Publish wizard with MSBuild.

This wasn't easy to find on the web, but this blog post by [Andrei Volkov](http://www.zvolkov.com/) explains how to do it:  
[How to "Package/Publish" Web Site project using VS2010 and MsBuild](http://www.zvolkov.com/clog/2010/05/18/how-to-packagepublish-web-site-project-using-vs2010-and-msbuild/)

Here's the MSBuild syntax that I got from Andrei's blog post:

	<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">

		<Target Name="Build">

			<MSBuild Projects="BuildTest.sln"
				Properties="Configuration=Release;
				DeployOnBuild=true;
				DeployTarget=Package;
				_PackageTempDir=$(MSBuildThisFileDirectory)\Build;
				PackageAsSingleFile=False;
				AutoParameterizationWebConfigConnectionStrings=False" />            
			
		</Target>
		
	</Project>

**Note that I made one small change here, I'm setting `_PackageTempDir` instead of `PackageLocation`!**

When I first used `PackageLocation`, MSBuild published the project to this path:

	C:\Dev\Code\BuildTest\Build\Archive\Content\C_C\Dev\Code\BuildTest\BuildTest\obj\Release\Package\PackageTmp

The value I passed was `$(MSBuildThisFileDirectory)\Build`, so I expected the output folder to be `C:\Dev\Code\BuildTest\Build\` *(`C:\Dev\Code\BuildTest\` is the directory where the MSBuild project file is)*.

Someone in the comments in Andrei's blog post had the same problem, and fortunately there's [another comment](http://www.zvolkov.com/clog/2010/05/18/how-to-packagepublish-web-site-project-using-vs2010-and-msbuild/#comment-1618) by [Pavel Chuchuva](http://chuchuva.com/pavel/), where he mentions `_PackageTempDir`.

So the first part is solved - the above MSBuild file causes MSBuild to properly publish to the expected output folder.

---

## Publishing multiple configurations

Now that the actual publishing process works, I'd like to publish multiple configurations at once.  
In this example, I will just use `Debug` and `Release`, but it would be possible to add more.

The naive approach would be to duplicate the `<MSBuild>` call shown above...but as we all know, [duplicating code is never a good idea](http://en.wikipedia.org/wiki/Duplicate_code#Problems_associated_with_duplicate_code).

A better solution is to use [MSBuild Batching](http://msdn.microsoft.com/en-us/library/ms171473.aspx), which is essentially the MSBuild equivalent of a `for...each` loop.

Using the example code from the "Batching one item at a time" section on [this page](http://msdn.microsoft.com/en-us/library/ms171474.aspx), the most basic loop goes like this:

You can define a list of build configurations by creating an `<ItemGroup>` with subitems right before the target that does the build.  
The target then loops through the list of items, and in each loop you can get the current item with `%(NameOfTheSubItems.Identity)`.

Basic example:

	<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">

		<ItemGroup>
			<BuildConfig Include="Debug" />
			<BuildConfig Include="Release" />
		</ItemGroup>
		
		<Target Name="Build">
			<Message Text="%(BuildConfig.Identity)" />
		</Target>
		
	</Project>

This will output:

	Debug
	Release

After adding this to the MSBuild project file from the examples above, the final version looks like this:

	<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">

		<ItemGroup>
			<BuildConfig Include="Debug" />
			<BuildConfig Include="Release" />
		</ItemGroup>
		
		<Target Name="Build">

			<MSBuild Projects="BuildTest.sln"
				Properties="Configuration=%(BuildConfig.Identity);
				DeployOnBuild=true;
				DeployTarget=Package;
				_PackageTempDir=$(MSBuildThisFileDirectory)\Build\%(BuildConfig.Identity);
				PackageAsSingleFile=False;
				AutoParameterizationWebConfigConnectionStrings=False" />            
			
		</Target>
		
	</Project>

This will:

- publish the project once for each configuration listed in the `<ItemGroup>`
- publish to a subfolder of the `Build` folder, where the subfolder is named exactly like the configuration
- transform `web.config` correctly for each configuration
