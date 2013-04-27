## Example 1
p1 <- nvd3Plot(mpg ~ wt, group = 'cyl', data = mtcars, type = 'scatterChart')
p1$xAxis(axisLabel = 'Weight')
p1

## Example 2
p2 <- nvd3Plot(~ cyl, group = 'gear', data = mtcars, type = 'multiBarHorizontalChart')
p2$chart(showControls = F)
p2

## Example 3 (does not work. bug reported on github)
p3 <- nvd3Plot(~ cyl, data = mtcars, type = 'pieChart')
p3

p3$chart(donut = TRUE)
p3

## Example 4
data(economics, package = 'ggplot2')
p4 <- nvd3Plot(uempmed ~ date, data = economics, type = 'lineChart')
p4


ecm <- reshape2::melt(economics[,c('date', 'uempmed', 'psavert')], id = 'date')
p5 <- nvd3Plot(value ~ date, group = 'variable', data = ecm, type = 'lineChart')
p5

p5$addParams(type = 'lineWithFocusChart')
p5

## Example 5 (multiBarChart)
hair_eye = as.data.frame(HairEyeColor)
p6 <- nvd3Plot(Freq ~ Hair, group = 'Eye', data = subset(hair_eye, Sex == "Female"), type = 'multiBarChart')
p6$chart(color = c('brown', 'blue', '#594c26', 'green'))
p6

## Example 6 (stackedAreaChart)
dat <- data.frame(t=rep(0:23,each=4),var=rep(LETTERS[1:4],4),val=round(runif(4*24,0,50)))
p7 <- nvd3Plot(val ~ t, group =  'var', data = dat, type = 'stackedAreaChart', id = 'chart')
p7