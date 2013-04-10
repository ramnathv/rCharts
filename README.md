## rCharts

This R package provides a familiar plotting interface for R users to create interactive visualizations using [polychart.js](https://github.com/Polychart/polychart2).

### Installation

You can install `rCharts` from `github` using the `devtools` package

```
require(devtools)
install_github('rCharts', 'ramnathv')
```

### Usage

`rCharts` uses a formula interface to specify plots, just like the `lattice` package. Here are a few examples you can try out in your R console.

```
## Example 1 Facetted Scatterplot
names(iris) = gsub("\\.", "", names(iris))
rPlot(SepalLength ~ SepalWidth | Species, data = iris, color = 'Species', type = 'point')

## Example 2 Facetted Barplot
hair_eye = as.data.frame(HairEyeColor)
rPlot(Freq ~ Hair | Eye, color = 'Eye', data = hair_eye, type = 'bar')
```

`rCharts` is also compatible with [Slidify](http://slidify.org).

More documentation is underway.

### Using with Shiny

```
## server.r
require(rCharts)
shinyServer(function(input, output) {
  output$myChart <- renderChart({
    names(iris) = gsub("\\.", "", names(iris))
    p1 <- rPlot(input$x, input$y, data = iris, color = "Species", 
      facet = "Species", type = 'point')
    p1$addParams(dom = 'myChart')
    return(p1)
  })
})

## ui.R
require(rCharts)
shinyUI(pageWithSidebar(
  headerPanel("rCharts: Interactive Charts from R using polychart.js"),
  
  sidebarPanel(
    selectInput(inputId = "x",
     label = "Choose X",
     choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
     selected = "SepalLength"),
    selectInput(inputId = "y",
      label = "Choose Y",
      choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
      selected = "SepalWidth")
  ),
  mainPanel(
    showOutput("myChart")
  )
))
```

### Credits

Most of the implementation in `rCharts` is inspired by [rHighcharts](https://github.com/metagraf/rHighcharts) and [rVega](https://github.com/metagraf/rVega). I have reused some code from these packages verbatim, and would like to acknowledge the efforts of its author [Thomas Reinholdsson](https://github.com/reinholdsson).

### License

`rCharts` is licensed under the MIT License. However, the Polycharts JavaScript library that is included in this package is not free for commercial use, and is licensed under Creative Commons 3.0 Attribution & Non-commercial. Read more about its license at http://polychart.com/js/license.