#' Converts an R object to a JSON array of objects
#' 
#' toJSON converts an R data frame to an object with key value pairs for each column. 
#' However, a lot of javascript charting libraries need an array of objects, one for
#' each row of the data frame. This utility function does that.
#' 
#' @author Ramnath Vaidyanathan
#' @keywords internal
#' @examples
#' \dontrun{
#' toJSONArray(head(iris))
#' }
toJSONArray <- function(obj, json = TRUE, nonames = TRUE){
  list2keyval <- function(l){
    keys = names(l)
    lapply(keys, function(key){
      list(key = key, values = l[[key]])
    })
  }
  obj2list <- function(df){
    l = plyr::alply(df, 1, as.list)
    if(nonames){ names(l) = NULL }
    return(l)
  }
  if (json){
    toJSON(obj2list(obj))
  } else {
    obj2list(obj)
  }
}

toJSONArray2 <- function(obj, json = TRUE, names = TRUE, ...){
  value = lapply(1:nrow(obj), function(i) {
    res <- as.list(obj[i, ])
    if (!names) names(res) <- NULL  # remove names (e.g. {x = 1, y = 2} => {1, 2})
    return(res)
  })
  if (json){
    return(toJSON(value, .withNames = F, ...))
  } else {
    names(value) <- NULL;
    return(value)
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
    sprintf("  .%s(%s)", key, toJSON2(x[[key]]))
  })
  if (length(config) != 0L){
    paste(c(obj, config), collapse = '\n')
  } else {
    ""
  }
}

# Thanks to @sigpwned and @mathematical.coffee from SO (http://goo.gl/eb0kN)
toObj <- function(x){
  gsub('\"#!(.*?)!#\"', "\\1", x)
}

toJSON2 <- function(x, ...){
  container_ = is.list(x) || (length(x) > 1)
  toObj(toJSON(x, .escapeEscapes = F, container = container_, ...))
}

toChain2 <- function(x, obj){
  if (length(x) == 0 || is.null(x)) return("")
  config <- sapply(names(x), USE.NAMES = F, function(key){
    sprintf("  .%s(%s)", key, toJSON2(x[[key]]))
  })
  paste(c(obj, config), collapse = '\n')
}

#' Convert a list to a GeoJSON compatible list.
toGeoJSON = function(list_, lat = 'latitude', lon = 'longitude'){
  x = lapply(list_, function(l){
    if (is.null(l[[lat]]) || is.null(l[[lon]])){
      return(NULL)
    }
    list(
      type = 'Feature',
      geometry = list(
        type = 'Point',
        coordinates = as.numeric(c(l[[lon]], l[[lat]]))
      ),
      properties = l[!(names(l) %in% c(lat, lon))]
    )
  })
  setNames(Filter(function(x) !is.null(x), x), NULL)
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


#courtesy of @ramnathv
to_json = function(df, orient = "columns", json = T){
  dl = as.list(df)
  dl = switch(orient, 
              columns = dl,
              records = do.call('zip_vectors_', dl),
              values = do.call('zip_vectors_', setNames(dl, NULL))
  )
  if (json){
    dl = rjson::toJSON(dl)
  }
  return(dl)
}

# ORIENTATION
# columns  {"x":[1,2],"y":["a","b"]}
# records [{"x":1,"y":"a"},{"x":2,"y":"b"}]
# values  [[1,"a"],[2,"b"]]

zip_vectors_ = function(..., names = F){
  x = list(...)
  y = lapply(seq_along(x[[1]]), function(i) lapply(x, pluck_(i)))
  if (names) names(y) = seq_along(y)
  return(y)
}

pluck_ = function (element){
  function(x) x[[element]]
}