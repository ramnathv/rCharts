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
    },
    
    # Custom add data method
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

    if (!is.null(d$group)) {
        d$data[[d$group]] <- as.character(d$data[[d$group]])
        d$data[[d$group]][is.na(d$data[[d$group]])] <- "NA"
        
        # Convert to character because of NA-values
        groups <- sort(as.character(unique(d$data[[d$group]])))
        
        # Repeat types to match length of groups
        types <- rep(d$type, length(groups))

        plyr::ddply(d$data, d$group, function(x) {
            g <- unique(x[[d$group]])
            i <- which(groups == g)
            
            # Requirements depending on chart type
            if (types[[i]] %in% c("bubble")) {
                if (is.null(d$size)) stop("Argument 'size' is missing.")
            }
            
            rChart$series(
                data = toJSONArray2(x[c(d$x, d$y, d$size)], json = F, names = F),
                name = g,
                type = types[[i]],
                marker = list(radius = radius)
            )
            return(NULL)
        })
    } else {
        
        rChart$series(
            data = toJSONArray2(d$data[c(d$x, d$y, d$size)], json = F, names = F),
            type = d$type[[1]],
            marker = list(radius = radius)
        )
        
        rChart$legend(enabled = FALSE)
    }

    # Set arguments
    rChart$xAxis(title = list(text= d$x), replace = T)
    rChart$yAxis(title = list(text= d$y), replace = T)
    rChart$title(text = title, replace = T)
    rChart$subtitle(text = subtitle, replace = T)

    return(rChart$copy())
}