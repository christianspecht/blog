---
layout: post
title: Using jQuery to integrate SimpleLeague tables into Jekyll sites
date: 2014/11/23 18:41:00
tags:
- jekyll
- web
- simpleleague
---

When I started building [SimpleLeague](/simpleleague/) last year, I needed it to show results and league tables in an existing website, built with a PHP-based CMS. So I just used [PHP's `include`](http://php.net/manual/en/function.include.php), with [`allow_url_include`](http://www.php.net/manual/en/filesystem.configuration.php#ini.allow-url-include) enabled to load the SimpleLeague tables from a subdomain of the site's URL.

This summer, I needed to re-think my previous approach, because I ditched the CMS and converted the whole site to Jekyll.  
I planned to keep the site running on the same server as before *(rented webspace with Apache/PHP)*, so the path of least resistance would have been to generate all pages with SimpleLeague tables as `.php` files and continue using PHP's `include`.

But I didn't like the idea, because creating `.php` files with a static site generator has one huge disadvantage that I already noticed when I built the [project pages]({% post_url 2013-02-17-how-to-display-markdown-files-from-other-sites-this-time-in-blogofile %}): the local testing server `jekyll serve` *(or `blogofile serve` before, when I was using [Blogofile](http://www.blogofile.com/))* isn't able to display them.

So I wanted a different approach for the SimpleLeague pages: create plain HTML files with Jekyll, and load the dynamic content from a different URL via JavaScript/[jQuery](http://jquery.com/)/whatever.

In the end, I chose to use [jQuery's `load` function](http://stackoverflow.com/a/16755565/6884). 

**Note that this approach will only work as long as the "host" site and the loaded URLs are under the same domain, due to the [same-origin policy](https://en.wikipedia.org/wiki/Same-origin_policy).**

**If that's a problem for you, then you can [relax the same-origin policy](https://en.wikipedia.org/wiki/Same-origin_policy#Relaxing_the_same-origin_policy).  
However, this wasn't necessary for me because as I said in the beginning: my server is running on Apache anyway, so it's able to host Jekyll's static pages as well as SimpleLeague's PHP files. So I just put the SimpleLeague files into Jekyll's `src` folder, under `/src/php/simpleleague/`.** 

Now back to jQuery's `load` - the basic idea is this:

	<div id="whatever"></div>

	<script type="text/javascript">
	$(document).ready(function() {
	    $('#whatever').load('http://url-to-load');
	});
	</script>

...which will insert the HTML from `http://url-to-load` into the `div` named "whatever".

This works as-is, but I didn't want to copy and paste this on each and every page where I need a SimpleLeague table, so I needed some more Jekyll integration.

---

## Building Jekyll includes

The easiest way to insert the same code snippet on multiple Jekyll pages is to create an [include file](http://jekyllrb.com/docs/templates/#includes).

So the first step is this basic include file which I'll use for all SimpleLeague URLs:

#### `/_includes/simpleleague.html` :

	{% raw %}

    <div id="sl-{{ include.divname }}"></div>
    <script type="text/javascript">
    $(document).ready(function() {
        $('#sl-{{ include.divname }}').load('{{ site.simpleleague_url }}{{ include.url }}');
    });
    </script>
    
	{% endraw %}

*(I'm prefixing the id of the div with `sl-`, to avoid collisions with the ids on the host site.)*

Plus, the `simpleleague_url` must be added to the config file:

#### `/_config.yml` :

    simpleleague_url: /php/simpleleague/

Both of this is already enough to load a SimpleLeague table with one line of code:

	{% raw %}

	{% include simpleleague.html divname='players' url='season_players/?season_name=2014' %}

	{% endraw %}

...which will generate the following HTML:

	<div id="sl-players"></div>
	<script type="text/javascript">
	$(document).ready(function() {
	    $('#sl-players').load('/php/simpleleague/season_players/?season_name=2014');
	});
	</script>

Using the include shown above works well, but it's still too much to type for my liking - I need this on *many* pages, often multiple times on each page.

---

## Separate includes

For each SimpleLeague URL, I created a separate include file that wraps `simpleleague.html`:

#### `/_includes/season_players.html` :

	{% raw %}

	{% assign tmp = 'season_players/?season_name=' | append: include.season %}
	{% include simpleleague.html divname='season' url=tmp %}

	{% endraw %}

Now I can shorten the include calls to this:

	{% raw %}

	{% include season_players.html season='2014' %}

	{% endraw %}

This approach has only one disadvantage: Building the URL like this (`assign | append`) gets messy if there are multiple parameters.

But I can live with that, because I need to create the include files only once.   Including them into the actual pages later is just a one-liner...and that's much more important.

---

## The finished includes for all SimpleLeague URLs

*Don't forget - you also need the `simpleleague.html` shown above!*

---

#### `/_includes/alltime_allresults.html` :

	{% raw %}

	{% include simpleleague.html divname='alltime' url='alltime_allresults/' %}

	{% endraw %}

---

#### `/_includes/round_results.html` :

	{% raw %}

	{% assign tmp = 'round_results/?season_name=' | append: include.season | append: '&round_number=' | append: include.round %}
	{% include simpleleague.html divname='results' url=tmp %}

	{% endraw %}

---

#### `/_includes/season_crosstab.html` :

	{% raw %}
	
	{% assign tmp = 'season_crosstab/?season_name=' | append: include.season %}
	{% include simpleleague.html divname='crosstab' url=tmp %}

	{% endraw %}

---

#### `/_includes/season_players.html` :

	{% raw %}

	{% assign tmp = 'season_players/?season_name=' | append: include.season %}
	{% include simpleleague.html divname='players' url=tmp %}

	{% endraw %}

---

#### `/_includes/season_ranking.html` :

	{% raw %}
	
	{% assign tmp = 'season_ranking/?season_name=' | append: include.season | append: '&round_number=' | append: include.round %}
	{% include simpleleague.html divname='ranking' url=tmp %}

	{% endraw %}

---

#### `/_includes/season_schedule.html` :

	{% raw %}

	{% assign tmp = 'season_schedule/?season_name=' | append: include.season %}
	{% if include.round %}
	    {% assign tmp = tmp | append: '&round_number=' | append: include.round %}
	{% endif %}
	{% include simpleleague.html divname='schedule' url=tmp %}

	{% endraw %}

---

## Supporting more features

Note that the includes featured here show the simplest approach possible. Some of the SimpleLeague URLs have optional parameters that I didn't include here for the sake of simplicity.

For example, SimpleLeague allows you to pass the name of a custom template, which will then be used instead of the default one.

If you **always** need the same custom template, you can just change this:

	{% raw %}

	{% assign tmp = 'season_players/?season_name=' | append: include.season %}

	{% endraw %}

...to this:

	{% raw %}

	{% assign tmp = 'season_players/?custom_template=whatever&season_name=' | append: include.season %}

	{% endraw %}


If you need to change the template conditionally instead, you can add the following before passing the url to `simpleleague.html`:

	{% raw %}

	{% if include.template %}
	    {% assign tmp = tmp | append: '&custom_template=' | append: include.template %}
	{% endif %}

	{% endraw %}

---

## Local testing

All of the above works on my actual server, which is running on Apache and is able to serve the static pages that Jekyll generates, **and** PHP.

But this approach doesn't work when I'm testing the site locally on my machine, because `jekyll serve` has no clue what to do with PHP pages.

So the only solution is to load the PHP stuff from a different URL - for example from the actual one on the web, or from a PHP server that runs on my local machine, like [XAMPP](https://www.apachefriends.org).

But there's the problem again that jQuery won't [`load`](http://api.jquery.com/load/) HTML from a different domain/subdomain/port than Jekyll's `http://localhost:4000`.

I'm using Google Chrome, so I can work around this by starting Chrome with the [`-disable-web-security` parameter](http://stackoverflow.com/a/3177718/6884).  
With security disabled, I can simply swap out the URL by [using a separate config file to hold my production settings](http://stackoverflow.com/a/26635715/6884):


#### `/_config.yml` :

	# local XAMPP URL
    simpleleague_url: http://localhost/simpleleague/src/

#### `/_config-prod.yml` :

	# production URL
    simpleleague_url: /php/simpleleague/    

---

## The same, but without disabling security

If you do **not** want to go the `-disable-web-security` way, there's also the possibility to replace the jQuery stuff by an iFrame.

Just change `/_includes/simpleleague.html` to this:

	{% raw %}

    {% if site.simpleleague_frame == 1 %}
    <iframe frameborder="0" height="500" width="500" name="{{ include.divname }}" src="{{ site.simpleleague_url }}{{ include.url }}"></iframe>
    {% else %}
    <div id="sl-{{ include.divname }}"></div>
    <script type="text/javascript">
    $(document).ready(function() {
        $('#sl-{{ include.divname }}').load('{{ site.simpleleague_url }}{{ include.url }}');
    });
    </script>
    {% endif %}
    
	{% endraw %}

... and set `simpleleague_frame` appropriately in the config file:

#### `/_config.yml` :

    simpleleague_frame: 1

#### `/_config-prod.yml` :

    simpleleague_frame: 0


