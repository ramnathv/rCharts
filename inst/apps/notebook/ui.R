library(shiny)
# addResourcePath('assets', system.file('shiny', 'assets', package = 'knitr'))

add_rCharts <- function(libs){
  require(rCharts)
  LIBS <- lapply(libs, get_lib)
  invisible(lapply(LIBS, function(LIB){
    suppressMessages(singleton(addResourcePath(LIB$name, LIB$url)))
  }))
  return(NULL)
}

get_rCharts_assets <- function(lib){
  LIB <- get_lib(lib)
  assets = get_assets_shiny(LIB)
  assets[!grepl('jquery', assets)]
}

libs = c('polycharts', 'nvd3', 'morris', 'xcharts')
add_rCharts(libs)

# div nbSrc takes source code from div notebook (via Ace editor), and div nbOut
# holds results from knitr
shinyUI(
  bootstrapPage(
    tags$head(
      tags$title('An R Notebook in Shiny'),
      tags$script(src = 'http://ace.ajax.org/build/src-min-noconflict/ace.js',
        type = 'text/javascript', charset = 'utf-8'),
      tags$link(rel = 'stylesheet', type = 'text/css', href = 'assets/ace-shiny.css'),
      tags$script(src = 'assets/highlight.pack.js', type = 'text/javascript'),
      tags$link(rel = 'stylesheet', type = 'text/css', href = 'assets/tomorrow.css'),
      tags$script(src = 'https://c328740.ssl.cf1.rackcdn.com/mathjax/2.0-latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML', type = 'text/javascript')
    ),
    div(id = 'notebook', title = 'Compile notebook: F4\nInsert chunk: Ctrl+Alt+I',
      paste(readLines('www/example.Rmd'), collapse = '\n')),
    tags$textarea(id = 'nbSrc', style = 'display: none;'),
    tags$script(src = 'assets/ace-shiny.js', type = 'text/javascript'),
    tagList(lapply(libs, get_rCharts_assets)),
    # add_rCharts(c('nvd3', 'polycharts')),
    htmlOutput('nbOut'),
    div(id = 'proxy', submitButton('Knit Notebook'))
  )
)
