---
layout: post
title: Switched from WordPress to Blogofile
date: 2013/01/29 22:13:00
tags: [wordpress, blogofile]
---

Like many other developers did before me, I just switched this site from WordPress to a static site generator ([Blogofile](http://www.blogofile.com/) in my case).  
The complete source code [is now on Bitbucket](https://github.com/christianspecht/blog).

There wasn't anything particularly *wrong* with WordPress, I did the switch mainly for the same reasons everyone else did it as well:

I'm a developer, I prefer writing Markdown files and using "proper" source control (Mercurial in my case), instead of a WYSIWYG web interface with all the data only on a server somewhere on the web.

Plus, WordPress as a whole always felt some kind of "overkill" to me.  
Sure, it does everything I want, but you need plugins for everything beyond the bare minimum. For example, I had to install a plugin just to enable Google Analytics. It worked without trouble, but still...just [inserting a few lines into a HTML file](https://github.com/christianspecht/blog/commit/8b63e5b4c07371bc04b4701458b92f7d5ed36577) feels somehow more natural to me, even though I'm not exactly a "web guy".  
And then you need another plugin for changing the meta tags, and another one for syntax highlighting, and...you get the idea.

The actual switching to Blogofile was pretty straightforward. The [documentation](http://docs.blogofile.com/) is good and I found nearly everything I needed there.

A few notes:

**Converting the old blog posts from WordPress:**  
Blogofile even offers a [converter script](http://docs.blogofile.com/en/latest/migrating_blogs.html#posts), but I had only a few posts, so I didn't bother playing around with the script and just converted the posts by hand.  
<del>I found [a bug](https://github.com/EnigmaCurry/blogofile/issues/141) while converting, which made me unable to set the date of any blog post to March (no matter which year).  
So I had to ["re-schedule" one post from last year's March to February instead](https://github.com/christianspecht/blog/commit/62e74a3e46b593f7366c45f50551291112359edd), and fake the original WordPress URL by [setting the permalink field of that post](https://github.com/christianspecht/blog/commit/a0fd83e1595bde4efe06c4079d2c3f0d7e37e2c3).</del>  
*EDIT (Feb 04 2013):  
I just discovered that setting the post date to March **does** work when you set the locale to English in the `pre_build` hook. Thanks to Peter Zsoldos for [pointing me to the `pre_build` solution](https://groups.google.com/forum/#!msg/blogofile-discuss/1qTU4nkBUuU/yj33kxCnd4YJ).  
Apparently the bug was caused by the German word for March ("März") containing an [umlaut](http://en.wikipedia.org/wiki/Germanic_umlaut). By setting the locale to English right at the beginning, no evil umlauts were used and the problem disappeared (at least for me - it would still occur for people trying to blog with Blogofile in German).*

**Templates/Themes:**  
There are no ready-made templates for Blogofile (or at least I didn't find any), so I had to build my own using [Twitter Bootstrap](http://twitter.github.com/bootstrap/) (which I had heard of, but never used before). The layout is based on the ["Fluid layout" example](http://twitter.github.com/bootstrap/examples/fluid.html) (I only moved the sidebar to the right), and I used one of the great free themes from [Bootswatch](http://bootswatch.com/) to make the site look less "bootstrappy".

**Comments:**  
The standard way of having comments on a static HTML site would be using [Disqus](http://disqus.com/). Well, I *could* enable Disqus for comments, but in about a year running this site on WordPress, I got exactly **zero** comments from real humans...only about ten spam comments for each post.  
So I'm leaving comments disabled for now...drop me a mail if you'd like to contact me.

