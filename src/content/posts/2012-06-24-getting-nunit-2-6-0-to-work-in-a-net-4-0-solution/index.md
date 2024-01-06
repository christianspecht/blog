---
title: Getting NUnit 2.6.0 to work in a .NET 4.0 solution
slug: getting-nunit-2-6-0-to-work-in-a-net-4-0-solution
date: 2012-06-24T23:12:16
tags: [.net, nunit, unit-testing]
---

I just tried to use NUnit 2.6.0 in a .NET 4.0 solution, but it failed to recognize my test assembly.  
No matter which runner I used, NUnit always said that it couldn't find any tests:

Console runner:  
![NUnit Console](/img/nunit-console.png "NUnit Console")

GUI runner:  
![NUnit GUI](/img/nunit-gui.png "NUnit GUI")

I spent a few minutes staring at the screen and wondering if I made a mistake somethere.

It couldn't be the test class, because the test class was **very** simple:

    [TestFixture]
    public class SomeTest
    {
        [Test]
        public void JustATest()
        {
            Assert.IsTrue(true);
        }
    }

After a while, I opened the config files of one of the runners (`nunit.exe.config` for `nunit.exe`) and found this at the beginning:

    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
        <!--
            The .NET 2.0 build of the console runner only
            runs under .NET 2.0 or higher. The setting
            useLegacyV2RuntimeActivationPolicy only applies
            under .NET 4.0 and permits use of mixed mode
            assemblies, which would otherwise not load
            correctly.
        -->
        <startup useLegacyV2RuntimeActivationPolicy="true">
            <!-- Comment out the next line to force use of .NET 4.0 -->
            <supportedRuntime version="v2.0.50727" />
            <supportedRuntime version="v4.0.30319" />
        </startup>

Apparently NUnit was running on .NET 2.0 (or 3.5, see the screenshot from the console runner above), so it wasn't able to open my .NET 4.0 test assembly.

So the solution is to comment out the first `supportedRuntime` line (line 3 in this example) in the config files of every runner you need:

    <startup useLegacyV2RuntimeActivationPolicy="true">
        <!-- Comment out the next line to force use of .NET 4.0 -->
        <!-- <supportedRuntime version="v2.0.50727" /> -->
        <supportedRuntime version="v4.0.30319" />
    </startup>

In my case, I did that in:

- `nunit.exe.config` (for the GUI, which I use during development)
- `nunit-console.exe.config` (for the console runner, which I use in my build script).

Apparently, this setting was added in NUnit 2.6.0, because I still had a working example solution from a few months ago where I used NUnit 2.5.10.

The example solution had very simple test classes similar to the one above, and I didn't have to change the config files there – in fact, this whole `<startup>`  section didn't even exist.
