## Example 1 Facetted Scatterplot
names(iris) = gsub("\\.", "", names(iris))
p1 <- rPlot(SepalLength ~ SepalWidth | Species, data = iris, color = 'Species', type = 'point')
p1$show(T)


## Example 2 Facetted Barplot
hair_eye = as.data.frame(HairEyeColor)
p2 <- rPlot(Freq ~ Hair | Eye, color = 'Eye', data = hair_eye, type = 'bar')
p2$show(T)

## Example 3 Boxplot
data(tips, package = 'reshape2')
p3 <- rPlot(x = 'day', y = 'box(tip)', data = tips, type = 'box')
p3$show(T)

## Example 4 
require(plyr)
dat = count(mtcars, .(gear, am))
p4 <- rPlot(x = 'bin(gear, 1)', y = 'freq', data = dat, type = 'bar', 
  list(var = 'am', type = 'wrap'))
p4$show(T)

## Example 5 (Heat Map)
dat = expand.grid(x = 1:5, y = 1:5)
dat = transform(dat, value = sample(1:5, 25, replace = T))
p5 <- rPlot(x = 'bin(x, 1)', y = 'bin(y, 1)', color = 'value', data = dat, type = 'tile')
p5$show(T)


# Example 6 (NBA Heat Map)
require(reshape2); require(scales)
nba <- read.csv('http://datasets.flowingdata.com/ppg2008.csv')
nba.m <- ddply(melt(nba), .(variable), transform, rescale = rescale(value))
p1 <- rPlot(Name ~ variable, color = 'rescale', data = nba.m, type = 'tile', height = 600)
p1$guides("{color: {scale: {type: gradient, lower: white, upper: steelblue}}}")
p1$show(T)

