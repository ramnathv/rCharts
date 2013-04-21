library(rCharts)

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

# Print chart
a$printChart()