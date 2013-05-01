library(rCharts)

## Example 1

# Prepare data
x <- data.frame(USPersonalExpenditure)
colnames(x) <- substr(colnames(x), 2, 5)

# Create chart
a <- rCharts:::Highcharts$new()
a$chart(type = "line")
a$title(text = "US Personal Expenditure")
a$xAxis(categories = rownames(x))
a$yAxis(title = list(text = "Billions of dollars"))
a$data(x)
a


## Example 2
# Prepare data
x <- data.frame(USPersonalExpenditure)
colnames(x) <- substr(colnames(x), 2, 5)

# Create chart
a <- rCharts:::Highcharts$new()
a$chart(type = "bar")
a$title(text = "US Personal Expenditure")
a$xAxis(categories = rownames(x))
a$yAxis(title = list(text = "Billions of dollars"))
a$data(x)
a

## Example 3

a1 <- rCharts:::Highcharts$new()
a1$title(text = "Fruits")
a1$data(x = c("Apples", "Bananas", "Oranges"), y = c(15, 20, 30), type = "pie", 
  name = "Amount")
a1

## Example 4

# Prepare data
x <- data.frame(USPersonalExpenditure)
colnames(x) <- substr(colnames(x), 2, 5)

# Create chart
a <- rCharts:::Highchart$new()
a$chart(type = "column")
a$title(text = "US Personal Expenditure")
a$xAxis(categories = rownames(x))
a$yAxis(title = list(text = "Billions of dollars"))
a$data(x)
a