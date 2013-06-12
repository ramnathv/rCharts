rCharts = setRefClass('rCharts', list(params = 'list', lib = 'character', LIB = 'list',
    srccode = 'ANY', tObj = 'list', container = 'character', html_id = 'character'), 
      methods = list(
  initialize = function(){
    srccode <<- NULL     # source code to create the chart
    html_id <<- ""       # no id initially
    tObj <<- list()      # 
    lib <<- tolower(as.character(class(.self)))
    LIB <<- get_lib(lib) # library name and url to library folder
    container <<- 'div'  # type of container holding the chart
    params <<- list(
      dom = basename(tempfile('chart')),       # id of dom element of chart
      width = getOption('RCHART_WIDTH', 800),  # width of the container
      height = getOption('RCHART_HEIGHT', 400) # height of the container
    )
  },
  addParams = function(...){
    params <<- modifyList(params, list(...))
  },
  set = function(...){
    # this is a hack, currently for external libraries
    # idea is to initialize LIB, since the set method will always be used.
    if (length(LIB) == 0 || LIB$url == ""){
      LIB <<- get_lib(lib)
    }
    params <<- modifyList(params, list(...))
  },
  getPayload = function(chartId){
    list(chartParams = toJSON(params), chartId = chartId, lib = basename(lib))
  },
  html = function(chartId = NULL){
    params$dom <<- chartId %||% params$dom
    params$id <<- params$dom
    template = read_file(file.path(LIB$url, 'layouts', 'chart.html'))
    html = render_template(template, getPayload(params$dom))
    return(html)
  },
  print = function(chartId = NULL, include_assets = F, ...){
    params$dom <<- chartId %||% params$dom
    assetHTML <- ifelse(include_assets, add_lib_assets(lib, ...), "")
    chartDiv = sprintf("<%s id='%s' class='rChart %s'></%s>", 
      container, params$dom, LIB$name, container)
    writeLines(c(assetHTML, chartDiv, .self$html(params$dom)))
  },
  render = function(chartId = NULL, cdn = F){
    params$dom <<- chartId %||% params$dom
    template = read_template(getOption('RCHART_TEMPLATE', 'rChart.html'))
    html = render_template(template, list(
      params = params,
      assets = get_assets(LIB, static = T, cdn = cdn),
      chartId = params$dom,
      script = .self$html(params$dom),
      CODE = srccode,
      lib = LIB$name,
      tObj = tObj,
      container = container
    ))
  },
  save = function(destfile = 'index.html', ...){
    'Save chart as a standalone html page'
    writeLines(.self$render(...), destfile)
  },
  show = function(static = T, ...){
    if (static){
      writeLines(.self$render(...), tf <- tempfile(fileext = '.html'))
      browseURL(tf)
    } else {
      shiny_copy = .self$copy()
      shiny_copy$params$dom = 'show'
      assign(".rChart_object", shiny_copy, envir = .GlobalEnv)
      shiny::runApp(file.path(system.file(package = "rCharts"), "shiny"))
    }
  },
  publish = function(description = "", id = NULL, ..., host = 'gist'){
    htmlFile = file.path(tempdir(), 'index.html'); on.exit(unlink(htmlFile))
    .self$save(destfile = htmlFile, cdn = T)
    if (!is.null(.self$srccode)){
      codeFile = file.path(tempdir(), 'code.R'); on.exit(unlink(codeFile))
      writeLines(.self$srccode, con = codeFile)
      files = c(htmlFile, codeFile)
    } else {
      files = htmlFile
    }
    class(files) = host
    if (is.null(id) && (html_id != "")){
      id = html_id
    }
    html_id <<- publish_(files = files, description = description, id = id, ...)
  }
))


