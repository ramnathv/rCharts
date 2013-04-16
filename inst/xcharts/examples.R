# Example 1
p1 <- xCharts$new()
p1$set(xScale = 'ordinal', yScale = 'linear')
p1$layer(~ cyl, data = mtcars, type = 'bar')

# Example2
p2 <- xCharts$new()
p2$set(xScale = 'ordinal', yScale = 'linear')
p2$layer(~ cyl, group = 'gear', data = mtcars, type = 'bar')

# Example3
data(economics, package = 'ggplot2')
p3 <- xCharts$new()
p3$set(xScale = 'time', yScale = 'linear', type = 'line')
p3$layer(x = as.character('date'), y = 'psavert', data = economics)