Rickshaw = setRefClass('Rickshaw', contains = 'rCharts', methods = list(
  initialize = function(){
    lib <<- 'rickshaw'
    options(RCHART_LIB = lib)
    params <<- list(dom = basename(tempfile('chart')), width = 400, height = 300,
      opts = list(), xAxis = list(), yAxis = list())
  },
  layer = function(...){
    params_ = toSeries(getLayer(...))
    params <<- modifyList(params, Filter(Negate(is.null), params_))
  },
  series = function(...){
    params$series <<- modifyList(params$series, list(...))
  },
  opts = function(..., replace = F){
    params$opts <<- setSpec(params$opts, ..., replace = replace)
  },
  xAxis = function(..., replace = F){
    params$xAxis <<- setSpec(params$xAxis, ..., replace = replace)
  },
  getPayload = function(chartId){
    list(
      chartParams = toJSON(params[!(names(params) %in% c('opts', 'xAxis'))]), 
      opts = toChain(params$opts, 'graph.renderer'),
      xAxis = toJSON(params$xAxis),
      chartId = chartId
    )
  }
))



fixLayerRickshaw = function(params_){
  x_ = params_$x; y = params_$y; data_ = params_$data[,c(x_, y_)]
  names(data_) = c("x", "y")
  params_$data = data_
  return(params_)
}

toSeries = function(params_){
  x_ = params_$x; y_ = params_$y; group = params_$group; data_ = params_$data;
  colors_ = brewer.pal(length(group), "Blues")
  data2 = dlply(data_, group)
  params_$series = llply(seq_along(data2), function(i){list(
    data = fixData(data2[[i]][,c(x_, y_)]), 
    color = colors_[i])
  })
  params_$renderer = params_$type
  params_$x <- params_$y <- params_$type <- params_$group <- params_$data <- NULL
  return(params_)
}

fixData = function(d){
  names(d) = c('x', 'y')
  toJSONArray(d, json = F)
}



# params_ = getLayer(~ cyl, group = 'am', data = mtcars, type = 'bar')

