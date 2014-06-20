rCharts = setRefClass('rCharts', list(params = 'list', lib = 'character', 
    LIB = 'list', srccode = 'ANY', tObj = 'list', container = 'character', 
    html_id = 'character', templates = 'list', html_assets = 'list'),
  methods = list(
    
  initialize = function(){
    srccode <<- NULL     # source code to create the chart
    html_id <<- ""       # no id initially
    html_assets <<- list(js = NULL, css = NULL) # no external assets
    tObj <<- list()      # 
    lib <<- tolower(as.character(class(.self)))
    LIB <<- get_lib(lib) # library name and url to library folder
    container <<- 'div'  # type of container holding the chart
    params <<- list(
      dom = basename(tempfile('chart')),       # id of dom element of chart
      width = getOption('RCHART_WIDTH', 800),  # width of the container
      height = getOption('RCHART_HEIGHT', 400) # height of the container
    )
    templates <<- list(page = 'rChart.html', chartDiv = NULL, afterScript = "<script></script>",
      script =  file.path(LIB$url, 'layouts', 'chart.html'))
    templates$chartDiv <<- "<{{container}} id = '{{ chartId }}' class = 'rChart {{ lib }}'></{{ container}}>"
  },
  addAssets = function(...){
    html_assets <<- list(...)
  },
  addParams = function(...){
    params <<- modifyList(params, list(...))
  },
  addControls = function(nm, value, values, label = paste("Select ", nm, ":")){
    .self$setTemplate(
      page = 'rChartControls2.html',
      script = system.file('libraries', lib, 'controls', 
        'script.html', package = 'rCharts')
    )
    .self$set(width = 700)
    control = list(name = nm, value = value, values = values, label = label)
    params$controls[[nm]] <<- control
  },
  setTemplate = function(...){
    templates <<- modifyList(templates, list(...))
  },
  setLib = function(lib, ...){
    lib <<- lib; LIB <<- get_lib(lib)
    templates <<- modifyList(list(
      page = 'rChart.html', 
      chartDiv = "<{{container}} id = '{{ chartId }}' class = 'rChart {{ lib }}'></{{ container}}>", 
      script =  file.path(LIB$url, 'layouts', 'chart.html')
    ), list(...))
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
    if(!is.null(params$digits))
      JSONized = toJSON(params, digits=params$digits)
    else
      JSONized = toJSON(params)
    list(chartParams = JSONized, chartId = chartId, lib = basename(lib), liburl = LIB$url)
  },
  html = function(chartId = NULL){
    params$dom <<- chartId %||% params$dom
    params$id <<- params$dom
    # template = read_file(templates$script)
    html = render_template(templates$script, getPayload(params$dom))
    return(html)
  },
  print = function(chartId = NULL, include_assets = F, ...){
    params$dom <<- chartId %||% params$dom
    assetHTML <- ifelse(include_assets, paste(
      paste(add_lib_assets(lib, ...), collapse = '\n'), '\n',
      add_style_(params$width, params$height), 
      collapse = '\n'
    ), "")
    chartDiv = render_template(templates$chartDiv, list(
      chartId = params$dom,
      lib = LIB$name,
      container = container
    ))
    writeLines(c(assetHTML, chartDiv, .self$html(params$dom)))
  },
  render = function(chartId = NULL, cdn = F, static = T, standalone = F){
    params$dom <<- chartId %||% params$dom
    template = read_template(getOption('RCHART_TEMPLATE', templates$page))
    assets = Map("c", 
      get_assets(LIB, static = static, cdn = cdn, standalone = standalone), 
      html_assets
    )
    html = render_template(template, list(
      params = params,
      assets = assets,
      chartId = params$dom,
      script = .self$html(params$dom),
      CODE = srccode,
      lib = LIB$name,
      tObj = tObj,
      container = container), 
      partials = list(
        chartDiv = templates$chartDiv,
        afterScript = templates$afterScript %||% "<script></script>"
      )
    )
  },
  save = function(destfile = 'index.html', ...){
    'Save chart as a standalone html page'
    writeLines(.self$render(...), destfile)
  },
  show = function(mode_ = NULL, ..., extra_files = NULL){
    mode_ = getMode(mode_)
    switch(mode_, 
       static = {
         dir.create(temp_dir <- tempfile(pattern = 'rCharts'))
         static_ = grepl("^http", LIB$url) || is.null(viewer <- getOption('viewer'))
         writeLines(.self$render(..., static = static_), 
           tf <- file.path(temp_dir, 'index.html')
         )
         if (!static_){
           suppressMessages(copy_dir_(LIB$url, file.path(temp_dir, LIB$name)))
           if (!is.null(extra_files)){
             suppressMessages(file.copy(extra_files, temp_dir))
           }
         }
         getOption('viewer', browseURL)(tf)
      },
      server = {
        shiny_copy = .self$copy()
        shiny_copy$params$dom = 'show'
        assign(".rChart_object", shiny_copy, envir = .GlobalEnv)
        if (packageVersion('shiny') > 0.7) {
          brwsr <- getOption('viewer', interactive())
        } else {
          brwsr <- getOption('shiny.launch.browser', interactive())
        }
        shiny::runApp(
          file.path(system.file(package = "rCharts"), "shiny"),
          launch.browser = brwsr
        )
      },
      inline = {
        add_ext_widgets(lib)
        return(.self$print(...))
      },
      iframe = {
        chunk_opts_ = opts_current$get() 
        file_ = knitr:::fig_path('.html', chunk_opts_)
        if (!file.exists(dirname(file_))){
          dir.create(dirname(file_))
        }
        cdn = !(chunk_opts_$rcharts %?=% 'draft')
        .self$save(file_, cdn = cdn)
        cat(c(
          "<iframe src='", file_, 
          "' scrolling='no' frameBorder='0' seamless", paste("class='rChart", lib, "'"),
          "id=iframe-", params$dom, "></iframe>",
          "<style>iframe.rChart{ width: 100%; height: 400px;}</style>"
        ))
        # cat(sprintf("<iframe src=%s seamless></iframe>", file_))
        return(invisible())
      },
      iframesrc = {
        cat(c(
          "<iframe srcdoc='", htmlspecialchars(.self$render(...)),
          "' scrolling='no' frameBorder='0' seamless class='rChart ", lib, " '",
          paste0("id='iframe-", params$dom, "'>"), "</iframe>\n",
          "<style>iframe.rChart{ width: 100%; height: 400px;}</style>"
        ))
        return(invisible())
      },
      ipynb = {
        if (!require(IRdisplay)){
          return(
            message('You need to install the IRdisplay package from github.')
          )
        }
        y = paste(capture.output(.self$show('iframesrc', cdn = TRUE)), 
          collapse = "\n")
        display_html(y)
      }
    )
  },
  publish = function(description = "", id = NULL, ..., host = 'gist'){
    htmlFile = file.path(tempdir(), 'index.html'); on.exit(unlink(htmlFile))
    .self$save(destfile = htmlFile, cdn = T)
    # imgFile = file.path(tempdir(), 'thumbnail.png'); on.exit(unlink(imgFile))
    # take_screenshot(htmlFile, tools::file_path_sans_ext(imgFile))
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

add_ext_widgets <- function(lib){
  libpath = paste('libraries', lib, sep = "/")
  if (exists('.SLIDIFY_ENV') && 
      !(libpath %in% .SLIDIFY_ENV$ext_widgets$rCharts)){
    rcharts_widgets = .SLIDIFY_ENV$ext_widgets$rCharts
    len = length(rcharts_widgets)
    .SLIDIFY_ENV$ext_widgets$rCharts[[len + 1]] <<- libpath
  }
}

getMode = function(mode_){
  default = ifelse(getOption('knitr.in.progress') %?=% TRUE, 'iframe', 'static')
  mode_ = mode_ %||% getOption('rcharts.mode') %||% default
  return(mode_)
}

`%?=%` <- function(x, y){
  ifelse(!is.null(x), x == y, FALSE)
}
