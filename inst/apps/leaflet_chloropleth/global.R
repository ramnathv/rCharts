# install_github('rCharts','bbest'); 
# load_all('~/Code/rCharts'); setwd('~/Code/ohigui'); load_all(); shiny::runApp('~/Code/rCharts/inst/apps/leaflet_chloropleth')
require(shiny); require(RJSONIO); require(rCharts); require(RColorBrewer)
options(stringsAsFactors = F)

# port data from ohicore package for example sake
# install_githbub('ohicore','bbest')
# require(ohicore)
# layers = layers.Global2013.www2013
# vars_rgn = as.character(sort(subset(layers$meta, fld_id_num=='rgn_id' & is.na(fld_category)  & is.na(fld_year) & is.na(fld_val_chr), layer, drop=T)))
# variable_data = plyr::rename(SelectLayersData(layers, layers=vars_rgn, narrow=T), c('id_num'='rgn_id'))
# write.csv(variable_data, file.path(system.file('inst/apps/leaflet_chloropleth/data', package='rCharts'), 'variable_data.csv'), row.names=F, na='')

# read data
#variable_data = read.csv(system.file('apps/leaflet_chloropleth/data/variable_data.csv', package='rCharts'), na.strings='')
variable_data = read.csv(system.file('inst/apps/leaflet_chloropleth/data/variable_data.csv', package='rCharts'), na.strings='')

# get data
getData <- function(variable, variable_data){ 
  d = subset(variable_data, layer==variable)
  brks = with(d, seq(min(val_num, na.rm=T),
                     max(val_num, na.rm=T), length.out=8))
  colors = brewer.pal(length(brks)-1, 'Spectral')
  regions = plyr::dlply(d, 'rgn_id', function(x) {
    return(list(val_num = x$val_num,
                color   = cut(x$val_num, breaks=brks, labels=colors, include.lowest=TRUE)))
  })                        
  legend = setNames(signif(brks, digits=4), cut(brks, breaks=brks, labels=colors, include.lowest=TRUE)) #; cat(toJSON(legend))
  return(list(regions=regions, legend=legend))
}

# plot map
plotMap <- function(variable, layers, width=1600, height=800){  
  
  d <- getData(variable, variable_data)
  
  lmap <- Leaflet$new()
  lmap$mapOpts(worldCopyJump = TRUE)
  lmap$tileLayer(provide='Stamen.TonerLite')
  lmap$set(width = width, height = height)
  lmap$setView(c(0, 0), zoom = 3)
  lmap$geoJson(
    "#! regions !#",
    style = sprintf("#! function(feature) {
      regions_data = %s;
      var rgn = feature.properties['rgn_id'].toString();
      if (typeof regions_data[rgn] != 'undefined'){
        var color = regions_data[rgn]['color'];
      } else {
        var color = 'gray';
      };
      return {
        color: color,
        strokeWidth: '1px',
        strokeOpacity: 0.5,
        fillOpacity: 0.2
      }; } !#", gsub('\\\"', "'", toJSON(d$regions, collapse=' '))),
    onEachFeature = sprintf("#! function (feature, layer) {

      // info rollover
      if (document.getElementsByClassName('info leaflet-control').length == 0 ){
        info = L.control({position: 'topright'});  // NOTE: made global b/c not ideal place to put this function
        info.onAdd = function (map) {
          this._div = L.DomUtil.create('div', 'info');
          this.update();
          return this._div;
        };
        info.update = function (props) {
          if (props && typeof props['rgn_id'] != 'undefined' && typeof regions_data[props['rgn_id'].toString()] != 'undefined'){
            var val_num = regions_data[props['rgn_id'].toString()]['val_num'];
          } else {
            var val_num = 'NA';
          };

          this._div.innerHTML = '<h4>%s</h4>' +  (props ?
        		'<b>' + props['rgn_nam'] + '</b> (' + props['rgn_id'] + '): ' + val_num
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
      } !#", variable))
  legend_vec = d$legend
  lmap$legend(position = 'bottomright', 
              colors   =  names(legend_vec), 
              labels   =  as.vector(legend_vec))
  return(lmap)
}
