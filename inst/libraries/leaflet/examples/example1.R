require(rCharts)
map1 = Leaflet$new()
map1$setView(45.5236, -122.675, 4)
map1$tileLayer("http://a.tiles.mapbox.com/v3/mapbox.control-room/{z}/{x}/{y}.png", 8)
map1
