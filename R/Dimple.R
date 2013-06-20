dPlot <- dimplePlot <- function(x, data, ...){
  myChart <- Dimple$new()
  myChart$getChartParams(x, data, ...)
  return(myChart$copy())
}

Dimple <- setRefClass('Dimple', contains = 'rCharts', methods = list(
  initialize = function(){
    callSuper(); 
    params <<- c(params, list(
      chart = list(), xAxis = list(), yAxis = list()
    ))
  },
  chart = function(..., replace = F){
    params$chart <<- setSpec(params$chart, ..., replace = replace)
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
    data = toJSONArray(params$data)
    #can I eliminate this or should I leave?
    chart = toChain(params$chart, 'chart')
    #cannot eliminate so changed toChain to toJSO
    xAxis = toJSON(params$xAxis) #toChain(params$xAxis, 'chart.xAxis')
    yAxis = toJSON(params$yAxis) #toChain(params$yAxis, 'chart.yAxis')
    opts = toJSON(params[!(names(params) %in% c('data', 'chart', 'xAxis', 'yAxis'))])
    list(opts = opts, xAxis = xAxis, yAxis = yAxis, data = data, 
         chart = chart, chartId = chartId)
  }
))