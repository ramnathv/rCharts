\name{toChain}
\alias{toChain}
\title{Converts an R list to a sequence of chained functions acting on a specified object.}
\usage{
  toChain(x, obj)
}
\description{
  Converts an R list to a sequence of chained functions
  acting on a specified object.
}
\examples{
\dontrun{
toChain(list(showControls = TRUE, showDistX = TRUE), "chart")
## chart.showControls(true).showDistX(true)
}
}
\author{
  Ramnath Vaidyanathan
}
\keyword{internal}

