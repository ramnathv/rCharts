..p. <- function() invisible(readline("\nPress <return> to continue: "))
library(rCharts)

## Example 1 Facetted Scatterplot
names(iris) = gsub("\\.", "", names(iris))
p1 <- rPlot(SepalLength ~ SepalWidth | Species, data = iris, color = 'Species', type = 'point')
p1
p1$show(cdn = T)
# p1$show(static = F)

..p.() # ================================

## Example 2 Facetted Barplot
hair_eye = as.data.frame(HairEyeColor)
p2 <- rPlot(Freq ~ Hair, color = 'Eye', data = hair_eye, type = 'bar')
p2$facet(var = 'Eye', type = 'wrap', rows = 2)
p2

..p.() # ================================

## Example 3 Boxplot
data(tips, package = 'reshape2')
p3 <- rPlot(x = 'day', y = 'box(tip)', data = tips, type = 'box')
p3

..p.() # ================================

## Example 4 
require(plyr)
dat = count(mtcars, .(gear, am))
p4 <- rPlot(x = 'bin(gear, 1)', y = 'freq', data = dat, type = 'bar', 
  list(var = 'am', type = 'wrap'))
p4

..p.() # ================================

## Example 5 (Heat Map)
dat = expand.grid(x = 1:5, y = 1:5)
dat = transform(dat, value = sample(1:5, 25, replace = T))
p5 <- rPlot(x = 'bin(x, 1)', y = 'bin(y, 1)', color = 'value', data = dat, type = 'tile')
p5

..p.() # ================================

# Example 6 (NBA Heat Map)
require(reshape2); require(scales); require(plyr)
nba <- read.csv('http://datasets.flowingdata.com/ppg2008.csv')
nba.m <- ddply(melt(nba), .(variable), transform, rescale = rescale(value))
p6 <- rPlot(Name ~ variable, color = 'rescale', data = nba.m, type = 'tile', height = 600)
p6$guides("{color: {scale: {type: gradient, lower: white, upper: steelblue}}}")
p6

..p.() # ================================
