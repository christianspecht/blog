This is the source code of [christianspecht.de](https://christianspecht.de), built with [Jekyll](https://jekyllrb.com/).

It's mostly a "regular" Jekyll site, but it contains [some PHP parts](https://github.com/christianspecht/blog/tree/master/src/php) ([more details](https://christianspecht.de/2014/11/09/how-to-display-markdown-files-from-other-sites-now-with-caching/)), which is the reason why I'm hosting it on my own webspace instead of Github Pages.

---

## How to deploy

Via [GitHub Actions](https://github.com/christianspecht/blog/actions) ([more on this](https://christianspecht.de/2020/05/03/building-and-deploying-a-jekyll-site-via-github-actions/))

- Pushing to `master` auto-deploys to https://christianspecht.de ![Jekyll site CI](https://github.com/christianspecht/blog/actions/workflows/ci.yml/badge.svg?branch=master)
- Pushing to `preview` auto-deploys to `https://preview.christianspecht.de` ![Jekyll site CI](https://github.com/christianspecht/blog/actions/workflows/ci.yml/badge.svg?branch=preview)

---

## Local build *(on Windows)*

Via `build.bat` - expects a local Jekyll installation, for example [Portable Jekyll](https://github.com/madhur/PortableJekyll)

