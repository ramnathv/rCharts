\name{showOutput}
\alias{showOutput}
\title{Use rCharts as Shiny output. First, use \code{renderChart} in \code{server.R} to assign
the chart object to an Shiny output. Then create an chartOutput with the same name in #'
\code{ui.R}. \code{chartOutput} is currently just an alias for \code{htmlOutput}.}
\usage{
  showOutput(outputId, lib = NULL, package = "rCharts")
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

