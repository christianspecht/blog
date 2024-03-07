---
title: Excluding integration tests in NUnit's GUI, part 2 - Specifying a fixture
slug: excluding-integration-tests-in-nunit-s-gui-part-2-specifying-a-fixture/
date: 2013-04-16T23:14:48
tags: [.net, nunit, unit-testing]
series: "Excluding integration tests in NUnit's GUI"
---

In [the first part of this post]({{< ref "/posts/2013-04-09-excluding-integration-tests-in-nunit-s-gui-part-1-using-categories/index.md" >}}), I used NUnit's `[Category]` attribute to separate my integration tests from my unit tests, but I wasn't 100% satisfied with the result.

So I looked for a better solution, and after reading the [GUI's command line options](http://www.nunit.org/index.php?p=guiCommandLine&r=2.6.2) again, I found out that you can tell the GUI to load only certain test classes or namespaces from the test assembly:

> **Specifying an Assembly and a Fixture**  
> [...]   
The name specified after the **/fixture** option may be that of a TestFixture class, or a namespace. If a namespace is given, then all fixtures under that namespace are loaded.


So I removed the `[Category]` attribute from the test class, and added the `.Integration` sub-namespace instead: 

	namespace Tasko.Tests.Integration
	{
	    [TestFixture]
	    public class RavenEmbeddedTests
	    {
        	// tests here
    	}
	}

Likewise, I moved the "normal" *(non-integration)* test class to the namespace `Tasko.Tests.Unit`.

Now I have two batch files to start the NUnit GUI.

The first one is the same like before:

	path\to\nunit-x86.exe path\to\Tests.dll

...and it runs all the tests:

![Running all tests](/img/nunit-categories-fixture-all.png "Running all tests")

The second one tells NUnit to only run the tests from the `.Unit` namespace:

	path\to\nunit-x86.exe path\to\Tests.dll /fixture:Tasko.Tests.Unit

This one doesn't even load the other namespaces, so the integration tests aren't visible at all. And of course they don't run, no matter if I press F5 or click the "Run" button:

![Running unit tests only](/img/nunit-categories-fixture-unit-only.png "Running unit tests only")

This may or may not work for you, because there are things you can do with categories that you can't do when you use my solution *(like [assigning more than one category to a single test](http://stackoverflow.com/q/1199611/6884))*.

For me, the simplicity of the `/fixture` approach outweighs these limitations, so I'll stick with it.

