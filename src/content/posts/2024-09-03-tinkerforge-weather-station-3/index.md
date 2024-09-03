---
title: "Tinkerforge Weather Station, part 3 - Continuing the project after a decade"  # One decade later, new plan / Reboot after a decade
date: 2024-09-03T21:00:00
tags:
- hardware
- .net
series: "Tinkerforge Weather Station"
externalfeeds: 1
---

Once upon a time...I bought a [Tinkerforge Weather Station](https://www.tinkerforge.com/en/doc/Kits/WeatherStation/WeatherStation.html), wrote some C# code to interact with it, and managed to get it to run via Mono on a Raspberry PI with Linux.  
My end goal was to measure temperature etc. in my garden, and somehow show it on this website.

Then I put the weather station and the Raspberry PI in a drawer...and completely forgot about them. That was about eleven years ago!

Now I found both items again and decided to continue the project.  
But of course, a decade is quite a long time for software - a lot of my original 2013 plan is not relevant anymore today:

---

## The new plan

1. I don't need Mono anymore. Ten years ago, the "new" .NET (a.k.a. .NET Core) didn't even exist, but today I can just create a project in the current .NET Version (on Windows, because this is what I use) and it will just run on any Raspberry PI (very likely *not* on Windows).

2. Back then, I didn't want to put the PI *inside* the weather station because I wanted to keep it in the house and also use it for other things (I didn't explicitly write it, but I remember that I actually had home automation in mind).
So I bought a [Tinkerforge WIFI Master Extension](https://www.tinkerforge.com/en/doc/Hardware/Master_Extensions/WIFI_Extension.html).  
But:
	
	a) now there's the Raspberry PI Zero W, which is ridiculously cheap AND has Wi-Fi
  
	b) [Home Assistant](https://www.home-assistant.io/), the home automation solution I evaluated so far, seems to "prefer" running on a dedicated machine anyway.  
	I have zero Home Assistant experience so far, but just from reading the documentation, it looks like that: the [easiest installation method](https://www.home-assistant.io/installation/#diy-with-raspberry-pi) comes with its own operating system, and manually installing HA on an existing OS seems to be the [hardest installation method](https://www.home-assistant.io/installation/#advanced-installation-methods).
	
	⇒ it doesn't make sense to have a Raspberry PI running in the house 24/7 that does nothing but power the weather station. So the obvious choice is removing the Wi-Fi module and putting a Raspberry PI Zero W directly into the weather station.  
	*(I still have the old Raspberry PI from 2013, but it has no Wi-Fi)*


3. I wanted (and still want) to periodically save the current temperature, humidity etc. *somewhere* and do something cool with it.  
In 2013, the Tinkerforge docs recommended Xively for this, but today their website doesn't even load anymore, and [according to Wikipedia they were bought by Google years ago](https://en.wikipedia.org/wiki/Xively).

	In 2024, there are *waaay* more cloud services, and there's probably one that makes perfect sense for a requirement like this *(and has a free tier that's enough for my needs)*.  
	I don't have any experience building stuff for/in the cloud yet, so I will use this project to get my feet wet.

	So this is a but vague, but I'm planning to:
	- periodically send temperature etc. somewhere to *The Cloud™* and store it there (not for all eternity, just the last few days?)
	- eventually use this data to create an auto-refreshing "this is the current weather in my garden" site with some nice graphs, `weather.christianspecht.de` or something like that.

---

## The application so far

The code is here on GitHub: https://github.com/christianspecht/weather-station

It's .NET 8 (the current LTS version). At the time of writing this post, it consists of nothing but [a simple "Hello World" example](https://github.com/christianspecht/weather-station/tree/290f067f48b71d0730a9fde7a808ed2bc64728aa) (similar to the one in the 2013 blog posts), which shows the current temperature on the display. 

Next (before I write the next post), I will add more functionality to the application, similar to the [two](https://www.tinkerforge.com/en/doc/Kits/WeatherStation/CSharpToLCD.html) [tutorials](https://www.tinkerforge.com/en/doc/Kits/WeatherStation/CSharpToButtonControl.html) in the Tinkerforge docs: read the values of all sensors and make use of the buttons to show different things on the display. And after that, I will start with the cloud stuff.
