publish_ <- function(htmlFile, ...){
  UseMethod('publish_')
}

publish_.gist <- function(htmlFile, description, ...){
  gist = create_gist(htmlFile, description = description, ...)
  post_gist(gist)
}

publish_.rpubs <- function(htmlFile, description, ...){
  url = markdown::rpubsUpload(title = description, htmlFile, ...)
  return(url)
}
