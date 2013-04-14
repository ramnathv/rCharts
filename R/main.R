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
