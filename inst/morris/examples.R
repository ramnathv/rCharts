haireye = as.data.frame(HairEyeColor)

## Example 1
dat = subset(haireye, Sex == "Female" & Eye == "Blue")
p1 <- Morris$new()
p1$layer(x = 'Hair', y = list('Freq'), data = dat, type = 'Bar', labels = list("Count"))
p1$show(T)

## Example 2

dat = subset(haireye, Sex == "Female")
p2 <- Morris$new()
p2$layer(x = "Eye", y = "Freq", group = "Hair", data = dat, type = 'Bar', labels = 1:4)

## Example 3
data(economics, package = 'ggplot2')
dat = transform(economics, date = as.character(date))
p3 <- Morris$new()
p3$layer(x = "date", y = list("psavert", "uempmed"), data = dat, type = 'Line',
  labels = list('Savings Rate', 'Median Duration of Unemployment'))
p3$addParams(pointSize = 0)

