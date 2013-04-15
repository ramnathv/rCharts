showOutput <- function(outputId, lib = NULL) {
  div(class="rChart", 
    # Add Javascripts
    tagList(setupResources(lib)),
    # Add chart html
    htmlOutput(outputId)
  )
}

setupResources <- function(lib, package = 'rCharts'){
  # this does not solve the issue still, since RCHART_LIB is not initialized
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
