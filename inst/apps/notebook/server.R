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
    if (allow_knit == TRUE){
      library(knitr)
      figdir = tempdir(); on.exit(unlink(figdir))
      opts_knit$set(progress = FALSE, fig.path = figdir)
      if (length(src) == 0L || src == '')
        return('Nothing to show yet...')
      on.exit(unlink('figure/', recursive = TRUE)) # do not need the figure dir
      paste(try(knit2html(text = src, fragment.only = TRUE)),
            '<script>',
            '// highlight code blocks',
            "$('#nbOut pre code').each(function(i, e) {hljs.highlightBlock(e)});",
            'MathJax.Hub.Typeset(); // update MathJax expressions',
            '</script>', sep = '\n'
      )
    } else {
      paste(c(readLines('www/example.html'), readLines('www/highlight.html')),
        collapse = '\n')
    }
  })
})
