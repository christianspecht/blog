---
order: 7
name: This site (2013)
site: /
logo: /img/site2013.png
sidebar: 0
featured: 0
---

**What I needed:**

Migrate existing WordPress site/blog to a static site generator *(I decided to use [Blogofile](http://blogofile.com/) first, later switched to [Jekyll](http://jekyllrb.com/))*.

**What I learned:**

- [Setting up a new site with Blogofile]({% post_url 2013-01-29-switched-from-wordpress-to-blogofile %}), and later [converting it to Jekyll]({% post_url 2013-12-31-hello-jekyll %}) *(source code [here](https://github.com/christianspecht/blog))*
- Creating a responsive HTML template with [Bootstrap](http://getbootstrap.com/)
- Writing custom [Mako](http://www.makotemplates.org/) *(for Blogofile)* and [Liquid](http://wiki.shopify.com/Liquid) *(for Jekyll)* templates
- Displaying [Markdown files from my Bitbucket projects (again)]({% post_url 2013-02-17-how-to-display-markdown-files-from-other-sites-this-time-in-blogofile %})...and [again in Jekyll](https://github.com/christianspecht/blog/commit/a185a0b1e3c787c2e0411b58269df4cc8bc4ac61) ([with caching]({% post_url 2014-11-09-how-to-display-markdown-files-from-other-sites-now-with-caching %}))
- Automating FTP uploads with [WinSCP](http://winscp.net/), later [auto-deploy]({% post_url 2020-02-26-setting-up-ci-for-this-site-with-bitbucket-pipelines-and-ssh %}) [with SSH from CI]({% post_url 2020-05-03-building-and-deploying-a-jekyll-site-via-github-actions %})
