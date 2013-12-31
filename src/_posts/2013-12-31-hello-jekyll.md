---
layout: post
title: Hello, Jekyll!
date: 2013/12/31 02:56:00
tags: [jekyll, blogofile, markdown]
---

I migrated this site again...this time to [Jekyll](http://jekyllrb.com).  
Why again? When I [migrated from WordPress to Blogofile](/2013/01/29/switched-from-wordpress-to-blogofile) in the beginning of 2013, I evaluated other static site generators *([Octopress](http://octopress.org/) and [Pelican](http://getpelican.com/))* as well, before settling on [Blogofile](http://blogofile.com). I knew at the time that Jekyll existed and that Octopress is based on it, but I didn't take a closer look.

After reading a few recent posts by other people who migrated to Jekyll, I became interested in Jekyll again. Originally I just started to convert my site to Jekyll to see how it works and how it's different/similar to Blogofile, but in the end I converted the complete site and decided to stay with Jekyll.

There's no real reason why...I guess it's just because Jekyll is all the rage now :-)  
Apart from the fact that Jekyll is slightly more popular *(starred on GitHub 13,476 vs. 295 times, as of now)*, Jekyll and Blogofile are largely the same.

Some things are easier to do in Blogofile, some are easier to do in Jekyll:

- Both have their little quirks: in Blogofile I had [issues with German umlauts](https://github.com/EnigmaCurry/blogofile/issues/141), in Jekyll I had trouble with wrong quote characters in old blog posts that were originally converted from WordPress  
*(Jekyll doesn't like it when you use `’` and `“` instead of `'` and `"`)*
- Generating the ["Projects" page](/projects/) is [much easier in Jekyll](https://bitbucket.org/christianspecht/blog/commits/4ee11cd25315257a88f9eb57bdccbb84086775bb) *(thanks to [YAML data files](http://jekyllrb.com/docs/datafiles/))*
- Blogofile automatically generates stuff like [feeds](/feed/index.xml), [tag pages](/tags/) and [archive pages](/archive/), which I needed to [copy-paste](https://github.com/coyled/coyled.com) or even [build](https://bitbucket.org/christianspecht/blog/src/8ad956713d41/src/tags/index.html) [myself](https://bitbucket.org/christianspecht/blog/src/8ad956713d41/src/archive/index.html) for Jekyll
- A few small things like combining a page-specific title with the site-wide title are
[incredibly complicated](https://groups.google.com/forum/?fromgroups=#!topic/blogofile-discuss/4sKwQxtWywc) in Blogofile, but [dead easy](https://bitbucket.org/christianspecht/blog/commits/ff37c497c310cc3539cd7486a945336d652866db) in Jekyll
- Blogofile has built-in helpers for creating lists of [posts by month](https://bitbucket.org/christianspecht/blog/commits/dea85ac7c3142b15756f4241fd52aa61a8c9106f#chg-src/_layouts/default.html) and [tags with number of posts](https://bitbucket.org/christianspecht/blog/commits/311d095d3b232d41f86969b7f0070466a58fa8da#chg-src/_layouts/default.html) in the sidebar, but Jekyll doesn't  
*(to see the difference, look at the diffs in the two links)*

Oh, and of course I needed to re-build [my previous solution to display Markdown files from my Bitbucket projects](/2013/02/17/how-to-display-markdown-files-from-other-sites-this-time-in-blogofile/) *(again)*.  
[Here's the Jekyll code](https://bitbucket.org/christianspecht/blog/commits/fc681c28835657accc3efd0d94fb4f1cbbd0c710) to generate the PHP pages.

Concerning hosting:  
The default Jekyll setup these days seems to be using [GitHub Pages](http://pages.github.com/), but my site is still hosted on my own webspace *(I'm paying for it anyway, and I prefer to use Mercurial, not Git)*.