Timeline = setRefClass('Timeline', contains = 'rCharts', method = list(
  initialize = function(){
    callSuper();
    params <<- c(params, list(config = list(source = 'dataObject')))
    templates$page <<- 'Timeline.html'
  },
  main = function(...){
    params$timeline <<- list(...)
  },
  event = function(...){
    event_ = as.list(...)
    if (!is.null(event_$text)){
      event_$text = markdown::renderMarkdown(text = event_$text)
    }
    if (is.null(params$timeline$date)){
      params$timeline$date <<- event_
    } else {
      params$timeline$date <<- list(params$timeline$date, event_)
    }
  },
  events2 = function(events_){
    params$timeline$date <<- lapply(events_, function(event_){
      event_$text = markdown::renderMarkdown(text = event_$text)
      not_asset = c('startDate', 'endDate', 'headline', 'text')
      event_$asset = event_[!(names(event_) %in% not_asset)]
      event_[!(names(event_) %in% c(not_asset, "asset"))] = NULL
      return(event_)
    })
  },
  events = function(events_){
    events_ = lapply(events_, function(event_){
      event_$text = markdown::renderMarkdown(text = event_$text)
      return(event_)
    })
    params$timeline$date <<- events_
  },
  config = function(...){
    params$config <<- modifyList(params$config, list(...))
  },
  getPayload = function(chartId){
    params$config$embed_id <<- params$dom
    dataObject = toJSON(params[names(params) != 'config'])
    config = toJSON(params$config)
    list(
      dataObject = dataObject, 
      config = config, 
      chartId = chartId,
      params = params
    )
  }
))

makeTimeLine <- function(mdFile){
  md_ = paste(readLines(mdFile, warn = F), collapse = '\n')
  dat = lapply(strsplit(md_, '\n---|^---')[[1]][-1], yaml::yaml.load)
  tml_ = Timeline$new()
  main = dat[[1]]
  do.call(tml_$main, main[names(main) != "config"])
  do.call(tml_$config, main$config)
  tml_$events(dat[-1])
  return(tml_)  
}