library(shiny)
options(device.ask.default = FALSE)
allow_knit = TRUE


shinyServer(function(input, output) {
  output$nbOut2 = reactive({
    src = input$nbSrc
    chart <- source(src, local = TRUE)$value
    paste(chart$render(), collapse = '\n')
  })
  
#   output$nbOut3 = renderText({
#     if (!(input$slidify == 0)){
#       src = input$nbSrc
#       print('Saved')
#     }
#   })
  
#   output$notebook <- reactive({
#     rmdFile <- input$fileinput
#     paste(readLines(rmdFile), collapse = '\n')
#   })
  
  output$downloadRmd <- downloadHandler(
    filename = 'myapp.Rmd',
    content = function(file){
     cat(input$nbSrc, file = file)
    }
  )
  
  output$nbOut = reactive({
    src = input$nbSrc
    if (input$modevariable == "R"){
      src = paste0(c(
        "```{r echo = F, results = 'asis', message = F, warning = F, comment = NA}", 
          input$nbSrc, 
        "\n```", collapse = "\n")
      )
    }
    if (allow_knit == TRUE){
      library(knitr)
      figdir = tempdir(); on.exit(unlink(figdir))
      opts_knit$set(progress = FALSE, fig.path = figdir)
      if (length(src) == 0L || src == '')
        return('Nothing to show yet...')
      on.exit(unlink('figure/', recursive = TRUE)) # do not need the figure dir
      src = paste(c(readLines('www/highlight.html'), src), collapse = '\n')
      paste(try(knit2html(text = src, fragment.only = TRUE)))
    } else {
      paste(c(readLines('www/example.html'), readLines('www/highlight.html')),
        collapse = '\n')
    }
  })
})
