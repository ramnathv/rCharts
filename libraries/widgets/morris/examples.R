haireye = as.data.frame(HairEyeColor)

## Example 1
dat = subset(haireye, Sex == "Female" & Eye == "Blue")
p1 <- mPlot(x = 'Hair', y = list('Freq'), data = dat, type = 'Bar', labels = list('Count'))
p1$show(T)

## Example 2

dat = subset(haireye, Sex == "Female")
p2 <- mPlot(Freq ~ Eye, group = "Hair", data = dat, type = 'Bar', labels = levels(dat$Hair))
p2$addParams(barColors = c('black', 'brown', 'red', '#F2DA91'))

## Example 3
data(economics, package = 'ggplot2')
dat = transform(economics, date = as.character(date))
p3 <- mPlot(x = "date", y = list("psavert", "uempmed"), data = dat, type = 'Line',
  labels = list('Savings Rate', 'Median Duration of Unemployment'), pointSize = 0)
p3$show(T)

