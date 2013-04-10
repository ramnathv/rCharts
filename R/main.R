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

rPlot.default <- function(x, y, data, ..., width = 800, height = 400){
  myChart <- PolyChart$new()
  myChart$addParams(width = width, height = height)
  myChart$layer2(x = x, y = y, data = data, ...)
  return(myChart$copy())
}

rPlot.formula <- function(x, data, ..., width = 800, height = 400){
  myChart <- PolyChart$new()
  myChart$addParams(width = width, height = height)
  myChart$layer(x, data, ...)
  return(myChart$copy())
}

