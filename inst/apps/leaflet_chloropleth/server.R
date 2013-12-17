require(shiny)
require(rCharts)
shinyServer(function(input, output, session){
  output$map_container <- renderMap({
    plotMap(input$variable)
  }, html_sub = c('"features": "#! regions !#",' = '"features": regions,'))
})