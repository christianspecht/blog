---
title: Switched from WordPress to Blogofile
date: 2013/01/29 22:13:00
categories: WordPress, Blogofile
---

Like many other developers did before me, I just switched this site from WordPress to a static site generator ([Blogofile](http://www.blogofile.com/) in my case).  
The complete source code [is now on Bitbucket](https://bitbucket.org/christianspecht/blog).

There wasn't anything particularly *wrong* with WordPress, I did the switch mainly for the same reasons everyone else did it as well:

I'm a developer, I prefer writing Markdown files and using "proper" source control (Mercurial in my case), instead of a WYSIWYG web interface with all the data only on a server somewhere on the web.

Plus, WordPress as a whole always felt some kind of "overkill" to me.  
Sure, it does everything I want, but you need plugins for everything beyond the bare minimum. For example, I had to install a plugin just to enable Google Analytics. It worked without trouble, but still...just [inserting a few lines into a HTML file](https://bitbucket.org/christianspecht/blog/commits/32cfb72c9cb2df01341e7614172cfa73ea6928c0) feels somehow more natural to me, even though I'm not exactly a "web guy".  
And then you need another plugin for changing the meta tags, and another one for syntax highlighting, and...you get the idea.

The actual switching to Blogofile was pretty straightforward. The [documentation](http://docs.blogofile.com/) is good and I found nearly everything I needed there.

A few notes:

**Converting the old blog posts from WordPress:**  
Blogofile even offers a [converter script](http://docs.blogofile.com/en/latest/migrating_blogs.html#posts), but I had only a few posts, so I didn't bother playing around with the script and just converted the posts by hand.  
I found [a bug](https://github.com/EnigmaCurry/blogofile/issues/141) while converting, which made me unable to set the date of any blog post to March (no matter which year).  
So I had to ["re-schedule" one post from last year's March to February instead](https://bitbucket.org/christianspecht/blog/commits/7d679e36cdf960596c477435f758a184fdda3e8f), and fake the original WordPress URL by [setting the permalink field of that post](https://bitbucket.org/christianspecht/blog/commits/c5246607b5f6c5b46be8f70aa4480dfee8c12d37).

**Templates/Themes:**  
There are no ready-made templates for Blogofile (or at least I didn't find any), so I had to build my own using [Twitter Bootstrap](http://twitter.github.com/bootstrap/) (which I had heard of, but never used before). The layout is based on the ["Fluid layout" example](http://twitter.github.com/bootstrap/examples/fluid.html) (I only moved the sidebar to the right), and I used one of the great free themes from [Bootswatch](http://bootswatch.com/) to make the site look less "bootstrappy".

**Comments:**  
The standard way of having comments on a static HTML site would be using [Disqus](http://disqus.com/). Well, I *could* enable Disqus for comments, but in about a year running this site on WordPress, I got exactly **zero** comments from real humans...only about ten spam comments for each post.  
So I'm leaving comments disabled for now...drop me a mail if you'd like to contact me.

