nvd3Plot <- function(x, data, ...){
  myChart <- NVD3$new()
  myChart$getChartParams(x, data, ...)
  return(myChart$copy())
}

NVD3 <- setRefClass('NVD3', contains = 'rCharts', methods = list(
  initialize = function(){
    lib <<- 'nvd3'
    options(RCHART_LIB = lib)
    params <<- list(dom = basename(tempfile("chart")), 
      width = 900, height = 400, chart = list(), xAxis = list(), yAxis = list());
  },
  chart = function(...){
    params$chart <<- modifyList(params$chart, list(...))
  },
  xAxis = function(..., replace = F){
    params$xAxis <<- setSpec(params$xAxis, ..., replace = replace)
  },
  yAxis = function(..., replace = F){
    params$yAxis <<- setSpec(params$yAxis, ..., replace = replace)
  },
  getChartParams = function(...){
    params <<- modifyList(params, getLayer(...))
  },
  getPayload = function(chartId){
    data = r2json(params$data)
    xAxis =  chainConfig(params$xAxis, prefix = 'chart.xAxis')
    yAxis = chainConfig(params$yAxis, prefix = 'chart.yAxis')
    chart = chainConfig(params$chart, prefix = 'chart')
    opts = toJSON(params[!(names(params) %in% c('data', 'chart', 'xAxis', 'yAxis'))])
    list(opts = opts, xAxis = xAxis, yAxis = yAxis, data = data, 
      chart = chart, chartId = chartId)
  }
))

chainConfig <- function(..., prefix){
  dotlist = list(...)
  obj = names(dotlist)
  params = dotlist[[1]]
  config <- sapply(names(params), USE.NAMES = F, function(param){
    sprintf('  .%s( %s )', param, toJSON(params[[param]]))
  })
  if (length(config) != 0L){
    paste(c(prefix, obj, config), collapse = "\n")
  } else {
    ""
  }
}

setSpec = function(spec, ... , replace = F){
  if (replace){
    list(...)
  } else {
    modifyList(spec, list(...))
  }
}
