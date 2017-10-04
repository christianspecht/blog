---
layout: post
title: "Running a combined Jekyll/PHP site on XAMPP"
date: 2017/10/04 18:14:00
tags:
- jekyll
- php
- web
codeproject: 1
---

Why this combination?  
Some would say that using it together with a server-side language defeats the purpose of a static site generator, but in my opinion it makes sense in certain cases.

I think my case is one of those where it *does* make sense:

Recently, I built [Sindorf trödelt](https://sindorf-troedelt.de/), a website for an annual garage sale in my home town, and I went with a combined Jekyll/PHP approach.  
Jekyll for the static part because I have a lot of experience with it, and PHP for the dynamic part because I'm already paying for webspace which is able to run it.

The site has only a few dynamic parts which *really* need to be done in a server-side language:

0. A registration form for people who participate as sellers.

0. Updating registrations later to mark them as "paid", either automatically via PayPal webhook, or via web interface for those who pay via bank transfer.

0. The addresses of those who have paid are listed in a table, and shown as markers on a Google Map.  
   This data is updated once a day via cronjob.

Everything else is just static information and changes only occasionally.


At first glance, it makes sense to just build a complete dynamic site in a server-side language, but there are reasons against it:

0. Scale  
   There's a lot less load on the server when most of the pages, including the landing page, are just static HTML.    
   No need to waste CPU cycles on each request, to regenerate stuff which almost never changes.  
   This is probably more important for sites with far more visitors than mine...but on the other hand, it enables you to run a site with average visitor numbers on *really* cheap webspace.

0. Familiarity with tools  
   I'm far more experienced with Jekyll than with PHP, especially when it comes to layouts/templates, and setting lots (and I mean *lots*) of configuration values depending on environment (dev/staging/prod).  
   This is probably equally easy in PHP if you know how to do it...but *I* already know how to do it in Jekyll.

It's mainly the second reason why I decided to go with the combined Jekyll/PHP approach. Even though it was "only" a hobby project which I built in my spare time, I still had a deadline because the date for the flea market was fixed, and people should be able to register X months before.

Plus, my spare time is still my spare time, so I didn't want to spend time learning templating frameworks in PHP, when I already know how to do everything I need in Jekyll/Liquid.

---

## The basic idea

I'm building most of the site like a regular Jekyll site - it has [config files](http://jekyllrb.com/docs/configuration/), [layouts](http://jekyllrb.com/docs/templates/), [includes](http://jekyllrb.com/docs/includes/), [a simple dynamic menu](https://learn.cloudcannon.com/jekyll/simple-navigation/) and so on.

The PHP pages are created with Jekyll too, so they can contain front-matter, includes, config variables etc. as well - it's just that they are `.php` files and contain `<?php ... ?>` sections.

Here's an example, `/register/index.php`:
	
{% raw %}

	---
	title: Seller Registration
	layout: default
	---
	
	{% if site.registration_enabled == 0 %}
	    Registration is not possible at the moment!
	    {% include under_construction.html %}
	{% else %}
	
	<?php
	if ($_SERVER['REQUEST_METHOD'] == 'POST') {	
	    // save registration in database
	} else {
	    // process "registration page" Mustache template
	}
	?>

	{% endif %}

{% endraw %}

The Jekyll parts are rendered when building the site on my local machine.  
So the file that goes onto the server already has my site's layout etc. and is mostly static, except for the `<?php ... ?>` part which will be executed at runtime by the server - but if the configuration value `registration_enabled` is set to `0`, the whole `<?php ... ?>` part is omitted from the output.

This means that I have to re-build and re-upload the site in order to enable/disable registration, but I can live with that.

Obviously I don't use GitHub Pages because part of the site is written in PHP, but I already [scripted the process of building and FTP'ing a Jekyll site](https://stackoverflow.com/a/21223950/6884) in the past, and I did the same with this site. So updating the site just means: running a batch file and waiting about a minute.

---

## Getting this to run on XAMPP

A combined Jekyll/PHP page like the one just shown is ready to be hosted on any cheap LAMP webhoster. But to be able to test the PHP parts on my local machine before uploading, I needed to do some more work.

Building and running this locally via `jekyll serve` is basically possible, but of course Jekyll's built-in webserver isn't able to process the PHP pages.

So because I already know [XAMPP](https://www.apachefriends.org), I'm running the site in XAMPP.

The whole project needs to be in XAMPP's `htdocs` folder in order to use XAMPP's webserver. On my machine, it's `C:\xampp\htdocs\sindorf-troedelt\src`.

The finished site will go to `C:\xampp\htdocs\sindorf-troedelt\site`, which means that the URL on my local machine will be `localhost/sindorf-troedelt/site`.

Because of this, all links and URLs **must** be created by prepending `{% raw %}{{site.url}}{% endraw %}` and using [multiple](https://stackoverflow.com/a/31296591/6884) [config files](https://stackoverflow.com/a/26635715/6884), e.g.:

`/_config-xampp.yml`

	url: http://localhost/sindorf-troedelt/web/site

`/_config-prod.yml`

	url: https://sindorf-troedelt.de

Example link in a Markdown page:

{% raw %}

	[Link text]({{site.url}}/register/)

{% endraw %}

---

## Using Jekyll config variables in PHP

Speaking of multiple config files: my site has **lots** of config variables, most of them depending on the current environment (local/staging/prod).

Some of those variables are only for Jekyll *(like the `site.registration_enabled` shown above)*, but some are used inside PHP code as well.

Using a Jekyll variable in PHP is simple:

{% raw %}

	<?php
	$site_url = '{{site.url}}';
	?>

{% endraw %}

...but I didn't want to have PHP code like this *(with Jekyll/Liquid hidden inside)* sprinkled all over the place.

So I created *one* central PHP include file, where I declared all "config" variables which I needed in PHP:

`/inc/config.inc.php`:

{% raw %}

	---
	layout: null
	---

	<?php

	// basics
	$site_url = '{{site.url}}';
	$site_environment = '{{site.environment}}';

	// database
    $db_host = '{{site.db_host}}';
    $db_name = '{{site.db_name}}';
    $db_user = '{{site.db_user}}';
    $db_pass = '{{site.db_pass}}';

	?>

{% endraw %}

To use those values in another PHP file, you need to include the first file and [declare the variable global](http://php.net/manual/en/language.variables.scope.php):

{% raw %}

	<?php
	require_once '../inc/config.inc.php'; 
	global $site_url;
	echo $site_url;
	?>

{% endraw %}


Plus, it's possible to use more complex config values in PHP as well.

My site has a list of possible payment options in the config file:

	payment_options:
	    - Bank transfer
	    - PayPal

These values are always the same for dev/staging/prod, but I needed them in Jekyll/Liquid code and PHP code, and I wanted to avoid defining them in two different places.

So I put this into the `inc/config.inc.php` file shown above:

{% raw %}

	$payment_options = array();
	{% for p in site.payment_options %}$payment_options [] = '{{p}}';
	{% endfor %}

{% endraw %}

After Jekyll has rendered the PHP file, it will look like this:

	$payment_options = array();
	$payment_options [] = 'Bank transfer';
	$payment_options [] = 'PayPal';

---

## Server Side Includes

In addition to PHP, I'm also using [Server Side Includes](https://en.wikipedia.org/wiki/Server_Side_Includes) on one page.

I already mentioned before that my garage sale site has a cronjob which runs once a day, loads the addresses of all registrations which are marked as "paid" and creates:

0. a JavaScript file with GPS coordinates to show markers on [this map](https://sindorf-troedelt.de/karte/) *(which was created similar to [this one]({% post_url 2015-01-22-creating-a-holiday-map-in-google-maps %}))*
0. a HTML file with a table *(containing all addresses ordered by street)*, which is loaded into [this page](https://sindorf-troedelt.de/adressliste/)

*Note: both pages are only enabled in the months before the garage sale (usually September), so you may not see the map and the list, depending on when you visit the links.*

The second file is what I'm using SSI for.  
Some say SSI [doesn't make sense when you're able to use PHP's `include` or `file_get_contents`](https://stackoverflow.com/a/13728881/6884), but I prefer SSI here because I'm including the table into a static HTML page.  
I'd have to change that to a PHP file to include the table with PHP, and this page will be hit **a lot** at the garage sale day and the days before, so I prefer static HTML and SSI to minimize the load on the server.

Technically, it's similar to the combined Jekyll/PHP pages shown before, but in order for SSI to work, the file usually has to be a `.shtml` or `.shtm` file (depending on the server configuration).

Here's an example:

`/addresses/index.shtml`

{% raw %}

	---
	title: Address List
	layout: default
	---
	
	{% if site.list_enabled == 0 %}
	    List is disabled at the moment
	    {% include under_construction.html %}
	{% else %}
	{{site.address_include}}
	{% endif %}

{% endraw %}

The most difficult part of this was getting the `{% raw %}{{site.address_include}}{% endraw %}` value in the config files right.

The path has to be relative from the root, but the root is different depending on the environment:

On the real server, it's in a subdirectory of the root:

	address_include: '<!--#include virtual="/data/addresses.html" -->'

...but for XAMPP, this directory is a few levels beneath `htdocs`:

	address_include: '<!--#include virtual="/sindorf-troedelt/web/site/data/addresses.html" -->'

---

## Mustache templates

I'm using the [PHP implementation of Mustache](https://github.com/bobthecow/mustache.php) for templates.

Both Mustache and Jekyll use double curly brackets as placeholders, **so you should load your Mustache templates from external files without front-matter, so they definitely won't be touched by Jekyll!**

I know this, because I made the same mistake. I just wanted to run a small example in order to see that Mustache was working properly, so I copied one of the examples from the Mustache documentation directly into my PHP source code:

{% raw %}

	<?php
	$m = new Mustache_Engine;
	echo $m->render('Hello {{planet}}', array('planet' => 'World!')); // "Hello World!"

{% endraw %}

...and Mustache displayed "Hello ", and didn't render the variable.

What I didn't take into account was the fact that this particular PHP page had YAML front-matter, so it was processed by Jekyll when building the site.

Jekyll replaced `{% raw %}{{planet}}{% endraw %}` by an empty string, because it didn't have a variable named `planet`.  
When Mustache finally executed, the template "Hello " didn't contain any variables anymore, so Mustache didn't do anything nothing and "Hello " was displayed.

This whole problem just goes away when you load the templates at runtime from external files.  
Because of this, and to be able to render templates with the absolute minimum amount of code possible, I created this helper function:

{% raw %}
	
    class Data {
        // empty helper class for Mustache
    }

    function template($template, $data) {

        $tpl_path = '{{site.template_path}}';

        $tpl = new Mustache_Engine(array(
            'loader' => new Mustache_Loader_FilesystemLoader($tpl_path.'tpl'),
            'cache' => $tpl_path.'tplcache',
        ));
        
        return $tpl->render($template, $data);
    }

{% endraw %}

`site.template_path` *(you guessed it)* is a value from the config files again, and again it depends on the environment.

For XAMPP, it's just:

	template_path: C:\xampp\htdocs\sindorf-troedelt\web\site\templates\

But for my webspace, it must be the complete part from the root *of the whole server*:

	template_path: /www/htdocs/my-user-name/sindorftroedelt/templates/

`/www/htdocs/my-user-name/` is the root of "my part" of the server. So when I FTP into the webspace I have rented, the directories that I see are `/sindorftroedelt/templates/`.

With this helper function, I can render a Mustache template from PHP like this:

	$data = new Data();
	$data->whatever = 'blah';
	echo template('foo', $data);

...given that there is a template in a file named `foo.mustache` inside the `/templates/tpl` directory.

