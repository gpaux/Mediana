#' Test object
#'
#' This function creates an object of class \code{Test} which can be added to
#' an object of class \code{AnalysisModel}.
#'
#' Objects of class \code{Test} are used in objects of class
#' \code{AnalysisModel} to define the statistical test to produce. Several
#' objects of class \code{Test} can be added to an object of class
#' \code{AnalysisModel}.
#'
#' \code{method} argument defines the statistical test method. Several methods
#' are already implemented in the Mediana package (listed below, along with the
#' required parameters to define in the \code{par} parameter): \itemize{ \item
#' \code{TTest}: perform a two-sample t-test between the two samples defined in
#' the \code{samples} argument. Optional parameter: \code{larger} (Larger value
#' is expected in the second sample (\code{TRUE} or \code{FALSE})). Two samples
#' must be defined. \item \code{TTestNI}: perform a non-inferiority two-sample
#' t-test between the two samples defined in the \code{samples} argument.
#' Required parameter: \code{margin}. Optional parameter: \code{larger} (Larger
#' value is expected in the second sample (\code{TRUE} or \code{FALSE})).Two
#' samples must be defined. \item \code{WilcoxTest}: perform a
#' Wilcoxon-Mann-Whitney test between the two samples defined in the
#' \code{samples} argument. Optional parameter: \code{larger} (Larger value is
#' expected in the second sample (\code{TRUE} or \code{FALSE})).Two samples
#' must be defined. \item \code{PropTest}: perform a two-sample test for
#' proportions between the two samples defined in the \code{samples} argument.
#' Optional parameter: \code{yates} (Yates' continuity correction \code{TRUE}
#' or \code{FALSE}) and \code{larger} (Larger value is expected in the second
#' sample (\code{TRUE} or \code{FALSE})). Two samples must be defined. \item
#' \code{PropTestNI}: perform a non-inferiority two-sample test for proportions
#' between the two samples defined in the \code{samples} argument. Required
#' parameter: \code{margin}. Optional parameter: \code{yates} (Yates'
#' continuity correction \code{TRUE} or \code{FALSE}) and \code{larger} (Larger
#' value is expected in the second sample (\code{TRUE} or \code{FALSE})). Two
#' samples must be defined. \item \code{FisherTest}: perform a Fisher exact
#' test between the two samples defined in the \code{samples} argument.
#' Optional parameter: \code{larger} (Larger value is expected in the second
#' sample (\code{TRUE} or \code{FALSE})). Two samples must be defined. \item
#' \code{GLMPoissonTest}: perform a Poisson regression test between the two
#' samples defined in the \code{samples} argument. Optional parameter:
#' \code{larger} (Larger value is expected in the second sample (\code{TRUE} or
#' \code{FALSE})). Two samples must be defined. \item \code{GLMNegBinomTest}:
#' perform a Negative-binomial regression test between the two samples defined
#' in the \code{samples} argument. Optional parameter: \code{larger} (Larger
#' value is expected in the second sample (\code{TRUE} or \code{FALSE})).Two
#' samples must be defined. \item \code{LogrankTest}: perform a Log-rank test
#' between the two samples defined in the \code{samples} argument. Optional
#' parameter: \code{larger} (Larger value is expected in the second sample
#' (\code{TRUE} or \code{FALSE})). Two samples must be defined. \item
#' \code{OrdinalLogisticRegTest}: perform an Ordinal logistic regression test
#' between the two samples defined in the \code{samples} argument. Optional
#' parameter: \code{larger} (Larger value is expected in the second sample
#' (\code{TRUE} or \code{FALSE})). Two samples must be defined. }
#'
#' It is to be noted that the statistical tests implemented are one-sided and
#' thus the sample order in the samples argument is important. In particular,
#' the Mediana package assumes by default that a numerically larger value of
#' the endpoint is expected in Sample 2 compared to Sample 1. Suppose, for
#' example, that a higher treatment response indicates a beneficial effect
#' (e.g., higher improvement rate). In this case Sample 1 should include
#' control patients whereas Sample 2 should include patients allocated to the
#' experimental treatment arm. The sample order needs to be reversed if a
#' beneficial treatment effect is associated with a lower value of the endpoint
#' (e.g., lower blood pressure), or alternatively (from version 1.0.6), the
#' optional parameters \code{larger} must be set to \code{FALSE} to indicate
#' that a larger value is expected on the first Sample.
#'
#' @param id defines the ID of the Test object.
#' @param method defines the method of the Test object.
#' @param samples defines a list of samples defined in the data model to be
#' used within the selected Test object method.
#' @param par defines the parameter(s) of the selected Test object method.
#' @seealso See Also \code{\link{AnalysisModel}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' # Analysis model
#' analysis.model = AnalysisModel() +
#'                  Test(id = "Placebo vs treatment",
#'                       samples = samples("Placebo", "Treatment"),
#'                       method = "TTest")
#'
#' @export Test
Test = function(id, method, samples, par = NULL) {

  # Error checks
  if (!is.character(id)) stop("Test: ID must be character.")
  if (!is.character(method)) stop("Test: statistical method must be character.")
  if (!is.list(samples)) stop("Test: samples must be wrapped in a list.")
  if (all(lapply(samples, is.list) == FALSE) & any(lapply(samples, is.character) == FALSE)) stop("Test: samples must be character.")
  if (all(lapply(samples, is.list) == TRUE) & (!is.character(unlist(samples)))) stop("Test: samples must be character.")
  if (!is.null(par) & !is.list(par)) stop("Test: par must be wrapped in a list.")

  test = list(id = id, method = method, samples = samples, par = par)

  class(test) = "Test"
  return(test)
  invisible(test)
}
