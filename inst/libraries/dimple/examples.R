require(devtools)
setwd("c:/users/kent.tleavell_nt/dropbox/development/r/rCharts")
load_all()


#get data used by dimple for all of its examples as a first test
data <- read.delim(
  "http://pmsi-alignalytics.github.io/dimple/data/example_data.tsv"
)

#eliminate . to avoid confusion in javascript
colnames(data) <- gsub("[.]","",colnames(data))

d1 <- dPlot(
  UnitSales ~ Month,
  groups = "Channel",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "dimple.plot.area"
)
d1$xAxis(type = "addCategoryAxis")
d1$yAxis(type = "addMeasureAxis")
d1
#now test adding legend
d1$set(legend = list(x=60, y=50, width=500, height=20, horizontalAlign="right"))
d1