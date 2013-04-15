require(rCharts)
shinyServer(function(input, output) {
  output$myChart <- renderChart({
    names(iris) = gsub("\\.", "", names(iris))
    p1 <- rPlot(input$x, input$y, data = iris, color = "Species", 
      facet = list(var = "Species", type = 'wrap'), type = 'point')
    p1$addParams(dom = 'myChart')
    return(p1)
  })
})