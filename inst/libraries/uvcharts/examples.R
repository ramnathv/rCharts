d1 <- rCharts$new()
d1$setLib('uvcharts')
d1$set(categories = names(dat), type = 'Bar')
d1$set(dataset = dat)
d1$show(cdn = T)


d2 <- dTable(iris, iDisplayLength = 4)
d2$set()





library(plyr)
library(rCharts)

make_dataset <- function(x, y, dat, group = NULL){
  require(plyr)
  dat <- rename(dat, setNames(c('name', 'value'), c(x, y)))
  if (!is.null(group)){
    dlply(dat, group, toJSONArray, json = F)
  } else {
    list(main = toJSONArray(dat, json = F)) 
  }
}

hair_eye <- subset(as.data.frame(HairEyeColor),Sex == "Male")
dat <- rename(dat, c('Eye' = 'name', 'Freq' = 'value'))
dat3 <- dlply(dat, "Hair", toJSONArray, json = F)

dat4 <- make_dataset("Hair", "Freq", dat = hair_eye, group = "Eye")

d1 <- rCharts$new()
d1$setLib('uvcharts')
d1$set(
  categories = names(dat4), 
  type = 'Bar', 
  dataset = dat4,
  dom = 'ch1'
)
d1$show(cdn = T)


## {title: Line Chart}
data(economics, package = 'ggplot2')
dat = transform(economics, date = as.character(date))
datm = reshape2::melt(dat, id = 'date')
uPlot("date", "value", data = datm, group = 'variable', type = 'LineChart')


