PolyChart = setRefClass('PolyChart', list(params = 'list'), methods = list(
  initialize = function(){
    params <<- list(dom = basename(tempfile('chart')), width = 700, height = 300)
    params$layers <<- list()
    params$facet <<- list()
    params$guides <<- list()
  },
  addParams = function(...){
    params <<- modifyList(params, list(...))
  },
  layer = function(x, data, ...){
    len = length(params$layers)
    fml = lattice::latticeParseFormula(x, data = data)
    params$layers[[len + 1]] <<- list(x = fml$right.name, y = fml$left.name, 
      data = data, ...)
    if (!is.null(fml$condition)){
      params$facet <<- c(params$facet, type = 'wrap', var = names(fml$condition))
      # len = length(params$facet)
      # params$facet[[len + 1]] <<- list(type = 'type', var = facet)
    }
  },
  layer2 = function(x, y, data, facet = NULL, ...){
    len = length(params$layers)
    params$layers[[len + 1]] <<- list(x = x, y = y, data = data, ...)
    if (!is.null(facet)){
      params$facet <<- c(params$facet, type = 'wrap', var = facet)
      # len = length(params$facet)
      # params$facet[[len + 1]] <<- list(type = 'type', var = facet)
    }
  },
  facet = function(...){
    len = length(params$facets)
    params$facet[[len + 1]] <<- list(...)
  },
  guides = function(...){
    params$guides <<- modifyList(params$guides, addGuide(...))
  },
  html = function(chartId = NULL){
    template_file = system.file('polycharts', 'layouts', 'polychart1.html', 
      package = 'rCharts')
    template = paste(readLines(template_file, warn = F), collapse = '\n')
    if (is.null(chartId)){
      chartId <- params$dom
    } else {
      params$dom <<- chartId
    }
    chartParams = toJSON(params)
    html = paste(capture.output(cat(whisker.render(template))), collapse = '\n')
    return(html)
  },
  printChart = function(chartId = NULL){
    writeLines(.self$html(chartId))
  },
  render = function(chartId = NULL){
    if (is.null(chartId)){
      chartId <- params$dom
    } else {
      params$dom <<- chartId
    }
    template_file = system.file('polycharts', 'layouts', 'polychart2.html', 
      package = 'rCharts')
    template = paste(readLines(template_file, warn = F), collapse = '\n')
    partials = list(polychart1 = .self$html(chartId))
    html = capture.output(cat(whisker.render(template, partials = partials)))
  },
  save = function(destfile = 'index.html'){
    writeLines(.self$render(), destfile)
  },
  show = function(static = !("shiny" %in% rownames(installed.packages()))){
    if (static){
      tf <- tempfile(fileext = 'html');
      writeLines(.self$render(), tf)
      system(sprintf("open %s", tf))
    } else {
      shiny_copy = .self$copy()
      shiny_copy$params$dom = 'show'
      assign(".rChart_object", shiny_copy, envir = .GlobalEnv) 
      shiny::runApp(file.path(system.file(package = "rCharts"), "shiny"))
    }
  }
))