Leaflet = setRefClass('Leaflet', contains = 'rCharts', methods = list(
  initialize = function(){
    callSuper(); lib <<- 'leaflet'; LIB <<- get_lib(lib);
  },
  setView = function(lat, long, zoom = 4, ...){
    params$center <<- list(lat, long)
    params$viewOpts <<- list(zoom, ...)
  },
  tileLayer = function(urlTemplate, ...){
    params$urlTemplate <<- urlTemplate
    params$layerOpts <<- list(..., 
      attribution =  'Map data © <a href="http://openstreetmap.org">OpenStreetMap</a>contributors, Imagery © <a href="http://mapbox.com">MapBox</a>'
    )
  },
  marker = function(lat, long, ...){
    marker = list(
      marker = list(lat, long),
      addTo = '#! map !#',
      ...
    )
    if (length(params$marker) > 0){
      params$marker <<- list(params$marker, marker)
    } else {
      params$marker <<- marker
    }
  },
  circle = function(lat, long, radius, ...){
    
  },
  geocsv = function(data){
    paste2 = function(...) {paste(..., sep = ';')}
    params$geocsv <<- list(
      titles = names(data),
      data = paste(do.call('paste2', data), collapse = '\n')
    )
  },
  getPayload = function(chartId){
    marker = paste(lapply(params$marker, toChain, obj =  'L'), collapse = '\n')
    chartParams = toJSON(params[!(names(params) %in% c('marker'))])
    list(chartParams = chartParams, chartId = chartId, lib = basename(lib),
      marker = marker
    )
  }
))
