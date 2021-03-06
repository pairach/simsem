\name{SimVector-class}
\Rdversion{1.1}
\docType{class}
\alias{SimVector-class}
\alias{run,SimVector-method}
\alias{summaryShort,SimVector-method}
\alias{summary,SimVector-method}
\alias{extract,SimVector-method}
\title{Vector object: Random parameters vector}
\description{
This object can be used to represent a vector in SEM model. It contains free parameters, fixed values, and starting values. This object can be represented mean, intercept, or variance vectors.
}
\section{Objects from the Class}{
This object is created by \code{\link{simVector}} function. Objects can be created by calls of the form \code{new("SimVector", ...)}.
}
\section{Slots}{
  \describe{
    \item{\code{free}:}{Object of class \code{"vector"} draws starting values from the \code{"labels"} slot and show as a vector sample. }
    \item{\code{value}:}{Object of class \code{"vector"} provides a thorough description of all information in the object }
  }
}
\section{Methods}{
  \describe{
    \item{\code{\link{adjust}}}{Adjust an element in the \code{"SimVector"} object }
    \item{\code{\link{run}}}{Draws starting values from the \code{"labels"} slot and show as a vector sample. }
    \item{\code{\link{summaryShort}}}{Provides a short summary of all information in the object }
    \item{\code{\link{summary}}}{Provides a thorough description of all information in the object }

	 }
}
\author{
    Sunthud Pornprasertmanit (University of Kansas; \email{psunthud@ku.edu})
}
\seealso{
\code{\linkS4class{SimMatrix}} for random parameter matrix and \code{\linkS4class{SymMatrix}} for random parameter symmetric matrix.
}
\examples{
showClass("SimVector")

factor.mean <- rep(NA, 2)
factor.mean.starting <- c(5, 2)
AL <- simVector(factor.mean, factor.mean.starting)
run(AL)
summary(AL)
summaryShort(AL)

n01 <- simNorm(0, 1)
AL <- adjust(AL, "n01", 2)
run(AL)
summary(AL)

AL <- extract(AL, 1)
summary(AL)
}
\keyword{classes}
