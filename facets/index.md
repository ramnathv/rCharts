---
title: Faceting
subtitle: rCharts
author: Ramnath Vaidyanathan
github:
  user: ramnathv
  repo: rCharts
framework: minimal
mode: selfcontained
widgets: polycharts
hitheme: solarized_dark
url: {lib: ../libraries}
background: images/fabric_of_squares_gray.png
---





## Facets 

Facets display subsets of the dataset in different panels. Such plots are also referred to as small multiple plots and are useful when dealing with datasets having multiple variables. `rCharts` uses lattice like syntax to specify the faceting variable. Here is an example to get you started, where we get multiple scatterplots of `mpg` vs `cyl` for each level of the variable `cyl`. 

<div id='chart1' class='rChart'></div>


```r
require(rCharts)
p1 <- rPlot(mpg ~ wt | cyl, data = mtcars, type = 'point', width = 600)
p1$printChart('chart1')
```

<script type='text/javascript'>
    var chartParams = {"dom":"chart1","width":600,"height":400,"layers":[{"x":"wt","y":"mpg","data":{"mpg":[21,21,22.8,21.4,18.7,18.1,14.3,24.4,22.8,19.2,17.8,16.4,17.3,15.2,10.4,10.4,14.7,32.4,30.4,33.9,21.5,15.5,15.2,13.3,19.2,27.3,26,30.4,15.8,19.7,15,21.4],"cyl":[6,6,4,6,8,6,8,4,4,6,6,8,8,8,8,8,8,4,4,4,4,8,8,8,8,4,4,4,8,6,8,4],"disp":[160,160,108,258,360,225,360,146.7,140.8,167.6,167.6,275.8,275.8,275.8,472,460,440,78.7,75.7,71.1,120.1,318,304,350,400,79,120.3,95.1,351,145,301,121],"hp":[110,110,93,110,175,105,245,62,95,123,123,180,180,180,205,215,230,66,52,65,97,150,150,245,175,66,91,113,264,175,335,109],"drat":[3.9,3.9,3.85,3.08,3.15,2.76,3.21,3.69,3.92,3.92,3.92,3.07,3.07,3.07,2.93,3,3.23,4.08,4.93,4.22,3.7,2.76,3.15,3.73,3.08,4.08,4.43,3.77,4.22,3.62,3.54,4.11],"wt":[2.62,2.875,2.32,3.215,3.44,3.46,3.57,3.19,3.15,3.44,3.44,4.07,3.73,3.78,5.25,5.424,5.345,2.2,1.615,1.835,2.465,3.52,3.435,3.84,3.845,1.935,2.14,1.513,3.17,2.77,3.57,2.78],"qsec":[16.46,17.02,18.61,19.44,17.02,20.22,15.84,20,22.9,18.3,18.9,17.4,17.6,18,17.98,17.82,17.42,19.47,18.52,19.9,20.01,16.87,17.3,15.41,17.05,18.9,16.7,16.9,14.5,15.5,14.6,18.6],"vs":[0,0,1,1,0,1,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,0,1,0,0,0,1],"am":[1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1],"gear":[4,4,4,3,3,3,3,4,4,4,4,3,3,3,3,3,3,4,4,4,3,3,3,3,3,4,5,5,5,5,5,4],"carb":[4,4,1,1,2,1,4,2,2,4,4,3,3,3,4,4,4,1,2,1,1,2,2,4,2,1,2,2,4,6,8,2]},"type":"point"}],"facet":{"type":"wrap","var":"cyl"},"guides":[],"coord":[]}
    _.each(chartParams.layers, function(el){
        el.data = polyjs.data(el.data)
    })
    polyjs.chart(chartParams);
</script>




It is also possible to split the data based on two variables. In the second example, a scatterplot is created for each unique combination of levels of the variables `cyl` and `am`.

<div id='chart2' class='rChart'></div>


```r
p2 <- rPlot(mpg ~ wt | cyl  + am, data = mtcars, type = 'point', dom = 'chart2', 
 width = 600)
p2$printChart('chart2')
```

<script type='text/javascript'>
    var chartParams = {"dom":"chart2","width":600,"height":400,"layers":[{"x":"wt","y":"mpg","data":{"mpg":[21,21,22.8,21.4,18.7,18.1,14.3,24.4,22.8,19.2,17.8,16.4,17.3,15.2,10.4,10.4,14.7,32.4,30.4,33.9,21.5,15.5,15.2,13.3,19.2,27.3,26,30.4,15.8,19.7,15,21.4],"cyl":[6,6,4,6,8,6,8,4,4,6,6,8,8,8,8,8,8,4,4,4,4,8,8,8,8,4,4,4,8,6,8,4],"disp":[160,160,108,258,360,225,360,146.7,140.8,167.6,167.6,275.8,275.8,275.8,472,460,440,78.7,75.7,71.1,120.1,318,304,350,400,79,120.3,95.1,351,145,301,121],"hp":[110,110,93,110,175,105,245,62,95,123,123,180,180,180,205,215,230,66,52,65,97,150,150,245,175,66,91,113,264,175,335,109],"drat":[3.9,3.9,3.85,3.08,3.15,2.76,3.21,3.69,3.92,3.92,3.92,3.07,3.07,3.07,2.93,3,3.23,4.08,4.93,4.22,3.7,2.76,3.15,3.73,3.08,4.08,4.43,3.77,4.22,3.62,3.54,4.11],"wt":[2.62,2.875,2.32,3.215,3.44,3.46,3.57,3.19,3.15,3.44,3.44,4.07,3.73,3.78,5.25,5.424,5.345,2.2,1.615,1.835,2.465,3.52,3.435,3.84,3.845,1.935,2.14,1.513,3.17,2.77,3.57,2.78],"qsec":[16.46,17.02,18.61,19.44,17.02,20.22,15.84,20,22.9,18.3,18.9,17.4,17.6,18,17.98,17.82,17.42,19.47,18.52,19.9,20.01,16.87,17.3,15.41,17.05,18.9,16.7,16.9,14.5,15.5,14.6,18.6],"vs":[0,0,1,1,0,1,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,0,1,0,0,0,1],"am":[1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1],"gear":[4,4,4,3,3,3,3,4,4,4,4,3,3,3,3,3,3,4,4,4,3,3,3,3,3,4,5,5,5,5,5,4],"carb":[4,4,1,1,2,1,4,2,2,4,4,3,3,3,4,4,4,1,2,1,1,2,2,4,2,1,2,2,4,6,8,2]},"type":"point","dom":"chart2"}],"facet":{"type":"grid","x":"cyl","y":"am"},"guides":[],"coord":[]}
    _.each(chartParams.layers, function(el){
        el.data = polyjs.data(el.data)
    })
    polyjs.chart(chartParams);
</script>





`rCharts` allows you to build the faceting specification after you have created your main plot. Here is an example creating the same plots using this alternate approach


```r
p1 <- rPlot(mpg ~ wt, data = mtcars, type = 'point')
p1$facet(var = 'cyl', type = 'wrap', rows = 3)
```


The `facet` method in `rCharts` allows finer control of the faceting. Depending on whether you are splitting the data by one or two data columns, it accepts a different set of arguments.

__Wrap__ : Split by one data column

```
type      "wrap"                                       (required)
var       name of the variable to split the data on    (required)
cols      number of columns of panes
rows      number of rows of panes
formatter NOT supported by rCharts
```

__Grid__ : Split by two data columns

```
type      "grid"                                     (required)
x         name of the x variable to split the data on  (required)
y         name of the y variable to split the data on  (required)
formatter NOT supported by rCharts
```

For more details, refer to the documentation on the [PolychartsJS Wiki](https://github.com/Polychart/polychart2/wiki/Facet)
