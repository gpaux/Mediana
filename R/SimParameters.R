#' SimParameters object
#'
#' This function creates an object of class \code{SimParameters} to be passed
#' into the \code{CSE} function.
#'
#' Objects of class \code{SimParameters} are used in the \code{CSE} function to
#' define the simulation parameters.
#'
#' The \code{proc.load} argument is used to define the number of clusters
#' dedicated to the simulations. Numeric value can be defined as well as
#' character value which automatically detect the number of cores: \itemize{
#' \item \code{low}: 1 processor core. \item \code{med}: Number of available
#' processor cores / 2. \item \code{high}: Number of available processor cores
#' - 1. \item \code{full}: All available processor cores. }
#'
#' @param n.sims defines the number of simulations.
#' @param seed defines the seed for the simulations.
#' @param proc.load defines the load of the processor (parallel computation).
#' @seealso See Also \code{\link{CSE}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' sim.parameters = SimParameters(n.sims = 1000, proc.load = "full", seed = 42938001)
#'
#' @export SimParameters
SimParameters = function(n.sims, seed, proc.load = 1) {

  # Error checks
  if (!is.numeric(n.sims)) stop("SimParameters: Number of simulation runs must be an integer.")
  if (length(n.sims) > 1) stop("SimParameters: Number of simulations runs: Only one value must be specified.")
  if (n.sims%%1 != 0) stop("SimParameters: Number of simulations runs must be an integer.")
  if (n.sims <= 0) stop("SimParameters: Number of simulations runs must be positive.")

  if (!is.numeric(seed)) stop("Seed must be an integer.")
  if (length(seed) > 1) stop("Seed: Only one value must be specified.")
  if (nchar(as.character(seed)) > 10) stop("Length of seed must be inferior to 10.")

  if (is.numeric(proc.load)){
    if (length(proc.load) > 1) stop("SimParameters: Processor load only one value must be specified.")
    if (proc.load %%1 != 0) stop("SimParameters: Processor load must be an integer.")
    if (proc.load <= 0) stop("SimParameters: Processor load must be positive.")
  }
  else if (is.character(proc.load)){
    if (!(proc.load %in% c("low", "med", "high", "full"))) stop("SimParameters: Processor load not valid")
  }

  sim.parameters = list(n.sims = n.sims,
                        seed = seed,
                        proc.load = proc.load)

  class(sim.parameters) = "SimParameters"
  return(sim.parameters)
  invisible(sim.parameters)
}
