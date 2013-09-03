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
create_chart <- function(rFile, page_ = 'rChart2.html', ...){
  rCode = paste(readLines(rFile, warn = F), collapse = '\n')
  chart = source(rFile, local = TRUE)$value
  chart$set(width = 700)
  chart$field('srccode', rCode)
  chart$setTemplate(page = page_, ...)
  return(chart)
}


#' Automate screenshot of an rChart, optionally upload it to imgur
#'
#' @param path to R file containing code to create an rChart
#' @param imgname name of the plot to save to
take_screenshot <- function(src, imgname = 'plot1', delay = 10000, upload = F){
  if (tools::file_ext(src) %in% c('r', 'R')){
    rCode = paste(readLines(src, warn = F), collapse = "\n")
    chart = source(src, local = TRUE)$value
    chart$set(width = 600, height = 325)
    tf <- tempfile(fileext = ".html"); on.exit(unlink(tf))
    chart$save(tf)
  } else {
    tf <- src
  }
  
  script = system.file('utils', 'screenshot.js', package = 'rCharts')
  cmd1 <- sprintf('casperjs %s %s %s %s', script, tf, imgname, delay)
  system(cmd1)
  cmd2 <- sprintf('convert -flatten %s.png %s.png', imgname, imgname)
  system(cmd2)
  # system(sprintf("convert %s.png  -resize 288x172", imgname))
  if (upload){
    h = knitr:::imgur_upload(paste0(imgname, '.png'))
    return(h[1])
  } else {
    return(imgname)
  }
}
