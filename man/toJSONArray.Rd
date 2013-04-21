\name{toJSONArray}
\alias{toJSONArray}
\title{Converts an R object to a JSON array of objects}
\usage{
  toJSONArray(obj, json = TRUE)
}
\description{
  toJSON converts an R data frame to an object with key
  value pairs for each column. However, a lot of javascript
  charting libraries need an array of objects, one for each
  row of the data frame. This utility function does that.
}
\examples{
\dontrun{
toJSONArray(head(iris))
}
}
\author{
  Ramnath Vaidyanathan
}
\keyword{internal}

