\name{AdjustPvalues}
\alias{AdjustPvalues}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
AdjustPvalues function
}

\description{Computation of adjusted p-values for commonly used multiple testing procedures based on univariate
p-values (Bonferroni, Holm, Hommel, Hochberg, fixed-sequence procedures) and multistage gatepeeking procedure.

}

\usage{
AdjustPvalues(pval, proc, par = NA)
}


\arguments{
  \item{pval}{
defines the raw p-values.
}
  \item{proc}{
defines the multiple testing procedure. Several procedures are already implemented in the Mediana package (listed below, along with the required or optional parameters to specify in the \code{par} argument):
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
}

  \item{par}{
defines the parameters associated to the multiple testing procedure
}
}

\details{
This function can be used to adjust p-values according to a multiple testing procedure defines in the \code{proc} argument.
}
\value{ Return a vector of adjusted p-values.
}

\references{
http://gpaux.github.io/Mediana/
}

\seealso{
See Also \code{\link{MultAdjProc}}.
}

\examples{
# Bonferroni, Holm, Hochberg, Hommel and Fixed-sequence procedure
proc = c("BonferroniAdj", "HolmAdj", "HochbergAdj", "HommelAdj", "FixedSeqAdj")
rawp = c(0.012, 0.009, 0.023)

# Equally weighted
sapply(proc, function(x) {AdjustPvalues(rawp,
                                        proc = x)})

# Unequally weighted (no effect on the fixed-sequence procedure)
sapply(proc, function(x) {AdjustPvalues(rawp,
                                        proc = x,
                                        par = parameters(weight = c(1/2, 1/4, 1/4)))})

# Parallel gatekeeping
# Consider a clinical trial with two families of null hypotheses
# Family 1: Primary null hypotheses (one-sided p-values)
# H1 (Endpoint 1), p1=0.0082
# H2 (Endpoint 2), p2=0.0174
# Family 2: Secondary null hypotheses (one-sided p-values)
# H3 (Endpoint 3), p3=0.0042
# H4 (Endpoint 4), p4=0.0180

# Define raw p-values
rawp<-c(0.0082,0.0174, 0.0042,0.0180)

# Define hHypothesis included in each family
family = families(family1 = c(1, 2),
                  family2 = c(3, 4))

# Define component procedure of each family
component.procedure = families(family1 ="HolmAdj",
                               family2 = "HolmAdj")

# Truncation parameter of each family
gamma = families(family1 = 0.5,
                 family2 = 1)

adjustp = AdjustPvalues(rawp,
                        proc = "ParallelGatekeepingAdj",
                        par = parameters(family = family,
                                         proc = component.procedure,
                                         gamma = gamma))

}
