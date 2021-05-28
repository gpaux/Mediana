#' Sample object
#'
#' This function creates an object of class \code{Sample} which can be added to
#' an object of class \code{DataModel}.
#'
#' Objects of class \code{Sample} are used in objects of class \code{DataModel}
#' to specify a sample. Several objects of class \code{Sample} can be added to
#' an object of class \code{DataModel}.
#'
#' Mandatory arguments are \code{id} and \code{outcome.par}. The
#' \code{sample.size} argument is optional but must be used to define the
#' sample size if unbalance samples have to be defined. The sample size must be
#' either defined in the \code{Sample} object or in the \code{SampleSize}
#' object, but not in both.
#'
#' \code{outcome.par} defines the sample-specific parameters of the
#' \code{OutcomeDist} object. Required parameters according to the distribution
#' can be found in \code{\link{OutcomeDist}}.
#'
#' @param id defines the ID of the sample.
#' @param outcome.par defines the parameters of the outcome distribution of the
#' sample.
#' @param sample.size defines the sample size of the sample (optional).
#' @seealso See Also \code{\link{DataModel}} and \code{\link{OutcomeDist}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' # Outcome parameter set 1
#' outcome1.placebo = parameters(mean = 0, sd = 70)
#' outcome1.treatment = parameters(mean = 40, sd = 70)
#'
#' # Outcome parameter set 2
#' outcome2.placebo = parameters(mean = 0, sd = 70)
#' outcome2.treatment = parameters(mean = 50, sd = 70)
#'
#' # Data model
#' case.study1.data.model = DataModel() +
#'                          OutcomeDist(outcome.dist = "NormalDist") +
#'                          SampleSize(c(50, 55, 60, 65, 70)) +
#'                          Sample(id = "Placebo",
#'                                 outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
#'                          Sample(id = "Treatment",
#'                                 outcome.par = parameters(outcome1.treatment, outcome2.treatment))
#'
#' @export Sample
Sample = function(id, outcome.par,  sample.size = NULL) {

  # Error checks
  if (!is.character(unlist(id))) stop("Sample: sample ID must be character.")
  if (!is.list(outcome.par)) stop("Sample: outcome parameters must be provided in a list.")

  if (!is.null(sample.size)){
    # Error checks
    if (any(!is.numeric(unlist(sample.size)))) stop("Sample: sample size must be numeric.")
    if (any(unlist(sample.size) %% 1 !=0)) stop("Sample: sample size must be integer.")
    if (any(unlist(sample.size) <=0)) stop("Sample: sample size must be strictly positive.")

  }

  sample = list(id = id,
                outcome.par = outcome.par,
                sample.size = sample.size)

  class(sample) = "Sample"
  return(sample)
  invisible(sample)
}
