\name{CustomLabel}
\alias{CustomLabel}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
CustomLabel object
}
\description{
This function creates an object of class \code{CustomLabel} which can be added to an object of class \code{PresentationModel}.
}
\usage{
CustomLabel(param, label)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{param}{
defines a parameter for which the labels will be assigned.
}
  \item{label}{
defines the label(s) to assign to the parameter.
}
}
\details{
Objects of class \code{CustomLabel} are used in objects of class \code{PresentationModel} to specify the labels that will be assigned to the parameter. Several objects of class \code{CustomLabel} can be added to an object of class \code{PresentationModel}.

The argument \code{param} only accepts the following values:
\itemize{
\item \code{"sample.size"}
\item \code{"event"}
\item \code{"outcome.parameter"}
\item \code{"design.parameter"}
\item \code{"multiplicity.adjustment"}
}
}

\references{
\url{http://biopharmnet.com/mediana}
}

\seealso{
See Also \code{\link{PresentationModel}}.
}
\examples{
## Create a PresentationModel object with customized label
presentation.model = PresentationModel() +
  Section(by = "outcome.parameter") +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size",
              label= paste0("N = ",c(50, 55, 60, 65, 70))) +
  CustomLabel(param = "outcome.parameter", label=c("Standard 1", "Standard 2"))
}
