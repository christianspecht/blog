---
layout: post
title: "Jekyll dynamic tree menu: show the whole menu at once" 
date: 2016/10/09 17:14:00
tags:
- jekyll
externalfeeds: 1
---

Over two years ago, I wrote a blog post about [building a dynamic tree menu with Jekyll]({% post_url 2014-06-13-building-a-pseudo-dynamic-tree-menu-with-jekyll %}).

Now I received an e-mail from Viesturs K, with a question about this post:

> What I would like to know is, how to print all the links from my menu file. Not just show subitems when parent is selected. I need this to make a separate categorized archive.

---

## The answer

Compared to building the dynamic menu, this is much simpler.  
The basic idea is still the same: The page loads an include file which builds HTML for the top level menu items.  
In case the current menu item has subitems, the include file recursively includes itself for each subitem, passing the subitems of the current menu item.

However, most of the complexity in the dynamic tree solution is because it's dynamic.  
When you don't have to deal with deciding which menu items to show based on the current menu item, the code becomes *much* easier:

`_includes/sitemap.html`
	
	{% raw %}
		<ul>
		{% for item in include.map %}
		<li><a href="{{ item.url }}">{{ item.text }}</a></li>
		{% if item.subitems %}{% include sitemap.html map=item.subitems %}{% endif %}
		{% endfor %}
		</ul>
	{% endraw %}

*(I called it "sitemap" because showing all menu items at once is kind of a sitemap)*

And the actual page which includes the sitemap:

`sitemap/index.html`

	{% raw %}
		---
		layout: default
		title: Sitemap (all menu items expanded)
		---
		
		{% include sitemap.html map=site.data.menu %}
	{% endraw %}


As a reminder, here's [the data file with the menu items](https://github.com/christianspecht/code-examples/blob/master/jekyll-dynamic-menu/src/_data/menu.yml) again:

`_data/menu.yml`

	- text: Home
	  url: /
	- text: First menu
	  url: /first-menu/
	  subitems:
	    - text: First menu (sub)
	      url: /first-menu/first-menu-sub/
	      subitems:
	        - text: First menu (sub-sub)
	          url: /first-menu/first-menu-sub/first-menu-sub-sub/
	- text: Second menu
	  url: /second-menu/
	  subitems:
	    - text: Second menu (sub)
	      url: /second-menu/second-menu-sub/
	- text: Sitemap
	  url: /sitemap/

All this together will output the following HTML:

	<ul>
	    <li><a href="/">Home</a></li>
	    <li><a href="/first-menu/">First menu</a></li>
	    <ul>
	        <li><a href="/first-menu/first-menu-sub/">First menu (sub)</a></li>
	        <ul>
	            <li><a href="/first-menu/first-menu-sub/first-menu-sub-sub/">First menu (sub-sub)</a></li>
	        </ul>
	    </ul>
	    <li><a href="/second-menu/">Second menu</a></li>
	    <ul>
	        <li><a href="/second-menu/second-menu-sub/">Second menu (sub)</a></li>
	    </ul>
	    <li><a href="/sitemap/">Sitemap</a></li>
	</ul>

---

## Complete example code

I already put the example code into [this repository](https://github.com/christianspecht/code-examples/tree/master/jekyll-dynamic-menu) when I created the first blog post.  
I just updated it, so this sitemap is in there as well now.