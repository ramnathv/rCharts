..p. <- function() invisible(readline("\nPress <return> to continue: "))
library(rCharts)

#get data used by dimple for all of its examples as a first test
data <- read.delim(
  "http://pmsi-alignalytics.github.io/dimple/data/example_data.tsv"
)

# original data is ~ 1000 rows, which is too huge as demo.
set.seed(42)
data <- data[sample(nrow(data), 50), ]

#eliminate . to avoid confusion in javascript
colnames(data) <- gsub("[.]","",colnames(data))

## example 1 vt bar
d1 <- dPlot(
  x ="Month" ,
  y = "UnitSales",
  data = data,
  type = "bar"
)
d1$xAxis(orderRule = "Date")
d1

..p.() # ================================

## example 2 vt stacked bar
d1 <- dPlot(
  x ="Month" ,
  y = "UnitSales",
  groups = "Channel",
  data = data,
  type = "bar"
)
d1$xAxis(orderRule = "Date")
d1$legend(
  x = 60,
  y = 10,
  width = 700,
  height = 20,
  horizontalAlign = "right"
)
d1

..p.() # ================================

## example 3 vertical 100% bar
#use from above and just change y axis type
d1$yAxis(type = "addPctAxis")
d1

..p.() # ================================

## example 4 vertical grouped bar
d1 <- dPlot(
  x = c("PriceTier","Channel"),
  y = "UnitSales",
  groups = "Channel",
  data = data,
  type = "bar"
)
d1$legend(
  x = 60,
  y = 10,
  width = 700,
  height = 20,
  horizontalAlign = "right"
)
d1

..p.() # ================================

## example 5 vertical stack grouped bar
d1 <- dPlot(
  x = c("PriceTier","Channel"),
  y = "UnitSales",
  groups = "Owner",
  data = data,
  type = "bar"
)
d1$legend(
  x = 200,
  y = 10,
  width = 400,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 6 vertical 100% Grouped Bar
#just change y Axis
d1$yAxis(type = "addPctAxis")
d1

..p.() # ================================

## example 7 horizontal bar
d1 <- dPlot(
  Month ~ UnitSales,
  data = data,
  type = "bar"
)
d1$xAxis(type = "addMeasureAxis")
#good test of orderRule on y instead of x
d1$yAxis(type = "addCategoryAxis", orderRule = "Date")
d1


..p.() # ================================

## example 8 horizontal stacked bar
d1 <- dPlot(
  Month ~ UnitSales,
  groups = "Channel",
  data = data,
  type = "bar"
)
d1$xAxis(type = "addMeasureAxis")
#good test of orderRule on y instead of x
d1$yAxis(type = "addCategoryAxis", orderRule = "Date")
d1$legend(
  x = 200,
  y = 10,
  width = 400,
  height = 20,
  horizontalAlign = "right"
)
d1

..p.() # ================================

## example 9 horizontal 100% bar
d1$xAxis(type = "addPctAxis")
d1


..p.() # ================================

## example 10 horizontal stacked bar
d1 <- dPlot(
  x = "UnitSales", 
  y = c("PriceTier","Channel"),
  groups = "Channel",
  data = data,
  type = "bar"
)
d1$xAxis(type = "addMeasureAxis")
#good test of orderRule on y instead of x
d1$yAxis(type = "addCategoryAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 400,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 11 horizontal stacked grouped bar
d1 <- dPlot(
  x = "UnitSales", 
  y = c("PriceTier","Channel"),
  groups = "Owner",
  data = data,
  type = "bar"
)
d1$xAxis(type = "addMeasureAxis")
#good test of orderRule on y instead of x
d1$yAxis(type = "addCategoryAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 400,
  height = 20,
  horizontalAlign = "right"
)
d1

..p.() # ================================

## example 12 horizontal 100% grouped bar
d1$xAxis(type = "addPctAxis")
d1


..p.() # ================================

## example 13 vertical marimekko
d1 <- dPlot(
  UnitSales ~ Channel,
  groups = "Owner",
  data = data,
  type = "bar"
)
d1$xAxis(type = "addAxis", measure = "UnitSales", showPercent = TRUE)
d1$yAxis(type = "addPctAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 400,
  height = 20,
  horizontalAlign = "right"
)
d1
#test with storyboard
d1$set(storyboard = "Date")
d1

..p.() # ================================

## example 14 horizontal marimekko
d1 <- dPlot(
  Channel ~ UnitSales,
  groups = "Owner",
  data = data,
  type = "bar"
)
d1$yAxis(type = "addAxis", measure = "UnitSales", showPercent = TRUE)
d1$xAxis(type = "addPctAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 400,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 15 block matrix
d1 <- dPlot(
  x = c("Channel","PriceTier"),
  y = "Owner",
  groups = "PriceTier",
  data = data,
  type = "bar"
)
d1$yAxis(type = "addCategoryAxis")
d1$xAxis(type = "addCategoryAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 400,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 16 Scatter
d1 <- dPlot(
  OperatingProfit~UnitSales,
  groups = c("SKU","Channel"),
  data = subset(data, Date == "01/12/2012"),
  type = "bubble"
)
d1$xAxis( type = "addMeasureAxis" )
d1$yAxis( type = "addMeasureAxis" )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 17 Vertical Lollipop
d1 <- dPlot(
  UnitSales ~ Month,
  groups = "Channel",
  data = data,
  type = "bubble"
)
#defaults to yAxis (Measure) and xAxis (Category)
d1$xAxis( orderRule = "Date")
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 18 Vertical Grouped Lollipop
d1 <- dPlot(
  y = "UnitSales",
  x = c("PriceTier","Channel"),
  groups = "Channel",
  data = data,
  type = "bubble"
)
#defaults to yAxis (Measure) and xAxis (Category)
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 19 Horizontal Lollipop
d1 <- dPlot(
  x = "UnitSales",
  y = "Month",
  groups = "Channel",
  data = data,
  type = "bubble"
)
d1$xAxis( type = "addMeasureAxis" )
d1$yAxis( type = "addCategoryAxis", orderRule = "Date")
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 20 Horizontal Grouped Lollipop
d1 <- dPlot(
  x = "UnitSales",
  y = c("PriceTier","Channel"),
  groups = "Channel",
  data = data,
  type = "bubble"
)
d1$xAxis( type = "addMeasureAxis" )
d1$yAxis( type = "addCategoryAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1



..p.() # ================================

## example 21 Dot Matrix
d1 <- dPlot(
  y = "Owner",
  x = c("Channel","PriceTier"),
  groups = "PriceTier",
  data = data,
  type = "bubble"
)
d1$xAxis( type = "addCategoryAxis" )
d1$yAxis( type = "addCategoryAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 22 Bubble
d1 <- dPlot(
  x = "UnitSalesMonthlyChange",
  y = "PriceMonthlyChange",
  z = "OperatingProfit",
  groups = c("SKU","Channel"),
  data = subset(data, Date == "01/12/2012"),
  type = "bubble"
)
d1$xAxis( type = "addMeasureAxis" )
d1$yAxis( type = "addMeasureAxis" )
d1$zAxis( type = "addMeasureAxis" )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 23 Vertical Bubble Lollipop
d1 <- dPlot(
  x = "Month",
  y = "UnitSales",
  z = "OperatingProfit",
  groups = "Channel",
  data = subset(
    data,
    Date %in% c(
      "01/07/2012",
      "01/08/2012",
      "01/09/2012",
      "01/10/2012",
      "01/11/2012",
      "01/12/2012"
    )
  ),
  type = "bubble"
)
d1$xAxis( type = "addCategoryAxis", orderRule = "Date" )
d1$yAxis( type = "addMeasureAxis" )
d1$zAxis( type = "addMeasureAxis" )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


#..p.() # ================================

## example 24 Vertical Grouped Bubble Lollipop
d1 <- dPlot(
  x = c("PriceTier","Channel"),
  y = "UnitSales",
  z = "OperatingProfit",
  groups = "Channel",
  data = subset(
    data,
    Date %in% c(
      "01/07/2012",
      "01/08/2012",
      "01/09/2012",
      "01/10/2012",
      "01/11/2012",
      "01/12/2012"
    )
  ),
  type = "bubble"
)
d1$xAxis( type = "addCategoryAxis" )
d1$yAxis( type = "addMeasureAxis" )
d1$zAxis( type = "addMeasureAxis" )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 25 Horizontal Bubble Lollipop
d1 <- dPlot(
  y = "Month",
  x = "UnitSales",
  z = "OperatingProfit",
  groups = "Channel",
  data = subset(
    data,
    Date %in% c(
      "01/07/2012",
      "01/08/2012",
      "01/09/2012",
      "01/10/2012",
      "01/11/2012",
      "01/12/2012"
    )
  ),
  type = "bubble"
)
d1$yAxis( type = "addCategoryAxis", orderRule = "Date" )
d1$xAxis( type = "addMeasureAxis" )
d1$zAxis( type = "addMeasureAxis" )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


#..p.() # ================================

## example 26 Horizontal Grouped Bubble Lollipop
d1 <- dPlot(
  y = c("PriceTier","Channel"),
  x = "UnitSales",
  z = "OperatingProfit",
  groups = "Channel",
  data = subset(
    data,
    Date %in% c(
      "01/07/2012",
      "01/08/2012",
      "01/09/2012",
      "01/10/2012",
      "01/11/2012",
      "01/12/2012"
    )
  ),
  type = "bubble"
)
d1$yAxis( type = "addCategoryAxis" )
d1$xAxis( type = "addMeasureAxis" )
d1$zAxis( type = "addMeasureAxis" )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 27 Bubble Matrix
d1 <- dPlot(
  x = c( "Channel", "PriceTier"),
  y = "Owner",
  z = "Distribution",
  groups = "PriceTier",
  data = data,
  type = "bubble",
  aggregate = "dimple.aggregateMethod.max"
)
d1$xAxis( type = "addCategoryAxis" )
d1$yAxis( type = "addCategoryAxis" )
d1$zAxis( type = "addMeasureAxis", overrideMax = 200 )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 28 Area
d1 <- dPlot(
  UnitSales ~ Month,
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "area"
)
d1$xAxis(type = "addCategoryAxis", orderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1


..p.() # ================================

## example 29 Stacked Area
d1 <- dPlot(
  UnitSales ~ Month,
  groups = "Channel",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "area"
)
d1$xAxis(type = "addCategoryAxis", orderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 30 100% Stacked Area
#just change type for y axis
d1$yAxis( type = "addPctAxis" )
d1



..p.() # ================================

## example 31 Grouped Area
d1 <- dPlot(
  y = "UnitSales",
  x = c("Owner","Month"),
  groups = "Owner",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "area"
)
d1$xAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1



..p.() # ================================

## example 32 Grouped Stacked Area
d1 <- dPlot(
  y = "UnitSales",
  x = c("Owner","Month"),
  groups = "SKU",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "area",
  bounds = list(x=70,y=30,height=340,width=330),
  barGap = 0.05,
  lineWeight = 1,
  height = 400,
  width = 590
)
d1$xAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1$legend(
  x = 430,
  y = 20,
  width = 100,
  height = 300,
  horizontalAlign = "left"
)
d1


..p.() # ================================

## example 33 Grouped 100% Area
d1$yAxis( type = "addPctAxis" )
d1


..p.() # ================================

## example 34 Vertical Area
d1 <- dPlot(
  x = "UnitSales",
  y = "Month",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "area",
  bounds = list(x=80,y=30,height=480,width=330),
  height = 400,
  width = 590
)
d1$xAxis(type = "addMeasureAxis")
d1$yAxis(type = "addCategoryAxis", orderRule = "Date")
d1



..p.() # ================================

## example 35 Vertical Stacked Area
d1 <- dPlot(
  x = "UnitSales",
  y = "Month",
  groups = "Channel",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "area",
  bounds = list(x=80,y=30,height=480,width=330),
  height = 400,
  width = 590
)
d1$xAxis(type = "addMeasureAxis")
d1$yAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$legend(
  x = 60,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1


..p.() # ================================

## example 36 Vertical 100% Stacked Area
d1$xAxis(type = "addPctAxis")
d1


..p.() # ================================

## example 37 Vertical Grouped Area
d1 <- dPlot(
  x = "UnitSales",
  y = c("Owner","Month"),
  groups = "Owner",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "area",
  bounds = list(x=90,y=30,height=470,width=330),
  lineWeight = 1,
  barGap = 0.05,
  height = 400,
  width = 590
)
d1$xAxis(type = "addMeasureAxis")
d1$yAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1

..p.() # ================================

## example 38 Vertical Grouped Stacked Area
d1 <- dPlot(
  x = "UnitSales",
  y = c("Owner","Month"),
  groups = "SKU",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "area",
  bounds = list(x=90,y=30,height=320,width=330),
  lineWeight = 1,
  barGap = 0.05,
  height = 400,
  width = 590
)
d1$xAxis(type = "addMeasureAxis")
d1$yAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$legend(
  x = 430,
  y = 20,
  width = 100,
  height = 300,
  horizontalAlign = "left"
)
d1



..p.() # ================================

## example 39 Vertical Group 100% Area
d1$xAxis( type = "addPctAxis" )
d1





..p.() # ================================

## example 40 Line
d1 <- dPlot(
  UnitSales ~ Month,
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line"
)
d1$xAxis(type = "addCategoryAxis", orderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1


..p.() # ================================

## example 41 Multiple Line
d1 <- dPlot(
  UnitSales ~ Month,
  groups = "Channel",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line"
)
d1$xAxis(type = "addCategoryAxis", orderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1

..p.() # ================================

## example 42 Grouped Single Line
d1 <- dPlot(
  y = "UnitSales",
  x = c("Owner","Month"),
  groups = "Owner",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line",
  barGap = 0.05
)
d1$xAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1



..p.() # ================================

## example 43 Grouped Multiple line
d1 <- dPlot(
  y = "UnitSales",
  x = c("Owner","Month"),
  groups = "Brand",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line",
  bounds = list(x=70,y=30,height=420,width=330),
  barGap = 0.05,
  height = 400,
  width = 590
)
d1$xAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1$legend(
  x = 510,
  y = 20,
  width = 100,
  height = 300,
  horizontalAlign = "left"
)
d1



..p.() # ================================

## example 44 Vertical Line
d1 <- dPlot(
  x = "UnitSales",
  y = "Month",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line",
  bounds = list(x=80,y=30,height=480,width=330),
  height = 400,
  width = 590
)
d1$xAxis(type = "addMeasureAxis")
d1$yAxis(type = "addCategoryAxis", orderRule = "Date")
d1



..p.() # ================================

## example 45 Vertical Multiple Line
d1 <- dPlot(
  x = "UnitSales",
  y = "Month",
  groups = "Channel",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line",
  bounds = list(x=80,y=30,height=480,width=330),
  height = 400,
  width = 590
)
d1$xAxis(type = "addMeasureAxis")
d1$yAxis(type = "addCategoryAxis", orderRule = "Date")
d1$legend(
  x = 60,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1



..p.() # ================================

## example 46 Vertical Grouped Line
d1 <- dPlot(
  x = "UnitSales",
  y = c("Owner","Month"),
  groups = "Owner",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line",
  bounds = list(x=90,y=30,height=470,width=330),
  barGap = 0.05,
  height = 400,
  width = 590
)
d1$xAxis(type = "addMeasureAxis")
d1$yAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1



..p.() # ================================

## example 47 Vertical Grouped Multi Line
d1 <- dPlot(
  x = "UnitSales",
  y = c("Owner","Month"),
  groups = "Brand",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line",
  bounds = list(x=90,y=30,height=320,width=330),
  barGap = 0.05,
  height = 400,
  width = 590
)
d1$xAxis(type = "addMeasureAxis")
d1$yAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$legend(
  x = 430,
  y = 20,
  width = 100,
  height = 300,
  horizontalAlign = "left"
)
d1


..p.() # ================================

## example 48 timeAxis
data( economics, package = "ggplot2" )
economics$date = format(economics$date, "%Y-%m-%d")
d1 <- dPlot(
x = "date",
y = "uempmed",
data = economics,
type = "line",
height = 400,
width = 700,
bounds = list(x=50,y=20,width=650,height=300)
)
d1$xAxis(
type = "addTimeAxis",
inputFormat = "%Y-%m-%d",
outputFormat = "%b %Y"
)
d1

..p.() # ================================
