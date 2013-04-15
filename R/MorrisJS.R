Morris = setRefClass('Morris', contains = 'rCharts', methods = list(
  initialize = function(){
    lib <<- 'morris'
    options(RCHART_LIB = lib)
    params <<- list(dom = basename(tempfile('chart')), width = 400, height = 300)
  },
  layer = function(...){
    params <<- modifyList(params, getLayer(...))
  },
  getPayload = function(chartId){
    params_ = fixLayerMorris(params)
    chartParams = toJSON(params_[names(params_) != 'type'])
    chartType = toJSON(params_$type)
    list(chartParams = chartParams, chartType = chartType)
  }
))

mPlot <- morrisPlot <- function(x, data, ...){
  rChart <- Morris$new()
  rChart$layer(x, data, ...)
  return(rChart$copy())
}

# dat = as.data.frame(HairEyeColor)
# params_ = getLayer(Freq ~ Hair, data = dat, type = 'Bar')

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
  params_$data = toJSONArray(params_$data, json = F)
  return(params_)
}
