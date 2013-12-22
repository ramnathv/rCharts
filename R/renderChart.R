#' renderChart (use with Shiny)
#' 
#' Use rCharts as Shiny output. First, use \code{renderChart} in \code{server.R}
#' to assign the chart object to an Shiny output. Then create an chartOutput
#' with the same name in #' \code{ui.R}. \code{chartOutput} is currently just an
#' alias for \code{htmlOutput}.
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
    cht_style <- sprintf("<style>.rChart {width: %spx; height: %spx} </style>",
      rChart_$params$width, rChart_$params$height)
    HTML(paste(c(cht_style, rChart_$html()), collapse = '\n'))
  }
}

renderMap = function(expr, env = parent.frame(), quoted = FALSE, html_sub = NULL){
  func <- shiny::exprToFunction(expr, env, quoted)
  function() {
    rChart_ <- func()
    map_style <- sprintf("<style>.leaflet {width: %spx; height: %spx} </style>",
      rChart_$params$width, rChart_$params$height)
    map_div = sprintf('<div id="%s" class="rChart leaflet"></div>', rChart_$params$dom)    
    rChart_html = rChart_$html()
    if (length(html_sub) > 0){
      for (i in 1:length(html_sub)){
        rChart_html = gsub(names(html_sub)[i], as.character(html_sub[i]), rChart_html)
      }
    }
    # bbest DEBUG    
    #cat(HTML(paste(c(map_style, map_div, rChart_html), collapse = '\n')), file='~/Code/rCharts/inst/apps/leaflet_chloropleth/debug_renderMap.html')
    HTML(paste(c(map_style, map_div, rChart_html), collapse = '\n'))    
  }
}

#' renderChart2 (use with Shiny)
#' 
#' renderChart2 is a modified version of renderChart. While renderChart 
#' creates the chart directly on a shiny input div, renderChart2 uses the
#' shiny input div as a wrapper and appends a new chart div to it. This
#' has advantages in being able to keep chart creation workflow the same
#' across shiny and non-shiny applications
renderChart2 <- function(expr, env = parent.frame(), quoted = FALSE) {
  func <- shiny::exprToFunction(expr, env, quoted)
  function() {
    rChart_ <- func()
    cht_style <- sprintf("<style>.rChart {width: %spx; height: %spx} </style>",
      rChart_$params$width, rChart_$params$height)
    cht <- paste(capture.output(rChart_$print()), collapse = '\n')
    HTML(paste(c(cht_style, cht), collapse = '\n'))
  }
}
