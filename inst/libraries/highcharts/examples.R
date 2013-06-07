library(rCharts)

# Example 1
hPlot(Pulse ~ Height, data = MASS::survey, type = "scatter", group = "Exer")

## Example 2
a <- hPlot(Pulse ~ Height, data = MASS::survey, type = "bubble", title = "Zoom demo", subtitle = "bubble chart", size = "Age", group = "Exer")
a$chart(zoomType = "xy")
a

## Example 4
x <- data.frame(key = c("a", "b", "c"), value = c(1, 2, 3))
hPlot(x = "key", y = "value", data = x, type = "pie")

## Example 5
a <- hPlot(Pulse ~ Height, data = MASS::survey, type = 'scatter', group = 'Sex', radius = 6)
a$colors('rgba(223, 83, 83, .5)', 'rgba(119, 152, 191, .5)', 'rgba(60, 179, 113, .5)')
a$legend(align = 'right', verticalAlign = 'top', layout = 'vertical')
a$plotOptions(scatter = list(marker = list(symbol = 'circle')))
a$tooltip(formatter = "#! function() { return round(this.x) + ', ' + round(this.y)} !#")
a

## Example 6
a <- hPlot(N ~ Exer, data = freq, type = c('column', 'line'), group = 'M.I', radius = 6)
a