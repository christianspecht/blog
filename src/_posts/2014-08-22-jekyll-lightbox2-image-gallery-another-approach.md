---
layout: post
title: Jekyll / Lightbox2 image gallery, another approach
date: 2014/08/22 22:43:00
tags:
- jekyll
- image-gallery
- lightbox2
codeproject: 1
---

In one of my recent posts, I showed [how to build an image gallery with Jekyll and Lightbox2]({% post_url 2014-03-08-generating-an-image-gallery-with-jekyll-and-lightbox2 %}).

The gallery featured there consists of [one index page](http://jekyll-gallery-example.christianspecht.de/galleries/) and [multiple](http://jekyll-gallery-example.christianspecht.de/galleries/gallery1/) [subpages](http://jekyll-gallery-example.christianspecht.de/galleries/anothergallery/), and all the content was dynamically generated out of [a YAML data file](https://bitbucket.org/christianspecht/code-examples/src/e2bf82b87bc2f12cf09baea9443b2195b83ffb46/jekyll-gallery-example/_data/galleries.yml?at=default).

Now I'm building another site with Jekyll, and I needed a slightly different kind of image gallery there:

- multiple long text pages with images on each one
- the pages that contain images are spread across the site, so there's no "index page with subpages" structure
- on one page, there can either be multiple images together, or single images sprinkled between text blocks

With my first gallery approach, this was not possible at all, so I had to think about something new.

---

## The list of images

As the pages with images would be spread across the whole site, it didn't make sense to put the images for all pages in one single YAML data file.  
Instead, I saved them directly in the YAML front-matter of the respective page. So a typical page, using the same demo images like in my first approach, would begin like this:

	---
	layout: default
	title: Gallery with text
	imgfolder: /img/demopage
	images:
	  - name: image-1.jpg
		thumb: thumb-1.jpg
		text: The first image
	  - name: image-2.jpg
		thumb: thumb-2.jpg
		text: The second image
	  - name: image-3.jpg
		thumb: thumb-3.jpg
		text: The third image
	---

---

## Loading jQuery and Lightbox2

First, I needed to load jQuery and Lightbox2's CSS and JS files again.

In my first approach, I had a separate layout file anyway *(with more stuff inside than just jQuery and Lightbox2)*.  
This time, I need **only** jQuery and Lightbox2...in other words, just these three lines:

	<script src="/js/jquery-1.10.2.min.js"></script>
	<script src="/js/lightbox-2.6.min.js"></script>
	<link href="/css/lightbox.css" rel="stylesheet" />

It doesn't make sense at all to create a special layout file for just these three lines, so I put them into an [include file](https://bitbucket.org/christianspecht/code-examples/src/tip/jekyll-gallery-example/_includes/galheader.html) instead, which I can load with:

{% raw %}
	{% include galheader.html %}
{% endraw %}
---

## Displaying the gallery

As already mentioned in the introduction, I needed two different "modes" how to display images:

0. Display a single image
0. Display the complete gallery

I'm using [another include file](https://bitbucket.org/christianspecht/code-examples/src/tip/jekyll-gallery-example/_includes/gal.html) for this, with the following code:

{% raw %}

	{% for image in page.images %}
		{% if include.image == null or include.image == image.name %}
			<a href="{{ page.imgfolder }}/{{ image.name }}" data-lightbox="1" title="{{ image.text }}">
				<img src="{{ page.imgfolder }}/{{ image.thumb }}" title="{{ image.text }}">
			</a>&nbsp;
		{% endif %}
	{% endfor %}

{% endraw %}

This just loops through all the images on the page, and uses Lightbox2 to display either a single image *(if the image's name was passed via `include.image`)* or all images.

So there are two different ways how this file can be included:

0. Show all images defined in the front-matter of the current page:

{% raw %}

	    {% include gal.html %}

{% endraw %}

0. Display a single image:

{% raw %}

	    {% include gal.html image="image-1.jpg" %}

{% endraw %}

---

## The end result

Here is a sample page which features both gallery "modes":

{% raw %}

	---
	layout: default
	title: Gallery with text
	imgfolder: /img/demopage
	images:
	  - name: image-1.jpg
		thumb: thumb-1.jpg
		text: The first image
	  - name: image-2.jpg
		thumb: thumb-2.jpg
		text: The second image
	  - name: image-3.jpg
		thumb: thumb-3.jpg
		text: The third image
	---
	
	{% include galheader.html %}
	
	Two single images:
	
	{% include gal.html image="image-1.jpg" %}
	{% include gal.html image="image-2.jpg" %}
	
	Some text

	...and the complete gallery for this page:
	
	{% include gal.html %}

	Footer text
	
{% endraw %}

This will be rendered to the following HTML *(just the part with the galleries)*:

	<script src="/js/jquery-1.10.2.min.js"></script>
	
	<script src="/js/lightbox-2.6.min.js"></script>
	
	<p><link href="/css/lightbox.css" rel="stylesheet" /></p>
	
	<p>Two single images:</p>
	
	<p><a href="/img/demopage/image-1.jpg" data-lightbox="1" title="The first image"><img src="/img/demopage/thumb-1.jpg" title="The first image"></a></p>
	
	<p><a href="/img/demopage/image-2.jpg" data-lightbox="1" title="The second image"><img src="/img/demopage/thumb-2.jpg" title="The second image"></a></p>
	
	<p>Some text</p>
	
	<p>...and the complete gallery for this page:</p>
	
	<p><a href="/img/demopage/image-1.jpg" data-lightbox="1" title="The first image"><img src="/img/demopage/thumb-1.jpg" title="The first image"></a></p>
	
	<p><a href="/img/demopage/image-2.jpg" data-lightbox="1" title="The second image"><img src="/img/demopage/thumb-2.jpg" title="The second image"></a></p>
	
	<p><a href="/img/demopage/image-3.jpg" data-lightbox="1" title="The third image"><img src="/img/demopage/thumb-3.jpg" title="The third image"></a></p>
	
	<p>Footer text</p>

---

## Example code

A complete example project is [here on Bitbucket](https://bitbucket.org/christianspecht/code-examples/src/tip/jekyll-gallery-example/), and [the finished](http://jekyll-gallery-example.christianspecht.de/gallery-text1/) [gallery pages](http://jekyll-gallery-example.christianspecht.de/gallery-text2/) are online as well, as a part of the example site from the [first blog post]({% post_url 2014-03-08-generating-an-image-gallery-with-jekyll-and-lightbox2 %}).

