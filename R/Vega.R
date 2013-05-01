Vega = setRefClass('Vega', contains = 'rCharts', methods = list(
  initialize = function(...){
    callSuper(); lib <<- 'vega'; LIB <<- get_lib(lib)
    params <<- c(params, ...)
  },
  data_values = function(values){
    params$data[[1]]$values <<- values
  },
  data = function(...){
    params$data[[1]] <<- modifyList(params$data[[1]], list(...))
  },
  scales = function(..., replace = T){
    params$scales <<- setSpec(params$scales, ..., replace = replace)
  },
  axes = function(..., replace = T){
    params$axes <<- setSpec(params$marks, ..., replace = replace)
  },
  marks = function(..., replace = T){
    params$marks <<- setSpec(params$marks, ..., replace = replace)
  }
))

vPlot <- function(x, y, data, type, ...){
  def_spec <- get_def_spec(type)
  vChart <- Vega$new(def_spec)
  params_ <- getLayer(x, y, data, type, ...)
  data_values <- toJSONArray(fixLayerVega(params_)$data, json = F)
  vChart$data_values(data_values)
  return(vChart)
}

get_def_spec <- function(type){
  spec_file = system.file('libraries', 'vega', 'examples', 'vega', 
    sprintf('%s.json', type), package = 'rCharts')
  spec = fromJSON(read_file(spec_file))
  return(spec)
}

fixLayerVega = function(params_){
  x_ = params_$x; y_ = params_$y; data_ = params_$data[,c(x_, y_)]
  names(data_) = c("x", "y")
  params_$data = data_
  return(params_)
}