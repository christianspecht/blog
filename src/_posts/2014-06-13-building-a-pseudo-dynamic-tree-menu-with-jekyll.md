---
layout: post
title: Building a pseudo-dynamic tree menu with Jekyll
date: 2014/06/18 00:40:00
tags:
- jekyll
codeproject: 1
---

I'm in the process of moving an existing site to [Jekyll](http://jekyllrb.com/). The existing site was built with a CMS, which generates a dynamic tree menu.  
Imagine a sitemap like this:

- Home
- First menu
    - First menu *(subitem)*
    	- First menu *(sub-subitem)*
- Second menu
    - Second menu *(subitem)*

When you load the site *(the "Home" page)*, it shows only the first level of menu items. The subitems are not visible, and the link to the current page is bold:

- **Home**
- First menu
- Second menu

When you click on one of the links that have subitems, the next level of subitems is shown. So clicking on "First Menu" makes it look like this:

- Home
- **First menu**
    - First menu *(subitem)*
- Second menu

...and clicking on "First menu *(subitem)*" :

- Home
- First menu
    - **First menu *(subitem)***
    	- First menu *(sub-subitem)*
- Second menu

...and so on.

This is what we're going to build with Jekyll in this post.

---

## First thoughts

If we think about it for a moment, we'll find that the menu we need is not actually "dynamic".  
Jekyll will generate a separate HTML file for each page anyway, and if we're looking at one single page in isolation, there's *nothing* dynamic in the menu of that page.  
Sure, the link to the current page needs to be bold and stuff like that, but nothing ever needs to change on that page at runtime - each time the page is loaded, the menu needs to look exactly the same.

**So we just need to generate static pages, but with a different "view" of the menu on each page.**

These are the rules:

- We need to display the link in bold if it's the link to the current page.
- Generally, we don't need to display subitems...but there are two exceptions:
	- we need to display subitems of the current page *(next level only, even if there are multiple levels of subitems)*
	- if the current page is a subitem itself, we need to display the subitems from the uppermost level down to that page

---

## Saving the sitemap in a data file

First of all, we'll use a [YAML data file](http://jekyllrb.com/docs/datafiles/) to hold the complete sitemap: the menu items, their URLs and their subitems.

`/_data/menu.yml`:

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

The `text` and `url` properties will be used later to build the actual HTML links in the menu.

All the URLs *(`/`, `/first-menu/`, `/first-menu/first-menu-sub/` and so on)* will need to exist as folders in Jekyll's source folder, with an `index.html` or `index.md` file inside each folder:
	
	/index.html
	/first-menu/index.html
	/first-menu/first-menu-sub/index.html
	etc.

For this example, I'll just use the most basic content possible for all those files:

	---
	layout: default
	title: whatever
	---

<div id="subfolders"></div>

**One important thing: you need to make sure that all subitems are placed in subfolders of their parents, as shown in my example data file above!**

Why?  
Technically, something like this would be possible as well:

	- text: First menu
	  url: /first-menu/
	  subitems:
	    - text: First menu (sub)
	      url: /somewhere-else/first-menu-sub/
	      subitems:
	        - text: First menu (sub-sub)
	          url: /first-menu-sub-sub/ 

With this folder structure, generating the basic menu would work as well.  
But then, some of the tricks that we'll use later *(to make the menu look dynamic)* won't work anymore.



---

## The basic solution

In my special case *(converting an existing site with an existing menu structure)* I knew how many levels of nested subitems the tree would have, so I could just build it with a few nested loops *(where "a few" is equal to the maximum nesting level of the menu items)*.

When I first tried this, I put the code for the rules *("Display the link to the current page in bold" etc.)* into an [include file](http://jekyllrb.com/docs/templates/#includes), to avoid repeating it in each loop.

But I still liked the idea of a "nesting level-agnostic" solution, so I googled some more, read some tutorials and found out that it's possible in Jekyll to recursively nest include files.  
In other words: an include file can include itself.

Based on this, I came up with the following solution.    
First, the [layout file](http://jekyllrb.com/docs/structure/) (`/_layouts/default.html`):

{% raw %}

	<!DOCTYPE html>
	<html>
	<head>
		<title>{{ page.title }}</title>
	</head>
	<body>
	
	<h2>Navigation:</h2>
	
	{% include nav.html nav=site.data.menu %}
	
	<hr>
	
	<h1>{{ page.title }}</h1>
	
	{{ content }}
	</body>
	</html>

{% endraw %}

Nothing special here - it just displays the navigation *(via include file)*, then a horizontal line, then the actual page content.

The only thing worth mentioning is that we're passing the complete sitemap from the data file to the include:

{% raw %}

	{% include nav.html nav=site.data.menu %}

{% endraw %}

According to [the docs](http://jekyllrb.com/docs/templates/#includes), it's available inside the include then, via `{% raw %}{{ include.nav }}{% endraw %}`.

---

## The recursive include file

This is where all the magic happens:

`/_includes/nav.html`

{% raw %}

	{% assign navurl = page.url | remove: 'index.html' %}
	<ul>
	{% for item in include.nav %}
		<li>
			<a href="{{ item.url }}">
				{% if item.url == navurl %}
					<b>{{ item.text }}</b>
				{% else %}
					{{ item.text }}
				{% endif %}
			</a>
		</li>
		{% if item.subitems and navurl contains item.url %}
			{% include nav.html nav=item.subitems %}
		{% endif %}
	{% endfor %}
	</ul>

{% endraw %}

There's *a lot* of magic happening here, so we'll go through it step by step.

0. First, we save the URL of the current page in a variable called `navurl`, stripping `index.html` from the end:

	{% raw %}

		{% assign navurl = page.url | remove: 'index.html' %}

	{% endraw %}

	So when the current page is `/first-menu/index.html`, `navurl` will be set to `/first-menu/`.

0. Then, we loop through the uppermost level of menu items.  
	In case of the example data file from above, these items are:
	
	- Home
	- First menu
	- Second menu  

	We'll come to the subitems later.

0. The next line displays the link to the menu item.  
	We're using the `navurl` variable from step 1 here, to determine whether the URL of the currently looped menu item is equal to the URL of the current page.  
	If yes, we'll display the link in bold because it's the link to the current page: 

	{% raw %}

		<a href="{{ item.url }}">
			{% if item.url == navurl %}
				<b>{{ item.text }}</b>
			{% else %}
				{{ item.text }}
			{% endif %}
		</a>

	{% endraw %}

0. Does the menu item have subitems? If yes, we now need to decide whether to show them.    
	There are two cases when they must be shown:

	- when the menu item is the current page
	- when the menu item is a parent of the current page

	This is quite easy when all the subitems are placed in subfolders of their parents ([see above](#subfolders)).  
	Because then, finding out if a menu item is either the current page or a parent of the current page becomes a matter of just comparing URLs:

	{% raw %}

	    {% if item.subitems and navurl contains item.url %}
	        <!-- show subitems here -->
	    {% endif %}

	{% endraw %}

	For clarification, I'll show the relevant part of the data file again:
	
		- text: First menu
		  url: /first-menu/
		  subitems:
		    - text: First menu (sub)
		      url: /first-menu/first-menu-sub/
		      subitems:
		        - text: First menu (sub-sub)
		          url: /first-menu/first-menu-sub/first-menu-sub-sub/
	
	When we're looping the first level of menu items, one of the items is **"First menu"** with this URL: `/first-menu/`

	**Now `{% raw %}{% if item.subitems and navurl contains item.url %}{% endraw %}` means:  
	We're displaying subitems for "First menu" whenever the URL of the current page *(`navurl`)* contains the URL of "First menu" *(`item.url`)*.**

	&rarr; When the current page is any of the three in the example above, each one's URL contains `/first-menu/`, so the subitems of **"First menu"** will be shown in all three cases.

0. We're showing the subitems by including `nav.html` again, only this time we're passing the subitems of the current menu item:

	{% raw %}

		{% include nav.html nav=item.subitems %}

	{% endraw %}

	So it will do everything I just described again, only one level deeper in the menu: it will loop the subitems that we just passed, include itself again if the subitems have subitems themselves, and so on.  
	That's all!

---

## Gotchas

When converting my site, I found one example that doesn't work 100% well with the approach I just described: when the **Home** link *(that points to the root `/`)* has subitems.

The problem is that *all* the URLs contain the URL of the root (`/`), which means that the root's subitems will always be shown, no matter which page is the current page.

I solved this by changing the URL of the **Home** menu item to `/home/`:

	- text: Home
	  url: /home/
	  subitems:
	    - text: Introduction
	      url: /home/introduction/

This fixes the problem that **Home**'s subitems are always displayed.  
Then, I just put an empty `index.html` *(with a [meta refresh](http://en.wikipedia.org/wiki/Meta_refresh) to `/home/`)* into the root folder, so everyone who visits `/` gets redirected to `/home/`.

I'm not sure if this is the best solution SEO-wise, but it's good enough for me because the site in question doesn't get much traffic anyway...and probably never will in the future.

---

## Example code

You can find a complete code example [on GitHub](https://github.com/christianspecht/code-examples/tree/master/jekyll-dynamic-menu).  
Usually I would ignore the folder with the generated site, but in this case I committed it as well, so you can see the result without having to build first.
