## {title: Scatter Chart}
p1 <- nPlot(mpg ~ wt, group = 'cyl', data = mtcars, type = 'scatterChart')
p1$xAxis(axisLabel = 'Weight')
p1


## {title: MultiBar Chart}
hair_eye = as.data.frame(HairEyeColor)
p2 <- nPlot(Freq ~ Hair, group = 'Eye', data = subset(hair_eye, Sex == "Female"), type = 'multiBarChart')
p2$chart(color = c('brown', 'blue', '#594c26', 'green'))
p2

## {title: MultiBar Horizontal Chart}
p3 <- nPlot(~ cyl, group = 'gear', data = mtcars, type = 'multiBarHorizontalChart')
p3$chart(showControls = F)
p3

## {title: Pie Chart}
p4 <- nPlot(~ cyl, data = mtcars, type = 'pieChart')
p4

## {title: Donut Chart}
p5 <- nPlot(~ cyl, data = mtcars, type = 'pieChart')
p5$chart(donut = TRUE)
p5

## {title: Line Chart}
data(economics, package = 'ggplot2')
p6 <- nPlot(uempmed ~ date, data = economics, type = 'lineChart')
p6

## {title: Line with Focus Chart }
ecm <- reshape2::melt(economics[,c('date', 'uempmed', 'psavert')], id = 'date')
p7 <- nPlot(value ~ date, group = 'variable', data = ecm, type = 'lineWithFocusChart')
#test format dates on the xAxis
#also good test of javascript functions as parameters
#dates from R to JSON will come over as number of days since 1970-01-01
#so convert to milliseconds 86400000 in a day and then format with d3
#on lineWithFocusChart type xAxis will also set x2Axis unless it is specified
p7$xAxis( tickFormat="#!function(d) {return d3.time.format('%b %Y')(new Date( d * 86400000 ));}!#" )
#test xAxis also sets x2Axis
p7
#now test setting x2Axis to something different
#test format dates on the x2Axis
#test to show %Y format which is different than xAxis
p7$x2Axis( tickFormat="#!function(d) {return d3.time.format('%Y')(new Date( d * 86400000 ));}!#" )
p7
#test set xAxis again to make sure it does not override set x2Axis
p7$xAxis( NULL, replace = T)
p7

## {title: Stacked Area Chart}
dat <- data.frame(t=rep(0:23,each=4),var=rep(LETTERS[1:4],4),val=round(runif(4*24,0,50)))
p8 <- nPlot(val ~ t, group =  'var', data = dat, type = 'stackedAreaChart', id = 'chart')
p8