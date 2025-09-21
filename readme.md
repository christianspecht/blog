This is the source code of [christianspecht.de](https://christianspecht.de), built with [Hugo](https://gohugo.io/).

It's mostly a "regular" Hugo site, but it contains [some PHP parts](https://github.com/christianspecht/blog/tree/master/src/static/php) ([more details](https://christianspecht.de/2014/11/09/how-to-display-markdown-files-from-other-sites-now-with-caching/)), which is the reason why I'm hosting it on my own webspace instead of Github Pages.

---


## Important rules

- Internal links *(in Markdown files)* to other pages MUST use the [`ref` shortcode](https://gohugo.io/content-management/shortcodes/#ref)
  - Example:  
    Instead of this: `[Imprint](/imprint/)`  
    ...use this: `[Imprint]({{< ref "/imprint/index.html" >}})`

- Hugo can't generate .php pages directly, so the project pages are created as .html files by Hugo, and renamed to .php in the build script

---

## How to deploy

Via [GitHub Actions](https://github.com/christianspecht/blog/actions) (more on this [here](https://christianspecht.de/2020/05/03/building-and-deploying-a-jekyll-site-via-github-actions/) and [here](https://christianspecht.de/2021/02/18/building-deploying-jekyll-and-hugo-sites-via-gitlab-ci/))

- Pushing to `master` auto-deploys to https://christianspecht.de ![CI badge](https://github.com/christianspecht/blog/actions/workflows/ci.yml/badge.svg?branch=master)
- Pushing to `preview` auto-deploys to `https://preview.christianspecht.de` ![CI badge](https://github.com/christianspecht/blog/actions/workflows/ci.yml/badge.svg?branch=preview)

---

## Local build *(on Windows)*

Via `hugo-server.bat` / `hugo-server-reset.bat` - expects a local Hugo installation *(whose version number should match the `hugo-version` used [here](https://github.com/christianspecht/blog/blob/master/.github/workflows/ci.yml))*

