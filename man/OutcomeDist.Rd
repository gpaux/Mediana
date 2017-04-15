\name{OutcomeDist}
\alias{OutcomeDist}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{OutcomeDist object
}
\description{
This function creates an object of class \code{OutcomeDist} which can be added to an object of class \code{DataModel}.
}
\usage{
OutcomeDist(outcome.dist, outcome.type = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{outcome.dist}{
defines the outcome distribution.
}
  \item{outcome.type}{
defines the outcome type.
}
}

\details{
Objects of class \code{OutcomeDist} are used in objects of class \code{DataModel} to specify the outcome distribution of the generated data. A single object of class \code{OutcomeDist} can be added to an object of class \code{DataModel}.

Several distribution are already implemented in the Mediana package (listed below, along with the required parameters to specify in the \code{outcome.par} argument of the \code{Sample} object) to be used in the \code{outcome.dist} argument:
\itemize{
\item \code{UniformDist}: generate data following a univariate distribution. Required parameter: \code{max}.
\item \code{NormalDist}: generate data following a normal distribution. Required parameters: \code{mean} and \code{sd}.
\item \code{BinomDist}: generate data following a binomial distribution. Required parameter: \code{prop}.
\item \code{BetaDist}: generate data following a beta distribution. Required parameter: \code{a}. and \code{b}.
\item \code{ExpoDist}: generate data following an exponential distribution. Required parameter: \code{rate}.
\item \code{WeibullDist}: generate data following a weibull distribution. Required parameter: \code{shape} and \code{scale}.
\item \code{TruncatedExpoDist}: generate data following a truncated exponential distribution. Required parameter: \code{rate} and \code{trunc}.
\item \code{PoissonDist}: generate data following a Poisson distribution. Required parameter: \code{lambda}.
\item \code{NegBinomDist}: generate data following a negative binomial distribution. Required parameters: \code{dispersion} and \code{mean}.
\item \code{MVNormalDist}: generate data following a multivariate normal distribution. Required parameters: \code{par} and \code{corr}. For each generated endpoint, the \code{par} parameter must contain the required parameters \code{mean} and \code{sd}. The \code{corr} parameter specifies the correlation matrix for the endpoints.
\item \code{MVBinomDist}: generate data following a multivariate binomial distribution. Required parameters: \code{par} and \code{corr}.For each generated endpoint, the \code{par} parameter must contain the required parameter \code{prop}.  The \code{corr} parameter specifies the correlation matrix for the endpoints.
\item \code{MVExpoDist}: generate data following a multivariate exponential distribution. Required parameters: \code{par} and \code{corr}. For each generated endpoint, the \code{par} parameter must contain the required parameter \code{rate}.  The \code{corr} parameter specifies the correlation matrix for the endpoints.
\item \code{MVExpoPFSOSDist}: generate data following a multivariate exponential distribution to generate PFS and OS endpoints. The  PFS value is imputed to the OS value if the latter occurs earlier. Required parameters: \code{par} and \code{corr}. For each generated endpoint, the \code{par} parameter must contain the required parameter \code{rate}.  The \code{corr} parameter specifies the correlation matrix for the endpoints.
\item \code{MVMixedDist}: generate data following a multivariate mixed distribution. Required parameters: \code{type}, \code{par} and \code{corr}. The \code{type} parameter can take the following values:
\itemize{
\item \code{NormalDist}
\item \code{BinomDist}
\item \code{ExpoDist}
}
For each generated endpoint, the \code{par} parameter must contain the required parameters according to the type of distribution. The \code{corr} parameter specifies the correlation matrix for the endpoints.
}

The \code{outcome.type} argument defines the outcome's type. This argument accepts only two values:
\itemize{
\item \code{standard}: for fixed design setting.
\item \code{event}: for event-driven design setting.
}
The outcome's type must be defined for each endpoint in case of multivariate disribution, e.g. \code{c("event","event")} in case of multivariate exponential distribution.

}

\references{
\url{http://gpaux.github.io/Mediana/}
}

\seealso{
See Also \code{\link{DataModel}}.
}
\examples{
# Simple example with a univariate distribution
# Outcome parameter set 1
outcome1.placebo = parameters(mean = 0, sd = 70)
outcome1.treatment = parameters(mean = 40, sd = 70)

# Outcome parameter set 2
outcome2.placebo = parameters(mean = 0, sd = 70)
outcome2.treatment = parameters(mean = 50, sd = 70)

# Data model
data.model = DataModel() +
             OutcomeDist(outcome.dist = "NormalDist") +
             SampleSize(c(50, 55, 60, 65, 70)) +
             Sample(id = "Placebo",
                    outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
             Sample(id = "Treatment",
                    outcome.par = parameters(outcome1.treatment, outcome2.treatment))

# Complex example with multivariate distribution following a Binomial and a Normal distribution
# Variable types
var.type = list("BinomDist", "NormalDist")

# Outcome distribution parameters
plac.par = list(list(prop = 0.3), list(mean = -0.10, sd = 0.5))

dosel.par1 = list(list(prop = 0.40), list(mean = -0.20, sd = 0.5))
dosel.par2 = list(list(prop = 0.45), list(mean = -0.25, sd = 0.5))
dosel.par3 = list(list(prop = 0.50), list(mean = -0.30, sd = 0.5))

doseh.par1 = list(list(prop = 0.50), list(mean = -0.30, sd = 0.5))
doseh.par2 = list(list(prop = 0.55), list(mean = -0.35, sd = 0.5))
doseh.par3 = list(list(prop = 0.60), list(mean = -0.40, sd = 0.5))

# Correlation between two endpoints
corr.matrix = matrix(c(1.0, 0.5,
                       0.5, 1.0), 2, 2)

# Outcome parameter set 1
outcome1.plac = list(type = var.type, par = plac.par, corr = corr.matrix)
outcome1.dosel = list(type = var.type, par = dosel.par1, corr = corr.matrix)
outcome1.doseh = list(type = var.type, par = doseh.par1, corr = corr.matrix)

# Outcome parameter set 2
outcome2.plac = list(type = var.type, par = plac.par, corr = corr.matrix)
outcome2.dosel = list(type = var.type, par = dosel.par2, corr = corr.matrix)
outcome2.doseh = list(type = var.type, par = doseh.par2, corr = corr.matrix)

# Outcome parameter set 3
outcome3.plac = list(type = var.type, par = plac.par, corr = corr.matrix)
outcome3.doseh = list(type = var.type, par = doseh.par3, corr = corr.matrix)
outcome3.dosel = list(type = var.type, par = dosel.par3, corr = corr.matrix)

# Data model
data.model = DataModel() +
             OutcomeDist(outcome.dist = "MVMixedDist") +
             SampleSize(c(100, 120)) +
             Sample(id = list("Plac ACR20", "Plac HAQ-DI"),
                    outcome.par = parameters(outcome1.plac, outcome2.plac, outcome3.plac)) +
             Sample(id = list("DoseL ACR20", "DoseL HAQ-DI"),
                    outcome.par = parameters(outcome1.dosel, outcome2.dosel, outcome3.dosel)) +
             Sample(id = list("DoseH ACR20", "DoseH HAQ-DI"),
                    outcome.par = parameters(outcome1.doseh, outcome2.doseh, outcome3.doseh))
}
