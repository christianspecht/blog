---
layout: post
title: "Hugo/Lightbox image gallery: Overlay images with logo"
date: 2022/09/15 22:00:00
tags:
- hugo
- lightbox2
- web
externalfeeds: 1
---

Another nice addition to the [Hugo/Lightbox2 image gallery]({% post_url 2020-08-10-creating-an-image-gallery-with-hugo-and-lightbox2 %}): one of Hugo's available image filters [is able to overlay the gallery images with a logo](https://gohugo.io/functions/images/#overlay).

Before we start, here's the previous version of the gallery shortcode *(including [the EXIF caption from the last post]({% post_url 2022-06-29-hugo-lightbox-image-gallery-loading-image-captions-from-exif-data %}))* for reference:

`/layouts/shortcodes/gallery.html`:

{% raw %}
	{{ $image := (.Page.Resources.ByType "image") }}
	{{ with $image }}
		{{ range . }}
		{{ $resized := .Fill "150x115 q20" }}
		<a href="{{ .Permalink }}" data-lightbox="x" data-title="{{ with .Exif }}{{ .Tags.ImageDescription }}{{ end }}"><img src="{{ $resized.Permalink }}" /></a>
		{{ end }}
	{{ end }}
{% endraw %}

Like in the previous post, I will add the changes shown here as new commits in the [`hugo-gallery-example` project in my `code-examples` repository](https://github.com/christianspecht/code-examples/tree/master/hugo-gallery-example).

---

## Step 1: show logo

In order to be processed by Hugo, images must be [either page resources or global resources](https://gohugo.io/content-management/image-processing/#image-resources).  
The gallery images are page resources anyway, but the logo that will overlay all gallery images doesn't belong to one single page. So it has to be a global resource.

The simplest way to make it a global resource is [putting it into the `assets` folder](https://gohugo.io/content-management/image-processing/#global-resources).

Once it's there, it can be applied to all gallery images by:

- loading the logo with `resources.Get`
- applying the filter, which overlays the gallery image with the logo
- showing the changed image in the gallery instead of the original one

[Here's the commit](https://github.com/christianspecht/code-examples/commit/cbc2686c0e1d6dad603eaa09f4ebddf268fcc9dc) with the changes.

The complete changed shortcode now looks like this:

{% raw %}
	{{ $logo := resources.Get "img/overlay-logo.png" }}
	{{ $image := (.Page.Resources.ByType "image") }}
	{{ with $image }}
		{{ range . }}
		{{ $resized := .Fill "150x115 q20" }}
		{{ $withlogo := .Filter (images.Overlay $logo 10 10)}}
		<a href="{{ $withlogo.Permalink }}" data-lightbox="x" data-title="{{ with .Exif }}{{ .Tags.ImageDescription }}{{ end }}"><img src="{{ $resized.Permalink }}" /></a>
		{{ end }}
	{{ end }}
{% endraw %}

---

## Step 2: move to bottom right

The coordinates are from the top left, so `images.Overlay $logo 10 10` means 10 pixels from the top and 10 pixels from the left.

But I wanted to have the logo at the bottom right, so I needed to calculate the correct pixel values depending on the sizes of the gallery image and the logo.

The calculation itself is not difficult. All images in Hugo have properties for width and height, so I can access `$logo.Width` and `$logo.Height` *(for the logo)* and `.Width` and `.Height` *(for the current gallery image)*.

For example, the correct `x` value for the logo's top left corner *(so that its bottom right corner is 10 pixels away from the right and from the bottom)* is `.Width - $logo.Width - 10`, 

Here's some fancy ASCII art to visualize:

	┌───────────────────────────────────────────────┐
	│                                               │
	│                                               │
	│                                               │
	│                                               │
	│                          ┌─────────────┐      │
	│                          │     LOGO    │      │
	│                          └─────────────┘      │
	│<---------- x -----------><-$logo.Width-><-10->│
	│                                               │
	└───────────────────────────────────────────────┘
	    
	<-------------------- .Width ------------------->

Same for the height: `.Height - $logo.Height - 10`

But I spent an insane amount of time getting the syntax right. The problem was the (for me) unusual syntax of [Hugo's template functions](https://gohugo.io/templates/introduction/#functions).

Getting used to the {% raw %}`{{ name parameter1 parameter2 }}`{% endraw %} format and finding [the correct math functions](https://gohugo.io/functions/math/) was one thing, but nesting two of these calls with all the correct brackets made my brain hurt.

But actually I just had to change this:

{% raw %}
	{{ $withlogo := .Filter (images.Overlay $logo 10 10)}}
{% endraw %}

...into this:

{% raw %}
	{{ $x := sub .Width (add $logo.Width 10) }}
	{{ $y := sub .Height (add $logo.Height 10) }}
	{{ $withlogo := .Filter (images.Overlay $logo $x $y)}}
{% endraw %}


Here's [the commit](https://github.com/christianspecht/code-examples/commit/53554ac1c7d728ae5c09574e310a732d6023fa1e), and finally here's the complete changed shortcode again:

{% raw %}
	{{ $logo := resources.Get "img/overlay-logo.png" }}
	{{ $image := (.Page.Resources.ByType "image") }}
	{{ with $image }}
		{{ range . }}
		{{ $resized := .Fill "150x115 q20" }}
		{{ $x := sub .Width (add $logo.Width 10) }}
		{{ $y := sub .Height (add $logo.Height 10) }}
		{{ $withlogo := .Filter (images.Overlay $logo $x $y)}}
		<a href="{{ $withlogo.Permalink }}" data-lightbox="x" data-title="{{ with .Exif }}{{ .Tags.ImageDescription }}{{ end }}"><img src="{{ $resized.Permalink }}" /></a>
		{{ end }}
	{{ end }}
{% endraw %}



Once again, I am amazed by Hugo's image manipulation features.

With these few lines of template code, I can now auto-create a thumbnail, pull the image title from the image's EXIF data *and* overlay the image with a logo.
