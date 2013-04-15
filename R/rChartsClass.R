rCharts = setRefClass('rCharts', list(params = 'list', lib = 'character'), methods = list(
  addParams = function(...){
    params <<- modifyList(params, list(...))
  },
  set = function(...){
    params <<- modifyList(params, list(...))
  },
  getPayload = function(chartId){
    list(chartParams = toJSON(params))
  },
  html = function(chartId = NULL){
    if (!is.null(chartId)) params$dom <<- chartId else chartId <- params$dom
    params$id <<- params$dom
    template = read_template(lib, 'layouts', 'chart.html')
    html = render_template(template, getPayload(chartId))
    return(html)
  },
  printChart = function(chartId = NULL){
    writeLines(.self$html(chartId))
  },
  render = function(chartId = NULL){
    if (!is.null(chartId)) params$dom <<- chartId
    template = read_template(lib, 'layouts', 'script.html')
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
