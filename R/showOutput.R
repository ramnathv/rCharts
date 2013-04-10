showOutput <- function(outputId) {
  # Add javascript resources
  suppressMessages(singleton(addResourcePath("polycharts", 
    system.file('polycharts', package='rCharts'))))
    
  div(class="rChart", 
    # Add Javascripts
    tagList(
     singleton(tags$head(tags$script(src = "polycharts/js/polychart2.standalone.js", 
       type='text/javascript')))
    ),
    # Add chart html
    htmlOutput(outputId)
  )
}
