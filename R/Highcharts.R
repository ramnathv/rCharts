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
    xAxis = function(..., replace = F) {
        params$xAxis <<- if (replace) list(list(...))
        else c(params$xAxis, list(list(...)))
    },
    yAxis = function(..., replace = F) {
        params$yAxis <<- if (replace) list(list(...))
        else c(params$yAxis, list(list(...)))
    },
    
    #' Custom add data method
    data = function(x = NULL, y = NULL, ...) {
        if (is.data.frame(x)) {
            for (i in colnames(x)) {
                if (is.numeric(x[[i]])) {
                    series(name = i, data = x[[i]], ...)
                } else {
                    warning (sprintf("Column '%s' wasn't added since it's not a numeric", i))
                }
            }
        } else {
            if (is.null(y) || !is.numeric(y)) {
                series(data = x, ...)
            } else {
                if (length(x) != length(y)) stop ("Arguments x and y must be of the same length")
                xy <- lapply(1:length(x), function(i) list(x[i], y[i]))
                series(data = xy, ...)
            }
        }
    }
))

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

    # Remove NA and sort data
    d$data <- d$data[!is.na(d$data[[d$x]]) & !is.na(d$data[[d$y]]), ]
    d$data <- d$data[order(d$data[[d$x]], d$data[[d$y]]), ]

    if (!is.null(d$color)) {
        d$data[[d$color]] <- as.character(d$data[[d$color]])
        d$data[[d$color]][is.na(d$data[[d$color]])] <- "NA"
        
        # Convert to character because of NA-values
        colors <- sort(as.character(unique(d$data[[d$color]])))
        
        # Repeat types to match length of colors
        types <- rep(d$type, length(colors))
        #sizes <- rep(d$size, length(colors))
    
        plyr::ddply(d$data, d$color, function(x) {
            clr <- unique(x[[d$color]])
            i <- which(colors == clr)
            
            # TODO: Different data structure depending on type
            rChart$data(
                x = x[[d$x]],
                y = x[[d$y]],
                name = clr,
                type = types[[i]],
                marker = list(radius = radius))
            return(NULL)
        })
    } else {
        rChart$data(x = d$data[[d$x]], y = d$data[[d$y]], type = d$type[[1]], marker = list(radius = radius))
        rChart$legend(enabled = FALSE)
    }

    # Set arguments
    rChart$xAxis(title = list(text= d$x), replace = T)
    rChart$yAxis(title = list(text= d$y), replace = T)
    rChart$title(text = title, replace = T)
    rChart$subtitle(text = title, replace = T)

    return(rChart$copy())
}

# hPlot(Height ~ Pulse, data = MASS::survey, type = c("scatter", "line"), color = "Sex", size = 4, title = "Title", subtitle = "Subtitle")