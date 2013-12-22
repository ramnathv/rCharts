Polycharts = setRefClass('Polycharts', contains = 'rCharts', methods = list(
  initialize = function(){
    callSuper(); 
    params <<- c(params, list(layers = list(), facet = list(), guides = list(), 
      coord = list(), controls = list()))
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
    controls_json = toJSON(params$controls)
    controls = setNames(params$controls, NULL)
    list(
      chartParams = toJSON2(params[names(params) != 'controls']), 
      chartId = chartId,
      controls_json = toJSON(params$controls),
      controls = setNames(params$controls, NULL)
    )
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

rPlot.default <- function(x, y, data, facet = NULL, ...){
  myChart <- Polycharts$new()
  myChart$layer(x = x, y = y, data = data, facet = facet, ...)
  myChart$facet(from_layer = TRUE)
  return(myChart$copy())
}

rrPlot <- function(x, y, data, facet = NULL, ...){
  myChart <- Polycharts$new()
  myChart$layer(x = x, y = y, data = data, facet = facet, ...)
  myChart$facet(from_layer = TRUE)
  myChart$render(cdn = TRUE)
}

Render <- function(x){
  x$render(cdn = TRUE)
}

rPlot.formula <- function(x, data, ...){
  myChart <- Polycharts$new()
  myChart$layer(x, data, ...)
  myChart$facet(from_layer = TRUE)
  return(myChart$copy())
}
