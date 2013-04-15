PolyChart = setRefClass('PolyChart', contains = 'rCharts', methods = list(
  initialize = function(){
    lib <<- 'polycharts'
    options(RCHART_LIB = lib)
    params <<- list(dom = basename(tempfile('chart')), width = 700, height = 300,
                    layers = list(), facet = list(), guides = list(), coord = list())
  },
  layer = function(...){
    len = length(params$layers)
    params$layers[[len + 1]] <<- getLayer(...)
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
  }
))

#' Main plotting function
#' 
#' @examples
#' names(iris) = gsub('\\.', '', names(iris))
#' rPlot(SepalLength ~ SepalWidth | Species, data = iris, type = 'point', color = 'Species')
#' 
#' 

rPlot <- function(x, ...){
  UseMethod('rPlot')
}

rPlot.default <- function(x, y, data, facet = NULL, ..., width = 800, height = 400){
  myChart <- PolyChart$new()
  myChart$addParams(width = width, height = height)
  myChart$layer(x = x, y = y, data = data, facet = facet, ...)
  myChart$facet(from_layer = TRUE)
  return(myChart$copy())
}

rPlot.formula <- function(x, data, ..., width = 800, height = 400){
  myChart <- PolyChart$new()
  myChart$addParams(width = width, height = height)
  myChart$layer(x, data, ...)
  myChart$facet(from_layer = TRUE)
  return(myChart$copy())
}
