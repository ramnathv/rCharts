Highcharts <- setRefClass("Highcharts", contains = "rCharts", methods = list(
    initialize = function() {
      callSuper(); lib <<- 'highcharts'; LIB <<- get_lib(lib)
      params <<- c(params, list(
        credits = list(href = NULL, text = NULL), 
        title = list(text = NULL),
        yAxis = list(title = list(text = NULL))
      ))
    },
    
    getPayload = function(chartId){

        # Set params before rendering
        params$chart$renderTo <<- chartId

        list(chartParams = toJSON(params), chartId = chartId)
    },

    #' Wrapper methods
    chart = function(..., replace = T){
        params$chart <<- setSpec(params$chart, ..., replace = replace)
    },
    colors = function(..., replace = T){
        params$colors <<- setSpec(params$colors, ..., replace = replace)
    },
    credits = function(..., replace = T){
        params$credits <<- setSpec(params$credits, ..., replace = replace)
    },
    exporting = function(..., replace = T){
        params$exporting <<- setSpec(params$exporting, ..., replace = replace)
    },
    global = function(..., replace = T){
        params$global <<- setSpec(params$global, ..., replace = replace)
    },
    labels = function(..., replace = T){
        params$labels <<- setSpec(params$labels, ..., replace = replace)
    },    
    lang = function(..., replace = T){
        params$lang <<- setSpec(params$lang, ..., replace = replace)
    },
    legend = function(..., replace = T){
        params$legend <<- setSpec(params$legend, ..., replace = replace)
    },
    loading = function(..., replace = T){
        params$loading <<- setSpec(params$loading, ..., replace = replace)
    },
    navigation = function(..., replace = T){
        params$navigation <<- setSpec(params$navigation, ..., replace = replace)
    },
    pane = function(..., replace = T){
        params$pane <<- setSpec(params$pane, ..., replace = replace)
    },
    plotOptions = function(..., replace = T){
        params$plotOptions <<- setSpec(params$plotOptions, ..., replace = replace)
    },
    series = function(..., replace = F) {
        params$series <<- if (replace) list(list(...))
        else c(params$series, list(list(...)))
    },
    subtitle = function(..., replace = T){
        params$subtitle <<- setSpec(params$subtitle, ..., replace = replace)
    },
    title = function(..., replace = T){
        params$title <<- setSpec(params$title, ..., replace = replace)
    },
    tooltip = function(..., replace = T){
        params$tooltip <<- setSpec(params$tooltip, ..., replace = replace)
    },
    xAxis = function(..., replace = T) {
        params$xAxis <<- if (replace) list(list(...))
        else c(params$xAxis, list(list(...)))
    },
    yAxis = function(..., replace = T) {
        params$yAxis <<- if (replace) list(list(...))
        else c(params$yAxis, list(list(...)))
    }
))

# Utils
is.categorical <- function(x) is.factor(x) || is.character(x)

#' Highcharts Plot
#' 
#' ...
#' 
#' @param ... see getLayer(...)
#' @param radius circle size
#' @param title chart title
#' @param subtitle chart subttitle

hPlot <- highchartPlot <- function(..., radius = 3, title = NULL, subtitle = NULL){
    rChart <- Highcharts$new()
    
    # Get layers
    d <- getLayer(...)
    
    data <- data.frame(
        x = d$data[[d$x]],
        y = d$data[[d$y]]
    )
    
    if (!is.null(d$group)) data$group <- as.character(d$data[[d$group]])
    if (!is.null(d$size)) data$size <- d$data[[d$size]]
    
    data <- na.omit(data)  # remove observations with NA's
    data <- data[order(data$x, data$y), ]  # order data (due to line charts)
    
    if ("bubble" %in% d$type && is.null(data$size)) stop("'size' data is missing")
    
    if (!is.null(d$group)) {
        groups <- sort(unique(data$group))
        types <- rep(d$type, length(groups))  # repeat types to match length of groups
        
        plyr::ddply(data, .(group), function(x) {
            g <- unique(x$group)
            i <- which(groups == g)
            
            x$group <- NULL  # fix
            rChart$series(
                data = toJSONArray2(x, json = F, names = F),
                name = g,
                type = types[[i]],
                marker = list(radius = radius)
            )
            return(NULL)
        })
    } else {
        
        rChart$series(
            data = toJSONArray2(data, json = F, names = F),
            type = d$type[[1]],
            marker = list(radius = radius)
        )
        
        rChart$legend(enabled = FALSE)
    }
    
    # Fix default arguments
    
    ## xAxis
    if (is.categorical(data$x)) {
        rChart$xAxis(title = list(text = d$x), categories = unique(as.character(data$x)), replace = T)
    } else {
        rChart$xAxis(title = list(text = d$x), replace = T)
    }
    
    ## yAxis
    if (is.categorical(data$y)) {
        rChart$yAxis(title = list(text = d$y), categories = unique(as.character(data$y)), replace = T)
    } else {
        rChart$yAxis(title = list(text = d$y), replace = T)
    }
    
    ## title/subtitle
    rChart$title(text = title, replace = T)
    rChart$subtitle(text = subtitle, replace = T)
    
    return(rChart$copy())
}