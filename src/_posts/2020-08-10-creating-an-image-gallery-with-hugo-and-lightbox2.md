---
layout: post
title: "Creating an image gallery with Hugo and Lightbox2"
date: 2020/08/10 23:00:00
tags:
- hugo
- lightbox2
- web
externalfeeds: 1
---

In the last few years, I built multiple static sites with Jekyll. Altogether, I'm happy with Jekyll, but there are a few things that could be better, with the build duration being on top of the list.

I wanted to evaluate another static site generator as an alternative, and I picked [Hugo](https://gohugo.io/) mainly because of its speed (I read multiple sources who said it's **really** fast).

Compared to Jekyll, I find Hugo's learning curve insanely steep, though...and it took me quite some time to grasp enough concepts until I was able to create a basic site.

At that point, I decided to create an image gallery first.  That was one of my first experiments with Jekyll - after getting the basics to run, I built an image gallery with [Lightbox2](https://lokeshdhakar.com/projects/lightbox2/) in two versions ([1]({% post_url 2014-03-08-generating-an-image-gallery-with-jekyll-and-lightbox2 %}), [2]({% post_url 2014-08-22-jekyll-lightbox2-image-gallery-another-approach %})).

Here's how to create the same result with Hugo:

---

## Directory structure

Example code is [here in the `code-examples` repo](https://github.com/christianspecht/code-examples/tree/master/hugo-gallery-example). While explaining the steps, I will link to the specific commit where I actually did the respective step. 

This is Hugo's basic structure for the `content` directory:

    |       
    +---content
    |   \---galleries
    |       |   _index.md
    |       |   
    |       \---gallery1
    |           |   index.md
    |           |   
    |           \---img
    |                   esmeralda.jpg
    |                   notebook.jpg
    |                   Pope-Edouard-de-Beaumont-1844.jpg
    |                   Victor_Hugo-Hunchback.jpg
    
Note the different `_index.md` and `index.md`:

- `_index.md` is an [index page](https://gohugo.io/content-management/organization/#index-pages-_indexmd), which just list its sub-items.
- `index.md` (without underscore) is a "single page", which means an actual content page.

[Here's the commit where I create the project with the `.md` files](https://github.com/christianspecht/code-examples/commit/bbf88f739271456089e2bbacd88d6dfaa9321257).  
Plus, I needed some sample images for the gallery, so I [just copied some](https://github.com/christianspecht/code-examples/commit/b82d5f5455e9edda8c493acad0da29a808f25716) from the [example site provided with the Ananke theme](https://github.com/theNewDynamic/gohugo-theme-ananke/tree/v2.6.2/exampleSite/static/images).

Note the destination directory: the images are in a subdirectory of `/content/galleries/gallery1`, so they are part of `/content/galleries/gallery1/index.md`'s [page bundle](https://gohugo.io/content-management/organization/#page-bundles).  
In Hugo terminology, the images are [page resources](https://gohugo.io/content-management/page-resources/), which means that we can list the current page's images like this:

{% raw %}
    {{ with .Page.Resources.ByType "image" }}
        <ul>
        {{ range . }}
        <li>{{ .Permalink }}</li>
        {{ end }}
        </ul>
    {{ end }}
{% endraw %}

But apparently, it's not possible in Hugo to paste that code directly into the page for testing...so we need to create a shortcode first:

---

## Shortcodes

For those who know Jekyll, Jekyll's includes are called [shortcodes](https://gohugo.io/templates/shortcode-templates/) in Hugo.

Shortcodes allow us to create things we need multiple times (like the code to show an image gallery :-) in a central HTML file - in this case, it's the "list all images" code from the last paragraph:

`/layouts/shortcodes/gallery.html`:

{% raw %}
    {{ with .Page.Resources.ByType "image" }}
        <ul>
        {{ range . }}
        <li>{{ .Permalink }}</li>
        {{ end }}
        </ul>
    {{ end }}
{% endraw %}

...and we can "include" it into other pages like this:

{% raw %}
    {{< gallery >}} 
{% endraw %}

[Here's the commit with the changes](https://github.com/christianspecht/code-examples/commit/a8945355940c45c3feb2039b5a8d525c8eda0e02) - this will eventually become my "show image gallery for the current page" include.

This will output the following HTML:

    <ul>
    <li>http://localhost:1313/galleries/gallery1/img/Pope-Edouard-de-Beaumont-1844.jpg</li>
    <li>http://localhost:1313/galleries/gallery1/img/Victor_Hugo-Hunchback.jpg</li>
    <li>http://localhost:1313/galleries/gallery1/img/esmeralda.jpg</li>
    <li>http://localhost:1313/galleries/gallery1/img/notebook.jpg</li>
    </ul>

---

## Auto-generating thumbnails

This is, besides the insane build speed, one of Hugo's killer features for me: it's able to [batch-manipulate images at build time](https://gohugo.io/content-management/image-processing/), which means that unlike my Jekyll image galleries, I just need to give Hugo the actual images, and it will auto-generate the thumbnails when building the site.

[Here's a simple example](https://github.com/christianspecht/code-examples/commit/ddeda4828f1af949935871fccd76139f27d5dcf3) where I create a thumbnail for each image in the page bundle (150x115 pixels, JPEG quality 20%), and show it together with the original (larger) image:

`/layouts/shortcodes/gallery.html`:

{% raw %}
    {{ $image := (.Page.Resources.ByType "image") }}
    {{ with $image }}
        <ul>
        {{ range . }}
        {{ $resized := .Fill "150x115 q20" }}
        <li>{{ .Permalink }}
            {{ $resized.Permalink }}</li>
        {{ end }}
        </ul>
    {{ end }}
{% endraw %}

This will generate the following HTML:

    <ul>
    <li>http://localhost:1313/galleries/gallery1/img/Pope-Edouard-de-Beaumont-1844.jpg
        http://localhost:1313/galleries/gallery1/img/Pope-Edouard-de-Beaumont-1844_hu28e98c35df2fb9cf55bbe1469dad4e9d_67722_150x115_fill_q20_box_smart1.jpg</li>
    <li>http://localhost:1313/galleries/gallery1/img/Victor_Hugo-Hunchback.jpg
        http://localhost:1313/galleries/gallery1/img/Victor_Hugo-Hunchback_hu0047bfedff79a029a47406b9671745f3_111947_150x115_fill_q20_box_smart1.jpg</li>
    <li>http://localhost:1313/galleries/gallery1/img/esmeralda.jpg
        http://localhost:1313/galleries/gallery1/img/esmeralda_hueb36a26f61b343d8dba9f5eda0997ef5_54891_150x115_fill_q20_box_smart1.jpg</li>
    <li>http://localhost:1313/galleries/gallery1/img/notebook.jpg
        http://localhost:1313/galleries/gallery1/img/notebook_hu3d03a01dcc18bc5be0e67db3d8d209a6_1586565_150x115_fill_q20_box_smart1.jpg</li>
    </ul>
    

Note that in my real test project, I ignored the whole `resources/_gen` directory in source control. The Hugo docs [tell me to commit the manipulated images](https://gohugo.io/content-management/image-processing/#image-processing-performance-consideration), but I chose to ignore them because IMO they're some kind of build artifact (like an executable, which I wouldn't commit either).

For the local developer experience it doesn't matter: on my local machine, Hugo only generates the images on the first build (because it doesn't delete them before subsequent builds).  
And the deploy will happen via CI, so I don't care if the CI server builds a few seconds longer.

However, in the demo project linked here, I **did** commit the generated images.

---

## Putting it all together

With all the "ingredients" prepared, we can now [show the actual image gallery](https://github.com/christianspecht/code-examples/commit/9d50daeb28c3b46e58a4dd191ee7e38f633c5e95) with [Lightbox2](https://lokeshdhakar.com/projects/lightbox2/):

`/layouts/shortcodes/gallery.html`:

{% raw %}
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.1/css/lightbox.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.1/js/lightbox.min.js"></script>

    {{ $image := (.Page.Resources.ByType "image") }}
    {{ with $image }}
        {{ range . }}
        {{ $resized := .Fill "150x115 q20" }}
        <a href="{{ .Permalink }}" data-lightbox="x"><img src="{{ $resized.Permalink }}" /></a>
        {{ end }}
    {{ end }}
{% endraw %}

HTML output:

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.1/css/lightbox.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.1/js/lightbox.min.js"></script>

    <a href="http://localhost:1313/galleries/gallery1/img/Pope-Edouard-de-Beaumont-1844.jpg" data-lightbox="x"><img src="http://localhost:1313/galleries/gallery1/img/Pope-Edouard-de-Beaumont-1844_hu28e98c35df2fb9cf55bbe1469dad4e9d_67722_150x115_fill_q20_box_smart1.jpg" /></a>
    
    <a href="http://localhost:1313/galleries/gallery1/img/Victor_Hugo-Hunchback.jpg" data-lightbox="x"><img src="http://localhost:1313/galleries/gallery1/img/Victor_Hugo-Hunchback_hu0047bfedff79a029a47406b9671745f3_111947_150x115_fill_q20_box_smart1.jpg" /></a>
    
    <a href="http://localhost:1313/galleries/gallery1/img/esmeralda.jpg" data-lightbox="x"><img src="http://localhost:1313/galleries/gallery1/img/esmeralda_hueb36a26f61b343d8dba9f5eda0997ef5_54891_150x115_fill_q20_box_smart1.jpg" /></a>
    
    <a href="http://localhost:1313/galleries/gallery1/img/notebook.jpg" data-lightbox="x"><img src="http://localhost:1313/galleries/gallery1/img/notebook_hu3d03a01dcc18bc5be0e67db3d8d209a6_1586565_150x115_fill_q20_box_smart1.jpg" /></a>
    
This is it - this HTML will display the thumbnails, and clicking on them will open the actual images with Lightbox2.

*Note: there is [one additional commit with a CSS file](https://github.com/christianspecht/code-examples/commit/bcbda057b832681e214d706b3a3c070798dfa6c7) in the demo repo - this is because of the Ananke theme.  
Without that tweak, Ananke's default CSS would stretch all images to the page width and show each one in a new row...which doesn't make any sense for thumbnails.*

---

## Conclusion

So far, I like what I've seen from Hugo.  
As I said before, I find the learning curve insanely steep compared to Jekyll *(and the docs don't explain the basic concepts enough, so my main problem was not knowing the exact terms for the things I was looking for)*.

But once I got past that stage, working with Hugo is very nice because it comes with a lot of stuff built-in, which I needed to do manually in Jekyll, like:

- getting a list of images belonging to a specific page (although I *think* Jekyll has improved in the meantime - I wrote the "Jekyll image gallery" posts in 2014)
- automatic [index pages](https://gohugo.io/content-management/organization/#index-pages-_indexmd)
- and, of course, auto-generating thumbnails!

