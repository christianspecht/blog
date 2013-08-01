---
title: Basic Authentication in ASP.NET Web API
date: 2013/08/02 01:51:00
categories: .NET, Web API, Authentication
---

For my current project [Tasko](/tasko), I'm writing a service backend in [ASP.NET Web API](http://www.asp.net/web-api) at the moment.

I already had a usable basic version for some time, the last thing that was missing was authentication.  
This web services stuff is all new to me *(that's one of the reasons why I'm creating a task management app myself, instead of using one of the many that already exist)*, so I didn't know much about authentication as well. I had a vague idea that something like [Basic Authentication](http://en.wikipedia.org/wiki/Basic_access_authentication) existed, but that was all.

A few weeks ago, I needed to write web services for an iPhone app at work, and used [ServiceStack](http://servicestack.net/) for that. Of course, these web services required authentication as well, so I already had to learn about authentication then.  
*([I had some problems first](http://stackoverflow.com/q/17110015/6884), but [soon managed to get it to work](http://stackoverflow.com/a/17179825/6884))*

With my newly gained knowledge about Basic Authentication in general and how to make it work in ServiceStack, I tried to implement it with ASP.NET Web API as well.


### First try: Using the handler from WebAPI Contrib

The first thing I looked at was the ["Security" section](http://www.asp.net/web-api/overview/security) on the official Web API site, especially the [Basic Authentication article](http://www.asp.net/web-api/overview/security/basic-authentication).

At the bottom of that page, there is example code for a HTTP Module that handles Basic Authentication with Custom Membership. IMO, this was quite a lot of code compared to the [bare minimum working solution in ServiceStack](http://stackoverflow.com/a/17179825/6884), so I disliked the idea of just copying and pasting the code from the site, and looked for a shorter solution instead.

Then I found the [Web API Contrib](http://webapicontrib.github.io/) project, which contains a [message handler for Basic Auth](https://github.com/WebApiContrib/WebAPIContrib/blob/master/src/WebApiContrib/MessageHandlers/BasicAuthenticationHandler.cs).

The usage looks similar to the basic minimum ServiceStack example linked above - just inherit from the class:

    using WebApiContrib.MessageHandlers;

    namespace Tasko.Server
    {
        public class TaskoBasicAuthHandler : BasicAuthenticationHandler
        {
            protected override bool Authorize(string username, string password)
            {
                if (username == "test" && password == "123")
                {
                    return true;
                }

                return false;
            }

            protected override string Realm
            {
                get { return "Tasko.Server"; }
            }
        }
    }

...and add this line to the configuration:

    GlobalConfiguration.Configuration.MessageHandlers.Add(new TaskoBasicAuthHandler());

This worked on my machine, but the problem was: I couldn't get it to run on [AppHarbor](https://appharbor.com/), where I intended to host my own Tasko instance.  
The authentication just didn't work - Web API always returned a 200 and the requested data, even with the wrong credentials or no credentials at all.



### Back to the example from the official docs

So I took a second look at [the examples from the official Web API site](http://www.asp.net/web-api/overview/security/basic-authentication) *(the last paragraph, "Basic Authentication with Custom Membership")*. I copied the HTTP Module into my project and registered it in `web.config`.

**Note that you can't just copy & paste the `type` attribute from the tutorial.** The first parameter needs to be the name of the class *(including namespace)* and the second parameter needs to be the name of the assembly.

So for [this HTTP Module](https://bitbucket.org/christianspecht/tasko/src/87defb080d0e8e503304ac91104e2d85ebb3a94f/src/Tasko.Server/BasicAuthHttpModule.cs?at=default), it's:

$$code(lang=xml)

<system.webServer>
    <modules>
        <add name="BasicAuthHttpModule"
        type="Tasko.Server.BasicAuthHttpModule, Tasko.Server"/>
    </modules>

$$/code

What happened then was exactly the opposite from the result of the first try: authentication worked on AppHarbor, but not on my local machine.  
This would make it difficult to test authentication locally, but I could have lived with that for now.

But I still googled some more, and finally found [this](http://stackoverflow.com/a/103817/6884):

> The built in web server for Visual Studio is called Cassini and here are a few of its limitations...
> 
> [...]  
> - It does not support authentication.

Okay...if you're a (.NET) web developer, you probably already know this.  
I guess that most people who are starting with Web API come from a ASP.NET MVC background, but not me...I'm not exactly a web guy.  
Now that I think about it: I'm quite sure that my co-workers *(who do ASP.NET MVC development)* use IIS to run their projects on their local machines, and not Cassini.

As soon as I had figured that out, the rest was easy: install [IIS Express](http://www.iis.net/learn/extensions/introduction-to-iis-express) on my machine, and that was it.


### Conclusion
 
None of the steps I had to go through is really difficult, as soon as you have figured out how this all works.  
But I could probably have avoided hours of trial and error if a few things were explained better in the tutorials - like the fact that Cassini doesn't support authentication.
