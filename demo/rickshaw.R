..p. <- function() invisible(readline("\nPress <return> to continue: "))
library(rCharts)

require(quantmod)
require(plyr)
tickers =  c('AAPL', 'GOOG', 'MSFT')
quotes = llply(tickers, getSymbols, auto.assign = F)

to_jsdate <- function(date_){
  val = as.POSIXct(as.Date(date_), origin="1970-01-01")
  as.numeric(val)
}

getSymbols('AAPL')
AAPL <- transform(AAPL, date = to_jsdate(index(AAPL)))
names(AAPL) = gsub(".", "_", names(AAPL), fixed = TRUE)

options(RCHART_TEMPLATE = 'Rickshaw.html')
r1 <- Rickshaw$new()
r1$layer(x = 'date', y = 'AAPL_Open', data = AAPL, type = 'line', colors = 'steelblue')
r1$xAxis(type = 'Time')
r1$yAxis(orientation = 'left')

riPlot <- function(x, y, data, type, ..., xAxis = list(type = 'Time'), 
    yAxis = list(orientation = 'left')){
  options(RCHART_TEMPLATE = 'Rickshaw.html')
  r1 <- Rickshaw$new()
  r1$layer(x = x, y = y, data = data, type = type, ...)
  do.call(r1$xAxis, xAxis)
  do.call(r1$yAxis, yAxis)
  return(r1)
}

# Example 1
p1 <- Rickshaw$new()
p1$layer(~ cyl, group = 'am', data = mtcars, type = 'bar')
p1

..p.() # ================================

# Example 2
require(RColorBrewer)
data(economics, package = 'ggplot2')
datm = reshape2::melt(
  economics[,c('date', 'psavert', 'uempmed')],
  id = 'date'
)
datm <- transform(datm, date = to_jsdate(date))
p2 <- Rickshaw$new()
p2$layer(value ~ date, group = 'variable', data = datm, type = 'line', 
  colors = c("darkred", "darkslategrey"))
p2

..p.() # ================================

p3 <- Rickshaw$new()
p3$layer(Employed ~ Year, data = longley, type = 'line', colors = c('darkred'))
p3

..p.() # ================================

usp = reshape2::melt(USPersonalExpenditure)
p4 <- Rickshaw$new()
p4$layer(value ~ Var2, group = 'Var1', data = usp, type = 'area')
p4$show(T)

..p.() # ================================

data(USPop, package = 'car')
dat <- USPop
dat <- transform(dat, year = to_jsdate(as.Date(paste(year, '01', '01', sep = '-'))))
p4 <- Rickshaw$new()
p4$layer(population ~ year, data = dat, type = 'area', colors = 'steelblue')
p4$yAxis(orientation = 'right')
p4$set(width = 540, height = 240)
p4

..p.() # ================================

uspexp <- reshape2::melt(USPersonalExpenditure)
names(uspexp) <- c('category', 'year', 'expenditure')
uspexp <- transform(uspexp, year = to_jsdate(as.Date(paste(year, '01', '01', sep = '-'))))
p4 <- Rickshaw$new()
p4$layer(expenditure ~ year, group = 'category', data = uspexp, type = 'area')
p4$yAxis(orientation = 'left')
p4$xAxis(type = 'Time')
p4$set(width = 540, height = 240)

p4

..p.() # ================================
