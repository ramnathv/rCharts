require(rCharts)
shinyServer(function(input, output) {
  output$show <- renderChart({
    return(.rChart_object)
  })
})
