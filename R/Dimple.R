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
      yAxis = list(type="addMeasureAxis", showPercent = FALSE),
      zAxis = list(), colorAxis = list(), legend = list()
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
  zAxis = function(..., replace = F){
    params$zAxis <<- setSpec(params$zAxis, ..., replace = replace)
  },
  colorAxis = function(...){
    .self$set(colorAxis = list(...))
  },
  legend = function(...){
    .self$set(legend = list(...))
  },
  getChartParams = function(...){
    params <<- modifyList(params, getLayer(...))
  },
  getPayload = function(chartId){
    data = to_json(params$data, orient="records")
    #there is potential to  chain the entire thing
    #making much cleaner
    #need to explore this
    #as of now thought chart is not being used
    chart = toChain(params$chart, 'myChart')
    #cannot eliminate so changed toChain to toJSON
    #but need to revert back to toChain for the axes
    xAxis = to_json(params$xAxis) #toChain(params$xAxis, 'chart.xAxis')
    yAxis = to_json(params$yAxis) #toChain(params$yAxis, 'chart.yAxis')
    zAxis = to_json(params$zAxis)
    colorAxis = to_json(params$colorAxis)
    legend = to_json(params$legend)
    opts = to_json(params[!(names(params) %in% c('data', 'chart', 'xAxis', 'yAxis', 'zAxis', 'colorAxis', 'legend'))])
    list(opts = opts, xAxis = xAxis, yAxis = yAxis, zAxis = zAxis, colorAxis = colorAxis, legend = legend, data = data, 
         chart = chart, chartId = chartId)
  }
))