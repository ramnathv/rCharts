## This app requires OpenCPU 1.0.1 or higher !!!! 
##

#' @export
make_chart <- function(text){
  writeLines(text, con="input.R")
  chart = source('input.R', local = TRUE)$value
  # chart$set(width = 700)
  # chart$setTemplate(page = 'rChart2.html')
  chart$save('output.html', cdn = TRUE)
  invisible();
}


#' Copy directories
#' 
#' @keywords internal
copy_dir_ <- function (from, to){
  if (!(file.exists(to))) {
    dir.create(to, recursive = TRUE)
    message("Copying files to ", to, "...")
    file.copy(list.files(from, full.names = T), to, recursive = TRUE)
  }
}

open_notebook <- function(rmdFile = NULL){
  if (!is.null(rmdFile)) {
    options(NOTEBOOK_TO_OPEN = normalizePath(rmdFile))
    on.exit(options(NOTEBOOK_TO_OPEN = NULL))
  }
  options(rcharts.mode = 'inline')
  on.exit(options(rcharts.mode = NULL))
  app <- system.file('apps', 'notebook', package = 'rCharts')
  shiny::runApp(app)
}

add_rCharts <- function(libs){
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

get_lib <- function(lib, package = 'rCharts'){
  if (grepl("^http", lib)){
    return(list(name = basename(lib), url = lib))
  }
  if (file.exists(lib)){
    lib_url <- normalizePath(lib)
    lib <- basename(lib_url)
  } else {
    lib_url <- system.file('libraries', lib, package = package)
  }
  return(list(name = basename(lib), url = lib_url))
}

get_assets <- function(LIB, static = T, cdn = F, standalone = F){
  config = yaml.load_file(file.path(LIB$url, 'config.yml'))[[1]]
  if (getOption('rcharts.cdn', cdn)) {
    result = config$cdn 
  } else {
    assets = config[names(config) != 'cdn']
    prefix = ifelse(static, LIB$url, LIB$name)
    result = lapply(assets, function(asset) paste(prefix, asset, sep = '/'))
  }
  if (standalone){
    result = make_standalone_assets(result)
  }
  return(result)
}

make_standalone_assets <- function(assets){
    if (!require(base64enc)){
      stop("You need to install the base64enc package.", call. = FALSE) 
    } else {
      make_standalone__ <- dataURI
    }
    if (length(assets[['css']]) > 0){
      assets[['css']] = lapply(assets[['css']], function(x) {
       make_standalone__(file = x, mime = "text/css")
      })
    }
    if (length(assets[['jshead']]) > 0){
      assets[['jshead']] = lapply(assets[['jshead']], function(x) {
        make_standalone__(file = x, mime = "application/javascript")
      })
    }
    return(assets)
}

# make_standalone__ <- function (file, mime){
#   prefix = paste0("data:", mime, ",")
#   paste(prefix, URLencode(read_file(file)), collapse = "")
# }

# make_standalone__ <- base64enc::dataURI

#' Add library assets (useful in knitr documents)
add_lib_assets <- function(lib, cdn = F, standalone = F){
  assets = get_assets(get_lib(lib), cdn = cdn, standalone = standalone)
  styles <- lapply(assets$css, function(style){
    sprintf("<link rel='stylesheet' href=%s>", style)
  })
  scripts <- lapply(assets$jshead, function(script){
    sprintf("<script type='text/javascript' src=%s></script>", script)
  })
  paste(c(styles, scripts), collapse = '\n')
}

#' Set a default value for an object
#' 
#' This function sets the value of an object to a default value if it is not defined. 
#' @params x object
#' @params y object
#' @keywords internal
#' @noRd
`%||%` <- function(x, y){
  if (is.null(x)) y else x
}


merge_list <- function (x, y, ...){
  if (length(x) == 0) 
    return(y)
  if (length(y) == 0) 
    return(x)
  i = match(names(y), names(x))
  i = is.na(i)
  if (any(i)) 
    x[names(y)[which(i)]] = y[which(i)]
  return(x)
}

setSpec = function(spec, ... , replace = F){
  if (replace){
    list(...)
  } else {
    modifyList(spec, list(...))
  }
}

addSpec <- function(...){
  UseMethod('addSpec')
}

addSpec.default <- function(...){
  list(...)
}

addSpec.character <- function(...){
  yaml::yaml.load(...)
}

addLayer <- function(x, ...){
  UseMethod('addLayer')
}

addLayer.default <- function(...){
  
}

#' Read contents of a file into a character string
#' 
#' @params file path to text file that needs to be read
#' @params warn logical. Warn if a text file is missing a final EOL
#' @params ... other parameters to be passed to \code{\link{readLines}}
#' @keywords internal
#' @noRd
read_file <- function(file, warn = F, ...){
  paste(readLines(file, warn = warn, ...), collapse = "\n")
}

#' Read contents of a system file into a character string
#'
#' @params ... character vectors, specifying subdirectory and file(s) within some package. 
#' @params package name of the package
#' 
#' @keywords internal
#' @noRd
#  TODO: Rename this to read_sysfile to better convey what it does.
#  This function needs to be refactored
read_template <- function(..., package = 'rCharts'){
  if (is.null(package)){
    template = file.path(...)
  } else {
    template = system.file(..., package = package)
  }
  read_file(template)
}

#' Render mustache template and capture output ready to be written into a file
#'
#' @params ... arguments to be passed to 
#' @keywords internal
#' @import whisker
#' @noRd
# render_template <- function(..., data = parent.frame(1)){
#   paste(capture.output(cat(whisker.render(...))), collapse = "\n")
# }
render_template = function(template, data = parent.frame(1), ...){
  if (file.exists(template) || (grepl("^http", template) && RCurl::url.exists(template))) {
    template <- read_file(template)
  }
  paste(capture.output(
    cat(whisker.render(template, data = data, ...))
  ), collapse = "\n")
}

##' Replace HTML special characters with HTML entities
##'
##' The characters \code{c("&", "\"", "'", "<", ">")} will be replaced
##' with \code{c("&amp;", "&quot;", "&#039;", "&lt;", "&gt;")}
##' respectively.
##' @param string the string with (or w/o) HTML special chars
##' @return the string with special chars replaced.
##' @author Yihui Xie <\url{http://yihui.name}>
##' @seealso \code{\link[base]{gsub}}
##' @references \url{http://php.net/manual/en/function.htmlspecialchars.php}
##' @keywords manip
##' @export
##' @examples
##' htmlspecialchars("<a href = 'http://yihui.name'>Yihui</a>")
##' # &lt;a href = &#039;http://yihui.name&#039;&gt;Yihui&lt;/a&gt;
htmlspecialchars <- function(string) {
  x = c("&", "\"", "'", "<", ">")
  subx = c("&amp;", "&quot;", "&#039;", "&lt;", "&gt;")
  for (i in seq_along(x)) {
    string = gsub(x[i], subx[i], string, fixed = TRUE)
  }
  string
}

# tpl <- '{{# items }} {{{.}}}\n {{/ items}}'
# items <- letters[1:5]
# render_template(tpl)
# render_template <- function(template, data = parent.frame(1), ...){
#   paste(capture.output(cat(whisker.render(template, data = data, ...))), collapse = '\n')
# }


add_style_ = function(width, height){
  style = sprintf("<style>
  .rChart {
    display: block;
    margin-left: auto; 
    margin-right: auto;
    width: %spx;
    height: %spx;
  }  
  </style>", width, height) 
  return(style)
}
