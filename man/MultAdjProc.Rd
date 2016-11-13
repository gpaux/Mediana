\name{MultAdjProc}
\alias{MultAdjProc}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{MultAdjProc object
}
\description{
This function creates an object of class \code{MultAdjProc} which can be added to objects of class \code{AnalysisModel}, \code{MultAdj} or \code{MultAdjStrategy}.
}
\usage{
MultAdjProc(proc, par = NULL, tests = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{proc}{
defines a multiplicity adjustment procedure.
}
\item{par}{
defines the parameters of the multiplicity adjustment procedure (optional).
}
  \item{tests}{
defines the tests taken into account in  the multiplicity adjustment procedure.
}
}
\details{
Objects of class \code{MultAdjProc} are used in objects of class \code{AnalysisModel} to specify a Multiplicity Adjustment Procedure that will be applied to the statistical tests to protect the overall Type I error rate. Several objects of class \code{MultAdjProc} can be added to an object of class \code{AnalysisModel}, using the '+' operator or by grouping them into a \code{MultAdj} object.

\code{proc} argument defines the multiplicity adjustment procedure. Several procedures are already implemented in the Mediana package (listed below, along with the required or optional parameters to specify in the \code{par} argument):
\itemize{
\item \code{BonferroniAdj}: Bonferroni procedure. Optional parameter: \code{weight}.
\item \code{HolmAdj}: Holm procedure. Optional parameter: \code{weight}.
\item \code{HochbergAdj}: Hochberg procedure. Optional parameter: \code{weight}.
\item \code{HommelAdj}: Hommel procedure. Optional parameter: \code{weight}.
\item \code{FixedSeqAdj}: Fixed-sequence procedure.
\item \code{ChainAdj}: Family of chain procedures. Required parameters: \code{weight} and \code{transition}.
\item \code{NormalParamAdj}: Parametric multiple testing procedure derived from a multivariate normal distribution. Required parameter: \code{corr}. Optional parameter: \code{weight}.
\item \code{ParallelGatekeepingAdj}: Family of parallel gatekeeping procedures. Required parameters: \code{family}, \code{proc}, \code{gamma}.
\item \code{MultipleSequenceGatekeepingAdj}: Family of multiple-sequence gatekeeping procedures. Required parameters: \code{family}, \code{proc}, \code{gamma}.
\item \code{MixtureGatekeepingAdj}: Family of mixture-based gatekeeping procedures. Required parameters: \code{family}, \code{proc}, \code{gamma}, \code{serial}, \code{parallel}.
}

If no \code{tests} are defined, the multiplicity adjustment procedure will be applied to all tests defined in the AnalysisModel.
}

\references{
\url{http://gpaux.github.io/Mediana/}
}

\seealso{
See Also \code{\link{MultAdj}}, \code{\link{MultAdjStrategy}} and \code{\link{AnalysisModel}}.
}
\examples{
# Parameters of the chain procedure (fixed-sequence procedure)
# Vector of hypothesis weights
chain.weight = c(1, 0)
# Matrix of transition parameters
chain.transition = matrix(c(0, 1,
                            0, 0), 2, 2, byrow = TRUE)

# Analysis model
analysis.model = AnalysisModel() +
  MultAdjProc(proc = "ChainAdj",
              par = parameters(weight = chain.weight,
                               transition = chain.transition)) +
  Test(id = "PFS test",
       samples = samples("Plac PFS", "Treat PFS"),
       method = "LogrankTest") +
  Test(id = "OS test",
       samples = samples("Plac OS", "Treat OS"),
       method = "LogrankTest")
}
