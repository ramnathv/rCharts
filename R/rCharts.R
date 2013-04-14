PolyChart = setRefClass('PolyChart', list(params = 'list'), methods = list(
  initialize = function(){
    params <<- list(dom = basename(tempfile('chart')), width = 700, height = 300,
      layers = list(), facet = list(), guides = list(), coord = list())
  },
  addParams = function(...){
    params <<- modifyList(params, list(...))
  },
  layer = function(...){
    len = length(params$layers)
    params$layers[[len + 1]] <<- getLayer(...)
  },
  facet = function(..., from_layer = FALSE){
    if (from_layer){
      facet_ = getFacet(params$layers[[1]]$facet)
    } else {
      facet_ = list(...)
    }
    params$facet <<- modifyList(params$facet, facet_)
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