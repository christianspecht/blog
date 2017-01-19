---
layout: post
title: "Creating a 'holiday map' in Google Maps"
date: 2015/01/22 17:43:00
tags:
- web
---

I recently read a book where one of the characters loved travelling. Each time he was able to spare some money *(and vacation days)*, he travelled to a country where he never had been before.  
He had a big map of the world on his living room wall, and whenever he returned from a vacation, he marked the spot on the map with a needle.

When I read this, my first thought was: "hey, I could probably do this with Google Maps"...so I did.

---

## Implementation

After reading the [Google Maps API docs](https://developers.google.com/maps/documentation/javascript/) first, I found [this example](http://stackoverflow.com/a/3059129/6884) on Stack Overflow, which is already pretty close to what I wanted to do.

I only made a few small changes, and came up with this in the end:

	<!DOCTYPE html>
	<html> 
	<head> 
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" /> 
	<title>Holiday Map</title> 
	<script src="http://maps.google.com/maps/api/js?sensor=false" 
	      type="text/javascript"></script>
	<style type="text/css">
	.gm-style-iw {
	width: 350px; 
	min-height: 60px;
	}
	</style>
	</head> 
	<body>
	<div id="map" style="height: 800px; width: 100%;"></div>
	
	<script src="holidays.js"></script>
	<script type="text/javascript">
	var map = new google.maps.Map(document.getElementById('map'), {
	  zoom: 3,
	  center: new google.maps.LatLng(50.906843, 6.666629),
	  mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	
	var infowindow = new google.maps.InfoWindow();
	var marker, i;
	
	for (i = 0; i < locations.length; i++) {  
	  marker = new google.maps.Marker({
	    position: new google.maps.LatLng(locations[i][0], locations[i][1]),
	    map: map,
	    icon: 'holidaymap-marker' + locations[i][2] + '.png'
	  });
	
	  google.maps.event.addListener(marker, 'click', (function(marker, i) {
	    return function() {
	      infowindow.setContent(locations[i][3] + '<br>' + locations[i][4]);
	      infowindow.open(map, marker);
	    }
	  })(marker, i));
	}
	</script>
	</body>
	</html>

*Note: This code works with version 3.x of the Google Maps API, which is the current version at the time I'm writing this.*

---

## Changes

Most of the changes were only small cosmetical things:

- increased the size of the `div` that holds the map *(100% screen width)*
- increased the size of the [`InfoWindow`](https://developers.google.com/maps/documentation/javascript/reference#InfoWindow) which opens when you click on one of the markers

The only thing worth mentioning is the file `holidays.js`.  
Its content originally was inside the JavaScript code in the HTML file...but this is the part that will be edited the most in the future, so I extracted it into a separate file:

	var locations = [
	    [52.516441, 13.377693, 1, 'visiting Berlin', 'December 2014'],
	    [48.858374, 2.294481, 2, 'summer vacation in Paris', 'June 2014'],
	];

You probably noticed that each line has three additional properties beside the GPS coordinates.  

---

## Custom markers

The single number directly behind the coordinates *(`1` and `2` in this example)* is used to show different [marker icons](https://developers.google.com/maps/documentation/javascript/reference#Marker).  
I need this because I wanted to use different markers for places I visited alone, and places I visited together with my wife.

I'm setting the icon of the markers to `'holidaymap-marker' + locations[i][2] + '.png'` in the HTML file.  
So the files for the icons need to be named `holidaymap-marker1.png`, `holidaymap-marker2.png` and so on.

In this example, I will use these images:

![Marker 1](/img/holidaymap-marker1.png)
![Marker 2](/img/holidaymap-marker2.png)

With the example data from above, the finished map with custom markers will look like this:

![The finished map](/img/holidaymap-finished.png)

---

## The InfoWindow

The last two properties *(for example, `visiting Berlin` and `December 2014` in the first line of `holidays.js`)* will be shown in the `InfoWindow` which pops up when you click on a marker:

![details](/img/holidaymap-details.png)
