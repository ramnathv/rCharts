..p. <- function() invisible(readline("\nPress <return> to continue: "))
require(rCharts)

map1 = Leaflet$new()
map1$setView(c(45.5236, -122.675), 13)
map1$tileLayer("http://a.tiles.mapbox.com/v3/mapbox.control-room/{z}/{x}/{y}.png", zoom = 8)
map1

..p.() # ================================

map1 = Leaflet$new()
map1$setView(c(45.50867, -73.55399), 13)
map1

..p.() # ================================

map2 = Leaflet$new()
map2$setView(c(45.5236, -122.675), 10)
map2$tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
map2

..p.() # ================================

map3 <- Leaflet$new()
map3$setView(c(51.505, -0.09), zoom = 13)
map3$tileLayer(
  "http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png",
   maxZoom = 18 
)
map3$marker(c(51.5, -0.09), bindPopup = "<p> Hi. I am a popup </p>")
map3$marker(c(51.495, -0.083), bindPopup = "<p> Hi. I am another popup </p>")
map3$show(cdn = T)

map3$circle(c(51.5, -0.09))

..p.() # ================================

map4 = Leaflet$new()
map4$setView(c(29.6779, -95.4379), 10)
map4$tileLayer("http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png")
# map4$tileLayer(provider = 'Stamen.Terrain')

data(crime, package = 'ggmap')
dat <- head(crime)[,c('lat', 'lon', 'offense')]
names(dat) <- c('lat', 'lng', 'offense')
map4$geocsv(dat)
map4

..p.() # ================================

#map5 = Leaflet$new()
#map5$setView(37.27667, -91.60611, 4)
#map5$tileLayer("http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png")
#
#dat <- read.csv('geoCoded.csv')
#names(dat) <- c('address', 'lat', 'lng')
#dat <- transform(dat, color = 'red', fillColor = '#f03', fillOpacity = 0.5, radius = 10)
#map5$circle(dat)
#map5

..p.() # ================================

rMap <- function(location = 'montreal', zoom = 10, provider = 'MapQuestOpen.OSM'){
  m1 <- Leaflet$new()
  lnglat <- as.list(ggmap::geocode(location))
  m1$setView(lnglat$lat, lnglat$lon, zoom = zoom)
  m1$tileLayer(provider = provider)
  return(m1)
}

r1 <- rMap()
mcgill <- as.list(ggmap::geocode('mcgill univesity'))
r1$marker(mcgill$lat, mcgill$lon, bindPopup = 'mcgill university')
r1

..p.() # ================================

map6 = Leaflet$new()
map6$setView(45.372, -121.6972, 12)
map6$tileLayer(provider ='Stamen.Terrain')
map6$marker(45.3288, -121.6625, bindPopup = 'Mt. Hood Meadows')
map6$marker(45.3311, -121.7113, bindPopup = 'Timberline Lodge')

..p.() # ================================

map1b = Leaflet$new()
map1b$setView(c(45.5236, -122.675), zoom = 14)
map1b$tileLayer(provider = 'MapQuestOpen.OSM')
map1b

..p.() # ================================

map3 <- Leaflet$new()
map3$setView(c(51.505, -0.09), zoom = 13)
map3$tileLayer(
  "http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png",
  maxZoom = 18 
)
map3$circle(c(51.5, -0.09), 100)

..p.() # ================================

map2 = Leaflet$new()
map2$setView(c(45.5236, -122.6750), 13)
map2$tileLayer(provider = 'Stamen.Toner')
map2$marker(c(45.5244, -122.6699), bindPopup = 'The Waterfront')
map2$circle(c(45.5215, -122.6261), radius = 500, bindPopup = 'Laurelhurst Park')
map2

..p.() # ================================

# devtools::install_github('rCharts', 'bbest') # tweak to make var geojsonLayer available
json = '{"type":"FeatureCollection","features":[
  {"type":"Feature",
   "properties":{"region_id":1, "region_name":"Australian Alps"},
   "geometry":{"type":"Polygon","coordinates":[[[141.13037109375,-38.788345355085625],[141.13037109375,-36.65079252503469],[144.38232421875,-36.65079252503469],[144.38232421875,-38.788345355085625],[141.13037109375,-38.788345355085625]]]}},
  {"type":"Feature",
   "properties":{"region_id":4, "region_name":"Shark Bay"},
   "geometry":{"type":"Polygon","coordinates":[[[143.10791015625,-37.75334401310656],[143.10791015625,-34.95799531086791],[146.25,-34.95799531086791],[146.25,-37.75334401310656],[143.10791015625,-37.75334401310656]]]}}
  ]}'
regions=RJSONIO::fromJSON(json)
  
lmap <- Leaflet$new()
lmap$tileLayer(provide='Stamen.TonerLite')
lmap$setView(c(-37, 145), zoom = 6)
lmap$geoJson(
  regions, 
  style = "#! function(feature) {
    var rgn2col = {1:'red',2:'blue',4:'green'};     
    return {
      color: rgn2col[feature.properties['region_id']],
      strokeWidth: '1px',
      strokeOpacity: 0.5,
      fillOpacity: 0.2
    }; } !#",
  onEachFeature = "#! function (feature, layer) {

    // info rollover
    if (document.getElementsByClassName('info leaflet-control').length == 0 ){
      info = L.control({position: 'topright'});  // NOTE: made global b/c not ideal place to put this function
      info.onAdd = function (map) {
        this._div = L.DomUtil.create('div', 'info');
        this.update();
        return this._div;
      };
      info.update = function (props) {
      	this._div.innerHTML = '<h4>Field Name</h4>' +  (props ?
      		props['region_id'] + ': <b> + props[fld] + </b>'
      		: 'Hover over a region');
      };
      info.addTo(map);
    };

    // mouse events
    layer.on({

      // mouseover to highlightFeature
  	  mouseover: function (e) {
        var layer = e.target;
        layer.setStyle({
          strokeWidth: '3px',
          strokeOpacity: 0.7,
          fillOpacity: 0.5
        });
      	if (!L.Browser.ie && !L.Browser.opera) {
      		layer.bringToFront();
      	}
	      info.update(layer.feature.properties);
      },

      // mouseout to resetHighlight
		  mouseout: function (e) {
        geojsonLayer.resetStyle(e.target);
	      info.update();
      },

      // click to zoom
		  click: function (e) {
        var layer = e.target;        
        if ( feature.geometry.type === 'MultiPolygon' ) {        
        // for multipolygons get true extent
          var bounds = layer.getBounds(); // get the bounds for the first polygon that makes up the multipolygon
          // loop through coordinates array, skip first element as the bounds var represents the bounds for that element
          for ( var i = 1, il = feature.geometry.coordinates[0].length; i < il; i++ ) {
            var ring = feature.geometry.coordinates[0][i];
            var latLngs = ring.map(function(pair) {
              return new L.LatLng(pair[1], pair[0]);
            });
            var nextBounds = new L.LatLngBounds(latLngs);
            bounds.extend(nextBounds);
          }
          map.fitBounds(bounds);
        } else {
        // otherwise use native target bounds
          map.fitBounds(e.target.getBounds());
        }
      }
	  });
    } !#")
legend_vec = c('red'='high', 'blue'='medium', 'green'='low')
lmap$legend(position = 'bottomright', 
            colors   =  names(legend_vec), 
            labels   =  as.vector(legend_vec))
lmap

..p.() # ================================
