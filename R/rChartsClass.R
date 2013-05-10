rCharts = setRefClass('rCharts', list(params = 'list', lib = 'character', LIB = 'list',
    srccode = 'ANY', tObj = 'list', container = 'character'), methods = list(
  initialize = function(){
    srccode <<- NULL     # source code to create the chart
    tObj <<- list()      # 
    LIB <<- list()       # library name and url to library folder
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
    if (length(LIB) == 0){
      LIB <<- get_lib(lib)
    }
    params <<- modifyList(params, list(...))
  },
  getPayload = function(chartId){
    list(chartParams = toJSON(params), chartId = chartId, lib = basename(lib))
  },
  html = function(chartId = NULL){
    if (!is.null(chartId)) params$dom <<- chartId else chartId <- params$dom
    params$id <<- params$dom
    template = read_file(file.path(LIB$url, 'layouts', 'chart.html'))
    html = render_template(template, getPayload(chartId))
    return(html)
  },
  print = function(chartId = NULL, include_assets = F, ...){
    if (!is.null(chartId)) params$dom <<- chartId else chartId <- params$dom
    assetHTML <- ifelse(include_assets, add_lib_assets(lib, ...), "")
    chartDiv = sprintf("<%s id='%s' class='rChart %s'></%s>", 
      container, chartId, LIB$name, container)
    writeLines(c(assetHTML, chartDiv, .self$html(chartId)))
  },
  render = function(chartId = NULL, cdn = F){
    if (!is.null(chartId)) params$dom <<- chartId else chartId <- params$dom
    template = read_template(getOption('RCHART_TEMPLATE', 'rChart.html'))
    html = render_template(template, list(
      params = params,
      assets = get_assets(LIB, static = T, cdn = cdn),
      chartId = chartId,
      script = .self$html(chartId),
      CODE = srccode,
      lib = LIB$name,
      tObj = tObj,
      container = container
    ))
  },
  save = function(destfile = 'index.html', ...){
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
  publish = function(description = "", ..., host = 'gist', readme = NULL){
      htmlFile = file.path(tempdir(), 'index.html'); on.exit(unlink(htmlFile))
      .self$save(destfile = htmlFile, cdn = T)
      
      # Add source code
      if (!is.null(.self$srccode)){
          codeFile = file.path(tempdir(), 'code.R'); on.exit(unlink(codeFile))
          writeLines(.self$srccode, con = codeFile)
      } else codeFile = NULL
      
      # Add readme
      if (!is.null(readme)){
          readmeFile = file.path(tempdir(), 'README.md'); on.exit(unlink(readmeFile))
          writeLines(toMarkdown(readme), con = readmeFile)
      }
      
      files = c(readmeFile, htmlFile, codeFile)
      
      class(files) = host
      publish_(files = files, description = description, ...)
  }
))
