make_dataset <- function(x, y, data, group = NULL){
  require(plyr)
  dat <- rename(data, setNames(c('name', 'value'), c(x, y)))
  dat <- dat[c('name', 'value', group)]
  if (!is.null(group)){
    dlply(dat, group, toJSONArray, json = F)
  } else {
    list(data = toJSONArray(dat, json = F)) 
  }
}

Uvcharts <- setRefClass('Uvcharts', contains = 'rCharts', methods = list(
  initialize = function(){
    callSuper()
    params$config <<- list(meta = list(position = "#uv-div"))
  },
  config = function(..., replace = F){
    params$config <<- setSpec(params$config, ..., replace = replace)
  }
))

uPlot <- function(x, y, data, group = NULL, type, ...){
  dataset = make_dataset(x = x, y = y, data = data, group = group)
  u1 <- Uvcharts$new()
  u1$set(graphdef = list(
    categories = as.list(names(dataset)),
    dataset = dataset
  ), type = type)
  
  dotlist = list(...)
  if (length(dotlist) > 0){
   u1$config(...)
  }
  return(u1)
}
