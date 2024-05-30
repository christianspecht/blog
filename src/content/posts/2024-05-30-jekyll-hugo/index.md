---
title: "Migrating my blog from Jekyll to Hugo"
date: 2024-05-30T22:00:00
tags:
- jekyll
- hugo
- web
externalfeeds: 1
---

A few weeks ago, I migrated my blog for the third time...after WordPress, [Blogofile]({{< ref "/posts/2013-01-29-switched-from-wordpress-to-blogofile/index.md" >}}) and [Jekyll]({{< ref "/posts/2013-12-31-hello-jekyll/index.md" >}}) it's now powered by [Hugo](https://gohugo.io/).

There's nothing wrong with Jekyll. I just became more proficient with Hugo in the meantime *(I hope I'm behind the steepest part of Hugo's learning curve now...)* and besides its insane build speed, I like the simplicity of installing/updating Hugo (compared to Ruby/Jekyll) on Windows machines.

And not to forget [all the things I learned about processing images with Hugo]({{< ref "/posts/2020-08-10-creating-an-image-gallery-with-hugo-and-lightbox2/index.md" >}}).  
My blog has a few old posts which directly load multiple larger images (e.g. [this one]({{< ref "/posts/2013-06-17-tinkerforge-weather-station-part-1-intro-and-construction/index.md" >}})). The images are not *that* large...but still, it would make more sense to auto-generate thumbnails and load just the thumbnails directly with the post. Not sure if it's worth the effort, I don't have that many posts with large images yet, but who knows...

Even though this is not the first Hugo site I built, I still learned a few new things about Hugo...and noticed some differences between Hugo and Jekyll:

---

## Some things are easier in Hugo

...like getting the number of posts per year, for example.  
Compare [the Jekyll and Hugo versions of the "Archives" box in the sidebar](https://github.com/christianspecht/blog/commit/9816be021377604ef83555c2b0e1012338698316). In Jekyll, I had to create logic for this myself, whereas Hugo supports it out of the box.

---

## Hugo template code works ONLY in templates

In Jekyll, I could just create a page (the [archive]({{< ref "/archive.html" >}}), for example) and write code like this directly in the page:

    {% for post in site.posts %}
      <a href="{{ post.url }}">{{ post.title }}</a>
    {% endfor %}

Hugo just ignores all template code inside regular pages. To build something like the archive page, you need [the actual (empty) page](https://github.com/christianspecht/blog/blob/6f2767c191c92bab234fb771b1cb393d2891a42a/src/content/archive.html), and a [special template](https://github.com/christianspecht/blog/blob/6f2767c191c92bab234fb771b1cb393d2891a42a/src/layouts/page/archive.html) which contains all the logic and is used only by that single page.

---

## Render hooks

Hugo has so-called render hooks, which allow things like auto-prefixing ALL image URLs with the complete site URL.  
In my old Jekyll site, I created all hyperlinks (in all templates and in all Markdown pages) without domain, e.g. `/page.html`.

When I switched to Hugo, I decided to use "proper" hyperlinks with full URLs (`https://christianspecht.de/page.html`). Pasting `{{ "/page.html" | absURL }}` all over the main template (for the menus etc.) was one thing, but all images in all posts are also linked without domain ([example](https://github.com/christianspecht/blog/blob/c81ed4255e043ec371fefc01fc452e5a8641725c/src/content/posts/2021-10-06-deleting-ssh-key-from-git-gui-the-easy-windows-solution/index.md?plain=1#L23)).
  
But - as noted in the last paragraph - in Hugo it's not even possible to put template code into regular pages, so I couldn't just do something like `{{ "/image.png" | absURL }}`.

Hugo's solution for this is called [Render Hooks](https://gohugo.io/render-hooks/images/) *(there are more types of them, but I needed the ones for images)*.  
You just need to create [one file with what looks similar to a shortcode](https://github.com/christianspecht/blog/commit/716f5341d30ae3bafcef13aaaf8375c6ee080b28), and this causes Hugo to render **all** images with full URLs.  
For example, the example Markdown image code linked above looks like this when rendered with this hook:
  
    <img src="https://christianspecht.de/img/git-ssh-2.png" alt="Git Gui screen"  />

---

## No HTML comments

Hugo also removes all HTML comments when generating the output, including the ASCII art I have at the top of my blog's HTML code.  
Apparently the only way to get a `<!--  -->` comment block into a Hugo site is [converting it to Unicode, storing it in Hugo's config file and loading it in the template with `safeHTML`](https://github.com/christianspecht/blog/commit/b6762142d4ca24406ceb581cd63a1809af33a350).

---

## Creating PHP pages is more complicated

My blog contains some PHP pages (for [the project pages]({{< ref "/posts/2014-11-09-how-to-display-markdown-files-from-other-sites-now-with-caching/index.md" >}})), and apparently it's not that easy to generate PHP pages in Hugo.

Jekyll treats all files (as long as they contain YAML front-matter) equally and doesn't really care about the file extension.  
Hugo treats files with different extensions **completely** different. To create PHP pages with Hugo, I would have to [create a copy of all layout files](https://discourse.gohugo.io/t/how-can-i-include-php-code-in-hugo/28589), just with .php instead of .html.  
In the end, I decided to "cheat", [generate the project pages as `.html` files](https://github.com/christianspecht/blog/commit/2ccac56d91984782b4ed18809c03ecd979784f0d) *(so they use the same layout files as all other pages)*, and [rename them to `.php` in the build script](https://github.com/christianspecht/blog/commit/d8f638ae9ef9c4e3c999d8d7f24af6387a25d3fb).

