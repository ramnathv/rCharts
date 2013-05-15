Leaflet = setRefClass('Leaflet', contains = 'rCharts', methods = list(
  setView = function(lat, long, zoom = 4, ...){
    params$center <<- list(lat, long)
    params$viewOpts <<- list(zoom, ...)
  },
  tileLayer = function(urlTemplate, provider = NULL, ...){
    if (!is.null(provider)){
      params$provider <<- provider
    } else {
      params$urlTemplate <<- urlTemplate
      params$layerOpts <<- list(..., 
        attribution =  'Map data<a href="http://openstreetmap.org">OpenStreetMap</a>contributors, Imagery<a href="http://mapbox.com">MapBox</a>'
      )
    }
  },
  marker = function(lat, long, ...){
    m = list(
      marker = list(lat, long),
      addTo = '#! map !#',
      ...
    )
    if (length(params$marker) > 0){
      params$marker <<- c(params$marker, list(m))
    } else {
      params$marker <<- list(m)
    }
  },
  circle = function(circleData){
    require(plyr)
    dat = alply(circleData, 1, function(c){
      list(
        center = list(c$lat, c$lng), 
        radius = c$radius, 
        options = c[!(names(c) %in% c('lat', 'lng', 'radius'))])
    })
    params$circle <<- setNames(dat, nm = NULL)
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
