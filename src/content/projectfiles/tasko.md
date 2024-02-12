---
order: 10
title: Tasko
site: /tasko/
logo: /php/cache/img/tasko-logo128x128.png
desc: Simple to-do list app for your own server (with Android client)
sidebar: 0
featured: 0
---

**What I needed:**

A ToDo app for my Android phone. I could have used an existing one, but decided to write one myself for learning purposes (mobile app with web service backend)

**What I learned:**

- Creating a web service with [ASP.NET Web API](http://www.asp.net/web-api) *(and [Basic Authentication]({% post_url 2013-08-02-basic-authentication-in-asp-net-web-api %}), but I later [switched to token-based authentication](https://github.com/christianspecht/tasko/commit/dceadd8dbf7feed631d2da7d06ea6051d93f869e))* and hosting it on [AppHarbor](https://appharbor.com/)
- Using a [NoSQL database](http://en.wikipedia.org/wiki/NoSQL), in this case [RavenDB](http://ravendb.net/)
- Writing a native [Android](http://www.android.com/) app