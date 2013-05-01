open_notebook <- function(){
 require(shiny)
 app <- system.file('notebook', package = 'rCharts')
 runApp(app)
}

get_lib <- function(lib){
  if (file.exists(lib)){
    lib_url <- normalizePath(lib)
    lib <- basename(lib_url)
  } else {
    lib_url <- system.file('libraries', lib, package = 'rCharts')
  }
  return(list(name = basename(lib), url = lib_url))
}

get_assets <- function(LIB, static = T, cdn = F){
  config = yaml.load_file(file.path(LIB$url, 'config.yml'))[[1]]
  if (cdn) {
    config$cdn 
  } else {
    assets = config[names(config) != 'cdn']
    prefix = ifelse(static, LIB$url, LIB$name)
    lapply(assets, function(asset) paste(prefix, asset, sep = '/'))
  }
}

#' Set a default value for an object
#' 
#' This function sets the value of an object to a default value if it is not defined. 
#' @params x object
#' @params y object
#' @keywords internal
#' @noRd
`%||%` <- function(x, y){
  if (is.null(x)) y else x
}

#' Creates an rChart, given a file with source code
#'
#' 
create_chart <- function(rFile){
  rCode = paste(readLines(rFile, warn = F), collapse = '\n')
  chart = source(rFile, local = TRUE)$value
  chart$field('srccode', rCode)
  options(RCHART_TEMPLATE = 'rChart2.html')
  return(chart)
}


merge_list <- function (x, y, ...){
  if (length(x) == 0) 
    return(y)
  if (length(y) == 0) 
    return(x)
  i = match(names(y), names(x))
  i = is.na(i)
  if (any(i)) 
    x[names(y)[which(i)]] = y[which(i)]
  return(x)
}

setSpec = function(spec, ... , replace = F){
  if (replace){
    list(...)
  } else {
    modifyList(spec, list(...))
  }
}

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
#' @params file path to text file that needs to be read
#' @params warn logical. Warn if a text file is missing a final EOL
#' @params ... other parameters to be passed to \code{\link{readLines}}
#' @keywords internal
#' @noRd
read_file <- function(file, warn = F, ...){
  paste(readLines(file, warn = warn, ...), collapse = "\n")
}

#' Read contents of a system file into a character string
#'
#' @params ... character vectors, specifying subdirectory and file(s) within some package. 
#' @params package name of the package
#' 
#' @keywords internal
#' @noRd
#  TODO: Rename this to read_sysfile to better convey what it does.
#  This function needs to be refactored
read_template <- function(..., package = 'rCharts'){
  if (is.null(package)){
    template = file.path(...)
  } else {
    template = system.file(..., package = package)
  }
  read_file(template)
}

#' Render mustache template and capture output ready to be written into a file
#'
#' @params ... arguments to be passed to 
#' @keywords internal
#' @import whisker
#' @noRd
render_template <- function(..., data = parent.frame(1)){
  paste(capture.output(cat(whisker.render(...))), collapse = "\n")
}


# tpl <- '{{# items }} {{{.}}}\n {{/ items}}'
# items <- letters[1:5]
# render_template(tpl)
# render_template <- function(template, data = parent.frame(1), ...){
#   paste(capture.output(cat(whisker.render(template, data = data, ...))), collapse = '\n')
# }