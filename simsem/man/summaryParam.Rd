\name{summaryParam}
\alias{summaryParam}
\alias{summaryParam-methods}
\alias{summaryParam,ANY-method}
\alias{summaryParam,SimResult-method}
\alias{summaryParam,SimModelOut-method}
\alias{summaryParam,SimModelMIOut-method}
\title{
	Provide summary of parameter estimates and standard error across replications
}
\description{
	This function will provide averages of parameter estimates, standard deviations of parameter estimates, averages of standard errors, and power of rejection with a priori alpha level for the null hypothesis of parameters equal 0.
}
\usage{
summaryParam(object, ...)
}
\arguments{
  \item{object}{
	\code{\linkS4class{SimResult}} object being described
}
  \item{\dots}{
    any additional arguments, such as for the function with result object, \code{detail} argument is available. If \code{TRUE}, it provides relative bias, standardized bias, and relative bias in standard errors.
}
}
\value{
	A data frame that provides the statistics described above from all parameters.
	For using with \code{\linkS4class{SimModelOut}}, each column means
	\itemize{
		\item \code{Estimate:} Parameter Estimates
		\item \code{SE:} Standard Error of the Parameter Estimates
		\item \code{z:} Wald Statistic
		\item \code{p:} \emph{p} value based on the Wald Statistic
		\item \code{Param:} Parameter Value underlying the analyzed data
		\item \code{Bias:} Bias in Parameter Estimates
		\item \code{Coverage:} Whether (1-alpha)\% confidence interval covers the parameter estimates
	}	
	For using with \code{linkS4class{SimResult}}, each column means
	\itemize{
		\item \code{Estimate.Average:} Average of parameter estimates across all replications
		\item \code{Estimate.SD:} Standard Deviation of parameter estimates across all replications
		\item \code{Average.SE:} Average of standard errors across all replications
		\item \code{Power (Not equal 0):} Proportion of significant replications when testing whether the parameters are different from zero
		\item \code{Average.Param:} Parameter values or average values of parameters if random parameters are specified
		\item \code{SD.Param:} Standard Deviations of parameters. Appeared only when random parameters are specified.
		\item \code{Average.Bias:} The difference between parameter estimates and parameter underlying data
		\item \code{SD.Bias:} Standard Deviations of bias across all replications. Appeared only when random parameters are specified. 
			This value is the expected value of average standard error when random parameter are specified.
		\item \code{Coverage:} The percentage of (1-alpha)\% confidence interval covers parameters underlying the data.
		\item \code{Rel.Bias:} Relative Bias, which is (\code{Estimate.Average} - \code{Average.Param})/\code{Average.Param}. 
			Hoogland and Boomsma (1998) proposed that the cutoff of .05 may be used for acceptable relative bias.
			This option will be available when \code{detail=TRUE}. This value will not be available when parameter values are very close to 0.
		\item \code{Std.Bias:} Standardized Bias, which is (\code{Estimate.Average} - \code{Average.Param})/\code{Estimate.SD} 
			for fixed parameters and (\code{Estimate.Average} - \code{Average.Param})/\code{SD.Bias} 
			for random parameters. Collins, Schafer, and Kam (2001) recommended that biases will be 
			only noticeable when standardized bias is greater than 0.4 in magnitude.
			This option will be available when \code{detail=TRUE}
		\item \code{Rel.SE.Bias:} Relative Bias in standard error, which is (\code{Average.SE} - \code{Estimate.SD})/\code{Estimate.SD} 
			for fixed parameters and (\code{Average.SE} - \code{SD.Bias})/\code{SD.Bias} 
			for random parameters. 	Hoogland and Boomsma (1998) proposed that 0.10 is the acceptable level.
			This option will be available when \code{detail=TRUE}
	}
}
\author{
    Sunthud Pornprasertmanit (University of Kansas; \email{psunthud@ku.edu})
}
\references{
	\itemize{
		\item Collins, L. M., Schafer, J. L., & Kam, C. M. (2001). A comparison of inclusive and restrictive strategies in modern missing data procedures. \emph{Psychological Methods, 6(4)}, 330.
		\item Hoogland, J. J., & Boomsma, A. (1998). Robustness studies in covariance structure modeling. \emph{Sociological Methods & Research, 26(3)}, 329.
	}
}
\seealso{
	\code{\linkS4class{SimResult}} for the object input
}
\examples{
showClass("SimResult")
loading <- matrix(0, 6, 1)
loading[1:6, 1] <- NA
LX <- simMatrix(loading, 0.7)
RPH <- symMatrix(diag(1))
RTD <- symMatrix(diag(6))
CFA.Model <- simSetCFA(LY = LX, RPS = RPH, RTE = RTD)
SimData <- simData(CFA.Model, 500)
SimModel <- simModel(CFA.Model)
# We make the examples running only 5 replications to save time.
# In reality, more replications are needed.
Output <- simResult(5, SimData, SimModel)
summaryParam(Output)
summaryParam(Output, detail=TRUE)
}
