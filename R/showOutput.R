#' Use rCharts as Shiny output. First, use \code{renderChart} in \code{server.R} to assign 
#' the chart object to an Shiny output. Then create an chartOutput with the same name in #'
#' \code{ui.R}. \code{chartOutput} is currently just an alias for \code{htmlOutput}. 
#' 
#' @author Thomas Reinholdsson, Ramnath Vaidyanathan
#' @params outputId output variable to read value from
#' @params lib name of js library used
#' @params package name where js library resides
#' @export
chartOutput <- showOutput <- function(outputId, lib = NULL, package = 'rCharts', 
    add_lib = TRUE){
  if (!is.null(lib)){
    LIB <- get_lib(lib)
  } else if (exists(".rChart_object")) {
    LIB <- .rChart_object$LIB
  }
  if (add_lib){
    suppressMessages(singleton(addResourcePath(LIB$name, LIB$url)))
  }
  div(
    id = outputId, 
    class=paste('shiny-html-output', 'rChart', basename(LIB$name)),
    ifelse(add_lib, tagList(get_assets_shiny(LIB)), "")
  )
}

mapOutput <- function(outputId){
  chartOutput(outputId, lib = 'leaflet', package)
}

get_assets_shiny <- function(LIB){
  assets <- get_assets(LIB, static = F)
  assets$jshead <- Filter(filter_jquery, assets$jshead)
  scripts <- lapply(assets$jshead, function(script){
    singleton(tags$head(tags$script(src = script, type = 'text/javascript')))
  })
  styles <- lapply(assets$css, function(style){
    singleton(tags$head(tags$link(href = style, rel="stylesheet")))
  })
  return(c(styles, scripts))
}

filter_jquery <- function(js){
  jquery = c('jquery.js', 'jquery.min.js', 'jquery-1.8.2.min.js', 'jquery-1.9.1.min.js')
  !(basename(js) %in% jquery)
}