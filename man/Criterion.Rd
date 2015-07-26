\name{Criterion}
\alias{Criterion}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Criterion object
}
\description{
This function creates an object of class \code{Criterion} which can be added to an object of class \code{EvaluationModel}.
}
\usage{
Criterion(id, method, tests = NULL, statistics = NULL, par = NULL, labels)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{id}{
defines the ID of the \code{Criterion} object.
}
  \item{method}{
defines the method used by the \code{Criterion} object.
}
  \item{tests}{
defines the test(s) used by the \code{Criterion} object.
}
  \item{statistics}{
defines the statistic(s) used by the \code{Criterion} object.
}
  \item{par}{
defines the parameter(s) of the \code{method} argument of the \code{Criterion} object .
}
  \item{labels}{
defines the label(s) of the results.
}
}
\details{
Objects of class \code{Criterion} are used in objects of class \code{EvaluationModel} to specify the criteria that will be applied to the Clinical Scenario. Several objects of class \code{Criterion} can be added to an object of class \code{EvaluationModel}.

Mandatory arguments are \code{id}, \code{method}, \code{labels} and \code{tests} and/or \code{statistics}.

\code{method} argument defines the criterion's method. Several methods are already implemented in the Mediana package (listed below, along with the required parameters to define in the \code{par} parameter):
\itemize{
\item \code{MarginalPower}: generate the marginal power of all tests defined in the \code{test} argument. Required parameter: \code{alpha}.
\item \code{WeightedPower}: generate the weighted power of all tests defined in the \code{test} argument. Required parameters: \code{alpha} and \code{weight}.
\item \code{DisjunctivePower}: generate the disjunctive power (probability to reject at least one hypothesis  defined in the \code{test} argument). Required parameter: \code{alpha}.
\item \code{ConjunctivePower}: generate the conjunctive power (probability to reject all hypotheses defined in the \code{test} argument). Required parameter: \code{alpha}.
\item \code{ExpectedRejPower}: generate the expected number of rejected hypotheses. Required parameter: \code{alpha}.
}
}

\references{
\url{http://biopharmnet.com/mediana}
}

\seealso{
See Also \code{\link{AnalysisModel}}.
}
\examples{
## Add a Criterion to an EvaluationModel object
evaluation.model = EvaluationModel() +
                   Criterion(id = "Marginal power",
                   method = "MarginalPower",
                   tests = tests("Placebo vs treatment"),
                   labels = c("Placebo vs treatment"),
                   par = parameters(alpha = 0.025))
}
