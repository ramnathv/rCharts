require(shiny)
require(rCharts)
# addResourcePath('assets', system.file('shiny', 'assets', package = 'knitr'))


libs = c('polycharts', 'nvd3', 'morris', 'xcharts')
foo <- function(libs){
  require(rCharts)
  add_rCharts(libs)
  tagList(lapply(libs, get_rCharts_assets))
}

# libs = 'vega'
# if (!exists('rmdFile')){
#   rmdFile <- 'www/example.Rmd'
# }


rmdFile <- getOption('NOTEBOOK_TO_OPEN', 'www/example.Rmd')
libs = c('polycharts', 'nvd3', 'morris', 'xcharts', 'highcharts', 'rickshaw', 'leaflet')
add_rCharts(libs)


# div nbSrc takes source code from div notebook (via Ace editor), and div nbOut
# holds results from knitr
shinyUI(
  bootstrapPage(
    tags$head(
      tags$title('An R Notebook in Shiny'),
      # tags$script(src = 'http://ace.ajax.org/build/src-min-noconflict/ace.js',
      #  type = 'text/javascript', charset = 'utf-8'),
      tags$script(src='assets/ace/js/ace.js', type = 'text/javascript', charset = 'utf-8'),
      tags$script(src='assets/app.js', type = 'text/javascript', charset = 'utf-8'),
      tags$link(rel = 'stylesheet', type = 'text/css', href = 'assets/ace-shiny.css'),
      tags$link(rel = 'stylesheet', type = 'text/css', href = 'assets/styles.css'),
      tags$script(src = 'assets/highlight.pack.js', type = 'text/javascript'),
      tags$script('hljs.initHighlightingOnLoad();'),
      tags$link(rel = 'stylesheet', type = 'text/css', href = 'assets/tomorrow.css'),
      tags$script(src = 'https://c328740.ssl.cf1.rackcdn.com/mathjax/2.0-latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML', type = 'text/javascript'),
      foo(libs)
    ),
    tags$body(
      includeHTML('www/header.html'),
      tags$section(id = "main",
      div(id = 'notebook', title = 'Compile notebook: F4\nInsert chunk: Ctrl+Alt+I',
        paste(readLines(rmdFile), collapse = '\n')),
      # uiOutput('notebook'),
        tags$textarea(id = 'nbSrc', style = 'display: none;'),
        div(id = 'nbOut', class='shiny-html-output')
      )
        # div(id = 'nbOut', class='shiny-html-output')
        # htmlOutput('nbOut')
        # div(id = 'proxy', submitButton('Knit HTML'))
    ),
    tags$script(src = 'assets/ace-shiny.js', type = 'text/javascript')
    # includeHTML('www/highlight.html')
  )
)

