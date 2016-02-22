\name{Test}
\alias{Test}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Test object
}
\description{
This function creates an object of class \code{Test} which can be added to an object of class \code{AnalysisModel}.
}
\usage{
Test(id, method, samples, par = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{id}{
defines the ID of the Test object.
}
  \item{method}{
defines the method of the Test object.
}
  \item{samples}{
defines a list of samples defined in the data model to be used within the selected Test object method.
}
  \item{par}{
defines the parameter(s) of the selected Test object method.
}
}
\details{
Objects of class \code{Test} are used in objects of class \code{AnalysisModel} to define the statistical test to produce. Several objects of class \code{Test} can be added to an object of class \code{AnalysisModel}.

\code{method} argument defines the statistical test method. Several methods are already implemented in the Mediana package (listed below, along with the required parameters to define in the \code{par} parameter):
\itemize{
\item \code{TTest}: perform a two-sample t-test between the two samples defined in the \code{samples} argument. Two samples must be defined.
\item \code{TTestNI}: perform a non-inferiority two-sample t-test between the two samples defined in the \code{samples} argument. Required parameter: \code{delta}. Two samples must be defined.
\item \code{WilcoxTest}: perform a Wilcoxon-Mann-Whitney test between the two samples defined in the \code{samples} argument. Two samples must be defined.
\item \code{PropTest}: perform a two-sample test for proportions between the two samples defined in the \code{samples} argument. Optional parameter: \code{yates} (Yates' continuity correction TRUE or FALSE). Two samples must be defined.
\item \code{FisherTest}: perform a Fisher exact test between the two samples defined in the \code{samples} argument. Two samples must be defined.
\item \code{GLMPoissonTest}: perform a Poisson regression test between the two samples defined in the \code{samples} argument. Two samples must be defined.
\item \code{GLMNegBinomTest}: perform a Negative-binomial regression test between the two samples defined in the \code{samples} argument. Two samples must be defined.
\item \code{LogrankTest}: perform a Log-rank test between the two samples defined in the \code{samples} argument. Two samples must be defined.
}

It is to be noted that the statistical tests implemented are one-sided.
}

\references{
\url{http://gpaux.github.io/Mediana/}
}

\seealso{
See Also \code{\link{AnalysisModel}}.
}
\examples{
# Analysis model
analysis.model = AnalysisModel() +
                 Test(id = "Placebo vs treatment",
                      samples = samples("Placebo", "Treatment"),
                      method = "TTest")
}
