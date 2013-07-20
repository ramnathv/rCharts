publish_ <- function(files, description, id, ...){
  UseMethod('publish_')
}

publish_.gist <- function(files, description, id, ...){
  gist = create_gist(files, description = description, ...)
  if (is.null(id)){
    html_id = post_gist(gist)
  } else {
    html_id = update_gist(gist, id)
  }
  invisible(html_id)
}

publish_.rpubs <- function(files, description, id, ...){
  htmlFile = grep('.html$', files, value = T)
  url = markdown::rpubsUpload(title = description, htmlFile, id = id, ...)
  message("Claim your page on RPubs at: ", "\n", url$continueUrl)
  return(url$id)
}

#' Run an rCharts example from a github repo
#' 
# runExample(
#    username = 'timelyportfolio', 
#    repo = 'rCharts_polycharts_standalone', 
#   filename = 'bar_athletes.R'
# )
viewExample <- function(repo, username, ref = 'master', filename){
  require(downloader)
  tf <- tempfile(pattern = '.R')
  url <- sprintf('https://raw.github.com/%s/%s/%s/%s',
    username, repo, ref, filename)
  download(url, tf)
  mychart = rCharts::create_chart(tf)
  return(mychart)
}
