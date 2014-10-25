---
layout: post
title: Separate pages per tag/category with Jekyll (without plugins)
date: 2014/10/25 15:58:00
tags:
- jekyll
---

Apparently one of the challenges that many new Jekyll users are facing is how to create nice-looking tag/category pages [like this one](/tags) without plugins (because most plugins won't work on [GitHub Pages](https://pages.github.com/)).

> *Note: I'll use the word "tag" in this post, but everything I'm writing here applies to categories as well - because for the purpose of generating list of posts with a certain tag/category, [tags and categories are the same in Jekyll](http://stackoverflow.com/q/8675841/6884).*

I had that problem as well when I [built this blog with Jekyll]({% post_url 2013-12-31-hello-jekyll %}), and after I [posted my solution on Stack Overflow](http://stackoverflow.com/a/21002505/6884), I received 17 upvotes *(as of now)* in about 10 months - this is by far my most upvoted answer in the `jekyll` tag.

However, Jekyll is not able to generate new pages on the fly without plugins...so the solution I'm using here in this blog consists of [a single tag page](/tags/) [which lists the posts for **all** tags](https://bitbucket.org/christianspecht/blog/src/0b3d2dbfd9488d63c6ed0c3b899f6625c12ba6a4/src/tags/index.html?at=default).

But some people absolutely want separate pages, one per tag.  
This is also possible without plugins, even though it's less comfortable because there's one disadvantage:  
**When you use a new tag for the first time, you have to create the tag page** *(i.e. an `index.html` file inside a folder with the name of the tag)* **by hand.** It's not much work, but you need to remember to do it.

---

## The layout file

In order to minimize the effort needed to create a new tag page, we'll put as much as possible into a [layout file](http://jekyllrb.com/docs/frontmatter/#predefined-global-variables):

`/_layouts/tagpage.html`:

    {% raw %}

    ---
    layout: default
    ---

    <h1>{{ page.tag }}</h1>

    <ul>
    {% for post in site.tags[page.tag] %}
      <li>
        {{ post.date | date: "%B %d, %Y" }}: <a href="{{ post.url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
    </ul>

    {% endraw %}

The layout file just pulls the name of the tag from a variable in the [YAML front-matter](http://jekyllrb.com/docs/frontmatter/) of the page, loops all posts with that tag and displays a list of links to them.

---

## Adding a new tag page

With the layout file shown above, adding a new tag page *(in this example for the `jekyll` tag)* is as simple as this:

`/tags/jekyll/index.html`:

    {% raw %}

    ---
    layout: tagpage
    tag: jekyll
    ---

    {% endraw %}
    
Just two lines of front-matter, no content necessary.

The created HTML will look like this:

    <h1>jekyll</h1>

    <ul>
      <li>
        September 15, 2014: <a href="/2014/09/15/easy-meta-redirects-with-jekyll/">Easy meta redirects with Jekyll</a>
      </li>
      <li>
        August 22, 2014: <a href="/2014/08/22/jekyll-lightbox2-image-gallery-another-approach/">Jekyll / Lightbox2 image gallery, another approach</a>
      </li>
      <li>
        June 18, 2014: <a href="/2014/06/18/building-a-pseudo-dynamic-tree-menu-with-jekyll/">Building a pseudo-dynamic tree menu with Jekyll</a>
      </li>
      <li>
        March 08, 2014: <a href="/2014/03/08/generating-an-image-gallery-with-jekyll-and-lightbox2/">Generating an image gallery with Jekyll and Lightbox2</a>
      </li>
      <li>
        December 31, 2013: <a href="/2013/12/31/hello-jekyll/">Hello, Jekyll!</a>
      </li>
    </ul>

As I said before - all you need to do is remember to create a new two-line tag page, each time you're using a new tag for the first time.
