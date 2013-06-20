Morris = setRefClass('Morris', contains = 'rCharts', methods = list(
  layer = function(...){
    params <<- modifyList(params, getLayer(...))
  },
  getPayload = function(chartId){
    params_ = fixLayerMorris(params)
    chartParams = toJSON2(params_[names(params_) != 'type'], digits = 13)
    chartType = toJSON2(params_$type)
    list(chartParams = chartParams, chartType = chartType)
  }
))

mPlot <- morrisPlot <- function(x, data, ...){
  rChart <- Morris$new()
  rChart$layer(x, data, ...)
  return(rChart$copy())
}


fixLayerMorris = function(params_){
  require(reshape2)
  if (!is.null(params_$group)){
    fml = as.formula(paste("...", "~", params_$group))
    y = params_$y
    params_$y = unique(params_$data[[params_$group]])
    params_$data = dcast(params_$data, fml, value.var = y)
    params_$group = NULL
  }
  params_ = rename(params_, c("x" = "xkey", "y" = "ykeys", "dom" = "element"))
  params_$labels = params_$labels %||% params_$y
  params_$data = toJSONArray(params_$data, json = F)
  params_$ykeys = as.list(params_$ykeys)
  return(params_)
}
