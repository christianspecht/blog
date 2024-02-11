---
title: "Fixing Resource.Designer.cs generation in .NET Core"
slug: fixing-resourcedesignercs-generation-in-net-core
date: 2017-11-29T18:03:00
tags:
- .net
- visual-studio
externalfeeds: 1
---

When you're starting a project using a technology which is still in alpha/beta status, sometimes things break.  
I experienced this with .NET Core. I created a new project with it [in the beginning of 2016](https://github.com/christianspecht/scm-backup/commit/3a91f6409f0cef7a3bd2c80cad389fa844b41e3c), using .NET Core `1.0.0-rc1-update1`, which had the original json-based project files (`global.json` and `project.json`).

I needed to show localized messages, so I as soon as .NET Core supported it, I [created a resource file](https://github.com/christianspecht/scm-backup/commit/ca9678d6befbd604b2247157033573a77150d451#diff-8cbb953e05086c518d25f1bdb5e129cb) in my project.  
As we know today, there were still lots of moving targets and breaking changes in the first .NET Core releases, and [some people felt that RC1/RC2 were more like alpha/beta](https://github.com/aspnet/Home/issues/1426), even though they were promised as production-ready.

So when I later [converted my project to Visual Studio 2017 and .NET Core 1.0 RTM](https://github.com/christianspecht/scm-backup/commit/c0fb6bf241c51d6f5ad84e2c5169c13106ed8c47) *(at least I think it was 1.0 RTM)*, the json-based project files auto-changed into `.csproj` files, and the automatic generation of the designer file stopped working.  
From then, whenever I changed something in `Resource.resx` and saved it,  `Resource.Designer.cs` was not updated with the changes.

Only recently, after upgrading to .NET Core 2.0, I investigated this issue by creating a new project, adding a resource file and looking at diffs.

I found out that adding a resource file also adds the following to the project's `.csproj` file:

	<ItemGroup>
	  <Compile Update="Resource.Designer.cs">
	    <DesignTime>True</DesignTime>
	    <AutoGen>True</AutoGen>
	    <DependentUpon>Resource.resx</DependentUpon>
	  </Compile>
	</ItemGroup>
	
	<ItemGroup>
	  <EmbeddedResource Update="Resource.resx">
	    <Generator>ResXFileCodeGenerator</Generator>
	    <LastGenOutput>Resource.Designer.cs</LastGenOutput>
	  </EmbeddedResource>
	</ItemGroup>

**This was missing in my actual project...so as soon as I [changed it, `Resource.Designer.cs` was re-generated again](https://github.com/christianspecht/scm-backup/commit/30f0d0c496d4c07c768faf0058dbdf3b198322fd).**

---

I was still wondering why it stopped working in the first place, so I (again) looked at the past commits where I updated the project to newer .NET Core versions.

Apparently, the resource files were never mentioned in the old json-based project files. So I suspect that the first .NET Core versions auto-detected the presence of a `Resource.resx` file and auto-generated the `Resource.Designer.cs` when building the project.

When I updated my project to .NET Core 1.0, the upgrade wizard automatically replaced the `.json` files by `.csproj` files, but it didn't detect the presence of the resource files. IMO, this should have happened and the code above should have been added to the `.csproj` automatically.
