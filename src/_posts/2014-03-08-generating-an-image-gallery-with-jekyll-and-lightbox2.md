---
layout: post
title: Generating an image gallery with Jekyll and Lightbox2
date: 2014/03/08 19:04:00
tags: 
- jekyll
- web
codeproject: 1
---

For a Jekyll-powered site that I'm building, I needed an image gallery. I browsed the ["Sites built with Jekyll" list](https://github.com/jekyll/jekyll/wiki/Sites) in Jekyll's GitHub wiki to see how others do galleries with Jekyll, but I didn't find a site that used any kind of "real" image gallery *(besides stuff like just showing thumbnails from Flickr and then linking directly to Flickr to display the actual image, which is not what I wanted)*.

I guess Jekyll is mostly used by programmers to create blogs about programming, so most Jekyll users don't want/need a gallery. Without a ready-made example to borrow from, I had to create something by myself.

---

## FancyBox or Lightbox2?

For a start, I needed an "image displaying" script.  
The standard these days seems to be [FancyBox](http://fancybox.net/) *(at least that's my impression)*, and I also evaluated [Lightbox2](http://lokeshdhakar.com/projects/lightbox2/).  
With FancyBox, I had some problems with the relative paths to the "helper images" *(stuff like left/right arrows)* that I didn't have with Lightbox2. So I just took the path of least resistance and used Lightbox2.

The actual site for which I created this gallery is private (as well as its source code), so I can't show it here.  
Instead, I built a small example site *(with Jekyll's standard template and the [example images that come with Lightbox2](http://lokeshdhakar.com/projects/lightbox2/#examples))* and put the source code on Bitbucket.  
You can view [the source code here](https://bitbucket.org/christianspecht/code-examples/src/tip/jekyll-gallery-example/) and [the finished site here](http://jekyll-gallery-example.christianspecht.de/galleries/).

---

## Creating a data file

First, I created one [data file](http://jekyllrb.com/docs/datafiles/) to hold all images of all image galleries.  
In my first draft I had one data file per gallery, but in the end I went with *one* single file for everything, because that makes it easier to display a list of all available galleries.

[My data file](https://bitbucket.org/christianspecht/code-examples/src/tip/jekyll-gallery-example/_data/galleries.yml) looks like this:

	- id: gallery1
	  description: This is the first gallery
	  imagefolder: /img/demopage
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
	- id: anothergallery
	  description: This is even another gallery!
	  imagefolder: /img/demopage
	  images:
	  - name: image-4.jpg
	    thumb: thumb-4.jpg
	    text: Another gallery, first image
	  - name: image-5.jpg
	    thumb: thumb-5.jpg
	    text: Another gallery, second image
	  - name: image-6.jpg
	    thumb: thumb-6.jpg
	    text: Another gallery, third image

---

## Gallery overview

Since all galleries are inside the same data file, creating the list of galleries on the ["gallery index page"](http://jekyll-gallery-example.christianspecht.de/galleries/) is very simple:

{% raw %}
	{% for gallery in site.data.galleries %}
	- [{{ gallery.description }}]({{ gallery.id }})
	{% endfor %}
{% endraw %}

This just loops through the list of galleries, displays the `description` value and links to a sub-folder with the name of the `id` value.  
[The file](https://bitbucket.org/christianspecht/code-examples/raw/tip/jekyll-gallery-example/galleries/index.md) is a Markdown file, so creating the list of links in Markdown is sufficient.

---

## Sub pages and Lightbox galleries

Next, I created the sub pages with the actual image galleries, the ones that are linked from the gallery index page.

According to the [Lightbox docs](http://lokeshdhakar.com/projects/lightbox2/#how-to-use), the following steps are required to display images with Lightbox:

0. Load jQuery and two Lightbox files (JS and CSS)
0. Show each image on the page with the following HTML:

        <a href="img/image-1.jpg" data-lightbox="image-1" title="My caption">image #1</a>


This means that all sub pages will be identical *(read from YAML data file and generate the HTML descibed above)*, so I put the actual creation of the gallery into a [layout file](http://jekyllrb.com/docs/frontmatter/#predefined_global_variables).

It's still necessary to create a HTML or Markdown file for the actual URL of each gallery, but these files don't need to have any content, just minimal YAML front-matter:
	
	---
	title: the first gallery page
	layout: gallery
	galleryid: gallery1
	--- 

- The line `layout: gallery` points to the layout file that I'll explain next, the one that does all the work.
- The line `galleryid: gallery1` refers to the `id` in the YAML data file, so the layout file knows that it needs to load the pictures of the gallery "gallery1".

This is how the [layout file](https://bitbucket.org/christianspecht/code-examples/src/tip/jekyll-gallery-example/_layouts/gallery.html) looks like:

{% raw %}
	---
	layout: default
	---
		
	<script src="/js/jquery-1.10.2.min.js"></script>
	<script src="/js/lightbox-2.6.min.js"></script>
	<link href="/css/lightbox.css" rel="stylesheet" />
	
	<p>default header for all gallery pages</p>
	
	{% for gallery in site.data.galleries %}
	  {% if gallery.id == page.galleryid %}
	    <h1>{{ gallery.description }}</h1>
	    <ol>
	    {% for image in gallery.images %}
	      <li>
	        {{ image.text }}<br>
	        <a href="{{ gallery.imagefolder }}/{{ image.name }}" data-lightbox="{{ gallery.id }}" title="{{ image.text }}">
              <img src="{{ gallery.imagefolder }}/{{ image.thumb }}">
            </a>
	      </li>
	    {% endfor %}
	    </ol>
	  {% endif %}
	{% endfor %}
	
	<p>default footer for all gallery pages</p>
{% endraw %}

To find the right gallery in the data file, the layout just loops through the data file until it finds a gallery where the `id` property matches the `galleryid` in the front matter of the page.  
Then, it loops through the images in the gallery and creates the necessary "Lightbox HTML" for each one *(with thumbnails and image descriptions)*.

---

### The result

In the end, this gallery *(from the first part of the [data file](https://bitbucket.org/christianspecht/code-examples/src/tip/jekyll-gallery-example/_data/galleries.yml))*:

	- id: gallery1
	  description: This is the first gallery
	  imagefolder: /img/demopage
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

...is transformed into [this HTML](http://jekyll-gallery-example.christianspecht.de/galleries/gallery1/):

    <h1>This is the first gallery</h1>
    <ol>
    
      <li>
        The first image<br>
        <a href="/img/demopage/image-1.jpg" data-lightbox="gallery1" title="The first image">
          <img src="/img/demopage/thumb-1.jpg">
        </a>
      </li>
    
      <li>
        The second image<br>
        <a href="/img/demopage/image-2.jpg" data-lightbox="gallery1" title="The second image">
          <img src="/img/demopage/thumb-2.jpg">
        </a>
      </li>
    
      <li>
        The third image<br>
        <a href="/img/demopage/image-3.jpg" data-lightbox="gallery1" title="The third image">
          <img src="/img/demopage/thumb-3.jpg">
        </a>
      </li>
    
    </ol>

---

## Adding a new gallery

Now that all the plumbing is done, adding a new gallery page is very simple:

- [Add a new gallery with a list of images to the YAML data file](https://bitbucket.org/christianspecht/code-examples/commits/d2e8838fbf8de9d72c6f7dbc5a7320be2acb337c#chg-jekyll-gallery-example/src/_data/galleries.yml)
- [Create a new index page with minimal YAML front-matter for the new gallery](https://bitbucket.org/christianspecht/code-examples/src/tip/jekyll-gallery-example/galleries/anothergallery/index.html)
- Add new images  
  *(note: in the commit linked above, I didn't add any images because they were already there, as I [committed them together with the Lightbox2 download](https://bitbucket.org/christianspecht/code-examples/commits/546861b353037b4c149ff31373fe49f2ef027155), where they came from)*

That's already enough to add [this gallery](http://jekyll-gallery-example.christianspecht.de/galleries/anothergallery/) to [the site](http://jekyll-gallery-example.christianspecht.de/).

*There is also [another blog post]({% post_url 2014-08-22-jekyll-lightbox2-image-gallery-another-approach %}) showing a different approach how to generate image galleries with Jekyll.*


