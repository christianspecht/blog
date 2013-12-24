---
layout: post
title: How to display Markdown files from other sites in WordPress
date: 2012/03/09 20:53:40
tags: [markdown, php, wordpress]
---

When I created the pages for my existing projects on this blog, I decided that I'd prefer to directly display the content of the readme files from [Bitbucket](https://bitbucket.org/) (where all of my projects are hosted), instead of just copying the content.


So the readme would be under source control as well, and the project pages on this site would update automatically each time I push changes to the repository.


This blog is running on WordPress and the readme files are written in Markdown, but I couldn't find a plugin to display a Markdown file from an external URL in WordPress.


What I did find was [this answer on the WordPress site on Stack Exchange](http://wordpress.stackexchange.com/a/26194), where the answerer suggested to "parse the markdown file and show the contents in the page with some method, say with shortcode".

That's exactly what I wanted, so I just had to figure out how to make WordPress do this.  
Here's a complete walkthrough:

1. Install [PHP Markdown](http://michelf.com/projects/php-markdown/) as a plugin in WordPress
(see the link for instructions)
2. Install the [Shortcode Exec PHP](http://wordpress.org/extend/plugins/shortcode-exec-php/) plugin for WordPress
3. In the WordPress admin panel, go to the **Shortcode Exec PHP setup page** (it's in the `Tools` menu)
4. Create a new shortcode, give it any name you want and paste the following PHP code:

		include_once $_SERVER['DOCUMENT_ROOT'] . "wp-content/plugins/markdown.php";
		
		$result = @file_get_contents($content);
		
		if ($result === false)
		{
			$html = "Could not load $content";
		}
		else
		{
			$html = Markdown($result);
		}

		echo $html;

Paste it exactly like shown here, don't use `<?php` tags etc.

The `include_once` in the first line includes the PHP Markdown plugin installed in step 1.  
This is the path where it's located on **MY** server - don't know if the path is the same in all WordPress installations.

Now, I can display my Bitbucket readme files, or other Markdown files from another server, by using the following shortcode on any WordPress page:  
(where `readme-md` is the name given to the shortcode in step 4)

	[readme-md]https://bitbucket.org/christianspecht/bitbucket-backup/raw/tip/readme-full.md[/readme-md]  

That's it!  
You can see it in action in any of the "projects" links on this site, for example [here](/bitbucket-backup) (with exactly the readme file from the above example).

**Disclaimer:**  
I'm completely new to WordPress, and the last time I used PHP must have been around 2004.  
So maybe my way is not the most elegant way to do this - but at least this worked for me using the following versions:

- WordPress 3.3.1
- PHP Markdown 1.0.1o
- Shortcode Exec PHP 1.41