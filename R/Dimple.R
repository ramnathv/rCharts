dPlot <- dimplePlot <- function(x, data, ...){
  myChart <- Dimple$new()
  myChart$getChartParams(x, data, ...)
  return(myChart$copy())
}

Dimple <- setRefClass('Dimple', contains = 'rCharts', methods = list(
  initialize = function(){
    callSuper(); 
    params <<- c(params, list(
      chart = list(), xAxis = list(type="addCategoryAxis", showPercent = FALSE),
      yAxis = list(type="addMeasureAxis", showPercent = FALSE), legend = list()
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
    #there is potential to  chain the entire thing
    #making much cleaner
    #need to explore this
    #as of now thought chart is not being used
    chart = toChain(params$chart, 'myChart')
    #cannot eliminate so changed toChain to toJSON
    #but need to revert back to toChain for the axes
    xAxis = toJSON(params$xAxis) #toChain(params$xAxis, 'chart.xAxis')
    yAxis = toJSON(params$yAxis) #toChain(params$yAxis, 'chart.yAxis')
    legend = toJSON(params$legend)
    opts = toJSON(params[!(names(params) %in% c('data', 'chart', 'xAxis', 'yAxis', 'legend'))])
    list(opts = opts, xAxis = xAxis, yAxis = yAxis, legend = legend, data = data, 
         chart = chart, chartId = chartId)
  }
))