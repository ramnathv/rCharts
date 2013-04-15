#' Utility function to convert R objects to JSON
#' 
#' 
r2json <- function(x, ...){
  UseMethod("r2json")
}

r2json.default <- rjson::toJSON

r2json.data.frame <- function(df, key = NULL){
  list2keyval <- function(l){
    keys = names(l)
    lapply(keys, function(key){
      list(key = key, values = l[[key]])
    })
  }
  
  df2list <- function(df){
    l = plyr::alply(df, 1, as.list)
    names(l) = NULL
    return(l)
  }
  
  df2keyval <- function(df, key){
    if (is.null(key)){
      df2list(df)
    } else {
      list2keyval(plyr::dlply(df, key, df2list))
    }
  }
  rjson::toJSON(df2keyval(df, key))
}