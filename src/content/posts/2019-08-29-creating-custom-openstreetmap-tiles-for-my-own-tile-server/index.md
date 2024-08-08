---
title: "Creating custom OpenStreetMap tiles for my own tile server"
aliases:
- /2019/08/29/creating-a-map-with-markers-for-printing-with-bigger-fonts/
date: 2019-08-29T21:00:00
tags:
- command-line
- maps
- web
externalfeeds: 1
---

Once a year, I need to create a printable map with markers.

The map is for [Sindorf trödelt](https://sindorf-troedelt.de/), a website which I built for an annual garage sale in my hometown.

Users can register with their addresses, and I use Google Maps to show them on [this map](https://sindorf-troedelt.de/karte/) on the website.

The map is not active the whole year, so here's a picture:

![map with markers](/img/sindorf-map.png "map with markers")

The organizers of the garage sale also need to print flyers and posters with this map, but using the exact same Google Map for this doesn't make sense, since there's a limit how many copies you are allowed to print with the free version of Google Maps.

Everybody involved in the garage sale is doing this in their spare time *(me included, and I'm sponsoring hosting as well)* so there's simply no budget to pay for a Google Maps license which would allow to print more copies.

---

## First solution

So I needed an alternative way to create a map for printing, and I managed to get something to work with [OpenLayers](https://openlayers.org/) and [OpenStreetMap](https://www.openstreetmap.org/):

I based my code on some example code for a OpenLayers map with markers which I found online (I don't have the link anymore) - it works well, [here's a simplified JSFiddle](https://jsfiddle.net/yw1d3vjc/) *(right-click on the map and save as image)*

But after the first flyers were printed, one problem came up: the font size for the street names was too small, the names weren't readable anymore.

That was two years ago. Last year I didn't have time to find a better solution, so they just printed bigger flyers :-)

This year, I finally had time to investigate this.


---

## Running my own tile server

Sounds impressive, doesn't it?  
When you search for things like "how to increase font size in *[random web mapping solution]*", you quickly find that:

- most solutions use pre-made tiles by 3rd party providers, which are provided as images
- to change the appearance of those tiles, you either need to change the provider or run your own tile server

Running my own tile server sounded scary, so at first I didn't investigate this, but focused on creating the whole image with different tools.

In the end, I found [Maperitive](http://maperitive.net/), which has its own scripting language, so it's possible to [write a text file with commands and execute it in Maperitive to create a map image from scratch](http://maperitive.net/docs/Command_Line.html).

While playing around with this, I found [example code](https://wiki.openstreetmap.org/wiki/Wanderkarte_Steyregg/MaperitiveScript) which saves the [map as tiles *(=image files)*](http://maperitive.net/docs/Commands/GenerateTiles.html) and [uploads them via FTP](http://maperitive.net/docs/Commands/FtpUpload.html).

**That was my "aha" moment: a tile server is not a complex piece of software, but just a regular web server which serves pre-generated image files over HTTP.**

So I just needed some try-and-error, until the tiles looked the way I wanted them to.

Here are the steps to do it with Maperitive (I used v2.4.3.0):

1. **Creating my own ruleset**

    A ruleset is [a file with Maperitive rendering rules](http://maperitive.net/docs/Rulesets.html). The look of the map can be changed in Maperitive (colors, details, text appearance), just by [providing a different ruleset](http://maperitive.net/docs/Rulesets.html#Switching%20Between%20Rulesets).
    
    I needed something "simple" (without many details which clutter the view), so I looked at all the rulesets and picked the [Google Maps ruleset](http://maperitive.net/docs/Rulesets.html#Google%20Maps%20Ruleset). This is just a file in the `Rules` subfolder in the Maperitive application folder.
    
    I want bigger fonts for the streets...so I copied that file, searched for `font-size` and increased some values for the street types that sounded right (some experimentation necessary). [Here's a gist with the changes](https://gist.github.com/christianspecht/9826de05c0e58d46ef23c934269582aa/revisions?diff=split).
    
1. **Getting OpenStreetMap data as XML**

    Quote from Maperitive's	[Ten Minutes Intro ⇒ Loading Map Data](http://maperitive.net/docs/TenMinutesIntro.html#Loading%20Map%20Data): 
    
    > Using the browser, go to [OSM map](http://www.openstreetmap.org/), choose a smallish area (let's say the size of a few city blocks) and then click on the **Export** tab. Select the **OpenStreetMap XML Data** radio button value, click on the **Export** button and you'll receive a file called *map.osm* from the server.
    
1. **Writing a Maperitive script**

    This code goes into a text file with .mscript extension:

        // this is the ruleset from step 1
        use-ruleset location=sindorftiles.mrules

        // this is the OpenStreetMap XML file from step 2
        load-source sindorf.osm
        
        // move and zoom the map, so that the whole town is visible on the screen
        move-pos x=6.674573 y=50.904049 zoom=16

        // now we could export the map to a file:
        // export-bitmap file=map.png height=2000 width=1600

        // ...but we want to generate tiles instead:
        generate-tiles minzoom=16 maxzoom=16 subpixel=3 bounds=6.6554,50.8898,6.6924,50.9191
        
        // upload via FTP:
        ftp-upload host=tiles.sindorf-troedelt.de user=USERNAME pwd=PASSWORD remote-dir=/
   
    A few notes about the `generate-tiles` command:
    
    - `minzoom` and `maxzoom` should match the zoom level from the `move-pos` command
    - generating tiles for one single zoom level is enough in this case - we just need **this view** of the map for printing, no more zooming necessary. [The more zoom levels, the more tiles are generated!](http://maperitive.net/docs/Commands/GenerateTiles.html#Performance%20And%20Storage%20Considerations)  
    
    For me, the FTP upload isn't really necessary because generating the tiles is a one-time thing. Uploading the tiles manually would be acceptable as well...but still, it's nice that Maperitive can do it.

1. **Opening Maperitive and executing the script:**

    This is just a two-liner, calling Maperitive and passing the script from step 3:

        rd /s /q Tiles
        C:\Maperitive\Maperitive.exe "%~dp0\sindorftiles.mscript" -exitafter 

    I put this into a batch file, and copied all the files mentioned before to the same directory where the batch file is.
    
That's it - running this will open Maperitive, which will generate the tiles, save them into the `\Tiles` subfolder and upload them to the web server.
    
Here is an example - on the left side an original OpenStreetMap tile, on the right side the same tile generated with Maperitive and my custom ruleset:

![tiles before and after](/img/sindorf-tiles.png "tiles before and after")

---

## Loading my own tiles with OpenLayers

Back to the [JSFiddle from the beginning](https://jsfiddle.net/yw1d3vjc/): 

At the bottom of the `<script>` block, there's this:

    var map = new ol.Map({
      target: 'map',
      layers: [
        new ol.layer.Tile({
          source: new ol.source.OSM()
        })
        ,vectorLayer1
      ],
      view: new ol.View({
        center: ol.proj.fromLonLat([6.674573,50.904049]),
        zoom: 16
      })
    });

To change this in order to use my custom tiles, I just needed to use the [XYZ source](https://openlayers.org/en/latest/examples/xyz.html) instead of the OpenStreetMap source which I'm using in the JSFiddle.

So it's simply changing this line:

    source: new ol.source.OSM()
    
...into this:

    source: new ol.source.XYZ({url: 'https://tiles.sindorf-troedelt.de/{z}/{x}/{y}.png'})
    
`/{z}/{x}/{y}.png` matches the folder structure and file names generated by Maperitive's `generate-tiles` command.

