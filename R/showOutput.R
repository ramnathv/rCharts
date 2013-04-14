showOutput <- function(outputId) {
  # Add javascript resources
  scripts = setupResources()
  
  div(class="rChart", 
    # Add Javascripts
    tagList(scripts),
    # Add chart html
    htmlOutput(outputId)
  )
}

setupResources <- function(){
  lib = .rChart_object$lib
  suppressMessages(singleton(addResourcePath(lib, system.file(lib, package='rCharts'))))
  cfg_file = system.file(lib, 'config.yml', package = 'rCharts')
  scripts = paste(lib, yaml.load_file(cfg_file)[[1]]$jshead, sep = "/")
  scripts = lapply(scripts, function(script){
    singleton(tags$head(tags$script(src = script, type = 'text/javascript')))
  })
  return(scripts)
}