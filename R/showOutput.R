showOutput <- function(outputId) {
  # Add javascript resources
  assets = setupResources()
  
  div(class="rChart", 
    # Add Javascripts
    tagList(assets),
    # Add chart html
    htmlOutput(outputId)
  )
}

setupResources <- function(package = 'rCharts'){
  # need to figure out a way to automatically determine this. maybe getOption.
  lib = 'polycharts'
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
