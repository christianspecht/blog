---
layout: default 
title: Projects
---

<h1>{{ page.title }}</h1>

<div class="row spacer25"></div>

Like many other developers, I have been creating small tools and tryout projects in my spare time for years, but I didn't ever publish one until 2011. Most of them were either not in a state to be published, or not of any practical use. Or both.

After seeing more and more people linking their personal GitHub/Bitbucket/CodePlex projects in their blogs and Stack Overflow profiles, I thought: I can do this, too! After all, having actual projects viewable online [can't hurt](https://twitter.com/jeresig/status/33968704983138304).

The projects listed here were created either because of an actual problem that I had *(like [taking backups of my personal stuff](/roboshell-backup/))* or just because I found something cool that I wanted to play around with *(like [controlling an USB Missile Launcher](/missilesharp/))*.  

I also try to use some new libraries/tools/technologies in each project that I'm not familiar with, for [learning purposes](http://norvig.com/21-days.html). And I've seen too many projects that look interesting, but [lack even the simplest "how to get started" example](http://www.codinghorror.com/blog/2007/01/if-it-isnt-documented-it-doesnt-exist.html)...so I always create full documentation, installers etc. for my projects whenever possible.

Here is everything I created so far, in reverse chronologial order (newest first):

<div class="row spacer25"></div>

<div class="container">
{% for project in site.data.projects %}
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