---
title: How to display Markdown files from other sites...this time in Blogofile
date: 2013/02/17 22:51:00
categories: Markdown, Blogofile, PHP
---

This is a follow-up to [How to display Markdown files from other sites in WordPress](http://christianspecht.de/2012/03/09/how-to-display-markdown-files-from-other-sites-in-wordpress).

When I [migrated this site from WordPress to Blogofile](http://christianspecht.de/2013/01/29/switched-from-wordpress-to-blogofile), I had the same problem again: How do I display Markdown files from external URLs on Blogofile pages?

Based on the previous solution I found for WordPress, I found a similar one that works **for me**.

**Warning: It certainly doesn't work for everyone, because it involves using PHP on the web server.**  
Yes, this somehow defeats the purpose of a static site generator.  
But the project pages are the only ones that I actually **want** to be dynamic...I don't want to update the site manually each time I edit one of my project readme files.

There are probably other ways to do this, like loading the content on the client with JavaScript.  
But I'm not a JavaScript guru, my server runs PHP and I already know how to do it in PHP...so I'll stay with PHP for now.

The code is nearly the same that I used for the shortcode in WordPress *(load Markdown file from URL and use [PHP Markdown](http://michelf.ca/projects/php-markdown/) to convert to HTML)*, only this time I put it into a new PHP [file](https://bitbucket.org/christianspecht/blog/src/e745c8d2880e71a6573cf696f30faa8c147ac062/src/php/md-include.php?at=default):

$$code(lang=php)

<?php

include_once "markdown.php";

function GetMarkdown($url) {

    $result = @file_get_contents($url);

    if ($result === false)
    {
        return "Could not load $url";
    }
    else
    {
        return Markdown($result);
    }
    
}

?>

$$/code

The `markdown.php` file, which contains PHP Markdown, needs to be in the same folder.

To put this into a Blogofile page, I created a new Mako template with the extension `.php.mako` *(so it will be a `.php` file after compiling)* and just inserted this PHP code instead of the "normal" content:

$$code(lang=php)

<?php
include_once "../php/md-include.php";
echo GetMarkdown("https://bitbucket.org/christianspecht/bitbucket-backup/raw/tip/readme-full.md");
?>

$$/code

The rest of the template looks exactly like a normal Mako template (`<%inherit file="site.mako" />`, etc.).  
When compiling, Blogofile creates the page as usual, only that it has the above PHP code as the content, which will be executed by the web server on each request.

Again, you can see it in action on all the project pages.  
(example: [raw Markdown file](https://bitbucket.org/christianspecht/bitbucket-backup/raw/tip/readme-full.md) &rarr; [final project page](http://christianspecht.de/bitbucket-backup))