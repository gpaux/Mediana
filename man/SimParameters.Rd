\name{SimParameters}
\alias{SimParameters}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{SimParameters object
}
\description{
This function creates an object of class \code{SimParameters} to be passed into the \code{CSE} function.
}
\usage{
SimParameters(n.sims, seed, proc.load = 1)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n.sims}{
defines the number of simulations.
}
  \item{seed}{
defines the seed for the simulations.
}
  \item{proc.load}{
defines the load of the processor (parallel computation).
}
}
\details{
Objects of class \code{SimParameters} are used in the \code{CSE} function to define the simulation parameters.

The \code{proc.load} argument is used to define the number of clusters dedicated to the simulations. Numeric value can be defined as well as character value which automatically detect the number of cores:
\itemize{
\item \code{low}: 1 processor core.
\item \code{med}: Number of available processor cores / 2.
\item \code{high}: Number of available processor cores - 1.
\item \code{full}: All available processor cores.
}

}

\references{
\url{http://biopharmnet.com/mediana}
}

\seealso{
See Also \code{\link{CSE}}.
}
\examples{
sim.parameters = SimParameters(n.sims = 1000, proc.load = "full", seed = 42938001)
}
