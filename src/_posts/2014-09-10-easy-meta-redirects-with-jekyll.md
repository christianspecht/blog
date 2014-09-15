---
layout: post
title: Easy meta redirects with Jekyll
date: 2014/09/15 22:51:00
tags:
- jekyll
---

If you ever did the work of converting a website that was originally built with some other technology to [Jekyll](http://jekyllrb.com/), you've probably encountered the need to do redirects. Most likely when the URLs of the "old" site contain some file extensions which indicate the underlying technology:  
In my case, the site I converted was built with [Website Baker](http://www.websitebaker.org/), which is written in PHP and generates URLs that look like this:

    http://mysite.com/pages/foo/bar.php

It **is** possible to preserve URLs like this with Jekyll without the need for PHP *(or ASP.NET, or whatever)* to be installed on the "new" server. I stole the basic idea from [Phil Haack](http://haacked.com), who had the same problem when he converted his blog *(built with [Subtext](http://subtextproject.com/), which creates URLs that end with `.aspx`)* to Jekyll.  

[Phil explains it in greater detail in this blog post](http://haacked.com/archive/2013/12/03/jekyll-url-extensions/), so I'll make it short - the trick is to build the following folder structure with Jekyll:

    http://mysite.com/pages/foo/bar.php/index.html

In this case, `bar.php` ist just a folder with an extension. So loading `http://mysite.com/pages/foo/bar.php` *(without the slash at the end)* will actually redirect to `http://mysite.com/pages/foo/bar.php/` *(**with** the slash at the end)*, which will just load the `index.html` in that folder.

However, I wanted new "pretty" URLs for my Jekyll site, so I needed the `index.html` mentioned above to do a [meta refresh](http://en.wikipedia.org/wiki/Meta_refresh) to the new URL *(let's say it's `http://mysite.com/foo/bar/`)*.

And I needed to do **a lot** of these redirects, so I wanted to be able to create each one with as little effort as possible.

---

## Changing the layout file

What I did in the end was adding two lines to the default layout.  
One *(the actual meta redirect)* inside the `<head>`:

{% raw %}
    {% if page.redirect %}<meta http-equiv="refresh" content="0; url={{ page.redirect }}">{% endif %}
{% endraw %}

...and one in the body, just above or below Jekyll's `{% raw %}{{content}}{% endraw %}` tag:
    
{% raw %}
    {% if page.redirect %}<h3> Redirecting to <a href="{{ page.redirect }}">{{ page.redirect }}</a> ...</h3>{% endif %}
{% endraw %}

So a *very* basic layout file with these two lines added will look like this:

{% raw %}
    <!DOCTYPE html>
    <html>
    <head>
        <title>{{ page.title }}</title>
        {% if page.redirect %}<meta http-equiv="refresh" content="0; url={{ page.redirect }}">{% endif %}
    </head>
    <body>
        <h1>{{ page.title }}</h1>
        {% if page.redirect %}<h3> Redirecting to <a href="{{ page.redirect }}">{{ page.redirect }}</a> ...</h3>{% endif %}
        {{ content }}
    </body>
    </html>
{% endraw %}

The line in the head will do the actual meta redirect.

The line in the body will display an informational text with a link, in case the automatic redirect doesn't work.  
Doing all this in the layout file has the advantage that this "Redirecting to..." pages will look similar to the rest of the site.

---

## Wrap up

With this approach, creating a new Jekyll page with a redirect is as simple as this:

    ---
    layout: default
    redirect: http://mysite.com/foo/bar/
    ---

*(just the front-matter as shown here, no content necessary)*
    
It's even possible [to define the layout **once** in `_config.yml`](http://jekyllrb.com/docs/configuration/#front-matter-defaults), so it's not necessary anymore to put the `layout: default` line in each and every single page.

So a page with a redirect can be shortened to:

    ---
    redirect: http://mysite.com/foo/bar/
    ---
