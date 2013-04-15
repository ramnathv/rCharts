#' Use rCharts as Shiny output. First, use \code{renderChart} in \code{server.R} to assign 
#' the chart object to an Shiny output. Then create an chartOutput with the same name in #'
#' \code{ui.R}. \code{chartOutput} is currently just an alias for \code{htmlOutput}. 
#' 
#' @author Thomas Reinholdsson, Ramnath Vaidyanathan
#' @params outputId output variable to read value from
#' @params lib name of js library used
#' @params package name where js library resides
#' @export
showOutput <- function(outputId, lib = NULL, package = 'rCharts') {
  div(class="rChart NVD3", 
    tagList(getAssets(lib, package)),
    htmlOutput(outputId)
  )
}

#' Get javascript and css assets to add to html output
#'
#' @params lib name of js library used
#' @params package name where js library resides
#' @keywords internal
#' @noRd
getAssets <- function(lib, package){
  if (is.null(lib)) lib = getOption('RCHART_LIB')
  suppressMessages(singleton(addResourcePath(lib, system.file(lib, package=package))))
  cfg_file = system.file(lib, 'config.yml', package = package)
  scripts = paste(lib, yaml.load_file(cfg_file)[[1]]$jshead, sep = "/")
  scripts = lapply(scripts, function(script){
    singleton(tags$head(tags$script(src = script, type = 'text/javascript')))
  })
  styles = yaml.load_file(cfg_file)[[1]]$css
  if (!is.null(styles)){
    styles = paste(lib, yaml.load_file(cfg_file)[[1]]$css, sep = "/")
    styles = lapply(styles, function(style){
      singleton(tags$head(tags$link(href = style, rel="stylesheet")))
    })
  }
  return(c(styles, scripts))
}
