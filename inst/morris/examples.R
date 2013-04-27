require(rCharts)
haireye = as.data.frame(HairEyeColor)

## Simple Bar Chart
dat = subset(haireye, Sex == "Female" & Eye == "Blue")
p1 <- mPlot(x = 'Hair', y = list('Freq'), data = dat, type = 'Bar', labels = list("Count"))
p1

### Check if hideHover = "auto" switches hover off when not on chart
p1$set(hideHover = "auto")
p1

## Multi Bar Chart
dat = subset(haireye, Sex == "Female")
p2 <- mPlot(Freq ~ Eye, group = "Hair", data = dat, type = "Bar", labels = 1:4)
p2

## Line Chart
data(economics, package = 'ggplot2')
dat = transform(economics, date = as.character(date))
p3 <- mPlot(x = "date", y = list("psavert", "uempmed"), data = dat, type = 'Line',
 pointSize = 0, lineWidth = 1)
p3$set(xLabelFormat = "#! function (x) { 
  return x.toString(); } 
!#")
p3


## Area Chart
p3$set(type = 'Area')
p3

