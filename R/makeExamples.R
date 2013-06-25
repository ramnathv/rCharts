#' Create a page of examples with sidebar
make_example_pages <- function(exDir, htmlDir = 'gallery'){
  rFiles = dir(exDir, pattern = ".R")
  sidebar = get_sidebar(exDir)
  if (!file.exists(htmlDir)) dir.create(htmlDir)
  invisible(lapply(rFiles, make_example_page, sidebar, htmlDir))
}

get_sidebar <- function(exDir){
  rFiles = dir(exDir, pattern = "*.R")
  menu = lapply(rFiles, function(rFile){
    filename = tools:::file_path_sans_ext(basename(rFile))
    c(title = filename, href = sprintf("%s.html", filename))
  })
  list(menu = menu)
}

make_example_page <- function(rFile, sidebar, htmlDir){
  myexample = create_chart(rFile)
  filename = tools:::file_path_sans_ext(basename(rFile))
  
  active = which(lapply(sidebar$menu, '[[', 'title') == filename)
  sidebar$menu[[active]] = c(sidebar$menu[[active]], class = 'active')
  myexample$field('tObj', sidebar)
  
  htmlFile = sprintf('%s/%s.html', htmlDir, filename)
  myexample$save(destfile = htmlFile, cdn = T)
}

#' Creates an rChart, given a file with source code
#'
#' 
create_chart <- function(rFile){
  rCode = paste(readLines(rFile, warn = F), collapse = '\n')
  chart = source(rFile, local = TRUE)$value
  chart$field('srccode', rCode)
<<<<<<< HEAD
  chart$field('templates', list(page = 'rChart2.html', chartDiv = NULL))
=======
  chart$field('templates', list(page = 'rChart2.html', chartDiv = NULL, script =  chart$templates$script))
>>>>>>> a46a4853507280ac7acafeef41b9d415dd98123c
  return(chart)
}