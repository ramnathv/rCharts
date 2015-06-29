# Custom setSpec method that also accepts list as an argument
# - for series, xAxis and yAxis
setListSpec <- function(obj, ..., replace)
{
    args <- list(...)
    
    if (length(args) == 1 && is.list(args[[1]]) && is.null(names(args))) {
        args <- args[[1]]
    } else {
        args <- list(args)
    }
    
    # Convert data values to a list (fixes issue 138)
    args <- lapply(args, function(x) {
        if (!is.null(x$data) && !is.list(x$data)){
            x$data <- as.list(x$data)
        }
        return(x)
    })
    
    if (replace) {
        obj <<- args
    } else {
        obj <<- c(obj, args)
    }
}

Highstock <- setRefClass("Highstock", contains = "rCharts", methods = list(
    initialize = function()
    {
        callSuper(); lib <<- 'highstock'; LIB <<- get_lib(lib)
        
        params <<- c(params, list(
                                credits = list(href = NULL, text = NULL),
                                exporting = list(enabled = T),
                                title = list(text = NULL),
                                yAxis = list(title = list(text = NULL))
                            ))
    },
    
    getPayload = function(chartId){
        
        # Set params before rendering
        params$chart$renderTo <<- chartId
        
        list(chartParams = toJSON2(params, digits = 13), chartId = chartId)
    },
    
    # Wrapper methods
    chart = function(..., replace = T)
    {
        params$chart <<- setSpec(params$chart, ..., replace = replace)
    },
    
    colors = function(..., replace = T)
    {
        args <- unlist(list(...))
        
        if (replace) {
            params$colors <<- args
        } else {
            params$colors <<- c(params$colors, args)
        }
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
    
    # Pane is not in Highstock
    #pane = function(..., replace = T){
    #    params$pane <<- setSpec(params$pane, ..., replace = replace)
    #},
    
    plotOptions = function(..., replace = T){
        params$plotOptions <<- setSpec(params$plotOptions, ..., replace = replace)
    },
    
    series = function(..., replace = F) {
        params$series <<- setListSpec(params$series, ..., replace = replace)
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
        params$xAxis <<- setListSpec(params$xAxis, ..., replace = replace)
    },
    
    yAxis = function(..., replace = T) {
        params$yAxis <<- setListSpec(params$yAxis, ..., replace = replace)
    },
    
    # >>> Specific to Highstock
    navigator = function(..., replace = T) {
        params$navigator <<- setSpec(params$navigator, ..., replace = replace)
    },
    
    scrollbar = function(..., replace = T) {
        params$scrollbar <<- setSpec(params$scrollbar, ..., replace = replace)
    },
    
    rangeSelector = function(..., replace = T) {
        params$rangeSelector <<- setSpec(params$rangeSelector, ..., replace = replace)
    },
    # <<< Specific to Highstock
    
    # Custom add data method
    #!! Seems to mostly work but may need to be adpated to highstock
    data = function(x = NULL, y = NULL, ...)
    {
        if (is.data.frame(x))
        {
            for (i in colnames(x))
            {
                if (is.numeric(x[[i]]))
                    series(name = i, data = x[[i]], ...)
                else
                    warning (sprintf("Column '%s' wasn't added since it's not a numeric", i))
            }
        } else
        {
            if (is.null(y) || !is.numeric(y))
                series(data = x, ...)
            else
            {
                if (length(x) != length(y))
                    stop ("Arguments x and y must be of the same length")
                
                xy <- lapply(1:length(x), function(i) list(x[i], y[i]))
                series(data = xy, ...)
            }
        }
    }
))
