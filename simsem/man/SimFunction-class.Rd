\name{SimFunction-class}
\docType{class}
\alias{SimFunction-class}
\alias{summary,SimFunction-method}
\alias{run,SimFunction-method}
\title{Class \code{"SimFunction"}}
\description{
This class will save a function using for data transformation later in a simulation study within \code{\link{simResult}}.
}
\section{Objects from the Class}{
Objects can be created by \code{\link{simFunction}}. It can also be called from the form \code{new("SimFunction", ...)}.
}
\section{Slots}{
  \describe{
    \item{\code{fun}:}{The desired function that will be used for data transformation.}
    \item{\code{attribute}:}{Additional arguments of the desired function.}
    \item{\code{callfun}:}{The command that users used to create the object.}
  }
}
\section{Methods}{
	\itemize{
		\item \code{\link{summary}} To summarize the object
		\item \code{\link{run}} To use the object for data transformation.
	}
}
\author{
    Sunthud Pornprasertmanit (University of Kansas; \email{psunthud@ku.edu})
}
\seealso{
	\itemize{
		\item \code{\linkS4class{SimResult}} for how to use the \code{simFunction} in a simulation study
	}
}
\examples{
showClass("SimFunction")

n65 <- simNorm(0.6, 0.05)
u35 <- simUnif(0.3, 0.5)
u68 <- simUnif(0.6, 0.8)
u2 <- simUnif(-0.2, 0.2)
n1 <- simNorm(0, 0.1)

loading <- matrix(0, 9, 3)
loading[1:3, 1] <- NA
loading[4:6, 2] <- NA
loading[7:9, 3] <- NA
loading.start <- matrix("", 9, 3)
loading.start[1:3, 1] <- 0.7
loading.start[4:6, 2] <- 0.7
loading.start[7:9, 3] <- "u68"
LY <- simMatrix(loading, loading.start)

RTE <- symMatrix(diag(9))

factor.cor <- diag(3)
factor.cor[1, 2] <- factor.cor[2, 1] <- NA
RPS <- symMatrix(factor.cor, 0.5)

path <- matrix(0, 3, 3)
path[3, 1:2] <- NA
path.start <- matrix(0, 3, 3)
path.start[3, 1] <- "n65"
path.start[3, 2] <- "u35"
BE <- simMatrix(path, path.start)

datGen <- simSetSEM(BE=BE, LY=LY, RPS=RPS, RTE=RTE)

loading.trivial <- matrix(NA, 9, 3)
loading.trivial[is.na(loading)] <- 0
LY.trivial <- simMatrix(loading.trivial, "u2")

error.cor.trivial <- matrix(NA, 9, 9)
diag(error.cor.trivial) <- 0
RTE.trivial <- symMatrix(error.cor.trivial, "n1")

misGen <- simMisspecSEM(LY = LY.trivial, RTE = RTE.trivial)

Data.Mis <- simData(datGen, 300, misspec=misGen)

loading <- matrix(0, 12, 4)
loading[1:3, 1] <- NA
loading[4:6, 2] <- NA
loading[7:9, 4] <- NA
loading[10:12, 3] <- NA

path <- matrix(0, 4, 4)
path[4, 1:3] <- NA

analysis <- simParamSEM(BE=path, LY=loading)

Model <- simModel(analysis)

fun <- simFunction(indProd, var1=paste("y", 1:3, sep=""), var2=paste("y", 4:6, sep=""), namesProd=paste("y", 10:12, sep=""))

# Real simulation will need more than just 10 replications
Output <- simResult(10, Data.Mis, Model, objFunction=fun)
summary(Output)

# Example of using the simfunction
mc <- simFunction(indProd, var1=1:3, var2=4:6)
run(mc, attitude[,-1])
summary(mc)
}
\keyword{classes}
