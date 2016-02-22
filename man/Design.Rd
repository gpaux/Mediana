\name{Design}
\alias{Design}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Design object
}
\description{
This function creates an object of class \code{Design} which can be added to an object of class \code{DataModel}.
}
\usage{
Design(enroll.period = NULL,
       enroll.dist = NULL,
       enroll.dist.par = NULL,
       followup.period = NULL,
       study.duration = NULL,
       dropout.dist = NULL,
       dropout.dist.par = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{enroll.period}{
  defines the length of the enrollment period.
}
  \item{enroll.dist}{
  defines the enrollment distribution.
}
  \item{enroll.dist.par}{
  defines the parameters of the enrollment distribution (optional).
}
  \item{followup.period}{
defines the length of the follow-up period for each patient in study designs with a fixed follow-up period, i.e., the length of time from the enrollment to planned discontinuation is constant across patients. The user must specify either \code{followup.period} or \code{study.duration}.
}
  \item{study.duration}{
defines the total study duration in study designs with a variable follow-up period. The total study duration is defined as the length of time from the enrollment of the first patient to the discontinuation of the last patient.
}
  \item{dropout.dist}{defines the dropout distribution.
}
  \item{dropout.dist.par}{defines the parameters of the dropout distribution.
}
}
\details{
Objects of class \code{Design} are used in objects of class \code{DataModel} to specify the design parameters used in event-driven designs if the user is interested in modeling the enrollment (or accrual) and dropout (or loss to follow up) processes that will be applied to the Clinical Scenario. Several objects of class \code{Design} can be added to an object of class \code{DataModel}.

Note that the length of the enrollment period, total study duration and follow-up periods are measured using the same time units.
}

\references{
\url{http://gpaux.github.io/Mediana/}
}

\seealso{
See Also \code{\link{DataModel}}.
}
\examples{
## Create DataModel object with a Design Object
data.model = DataModel() +
             Design(enroll.period = 9,
                    study.duration = 21,
                    enroll.dist = "UniformDist",
                    dropout.dist = "ExpoDist",
                    dropout.dist.par = parameters(rate = 0.0115))

## Create DataModel object with several Design Objects
design1 = Design(enroll.period = 9,
                 study.duration = 21,
                 enroll.dist = "UniformDist",
                 dropout.dist = "ExpoDist",
                 dropout.dist.par = parameters(rate = 0.0115))

design2 = Design(enroll.period   = 18,
                 study.duration = 24,
                 enroll.dist = "UniformDist",
                 dropout.dist = "ExpoDist",
                 dropout.dist.par = parameters(rate = 0.0115))

data.model = DataModel() +
             design1 +
             design2
}
