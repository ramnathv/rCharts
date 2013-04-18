# Example 1
p1 <- Rickshaw$new()
p1$layer(~ cyl, group = 'am', data = mtcars, type = 'bar')

# Example 2
require(RColorBrewer)
data(economics, package = 'ggplot2')
datm = reshape2::melt(
  economics[,c('date', 'psavert', 'uempmed')],
  id = 'date'
)
p2 <- Rickshaw$new()
p2$layer(value ~ date, group = 'variable', data = datm, type = 'line', 
  colors = c("darkred", "darkslategrey"))
