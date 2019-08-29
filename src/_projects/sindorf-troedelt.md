---
order: 12
name: "Sindorf trödelt"
site: https://sindorf-troedelt.de/
logo: /img/sindorf-troedelt.png
desc: Website about a garage sale in my home town
sidebar: 0
featured: 0
---

**What I needed:**

An informational website for an annual garage sale in my home town. Requirements:

- Sellers should be able to register with their addresses and pay via PayPal
- A list of registered adresses and a Google map with markers should be re-created daily via cronjob

**What I learned:**

- Building a static [Jekyll](http://jekyllrb.com/) site with dynamic PHP parts, and [running it locally under XAMPP]({% post_url 2017-10-04-running-a-combined-jekyll-php-site-on-xampp %})
- [Implementing](https://stackoverflow.com/a/44202971/6884) and [troubleshooting](https://stackoverflow.com/a/43955343/6884) a PayPal "Pay now" button
- Creating files for the Google map *(based on [this one]({% post_url 2015-01-22-creating-a-holiday-map-in-google-maps %}))* and the address list with [Mustache.php](https://github.com/bobthecow/mustache.php)
- Creating [a map for printing with custom map tiles](/2019/08/29/creating-a-map-with-markers-for-printing-with-bigger-fonts/) with [OpenLayers](https://openlayers.org/) and [Maperitive](http://maperitive.net/)
