PolyChart = setRefClass('PolyChart', list(params = 'list'), methods = list(
  initialize = function(){
    params <<- list(dom = basename(tempfile('chart')), width = 700, height = 300,
      layers = list(), facet = list(), guides = list(), coord = list())
  },
  addParams = function(...){
    params <<- modifyList(params, list(...))
  },
  layer = function(...){
    tmp <- list(...)[[1]]
    if (is.character(tmp) || is.list(tmp)){
     .self$layerDefault(...)
    } else {
     .self$layerFormula(...)
    }
  },
  layerFormula = function(x, data, ...){
    len = length(params$layers)
    fml = lattice::latticeParseFormula(x, data = data)
    params$layers[[len + 1]] <<- list(x = fml$right.name, y = fml$left.name, 
      data = data, ...)
    if (!is.null(fml$condition)){
      facet = names(fml$condition)
      if (length(facet) == 1){
        params$facet <<- list(type = 'wrap', var = facet)
      } else {
        params$facet <<- list(type = 'grid', x = facet[1], y = facet[2])
      }
    }
  },
  layerDefault = function(x, y, data, facet = NULL, ...){
    len = length(params$layers)
    params$layers[[len + 1]] <<- list(x = x, y = y, data = data, ...)
    if (!is.null(facet)){
      params$facet <<- modifyList(params$facet, facet)
    }
  },
  facet = function(...){
    params$facet <<- modifyList(params$facet, list(...))
  },
  guides = function(...){
    params$guides <<- modifyList(params$guides, addSpec(...))
  },
  coord = function(...){
    params$coord <<- modifyList(params$coord, list(...))
  },
  
  html = function(chartId = NULL){
    if (!is.null(chartId)) params$dom <<- chartId
    template = read_template('polycharts', 'layouts', 'chart.html')
    html = render_template(template, list(chartParams = toJSON(params)))
    return(html)
  },
  printChart = function(chartId = NULL){
    writeLines(.self$html(chartId))
  },
  render = function(chartId = NULL){
    if (!is.null(chartId)) params$dom <<- chartId
    template = read_template('polycharts', 'layouts', 'script.html')
    html = render_template(template, list(params = params, script = .self$html(chartId)))
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