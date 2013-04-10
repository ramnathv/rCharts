addGuide <- function(...){
  UseMethod('addGuides')
}

addGuides.default <- function(...){
  list(...)
}

addGuides.character <- function(...){
  yaml::yaml.load(...)
}

addLayer <- function(x, ...){
  UseMethod('addLayer')
}

addLayer.default <- function(...){
  
}