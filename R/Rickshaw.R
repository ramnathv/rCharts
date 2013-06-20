Rickshaw = setRefClass('Rickshaw', contains = 'rCharts', methods = list(
  initialize = function(){
    callSuper();
    params <<- c(params, list(xAxis = TRUE, yAxis = TRUE, legend = TRUE, 
      scheme = 'colorwheel', shelving = TRUE, hoverDetail = TRUE, 
      highlight = TRUE, slider = FALSE)
    )
    templates$page <<- 'Rickshaw.html'
    templates$chartDiv <<- paste(readLines(
      system.file('libraries', 'rickshaw', 'layouts', 'rickshaw-chartDiv.html', 
        package = 'rCharts')), collapse = '\n'
    )
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
  xAxis = function(..., type = 'Time', replace = F){
    params$xAxis <<- c(list(...), extension = paste('Axis', type, sep = '.'))
  },
  yAxis = function(...){
    params$yAxis <<- list(...)
  },
  hoverDetail = function(..., replace = F){
    params$hoverDetail <<- list(...)
  },
  getPayload = function(chartId){
    extensions = c('xAxis', 'yAxis', 'legend', 'shelving', 
      'hoverDetail', 'highlight', 'slider')
    defaults = rickshaw_defaults(chartId)
    list(
      chartParams = toJSON2(params[!(names(params) %in% extensions)], digits = 13), 
      opts = toChain(params$opts, 'graph.renderer'),
      chartExtensions = make_extensions(extensions, params, defaults),
      chartId = chartId,
      params = params
    )
  }
))
