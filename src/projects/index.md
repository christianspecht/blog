---
layout: default 
title: Projects
permalink: /projects/index.html
---

<h1>{{ page.title }}</h1>

<div class="row spacer25"></div>

The projects listed here were created either because of an actual problem that I had *(like taking backups of [my computers](/roboshell-backup/) and [my code](/bitbucket-backup/))* or just because I found something cool that I wanted to play around with *(like [controlling an USB Missile Launcher](/missilesharp/))*.  

I also try to use some new libraries/tools/technologies in each project that I'm not familiar with, for [learning purposes](http://norvig.com/21-days.html). And I've seen too many projects that look interesting, but [lack even the simplest "how to get started" example](http://www.codinghorror.com/blog/2007/01/if-it-isnt-documented-it-doesnt-exist.html)...so I always create full documentation, installers etc. for my projects whenever possible.

Here is everything I created so far, in reverse chronologial order (newest first):

<div class="row spacer25"></div>

<div class="container">
{% assign projects = site.projects | sort: 'order' | reverse %}
{% for project in projects %}
{% assign loopindex = forloop.index | modulo:2 %}
{% if loopindex == 1 %}
    <div class="row">
    {% assign lastloop = 1 %}
{% include projectdetails.html %}
        <div class="row visible-phone spacer25"></div>
{% else %}
{% include projectdetails.html %}
    {% assign lastloop = 2 %}
    </div><!--/row-->
    <div class="row spacer25"></div>
{% endif %}
{% endfor %}

{% if lastloop == 1 %}
    </div><!--/row-->
    <div class="row spacer25"></div>  
{% endif %}

</div><!--/container-->

<div class="row visible-phone spacer25"></div>