## Example 1 Facetted Scatterplot
names(iris) = gsub("\\.", "", names(iris))
rPlot(SepalLength ~ SepalWidth | Species, data = iris, color = 'Species', type = 'point')


## Example 2 Facetted Barplot
hair_eye = as.data.frame(HairEyeColor)
rPlot(Freq ~ Hair | Eye, color = 'Eye', data = hair_eye, type = 'bar')

## Example 3 Boxplot
data(tips, package = 'reshape2')
rPlot(x = 'day', y = 'box(tip)', data = tips, type = 'box')

## Example 4 

dat = count(mtcars, .(gear, am))
rPlot(x = 'bin(gear, 1)', y = 'freq', data = dat, type = 'bar', facet = 'am')

## Example 5 (Heat Map)

dat = expand.grid(x = 1:5, y = 1:5)
dat = transform(dat, value = sample(1:5, 25, replace = T))
rPlot(x = 'bin(x, 1)', y = 'bin(y, 1)', color = 'value', data = dat, type = 'tile')


# Example 6 (NBA Heat Map)
nba <- read.csv('http://datasets.flowingdata.com/ppg2008.csv')
nba.m <- ddply(melt(nba), .(variable), transform, rescale = rescale(value))
p1 <- rPlot(Name ~ variable, color = 'rescale', data = nba.m, type = 'tile', height = 600)
p1$guides("{color: {scale: {type: gradient, lower: white, upper: steelblue}}}")
p1

