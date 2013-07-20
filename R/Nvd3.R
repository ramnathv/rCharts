nPlot <- nvd3Plot <- function(x, data, ...){
  myChart <- Nvd3$new()
  myChart$getChartParams(x, data, ...)
  return(myChart$copy())
}

Nvd3 <- setRefClass('Nvd3', contains = 'rCharts', methods = list(
  initialize = function(){
    callSuper(); 
    params <<- c(params, list(controls = list(),
      chart = list(), xAxis = list(), x2Axis = list(), yAxis = list()
    ))
  },
  chart = function(..., replace = F){
    params$chart <<- setSpec(params$chart, ..., replace = replace)
  },
  xAxis = function(..., replace = F){
    params$xAxis <<- setSpec(params$xAxis, ..., replace = replace)
    #if type is lineWithFocus and x2Axis not specified
    #make it the same as xAxis
    if(  params$type == "lineWithFocusChart" && length(params$x2Axis) == 0 ) {
      params$x2Axis <<- setSpec(params$x2Axis, ..., replace = replace)
    }
  },
  x2Axis = function(..., replace = F){
    params$x2Axis <<- setSpec(params$x2Axis, ..., replace = replace)
  },
  yAxis = function(..., replace = F){
    params$yAxis <<- setSpec(params$yAxis, ..., replace = replace)
  },
  getChartParams = function(...){
    params <<- modifyList(params, getLayer(...))
  },
  getPayload = function(chartId){
    data = toJSONArray(params$data)
    chart = toChain(params$chart, 'chart')
    xAxis = toChain(params$xAxis, 'chart.xAxis')
    x2Axis = toChain(params$x2Axis, 'chart.x2Axis')    
    yAxis = toChain(params$yAxis, 'chart.yAxis')
    controls_json = toJSON(params$controls)
    controls = setNames(params$controls, NULL)
    opts = toJSON(params[!(names(params) %in% c('data', 'chart', 'xAxis', 'x2Axis', 'yAxis', 'controls'))])
    list(opts = opts, xAxis = xAxis, x2Axis = x2Axis, yAxis = yAxis, data = data, 
         chart = chart, chartId = chartId, controls = controls, 
         controls_json = controls_json
    )
  }
))