h = Timeline$new()
h$main(
  headline = 'Sh*t People Say', 
  type = "default",
  text = "People Say Stuff",
  startDate = "2012,1,26"
)
h$event(
  startDate = "2011,12,12",
  endDate = "2012,1,27",
  headline = "Vine",
  text = "Vine Text",
  asset = list(
    media = "https://vine.co/v/b55LOA1dgJU",
    credit = "",
    caption = ""
  )
)

h$event(
  startDate = "2011,12,12",
  headline = "Sh*t Girls Say",
  text = "Vine Text",
  asset = list(
    media = "http://youtu.be/u-yLGIH7W9Y",
    credit = "",
    caption = ""
  )
)

dat <- read.csv('~/Downloads/timeline.csv', stringsAsFactors = F)
events_ <- toJSONArray(dat, json = F)
lapply(events_, function(event_){
  event_$text = markdown::renderMarkdown(text = event_$text)
  event_
})

dat <- read.csv('~/Downloads/timeline.csv', stringsAsFactors = F)
h = Timeline$new()
h$main(
  headline = 'Financial Time Series', 
  type = "default",
  text = "People Say Stuff",
  startDate = "2012,1,26"
)
h$config(
  font = "Merriweather-NewsCycle"  
)
h$events(toJSONArray(dat, json = F))

makeTimeLine <- function(mdFile){
  require(rCharts); require(yaml)
  md_ = paste(readLines(mdFile, warn = F), collapse = '\n')
  dat = lapply(strsplit(md_, '\n---|^---')[[1]][-1], yaml.load)
  tml_ = Timeline$new()
  main = dat[[1]]
  do.call(tml_$main, main[names(main) != "config"])
  do.call(tml_$config, main$config)
  for (i in 2:(length(dat))){
    do.call(tml_$event, dat[[i]])
  }
  return(tml_)  
}

