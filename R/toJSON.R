#' Converts an R object to a JSON array of objects
#' 
#' toJSON converts an R data frame to an object with key value pairs for each column. 
#' However, a lot of javascript charting libraries need an array of objects, one for
#' each row of the data frame. This utility function does that.
#' 
#' @author Ramnath Vaidyanathan
#' @importFrom rjson toJSON
#' @keywords internal
#' @examples
#' \dontrun{
#' toJSONArray(head(iris))
#' }
toJSONArray <- function(obj, json = TRUE){
  list2keyval <- function(l){
    keys = names(l)
    lapply(keys, function(key){
      list(key = key, values = l[[key]])
    })
  }
  obj2list <- function(df){
    l = plyr::alply(df, 1, as.list)
    names(l) = NULL
    return(l)
  }
  if (json){
    toJSON(obj2list(obj))
  } else {
    obj2list(obj)
  }
}

#' Converts an R list to a sequence of chained functions acting on a specified object.
#' 
#' @author Ramnath Vaidyanathan
#' @params x list with configuration
#' @params name of object to apply the configuration to
#' 
#' @keywords internal
#' @importFrom RJSONIO toJSON
#' @examples
#' \dontrun{
#' toChain(list(showControls = TRUE, showDistX = TRUE), "chart")
#' ## chart.showControls(true).showDistX(true)
#' }
toChain <- function(x, obj){
  config <- sapply(names(x), USE.NAMES = F, function(key){
    value = toObj(toJSON(x[[key]], container = F, .escapeEscapes = F))
    sprintf("  .%s(%s)", key, value)
  })
  if (length(config) != 0L){
    paste(c(obj, config), collapse = '\n')
  } else {
    ""
  }
}

toObj <- function(x){
  gsub('\"#!(.*)!#\"', "\\1", x)
}

toJSON2 <- function(x){
  toObj(toJSON(x, .escapeEscapes = F))
}

# toObj <- function(x){
#   gsub('#!(.*)!#', "\\1", x)
# }

# toChain <- function(x, obj){
#   config <- sapply(names(x), USE.NAMES = F, function(key){
#     value = x[[key]]
#     if(any(grepl('^#!', value))){
#       sprintf("  .%s(%s)", key, toObj(value))
#     } else {
#       sprintf("  .%s(%s)", key, toJSON(value))
#     }
#   })
#   if (length(config) != 0L){
#     paste(c(obj, config), collapse = '\n')
#   } else {
#     ""
#   }
# }
