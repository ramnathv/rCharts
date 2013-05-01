publish_ <- function(files, ...){
  UseMethod('publish_')
}

publish_.gist <- function(files, description, ...){
  gist = create_gist(files, description = description, ...)
  post_gist(gist)
}

publish_.rpubs <- function(files, description, ...){
  htmlFile = grep('.html$', files, value = T)
  url = markdown::rpubsUpload(title = description, htmlFile, ...)
  return(url)
}

#' Run an rCharts example from a github repo
#' 
# runExample(
#    username = 'timelyportfolio', 
#    repo = 'rCharts_polycharts_standalone', 
#   filename = 'bar_athletes.R'
# )
viewExample <- runExample <- function(repo, username, ref = 'master', filename){
  require(downloader)
  tf <- tempfile(pattern = '.R')
  url <- sprintf('https://raw.github.com/%s/%s/%s/%s',
    username, repo, ref, filename)
  download(url, tf)
  mychart = rCharts::create_chart(tf)
  return(mychart)
}
