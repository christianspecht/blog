---
title: Excluding integration tests in NUnit's GUI, part 1 - Using categories
slug: excluding-integration-tests-in-nunit-s-gui-part-1-using-categories/
date: 2013-04-09T21:39:00
tags: [.net, nunit, unit-testing]
series: "Excluding integration tests in NUnit's GUI"
---

After writing unit tests for my personal projects for a while, now is the first time that I'm writing integration tests.  
So far, none of the projects I [wrote]({{< ref "/recordset-net.html" >}}) [tests]({{< ref "/missilesharp.html" >}}) [for]({{< ref "/vba-helpers.html" >}}) did involve any external components *(or at least none that [couldn't be mocked](https://github.com/christianspecht/missilesharp/blob/master/src/MissileSharp.Tests/MockHidDevice.cs))*.

But my [current project]({{< ref "/tasko.html" >}}) needed a database, and I decided to use [RavenDB](http://ravendb.net/) to get familiar with NoSQL.  
According [to](http://stackoverflow.com/a/7538082/6884) [Ayende](http://stackoverflow.com/a/8375226/6884), the recommended way to test RavenDB apps is directly using the database in in-memory mode. So here I am now, writing integration tests.

After running the first test for the first time, I was reminded that integration tests are **slow** - the in-memory database takes a few seconds to initialize on each run.  
I don't want to wait each time I run my tests, so I went to Google and the [NUnit docs](http://www.nunit.org/index.php?p=documentation) to find out how to make NUnit ignore the integration tests when I don't want to run them *(the NUnit version I'm using here is 2.6.2, by the way)*.

The first thing I found is the `[Category]` attribute, which does almost what I wanted.  

To use it, I just need to mark the test class in question with the attribute:

	namespace Tasko.Tests
	{
	    [TestFixture]
	    [Category("Integration")]
	    public class RavenEmbeddedTests
	    {
        	// tests here
    	}
	}

Now I can tell the GUI to only run tests with a certain attribute, or to run all tests **except** those with a certain attribute.  

The [documentation](http://www.nunit.org/index.php?p=category&r=2.6.2) says how to do this:

> This feature is accessible by use of the /include and /exclude arguments to the console runner and through a separate "Categories" tab in the gui. The gui provides a visual indication of which categories are selected at any time.

This sounds like the only way to do this in the GUI is to navigate to the "Categories" tab, add the category to the list below and tell NUnit to exclude the categories in the list...all by clicking manually with the mouse:

![Category settings](/img/nunit-categories-tab.png "Category settings")

The problem is that I'm too lazy to do this by hand. All my projects with unit tests have a batch file to open the NUnit GUI, which looks like this:

	path\to\nunit-x86.exe path\to\Tests.dll

Similar to this, I'd like to have **two** batch files to open the GUI...one to run all tests, and one to exclude the integration tests.

I didn't find this in the [documentation about the GUI's command line options](http://www.nunit.org/index.php?p=consoleCommandLine&r=2.6.2), but it turns out that the GUI understands `/include` and `/exclude` as well.

So I added a second batch file to run everything except the integration tests:

	path\to\nunit-x86.exe path\to\Tests.dll /exclude:Integration

This makes the single integration test that I have at the moment appear with a different text color:

![Different text color](/img/nunit-categories-textcolor.png "Different text color")

And now comes the part where I said at the beginning that it **almost** works for me:  
In the Nunit GUI, there are two ways to run the tests - you can either click on the "Run" button or press F5.

Unfortunately, the results are different:

The "Run" button runs all tests except the "Integration" category, as expected:

![After pressing the Run button](/img/nunit-categories-run.png "After pressing the Run button")

But F5 runs **all** tests...**including** the "Integration" category:

![After pressing F5](/img/nunit-categories-f5.png "After pressing F5")

Depending on your habits, this may be okay for you. After all, you can just use the button instead of F5 and everything works.

But I am so used to pressing F5...I literally **never** used the button at all.  
So I kept on searching for a better solution, and I actually found one that works better for me.  
More about that in [the next post]({{< ref "/posts/2013-04-16-excluding-integration-tests-in-nunit-s-gui-part-2-specifying-a-fixture/index.md" >}}).
