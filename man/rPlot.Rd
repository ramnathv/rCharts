\name{rPlot}
\alias{rPlot}
\title{Main plotting function}
\usage{
  rPlot(x, ...)
}
\description{
  Main plotting function
}
\examples{
\dontrun{
names(iris) = gsub('\\\\.', '', names(iris))
rPlot(SepalLength ~ SepalWidth | Species, data = iris, type = 'point', color = 'Species')
}
}

