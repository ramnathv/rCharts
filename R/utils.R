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

#' Create page head for a library
get_assets <- function(lib, cdn = F, package = 'rCharts'){
  config = yaml.load_file(system.file(lib, 'config.yml', package = package))[[1]]
  if (cdn) {
    config$cdn 
  } else {
    assets = config[names(config) != 'cdn']
    LIB_URL = system.file(lib, package = 'rCharts')
    lapply(assets, function(asset) paste(LIB_URL, asset, sep = '/'))
  }
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
  if (is.null(package)){
    template = file.path(...)
  } else {
    template = system.file(..., package = package)
  }
  read_file(template)
}

#' Render mustache template and capture output ready to be written into a file
#'
#' @keywords internal
#' @noRd
render_template <- function(..., data = parent.frame(1)){
  paste(capture.output(cat(whisker.render(...))), collapse = "\n")
}