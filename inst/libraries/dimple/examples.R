require(devtools)
setwd("c:/users/kent.tleavell_nt/dropbox/development/r/rCharts")
load_all()


#get data used by dimple for all of its examples as a first test
data <- read.delim(
  "http://pmsi-alignalytics.github.io/dimple/data/example_data.tsv"
)

#eliminate . to avoid confusion in javascript
colnames(data) <- gsub("[.]","",colnames(data))

#example 1 vt bar
d1 <- dPlot(
  x ="Month" ,
  y = "UnitSales",
  data = data,
  type = "dimple.plot.bar"
)
d1$xAxis(orderRule = "Date")
d1

#example 2 vt stacked bar
d1 <- dPlot(
  x ="Month" ,
  y = "UnitSales",
  groups = "Channel",
  data = data,
  type = "dimple.plot.bar"
)
d1$xAxis(orderRule = "Date")
d1$set(
  legend = list(
    x = 60,
    y = 10,
    width = 700,
    height = 20,
    horizontalAlign = "right"
  )
)
d1

#example 3 vertical 100% bar
#use from above and just change y axis type
d1$yAxis(type = "addPctAxis")
d1

#example 4 vertical grouped bar
d1 <- dPlot(
  x = c("PriceTier","Channel"),
  y = "UnitSales",
  groups = "Channel",
  data = data,
  type = "dimple.plot.bar"
)
d1$set(
  legend = list(
    x = 60,
    y = 10,
    width = 700,
    height = 20,
    horizontalAlign = "right"
  )
)
d1

#example 5 vertical stack grouped bar
d1 <- dPlot(
  x = c("PriceTier","Channel"),
  y = "UnitSales",
  groups = "Owner",
  data = data,
  type = "dimple.plot.bar"
)
d1$set(
  legend = list(
    x = 200,
    y = 10,
    width = 400,
    height = 20,
    horizontalAlign = "right"
  )
)
d1


#example 6 vertical 100% Grouped Bar
#just change y Axis
d1$yAxis(type = "addPctAxis")
d1

#example 7 horizontal bar
d1 <- dPlot(
  Month ~ UnitSales,
  data = data,
  type = "dimple.plot.bar"
)
d1$xAxis(type = "addMeasureAxis")
#good test of orderRule on y instead of x
d1$yAxis(type = "addCategoryAxis", orderRule = "Date")
d1


#example 8 horizontal stacked bar
d1 <- dPlot(
  Month ~ UnitSales,
  groups = "Channel",
  data = data,
  type = "dimple.plot.bar"
)
d1$xAxis(type = "addMeasureAxis")
#good test of orderRule on y instead of x
d1$yAxis(type = "addCategoryAxis", orderRule = "Date")
d1$set(
  legend = list(
    x = 200,
    y = 10,
    width = 400,
    height = 20,
    horizontalAlign = "right"
  )
)
d1


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
d1$set(
  legend = list(
    x=60,
    y=50,
    width=500,
    height=20,
    horizontalAlign="right"
  )
)

d1