# Utils
is.categorical <- function(x) is.factor(x) || is.character(x)

#' Highstock Plot
#'
#' ...
#'
#' @param ... see getLayer(...)
#' @param radius circle size
#' @param title chart title
#' @param subtitle chart subttitle
#' @param group.na replace NA's with chosen value in the group column, or else these observations will be removed
sPlot <- highstockPlot <- function(..., radius = 3, title = NULL, subtitle = NULL, group.na = NULL, navigator = TRUE)
{
    rChart <- Highstock$new()
    
    # Get layers
    d <- getLayer(...)
    
    data <- data.frame( x = d$data[[d$x]], y = d$data[[d$y]])
    
    if (!is.null(d$group))
    {
        data$group <- as.character(d$data[[d$group]])
        
        if (!is.null(group.na))
            data$group[is.na(data$group)] <- group.na
    }
    
    if (!is.null(d$size))
        data$size <- d$data[[d$size]]
    
    nrows <- nrow(data)
    data <- na.omit(data) # remove remaining observations with NA's
    
    if (nrows != nrow(data))
        warning("Observations with NA has been removed")
    
    data <- data[order(data$x, data$y), ] # order data (due to line charts)
    
    if ("bubble" %in% d$type && is.null(data$size)) stop("'size' is missing")
    
    if (!is.null(d$group))
    {
        groups <- sort(unique(data$group))
        types <- rep(d$type, length(groups)) # repeat types to match length of groups
        
        plyr::ddply(data,
                    .(group),
                    function(x) {
                        g <- unique(x$group)
                        i <- which(groups == g)
                        
                        x$group <- NULL # fix
                        rChart$series(
                            data = toJSONArray2(x, json = F, names = F),
                            name = g,
                            type = types[[i]],
                            marker = list(radius = radius)
                        )
                        return(NULL)
                    })
        
        rChart$legend(enabled = TRUE)
    } else
    {
        rChart$series(
            data = toJSONArray2(data, json = F, names = F),
            type = d$type[[1]],               # The type is lifted from the ...
            marker = list(radius = radius))
        
        rChart$legend(enabled = FALSE)
    }
    
    # Fix defaults
    
    ## xAxis
    if (is.categorical(data$x))
        rChart$xAxis(title = list(text = d$x), categories = unique(as.character(data$x)), replace = T)
    else
        rChart$xAxis(title = list(text = d$x), replace = T)
    
    ## yAxis
    if (is.categorical(data$y))
        rChart$yAxis(title = list(text = d$y), categories = unique(as.character(data$y)), replace = T)
    else
        rChart$yAxis(title = list(text = d$y), replace = T)
    
    ## title
    rChart$title(text = title, replace = T)
    
    ## subtitle
    rChart$subtitle(text = subtitle, replace = T)
    
    ## navigator and scrollbar panel
    rChart$navigator(enabled = navigator, replace = T)
    rChart$scrollbar(enabled = navigator, replace = T)
    
    return(rChart$copy())
}
