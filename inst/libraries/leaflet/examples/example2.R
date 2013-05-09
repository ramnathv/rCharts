require(rCharts)
map2 = Leaflet$new()
map2$setView(45.5236, -122.675, 10)
map2$tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
map2
