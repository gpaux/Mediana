\name{Section}
\alias{Section}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Section object
}
\description{
This function creates an object of class \code{Section} which can be added to an object of class \code{PresentationModel}.
}
\usage{
Section(by)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{by}{
defines the parameter to create the section in the report.
}
}
\details{
Objects of class \code{Section} are used in objects of class \code{PresentationModel} to define how the results will be presented in the report. If a \code{Section} object is added to a \code{PresentationModel} object, the report will have sections according to the parameter defined in the \code{by} argument. A single object of class \code{Section} can be added to an object of class \code{PresentationModel}.

One or several parameters can be defined in the \code{by} argument:
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
# Reporting
presentation.model = PresentationModel() +
  Section(by = "outcome.parameter") +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size",
              label= paste0("N = ",c(50, 55, 60, 65, 70))) +
  CustomLabel(param = "outcome.parameter",
              label=c("Standard 1", "Standard 2"))

# In this report, one section will be created for each outcome parameter assumption.

}
