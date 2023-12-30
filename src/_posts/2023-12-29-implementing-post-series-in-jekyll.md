---
layout: post
title: "Implementing post series in Jekyll"
date: 2023/12/29 23:00:00
tags:
- jekyll
- web
externalfeeds: 1
---

There were several occasions in the past where I wrote a "post series", i.e. multiple posts about the same topic that belong together.

Until now, there was only one way to visually indicate this: including the name of the series in the post title, like this:

- Cool Series, part 1: Intro
- Cool Series, part 2: Implementation
- etc.

Sometimes, I actually remembered to name the posts like this...sometimes I didn't.

Recently, I noticed a few examples how others show post series on their blogs:

- Ayende ([example post](https://ayende.com/blog/200289-B/production-postmortem-the-spawn-of-denial-of-service))
  - at the top of the post, there are separate "previous/next post" and "previous/next post *in this series*" links
  - at the bottom of a post is a "More posts in this series" box

- Steven van Deursen ([example post](https://blogs.cuttingedge.it/steven/posts/2019/di-composition-models-primer/))
  - at the top of the post, there is a box with links to all posts in the series


"Previous/next post in this series" links sound tempting, but my blog is built with Jekyll, and it's not that easy to determine the previous/next post that belongs to the same series.

But a box with links to all posts in the series, that's doable. Here's how I built it:

---

## 1. Defining the series in the YAML front-matter:

I just added a new variable called `series` to all relevant posts.

Example:

    series: "Hugo/Lightbox image gallery"

This string is used to determine which posts belong together, so it must be 100% identical for all posts in the same series.

---

## 2. Adding the "series box" to the layout file:

I'm using a separate layout file (which [inherits from the default layout](http://jekyllrb.com/docs/layouts/#inheritance)) for posts.

The additional code for the "series box" goes into that file *(so the box can only appear in posts)*, and here's the complete code for it:

{% raw %}

    {% if page.series %}
    <div>
      <h4>This post is part of a series: {{ page.series }}</h4>
      <ol>
        {% assign posts = site.posts | where: "series", page.series | sort: "date" %}
        {% for post in posts %}
        <li>{% if post.url == page.url %}{{ post.title }} <i>(this post)</i>{% else %}<a href="{{ post.url }}">{{ post.title }}</a>{% endif %}</li>
        {% endfor %}
      </ol>
    </div>
    {% endif %}

{% endraw %}

Nothing fancy here:

- `if page.series` ⇒ only show the whole block if the current page actually has a `series` variable
- `assign posts = site.posts | where: "series", page.series | sort: "date"` ⇒ load all posts that have the same series as the current post *(including the current post)*
- loop them
  - if it's the current post, show the title only as text with "*(this post)*" behind it
  - for all other posts, show them as links

And finally, here's [an example how the finished "series box" looks like]({% post_url 2020-08-10-creating-an-image-gallery-with-hugo-and-lightbox2 %}).
