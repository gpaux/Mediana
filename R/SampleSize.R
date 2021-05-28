#' SampleSize object
#'
#' This function creates an object of class \code{SampleSize} which can be
#' added to an object of class \code{DataModel}.
#'
#' Objects of class \code{SampleSize} are used in objects of class
#' \code{DataModel} to specify the sample size in case of balanced design (all
#' samples will have the same sample size). A single object of class
#' \code{SampleSize} can be added to an object of class \code{DataModel}.
#'
#' Either objects of class \code{Event} or \code{SampleSize} can be added to an
#' object of class \code{DataModel}, but not both.
#'
#' @param sample.size a list or vector of sample size(s).
#' @seealso See Also \code{\link{DataModel}}.
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
#' # Equivalent to:
#' case.study1.data.model = DataModel() +
#'                          OutcomeDist(outcome.dist = "NormalDist") +
#'                          SampleSize(seq(50, 70, 5)) +
#'                          Sample(id = "Placebo",
#'                                 outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
#'                          Sample(id = "Treatment",
#'                                 outcome.par = parameters(outcome1.treatment, outcome2.treatment))
#'
#' @export SampleSize
SampleSize = function(sample.size) {

  # Error checks
  if (any(!is.numeric(unlist(sample.size)))) stop("SampleSize: sample size must be numeric.")
  if (any(unlist(sample.size) %% 1 !=0)) stop("SampleSize: sample size must be integer.")
  if (any(unlist(sample.size) <=0)) stop("SampleSize: sample size must be strictly positive.")

  class(sample.size) = "SampleSize"
  return(unlist(sample.size))
  invisible(sample.size)

}
