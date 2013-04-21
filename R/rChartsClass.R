rCharts = setRefClass('rCharts', list(params = 'list', lib = 'character'), methods = list(
  addParams = function(...){
    params <<- modifyList(params, list(...))
  },
  set = function(...){
    params <<- modifyList(params, list(...))
  },
  getPayload = function(chartId){
    list(chartParams = toJSON(params), chartId = chartId)
  },
  html = function(chartId = NULL){
    if (!is.null(chartId)) params$dom <<- chartId else chartId <- params$dom
    params$id <<- params$dom
    template = read_template(lib, 'layouts', 'chart.html')
    html = render_template(template, getPayload(chartId))
    return(html)
  },
  printChart = function(chartId = NULL){
    if (!is.null(chartId)) params$dom <<- chartId else chartId <- params$dom
    chartDiv = sprintf("<div id='%s' class='rChart nvd3Plot'></div>", chartId)
    writeLines(c(chartDiv, .self$html(chartId)))
  },
  render = function(chartId = NULL, offline = TRUE){
    if (!is.null(chartId)) params$dom <<- chartId else chartId <- params$dom
    template = ifelse(offline, read_template('rChart.html'), 
      read_template(lib, 'layouts', 'script.html'))
    html = render_template(template, list(
      params = params,
      assets = get_assets(lib),
      LIB_URL = system.file(lib, package = 'rCharts'),
      chartId = chartId,
      script = .self$html(chartId))
    )
  },
  save = function(destfile = 'index.html', ...){
    writeLines(.self$render(...), destfile)
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
  },
  publish = function(description = "", ..., host = 'gist'){
    htmlFile = file.path(tempdir(), 'index.html'); on.exit(unlink(htmlFile))
    .self$save(destfile = htmlFile, offline = F)
    class(htmlFile) = host
    publish_(htmlFile = htmlFile, description = description, ...)
  }
))


