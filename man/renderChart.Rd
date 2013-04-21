\name{renderChart}
\alias{renderChart}
\title{renderChart (use with Shiny)}
\usage{
  renderChart(expr, env = parent.frame(), quoted = FALSE)
}
\arguments{
  \item{expr}{An expression that returns a chart object}

  \item{env}{The environment in which to evaluate
  \code{expr}.}

  \item{quoted}{Is expr a quoted expression (with
  \code{quote()})? This is useful if you want to save an
  expression in a variable.}
}
\description{
  Use rCharts as Shiny output. First, use
  \code{renderChart} in \code{server.R} to assign the chart
  object to an Shiny output. Then create an chartOutput
  with the same name in #' \code{ui.R}. \code{chartOutput}
  is currently just an alias for \code{htmlOutput}.
}
\author{
  Thomas Reinholdsson, Ramnath Vaidyanathan
}

