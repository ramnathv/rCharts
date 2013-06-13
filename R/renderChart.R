#' renderChart (use with Shiny)
#' 
#' Use rCharts as Shiny output. First, use \code{renderChart} in \code{server.R} to assign 
#' the chart object to an Shiny output. Then create an chartOutput with the same name in #'
#' \code{ui.R}. \code{chartOutput} is currently just an alias for \code{htmlOutput}. 
#' 
#' @author Thomas Reinholdsson, Ramnath Vaidyanathan
#' @param expr An expression that returns a chart object
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is expr a quoted expression (with \code{quote()})? This is
#'  useful if you want to save an expression in a variable.
#'   
#' @export
renderChart <- function(expr, env = parent.frame(), quoted = FALSE) {
  func <- shiny::exprToFunction(expr, env, quoted)
  function() {
    rChart_ <- func()
    rChart_$html()
  }
}


renderMap = function(expr, env = parent.frame(), quoted = FALSE){
  func <- shiny::exprToFunction(expr, env, quoted)
  function() {
    rChart_ <- func()
    map_style <- sprintf("<style>.leaflet {width: %spx; height: %spx} </style>",
      rChart_$params$width, rChart_$params$height)
    map_div = sprintf('<div id="%s" class="rChart leaflet"></div>', rChart_$params$dom)
    HTML(paste(c(map_style, map_div, rChart_$html()), collapse = '\n'))
  }
}