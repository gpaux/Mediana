\name{MultAdj}
\alias{MultAdj}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{MultAdj object
}
\description{
This function creates an object of class \code{MultAdj} which can be added to an object of class \code{AnalysisModel}.
}
\usage{
MultAdj(...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
defines the arguments passed to create the object of class \code{MultAdj}.
}
}
\details{
This function can be used to wrap-up several objects of class \code{MultAdjProc} or \code{MultAdjStrategy} and add them to an object of class \code{AnalysisModel}. Its use is optional as objects of class \code{MultAdjProc} or \code{MultAdjStrategy} can be added to an object of class \code{AnalysisModel} incrementally using the '+' operator.

Objects of class \code{MultAdjProc} or \code{MultAdjStrategy} can be added to an object of class \code{AnalysisModel}.

}

\references{
\url{http://biopharmnet.com/mediana}
}

\seealso{
See Also \code{\link{MultAdjStrategy}}, \code{\link{MultAdjProc}} and \code{\link{AnalysisModel}}.
}
\examples{
# Multiplicity adjustments
mult.adj1 = MultAdjProc(proc = NA)
mult.adj2 = MultAdjProc(proc = "BonferroniAdj")
mult.adj3 = MultAdjProc(proc = "HolmAdj", par = parameters(weight = rep(1/3,3)))
mult.adj4 = MultAdjProc(proc = "HochbergAdj", par = parameters(weight = c(1/4,1/4,1/2)))


# Analysis model
analysis.model = AnalysisModel() +
                 MultAdj(mult.adj1, mult.adj2, mult.adj3, mult.adj4) +
                 Test(id = "Pl vs Dose L",
                      samples = samples("Placebo", "Dose L"),
                      method = "TTest") +
                 Test(id = "Pl vs Dose M",
                      samples = samples ("Placebo", "Dose M"),
                      method = "TTest") +
                 Test(id = "Pl vs Dose H",
                      samples = samples("Placebo", "Dose H"),
                      method = "TTest")

# Equivalent to:
analysis.model = AnalysisModel() +
                 mult.adj1 +
                 mult.adj2 +
                 mult.adj3 +
                 mult.adj4 +
                 Test(id = "Pl vs Dose L",
                      samples = samples("Placebo", "Dose L"),
                      method = "TTest") +
                 Test(id = "Pl vs Dose M",
                      samples = samples ("Placebo", "Dose M"),
                      method = "TTest") +
                 Test(id = "Pl vs Dose H",
                      samples = samples("Placebo", "Dose H"),
                      method = "TTest")

}
