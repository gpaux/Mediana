\name{EvaluationModel}
\alias{EvaluationModel}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
EvaluationModel object
}
\description{
\code{EvaluationModel()} initializes an object of class \code{EvaluationModel}.
}
\usage{
EvaluationModel(...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
defines the arguments passed to create the object of class \code{EvaluationModel}.
}
}
\details{
Evaluation models are used within the Mediana package to specify the measures (metrics) for evaluating the performance of the selected clinical scenario (combination of data and analysis models).

\code{EvaluationModel()} is used to create an object of class \code{EvaluationModel} incrementally, using the '+' operator to add objects to the existing \code{EvaluationModel} object. The advantage is to explicitely define which objects are added to the \code{EvaluationModel} object. Initialization with \code{EvaluationModel()} is highly recommended.

Object of Class \code{Criterion} can be added to an object of class \code{EvaluationModel}.
}

\references{
\url{http://biopharmnet.com/mediana}
}

\seealso{
See Also \code{\link{Criterion}}.
}
\examples{
## Initialize a EvaluationModel and add objects to it
evaluation.model = EvaluationModel() +
                   Criterion(id = "Marginal power",
                             method = "MarginalPower",
                             tests = tests("Placebo vs treatment"),
                             labels = c("Placebo vs treatment"),
                             par = parameters(alpha = 0.025))
}
