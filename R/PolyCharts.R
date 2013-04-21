PolyChart = setRefClass('PolyChart', contains = 'rCharts', methods = list(
  initialize = function(){
    lib <<- 'polycharts'
    options(RCHART_LIB = lib)
    params <<- list(dom = basename(tempfile('chart')),
      width = getOption('RCHART_WIDTH', 700), 
      height = getOption('RCHART_HEIGHT', 300),
      layers = list(), facet = list(), guides = list(), coord = list())
  },
  layer = function(..., copy_layer = F){
    len = length(params$layers)
    if (!copy_layer){
      params$layers[[len + 1]] <<- getLayer(...)
    } else {
      params$layers[[len + 1]] <<- merge_list(list(...), params$layers[[len]])
    }
  },
  facet = function(..., from_layer = FALSE){
    if (from_layer){
      facet_ = getFacet(params$layers[[1]]$facet)
    } else {
      facet_ = list(...)
    }
    params$facet <<- modifyList(params$facet, facet_)
  },
  guides = function(...){
    params$guides <<- modifyList(params$guides, addSpec(...))
  },
  coord = function(...){
    params$coord <<- modifyList(params$coord, list(...))
  },
  getPayload = function(chartId){
    list(chartParams = fixJSON(toJSON(params)), chartId = chartId)
  }
))

# this is a hack to return a function in the JSON payload
fixJSON = function(x){
  gsub("\"(function.*\\})\"", "\\1", x)
}

#' Main plotting function
#' 
#' @examples
#' \dontrun{
#' names(iris) = gsub('\\.', '', names(iris))
#' rPlot(SepalLength ~ SepalWidth | Species, data = iris, type = 'point', color = 'Species')
#' }
#' 
#' 
rPlot <- function(x, ...){
  UseMethod('rPlot')
}

rPlot.default <- function(x, y, data, facet = NULL, ..., 
    width = getOption('RCHART_WIDTH', 700), height = getOption('RCHART_HEIGHT', 300)){
  myChart <- PolyChart$new()
  myChart$addParams(width = width, height = height)
  myChart$layer(x = x, y = y, data = data, facet = facet, ...)
  myChart$facet(from_layer = TRUE)
  return(myChart$copy())
}

rPlot.formula <- function(x, data, ..., 
   width = getOption('RCHART_WIDTH', 700), height = getOption('RCHART_HEIGHT', 300)){
  myChart <- PolyChart$new()
  myChart$addParams(width = width, height = height)
  myChart$layer(x, data, ...)
  myChart$facet(from_layer = TRUE)
  return(myChart$copy())
}
