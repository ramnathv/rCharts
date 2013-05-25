Rickshaw = setRefClass('Rickshaw', contains = 'rCharts', methods = list(
  initialize = function(){
    callSuper();
    params <<- c(params, list(opts = list(), xAxis = list(), 
      yAxis = list(), hoverDetail = list()))
    params$slider <<- FALSE
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
  yAxis = function(...){
    params$yAxis <<- list(
      orientation = 'left',
      tickFormat = 'Rickshaw.Fixtures.Number.formatKMBT'
    )
    params$yAxis <<- modifyList(params$yAxis, list(...))
  },
  hoverDetail = function(..., replace = F){
    params$hoverDetail <<- setSpec(params$hoverDetail, ..., replace = replace)
  },
  getPayload = function(chartId){
    skip = c('opts', 'xAxis', 'yAxis', 'hoverDetail')
    list(
      chartParams = toJSON2(params[!(names(params) %in% skip)], 
        digits = 13), 
      opts = toChain(params$opts, 'graph.renderer'),
      xAxis = params$xAxis,
      yAxis = params$yAxis,
      hoverDetail = params$hoverDetail,
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

`%||%` <- function(x, y){
  if (!is.null(x)) x else y
}

toSeries = function(params_, series = 'series'){
  x_ = params_$x; y_ = params_$y; group = params_$group; data_ = params_$data;
  data2 = dlply(data_, group)
  if (is.null(group)){
    names(data2) = params_$y
  }
  nm2 = names(data2)
  colors_ = params_$colors %||% brewer.pal(length(nm2), "Blues")
  params_[[series]] = llply(seq_along(nm2), function(i){list(
    data = fixData(data2[[i]][,c(x_, y_)]), 
    name = nm2[i],
    info = toJSONArray(data2[[i]][,!(names(data2[[i]]) %in% y_)], json = F, nonames = F),
    color = colors_[i])
  })
  params_$renderer = params_$type
  params_$x <- params_$y <- params_$type <- params_$group <- params_$data <- NULL
  params_$colpal <- NULL
  return(params_)
}

fixData = function(d){
  names(d) = c('x', 'y')
  toJSONArray(d, json = F)
}



# params_ = getLayer(~ cyl, group = 'am', data = mtcars, type = 'bar')

