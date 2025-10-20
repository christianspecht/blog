---
title: Tinkerforge Weather Station, part 1 - Intro and construction
date: 2013-06-17T23:03:00
tags: [hardware]
series: "Tinkerforge Weather Station"
externalfeeds: 1
---

This is my first "real" try to write software for an electronic device.  
Actually, I already [controlled an USB Missile Launcher]({{< ref "/missilesharp.html" >}}). But I didn't really interact much with the hardware then, I just bought a shrink-wrapped device and figured out how to send the right commands to the USB port. So I don't know if this really counts as "electronics".

I was already longer interested to do something "real" with electronics/hardware, but I wasn't sure how to get started.  
For example, I looked at the [Arduino](http://www.arduino.cc/) first *(I even pre-ordered the ["Arduino in Action" book](http://www.manning.com/mevans/) from Manning)*. The whole platform looks interesting, but as I have absolutely **no** electronics/hardware experience at all, fuddling with LEDs, resistors etc. sounds hard/complicated to me.

So I looked further and found alternatives that sounded easier to start with, for a software guy like me:

- [.NET Gadgeteer](http://www.netmf.com/gadgeteer/what-is-gadgeteer.aspx):

	> Even someone with little or no electronics background can build devices made up of components like sensors, lights, switches, displays, communications modules, motor controllers, and much more. Just pick your components, plug them into a mainboard and program the way they work together. .NET Gadgeteer uses the .NET Micro Framework to make writing code for your device as easy as writing a desktop, Web or Windows Phone application.

- [Tinkerforge](http://www.tinkerforge.com/en/home/what_is_tinkerforge/):
	
	> **No detailed knowledge in electronics necessary**  
	> The realization of a project with Tinkerforge is possible without troubles. You simply pick the required modules and connect them together with each other. There is no other electronics knowledge and no soldering needed.  
	>(...)  
	&nbsp;  
	> **Intuitive API**  
	> The Tinkerforge API offers intuitive functions, that simplify the programming. For example: It is possible to set the velocity of a motor in meters per second with a call of setVelocity() or to read out a temperature in degree Celsius (°C) with getTemperature().

Yes, I can probably learn more about embedded programming and hardware by using something more "low-level" (like Arduino).  
But for now I don't want/need deep knowledge, I just want to do something cool *with* hardware.

There are starter kits available for both .NET Gadgeteer and Tinkerforge. I looked at the starter kits for both systems - they are a bit more expensive than Arduino starter kits, but I'm willing to pay more for ease of use.  
So I thought about purchasing one of those starter kits, but I hesitated, because I didn't have an idea for a project yet.

Then Tinkerforge [announced a new starter kit](http://www.tinkerforge.com/en/blog/2013/4/19/starter-kit:-weather-station).  
Quote from the blog post:

> Points of criticism for the old Starter Kit were the missing description of applications, assembly instructions and documentation. We want to counteract these points with a whole series of Starter Kits. The new Starter Kits will always have a specific application as well as instructions for assembly and for the usage of all of our supported programming languages.  
> The Idea is, that you can finish a whole project with the software and hardware as it is provided by the kit. It will however always be possible to add a whole range of modifications, extensions and improvements, so that the fun of tinkering doesn’t come short.

That sounded exactly like what I needed to get started, so I took advantage of the initial promotional discount and purchased a [Weather Station Starter Kit](http://www.tinkerforge.com/en/doc/Kits/WeatherStation/WeatherStation.html).

Inspired by the projects described on the Tinkerforge site, my planned "end goal" is to do something similar:  
I'd like to measure temperature, air pressure etc. on my terrace and display the data somewhere on this site.

But this will come later - in this post, I'll just [assemble the Basic Weather Station](http://www.tinkerforge.com/en/doc/Kits/WeatherStation/Construction_Basic.html#starter-kit-weather-station-construction-basic) and write my first application for it.

---

## Construction / Software

There's not much to say about the actual construction - I blindly followed [the instructions](http://www.tinkerforge.com/en/doc/Kits/WeatherStation/Construction_Basic.html#starter-kit-weather-station-construction-basic).


To get started with the software, I followed the ["First steps" tutorial](http://www.tinkerforge.com/en/doc/Tutorials/Tutorial_Extending/Tutorial.html):

1. [Install Brick Daemon 2.0.5](http://www.tinkerforge.com/de/doc/Software/Brickd_Install_Windows.html#brickd-install-windows)

2. [Install Brick Viewer 2.0.4](http://www.tinkerforge.com/de/doc/Software/Brickv_Install_Windows.html#brickv-install-windows)

3. [Download bindings](http://www.tinkerforge.com/en/doc/Downloads.html#downloads-bindings-examples)

4. Write my first program:

This reads the temperature from the [Barometer Bricklet](http://www.tinkerforge.com/de/doc/Hardware/Bricklets/Barometer.html) and displays it on the [LCD Bricklet](http://www.tinkerforge.com/de/doc/Hardware/Bricklets/LCD_20x4.html):

	using System;
	using Tinkerforge;
	
	namespace FirstTest
	{
	    class Program
	    {
	        private static string host = "localhost";
	        private static int port = 4223;
	        private static string uidLcd = "ezS";
	        private static string uidBar = "ewy";
	
	        static void Main(string[] args)
	        {
	            var con = new IPConnection();
	            var lcd = new BrickletLCD20x4(uidLcd, con);
	            var bar = new BrickletBarometer(uidBar, con);
	
	            con.Connect(host, port);
	
	            var temp = bar.GetChipTemperature() / 100.0;
	
	            lcd.ClearDisplay();
	            lcd.WriteLine(0, 0, "HELLO TINKERFORGE");
	            lcd.WriteLine(2, 0, "Temperature:");
	            lcd.WriteLine(3, 0, string.Format("{0} {1}C", temp, (char)0xDF));
	
	            lcd.BacklightOn();
	            Console.ReadLine();
	            lcd.BacklightOff();
	        }
	    }
	}

And there it is:

![The demo app](/img/tinkerforge01.jpg "The demo app")


---

## Adding Wi-Fi

I'm going to put the Weather Station on my terrace and I don't have Ethernet there, so it needs a Wi-Fi connection.

I didn't buy the [Wi-Fi Master Extension](http://www.tinkerforge.com/en/doc/Hardware/Master_Extensions/WIFI_Extension.html) directly with the Weather Station, because it's not exactly cheap (59,99 €) and I wanted to make sure first that the basic Weather Station (and Tinkerforge in general) works for me.

It did, so I purchased a Wi-Fi extension next.  
The [instructions page](http://www.tinkerforge.com/en/doc/Kits/WeatherStation/Construction_Wifi.html) says that the stack can be powered either with a [Step-Down Power Supply](http://www.tinkerforge.com/en/doc/Hardware/Power_Supplies/Step_Down.html) **or** an [USB Power Supply](https://www.tinkerforge.com/en/shop/power-supplies/usb-power-supply.html).  
The Step-Down Power Supply makes sense when you want to power more than just the Tinkerforge Stack *(for example, [when you put a Raspberry PI into the Weather Station](http://www.tinkerforge.com/en/doc/Kits/WeatherStation/Construction_RaspberryPi.html))*.

I *will* use a Raspberry PI, but I don't intend to put it into the Weather Station (more about this in the next post), so I bought the (cheaper) USB Power Supply.


The construction was simple. I still had some spare mounting kit parts, so I just mounted the Wi-Fi Extension on top of the Master Brick with four 9mm spacers. That's all:

![The Wi-Fi Extension](/img/tinkerforge02.jpg "The Wi-Fi Extension")

---

## Changing the software

After [configuring the Wi-Fi Extension](http://www.tinkerforge.com/en/doc/Hardware/Master_Extensions/WIFI_Extension.html#wifi-configuration) and connecting it to my home network, I tried to get the demo app from above to run again.

Fortunately, there's not much to change because the extension causes the stack to behave exactly as if it was connected directly via USB.  
Quote from the docs:

> From the programming perspective this is completely transparent, i.e. all Bricks and Bricklets can be used exactly the same way as if they were connected to your controlling device via USB.

So I only had to change this line in the code:

	private static string host = "localhost";

...to this:

	private static string host = "192.168.0.115";

That's enough to get it to work:

![The demo app again](/img/tinkerforge03.jpg "The demo app again")

---

## Conclusion

That was the first part. As I said before, I'm planning to control the Weather Station with a [Raspberry PI](http://www.raspberrypi.org/).  
It's already ordered, and in [the second part]({{< ref "/posts/2013-08-15-tinkerforge-weather-station-part-2-connecting-to-a-raspberry-pi/index.md" >}}), I will connect it to the Weather Station.


	
