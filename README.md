# rCharts

rCharts is an R package to create, customize and publish interactive javascript visualizations from R using a familiar lattice style plotting interface.

## Installation

You can install `rCharts` from `github` using the `devtools` package

```
require(devtools)
install_github('rCharts', 'ramnathv')
```

## Features

The design philosophy behind rCharts is to make the process of creating, customizing and sharing interactive visualizations easy. 

### Create

`rCharts` uses a formula interface to specify plots, just like the `lattice` package. Here are a few examples you can try out in your R console.

```
## Example 1 Facetted Scatterplot
names(iris) = gsub("\\.", "", names(iris))
rPlot(SepalLength ~ SepalWidth | Species, data = iris, color = 'Species', type = 'point')

## Example 2 Facetted Barplot
hair_eye = as.data.frame(HairEyeColor)
rPlot(Freq ~ Hair | Eye, color = 'Eye', data = hair_eye, type = 'bar')
```

### Customize

rCharts supports multiple javascript charting libraries, each with its own strengths. Each of these libraries has multiple customization options, most of which are supported within rCharts. Here is a list of libraries currently supported.

1. [Polychart](https://github.com/Polychart/polychart2).
2. [NVD3](https://github.com/novus/nvd3)
3. [MorrisJS](https://github.com/oesmith/morris.js)
4. [Rickshaw](https://github.com/shutterstock/rickshaw)
5. [HighCharts](http://www.highcharts.com/)
6. [xCharts](https://github.com/tenXer/xcharts/)
7. [Leaflet](http://leafletjs.com/)

More documentation is underway on how to use rCharts with each of these libraries.

### Share

rCharts allows you to share your visualization in multiple ways, as a standalone page, embedded in a shiny application, or in a tutorial/blog post.

#### Standalone

You can publish your visualization as a standalone html page using the `publish` method. Here is an example. Currently, you can publish your chart as a `gist` or to `rpubs`.

```
## 
names(iris) = gsub("\\.", "", names(iris))
r1 <- rPlot(SepalLength ~ SepalWidth | Species, data = iris, 
  color = 'Species', type = 'point')
r1$publish('Scatterplot', host = 'gist')
r1$publish('Scatterplot', host = 'rpubs')
```

#### Shiny Application

rCharts is easy to embed into a Shiny application using the utility functions `renderChart` and `showOutput`. Here is an example of an [rCharts Shiny App](http://glimmer.rstudio.com/ramnathv/rChartApp/).

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
    showOutput("myChart", "polycharts")
  )
))
```

#### Blog Post

rCharts can also be embedded into an Rmd document using `knit2html` or in a blog post using `slidify`. Here are a few examples of tutorials written using `rCharts` and `slidify`.

1. [Parallel Coordinate Plots](http://ramnathv.github.io/rChartsParCoords/)
2. [NY Times Graphics Tutorial](http://ramnathv.github.io/rChartsNYT/)

### Credits

Most of the implementation in `rCharts` is inspired by [rHighcharts](https://github.com/metagraf/rHighcharts) and [rVega](https://github.com/metagraf/rVega). I have reused some code from these packages verbatim, and would like to acknowledge the efforts of its author [Thomas Reinholdsson](https://github.com/reinholdsson).

### License

`rCharts` is licensed under the MIT License. However, the Polycharts JavaScript library that is included in this package is not free for commercial use, and is licensed under Creative Commons 3.0 Attribution & Non-commercial. Read more about its license at http://polychart.com/js/license.

### See Also

There has been a lot of interest recently in creating packages that allow R users to make use of Javascript charting libraries. 

- [gg2v](https://github.com/hadley/gg2v) by [Hadley Wickham](https://github.com/hadley)
- [clickme](https://github.com/nachocab/clickme) by [Nacho Caballero](https://github.com/nachocab)
- [rVega](https://github.com/metagraf/rVega) by [Thomas Reinholdsson](https://github.com/reinholdsson)

