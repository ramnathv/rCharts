\name{post_gist}
\alias{post_gist}
\title{Publish a list of files as a gist}
\usage{
  post_gist(gist)
}
\arguments{
  \item{gdir}{directory of files to post}

  \item{description}{brief description of gist}

  \item{public}{whether gist is public (defaults to TRUE)}
}
\description{
  Publish a list of files as a gist
}
\examples{
\dontrun{
gist = create_gist(gfiles, description = 'description', public = T)
}
}

