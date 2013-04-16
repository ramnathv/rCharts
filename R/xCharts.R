xCharts = setRefClass('xCharts', contains = 'rCharts', methods = list(
  initialize = function(){
    lib <<- 'xCharts'
    options(RCHART_LIB = lib)
    params <<- list(dom = basename(tempfile('chart')),
      width = getOption('RCHART_WIDTH', 900), 
      height = getOption('RCHART_HEIGHT', 400)
    )
  },
  layer = function(...){
    params_ = toXSeries(getLayer(...), series = 'main')
    params <<- modifyList(params, Filter(Negate(is.null), params_))
  },
  main = function(...){
    params$main <<- modifyList(params$main, list(...))
  },
  opts = function(..., replace = F){
    params$opts <<- setSpec(params$opts, ..., replace = replace)
  },
  xAxis = function(..., replace = F){
    params$xAxis <<- setSpec(params$xAxis, ..., replace = replace)
  },
  getPayload = function(chartId){
    list(
      chartParams = toJSON(params[!(names(params) %in% c('type'))]), 
      chartId = chartId,
      chartType = params$type
    )
  }
))

toXSeries = function(params_, series = 'main'){
  x_ = params_$x; y_ = params_$y; group = params_$group; data_ = params_$data;
  data2 = dlply(data_, group)
  params_[series] = list(llply(seq_along(data2), function(i){list(
    data = fixData(data2[[i]][,c(x_, y_)]))
  }))
  params_$x <- params_$y <- params_$group <- params_$data <- NULL
  return(params_)
}
