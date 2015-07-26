\name{Event}
\alias{Event}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Event object
}
\description{
This function creates an object of class \code{Event} which can be added to an object of class \code{DataModel}.
}
\usage{
Event(n.events, rando.ratio = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n.events}{
defines a vector of number of events required.
}
  \item{rando.ratio}{
defines a vector of randomization ratios for each \code{Sample} object defined in the \code{DataModel}.
}
}
\details{
This function can be used if the number of events needs to be fixed in an event-driven clinical trial. Either objects of class \code{Event} or \code{SampleSize} can be added to an object of class \code{DataModel} but not both.
}

\references{
\url{http://biopharmnet.com/mediana}
}

\seealso{
See Also \code{\link{DataModel}}.
}
\examples{
# In this case study, the radomization ratio is 2:1 (Treatment:Placebo).

# Sample size parameters
event.count.total = c(390, 420)
randomization.ratio = c(1,2)

# Outcome parameters
median.time.placebo = 6
rate.placebo = log(2)/median.time.placebo
outcome.placebo = list(rate = rate.placebo)
median.time.treatment = 9
rate.treatment = log(2)/median.time.treatment
outcome.treatment = list(rate = rate.treatment)

# Dropout parameters
dropout.par = parameters(rate = 0.0115)

# Data model
data.model = DataModel() +
             OutcomeDist(outcome.dist = "ExpoDist") +
             Event(n.events = event.count.total, rando.ratio = randomization.ratio) +
             Design(enroll.period = 9,
                    study.duration = 21,
                    enroll.dist = "UniformDist",
                    dropout.dist = "ExpoDist",
                    dropout.dist.par = dropout.par) +
             Sample(id = "Placebo",
                    outcome.par = parameters(outcome.placebo)) +
             Sample(id = "Treatment",
                    outcome.par = parameters(outcome.treatment))
}
