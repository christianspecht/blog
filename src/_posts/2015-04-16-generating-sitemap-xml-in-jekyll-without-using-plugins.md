---
layout: post
title: Generating sitemap.xml in Jekyll, without using plugins
date: 2015/04/16 21:16:00
tags:
- jekyll
externalfeeds: 1
---

After my blog was already online for a while, I discovered [Google Webmaster Tools](http://www.google.com/webmasters/tools/) and [sitemaps](https://support.google.com/webmasters/answer/183668?hl=en) while reading about the SEO basics.

According to the link, a sitemap in its simplest form is just an XML file like this, with one `<url><loc>` element per URL on the site:

	<?xml version="1.0" encoding="UTF-8"?>
	<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"> 
	  <url>
	    <loc>http://www.example.com/foo.html</loc> 
	  </url>
	</urlset>

Using Jekyll and depending on the structure of the site, it's relatively easy to create this in a dynamic way, so it's updated automatically when adding new posts or pages to the site.

**Note that if you're fine with using plugins, [there's a plugin for generating sitemaps](https://github.com/jekyll/jekyll-sitemap) that [works on GitHub Pages](https://help.github.com/articles/sitemaps-for-github-pages/).**  
I'm not using GitHub Pages, but I still wanted to find a solution *without* plugins, because so far I managed to achieve everything I tried in Jekyll without plugins.

---

## The `<url>` element

Since the `<url><loc>...</loc></url>` part needs to be repeated for each link, it will go into an [include file](http://jekyllrb.com/docs/templates/#includes):

#### `/_includes/sitemapxml.html` :

	{% raw %}

	<url>
		<loc>{{ site.url }}{{ include.url }}</loc> 
	</url>

	{% endraw %}

`site.url` refers to the site's [config file](http://jekyllrb.com/docs/configuration/). For this blog, it contains the following line:

	url: http://christianspecht.de

The links in the sitemap must contain the full URL *(`http://christianspecht.de/foo` instead of just `/foo`)*, so all links need to be prefixed with the base URL.

With this include file, it's already possible to create a simple sitemap, by providing URLs manually:

#### `/sitemap.xml` :

	{% raw %}

	---
	layout: none
	---
	
	<?xml version="1.0" encoding="UTF-8"?>
	<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"> 
	{% include sitemapxml.html url="/foo/" %}
	</urlset>

	{% endraw %}

The generated XML:

	<?xml version="1.0" encoding="UTF-8"?>
	<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"> 
	  <url>
	    <loc>http://christianspecht.de/foo/</loc> 
	  </url>
	</urlset>

Being programmers, we obviously don't want to provide URLs manually, though...so we're going to automate this in the next steps.

---

## Getting all URLs, the simple way

The easiest way to get all URLs is to loop `site.pages`:

	{% raw %}

	---
	layout: none
	---
	
	<?xml version="1.0" encoding="UTF-8"?>
	<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"> 
	{% for p in site.pages %}{% include sitemapxml.html url=p.url %}
	{% endfor %}
	</urlset>

	{% endraw %}

Note the line break inside the `for` loop. There must be *exactly one* line break after the include, so the line breaks in the resulting XML file look exactly like in the example in the intro above.

This approach has one big disadvantage: it only works if you actually want all pages listed in the sitemap.  
"All" really means **all** files which contain [YAML front matter](http://jekyllrb.com/docs/frontmatter/)...including, for example, the `sitemap.xml` file itself.
  
In reality, there are probably some pages besides the sitemap that you don't want to be listed either, so you could explicitly exclude everything in the loop which is named X, Y and Z.

It's possible to do it like this, but most of my Jekyll sites have "special" menus which rely on the important URLs being in a data file anyway, so I'll show two advanced approaches how to make use of this.

---

## When most of the URLs are blog posts or in data files

This is what I used for the sitemap of this blog.  

All the URLs that exist here belong to one of these three categories:

- The blog posts, [which I can loop with Jekyll](http://jekyllrb.com/docs/posts/#displaying-an-index-of-posts)
- The project pages in the sidebar, which I can loop as well, because the list in the sidebar is coming from [this data file](https://bitbucket.org/christianspecht/blog/src/a08df7a116eec07654e84ea78d5a68b68dbcc564/src/_data/sidebarprojects.yml?at=default)
- A very small number of "other" pages (three at the time I'm writing this: the [archive](/archive/), the [project list](/projects/) and the [tags page](/tags/))

So creating [this sitemap file](/sitemap.xml) for my blog was as simple as that:

	{% raw %}
	
	---
	layout: none
	---
	
	<?xml version="1.0" encoding="UTF-8"?>
	<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"> 
	{% include sitemapxml.html url="/archive/" %}
	{% include sitemapxml.html url="/projects/" %}
	{% include sitemapxml.html url="/tags/" %}
	{% for project in site.data.sidebarprojects %}{% include sitemapxml.html url=project.url %}
	{% endfor %}{% for post in site.posts %}{% include sitemapxml.html url=post.url %}
	{% endfor %}</urlset>
	
	{% endraw %}

The three pages at the beginning are very unlikely to change, and new projects and new blog posts will be updated automatically when I add them to the rest of the site.

---

## When you have a nested data file

I'm running another site which uses [the "dynamic" tree menu I described here](/2014/06/18/building-a-pseudo-dynamic-tree-menu-with-jekyll/).

There's a data file with all the URLs anyway, but the URLs are nested, so getting a list with all of them is a bit more complex.  
The way to create a sitemap file here is similar to creating the menu: by using a recursive include file.

I'll show just the code here - read the blog post linked above for an in-depth explanation how this works, it's exactly the same approach.

#### `/_includes/sitemap.html`:

	{% raw %}

	{% for item in include.map %}{% include sitemapxml.html url=item.url %}
	{% if item.subitems %}{% include sitemap.html map=item.subitems %}{% endif %}{% endfor %}

	{% endraw %}

Again, the line breaks must be exactly as shown here in order to avoid unnecessary empty lines in the finished sitemap file.
    
And here's the actual sitemap file which uses the include, passing the data file with the menu information:

#### `/sitemap.xml`:

	{% raw %}

	---
	layout: none
	---
	
	<?xml version="1.0" encoding="UTF-8"?>
	<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"> 
	{% include sitemap.html map=site.data.menu %}</urlset>

	{% endraw %}

I won't show the generated XML here, but it looks exactly like the example in the very beginning of this post.


---

## Telling Google about the sitemap

Now there's only one thing missing: we need to tell the search engines about our new sitemap.

Another quote from Google's ["Build a sitemap" page](https://support.google.com/webmasters/answer/183668?hl=en) *(from the very bottom)*:

> Once you've made your sitemap, you can then [submit it to Google with the Sitemaps page](https://support.google.com/webmasters/answer/183669), or by inserting the following line anywhere in your `robots.txt` file:
>
>    Sitemap: http://example.com/sitemap_location.xml

For my sites, I immediately submitted the sitemaps to Google, but still inserted the line into `robots.txt`.

Apparently [the link to the sitemap file needs to contain the full URL as well](http://stackoverflow.com/a/14218476/6884) *(not just `/sitemap.xml`)*, so created `robots.txt` with Jekyll as well, so I could reuse `site.url`:

#### `/robots.txt`:

{% raw %}

    ---
    layout: none
    ---

    Sitemap: {{ site.url }}/sitemap.xml

{% endraw %}
