addSpec <- function(...){
  UseMethod('addSpec')
}

addSpec.default <- function(...){
  list(...)
}

addSpec.character <- function(...){
  yaml::yaml.load(...)
}

addLayer <- function(x, ...){
  UseMethod('addLayer')
}

addLayer.default <- function(...){
  
}

#' Read contents of a file into a character string
#' 
#' @keywords internal
#' @noRd
read_file <- function(file){
  paste(readLines(file, warn = F), collapse = "\n")
}

#' Read contents of a system file into a character string
#'
#' @params ... character vectors, specifying subdirectory and file(s) within some package. 
#' @params package name of the package
#' 
#' @keywords internal
#' @noRd
read_template <- function(..., package = 'rCharts'){
  template = system.file(..., package = package)
  read_file(template)
}

#' Render mustache template and capture output ready to be written into a file
#'
#' @keywords internal
#' @noRd
render_template <- function(..., data = parent.frame(1)){
  paste(capture.output(cat(whisker.render(...))), collapse = "\n")
}