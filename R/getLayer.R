#' S3 Method to get 
#' 
#' @importFrom lattice latticeParseFormula
#' @keywords internal
#' @noRd
#' @examples
#' getLayer(mpg ~ wt, data = mtcars)
#' getLayer('mpg', 'wt', data = mtcars, color = 'cyl')

getLayer <- function(x, ...){
  UseMethod('getLayer')
}

getLayer.formula <- function(x, data, ...){
  fml = lattice::latticeParseFormula(x, data = data)
  params_ = list(x = fml$right.name, y = fml$left.name, 
    data = data, facet = names(fml$condition), ...)
  fixLayer(params_) 
}

getLayer.default <- function(x, y, data, facet = NULL, ...){
  params_ = list(x = x, y = y, data = data, facet = facet, ...)
  fixLayer(params_)
}

#' Fix an incomplete layer by adding relevant summaries and modifying the data
#' 
#' @keywords internal
#' @noRd
#' 
fixLayer <- function(params_){
  if (length(params_$y) == 0){
    variables = c(params_$x, params_$group)
    params_$data = count(params_$data, variables[variables != ""])
    params_$y = 'freq'
  }
  return(params_)
}

#' Convert faceting variable to format required by PolyChartJS
#' 
#' @keywords internal
#' @noRd
#' @examples
#' getFacet(c('x', 'y'))
#' getFacet(list(var = "x", type = "wrap", nrows = 1))
#'
getFacet <- function(facet){
  if (is.null(facet)) return(list()) 
  if (is.list(facet)) return(facet) 
  if (length(facet) == 1){
    facet = list(type = 'wrap', var = facet)
  } else {
    facet = list(type = 'grid', x = facet[1], y = facet[2])
  }
  return(facet)
}
