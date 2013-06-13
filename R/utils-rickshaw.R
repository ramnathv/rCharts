#' Function to merge lists
#' 
#' @noRd
#' @keywords internal
merge_lists <- function (x, y, ...){
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

#' Set Rickshaw Defaults
#' 
#' @noRd
#' @keywords internal
rickshaw_defaults = function(chartId){
  graph = sprintf("#! graph%s !#", chartId)
  element = function(prefix){
    sprintf("#! document.getElementById('%s%s') !#", prefix, chartId)
  }
  xAxis = list(
    graph = graph,
    # element = element('xAxis'),
    extension = 'Axis.Time'
  )
  yAxis = list(
    graph =  graph,
    orientation =  'left',
    element =  element('yAxis'),
    tickFormat = "#! Rickshaw.Fixtures.Number.formatKMBT !#",
    extension = 'Axis.Y'
  )
  legend = list(
    graph = graph,
    element = element('legend'),
    extension = 'Legend'
  )
  shelving = list(
    graph = graph,
    legend = sprintf("#! legend%s !#", chartId),
    extension = 'Behavior.Series.Toggle'
  )
  highlight = list(
    graph = graph,
    legend = sprintf("#! legend%s !#", chartId),
    extension = 'Behavior.Series.Highlight'
  )
  slider = list(
    graph = graph,
    element = element("slider"),
    extension = 'RangeSlider'
  )
  hoverDetail = list(
    graph = graph,
    extension = 'HoverDetail'
  )
  list(xAxis = xAxis, yAxis = yAxis, legend = legend, hoverDetail = hoverDetail,
    shelving = shelving, highlight = highlight, slider = slider)
}

#' Make extension
#'
#' @noRd
#' @keywords internal
make_extension = function(extension, params, defaults){
  params_ = merge_lists(params[[extension]], defaults[[extension]])
  sprintf("var %s%s = new Rickshaw.Graph.%s(%s)",
    extension,
    params$dom,
    params_$extension,
    toJSON2(params_[!(names(params_) %in% c('', 'extension'))])     
  )
}

#' Make extensions
#'
#' @noRd
#' @keywords internal
make_extensions  = function(extensions, params, defaults){
  VARS = lapply(extensions, function(extension){
    if (!identical(params[[extension]], FALSE)){
      ext_var = make_extension(extension, params, defaults)
      if (extension == 'yAxis'){
        ext_var = paste(c(ext_var, sprintf('graph%s.render()', params$dom)), 
          collapse = '\n')
      }
      return(ext_var)
    } else {
      ""
    }
  })
  paste(VARS, collapse = '\n')
}

fixLayerRickshaw = function(params_){
  x_ = params_$x; y = params_$y; data_ = params_$data[,c(x_, y_)]
  names(data_) = c("x", "y")
  params_$data = data_
  return(params_)
}

`%||%` <- function(x, y){
  if (!is.null(x)) x else y
}

toSeries = function(params_, series = 'series'){
  x_ = params_$x; y_ = params_$y; group = params_$group; data_ = params_$data;
  data2 = dlply(data_, group)
  if (is.null(group)){
    names(data2) = params_$y
  }
  nm2 = names(data2)
  colors_ = params_$colors %||% rep("#! palette.color() !#", length(nm2))
  params_[[series]] = llply(seq_along(nm2), function(i){list(
    data = fixData(data2[[i]][,c(x_, y_)]), 
    name = nm2[i],
    info = setNames(
      toJSONArray(data2[[i]][,!(names(data2[[i]]) %in% y_)], json = F, nonames = F),
      data2[[i]][,x_]
    ),
    color = colors_[i])
  })
  params_$renderer = params_$type
  params_$x <- params_$y <- params_$type <- params_$group <- params_$data <- NULL
  params_$colpal <- NULL
  return(params_)
}

fixData = function(d){
  names(d) = c('x', 'y')
  toJSONArray(d, json = F)
}

#' Function to create Rickshaw plots
riPlot <- function(x, y, data, type, ..., xAxis = list(type = 'Time'), 
                   yAxis = list(orientation = 'left')){
  options(RCHART_TEMPLATE = 'Rickshaw.html')
  r1 <- Rickshaw$new()
  r1$layer(x = x, y = y, data = data, type = type, ...)
  do.call(r1$xAxis, xAxis)
  do.call(r1$yAxis, yAxis)
  return(r1)
}
