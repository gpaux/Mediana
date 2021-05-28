#' Criterion object
#'
#' This function creates an object of class \code{Criterion} which can be added
#' to an object of class \code{EvaluationModel}.
#'
#' Objects of class \code{Criterion} are used in objects of class
#' \code{EvaluationModel} to specify the criteria that will be applied to the
#' Clinical Scenario. Several objects of class \code{Criterion} can be added to
#' an object of class \code{EvaluationModel}.
#'
#' Mandatory arguments are \code{id}, \code{method}, \code{labels} and
#' \code{tests} and/or \code{statistics}.
#'
#' \code{method} argument defines the criterion's method. Several methods are
#' already implemented in the Mediana package (listed below, along with the
#' required parameters to define in the \code{par} parameter): \itemize{ \item
#' \code{MarginalPower}: generate the marginal power of all tests defined in
#' the \code{test} argument. Required parameter: \code{alpha}. \item
#' \code{WeightedPower}: generate the weighted power of all tests defined in
#' the \code{test} argument. Required parameters: \code{alpha} and
#' \code{weight}. \item \code{DisjunctivePower}: generate the disjunctive power
#' (probability to reject at least one hypothesis defined in the \code{test}
#' argument). Required parameter: \code{alpha}. \item \code{ConjunctivePower}:
#' generate the conjunctive power (probability to reject all hypotheses defined
#' in the \code{test} argument). Required parameter: \code{alpha}. \item
#' \code{ExpectedRejPower}: generate the expected number of rejected
#' hypotheses. Required parameter: \code{alpha}. }
#'
#' @param id defines the ID of the \code{Criterion} object.
#' @param method defines the method used by the \code{Criterion} object.
#' @param tests defines the test(s) used by the \code{Criterion} object.
#' @param statistics defines the statistic(s) used by the \code{Criterion}
#' object.
#' @param par defines the parameter(s) of the \code{method} argument of the
#' \code{Criterion} object .
#' @param labels defines the label(s) of the results.
#' @seealso See Also \code{\link{AnalysisModel}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' ## Add a Criterion to an EvaluationModel object
#' evaluation.model = EvaluationModel() +
#'                    Criterion(id = "Marginal power",
#'                    method = "MarginalPower",
#'                    tests = tests("Placebo vs treatment"),
#'                    labels = c("Placebo vs treatment"),
#'                    par = parameters(alpha = 0.025))
#'
#' @export Criterion
Criterion = function(id, method, tests = NULL, statistics = NULL, par = NULL, labels) {

  # Error checks
  if (!is.character(id)) stop("Criterion: ID must be character.")
  if (!is.character(method)) stop("Criterion: method must be character.")
  if (!is.null(tests) & !is.list(tests)) stop("Criterion: tests must be wrapped in a list.")
  if (any(lapply(tests, is.character) == FALSE)) stop("Criterion: tests must be character.")
  if (!is.null(statistics) & !is.list(statistics)) stop("Criterion: statistics must be wrapped in a list.")
  if (any(lapply(statistics, is.character) == FALSE)) stop("Criterion: statistics must be character.")
  if (is.null(tests) & is.null(statistics )) stop("Criterion: tests and/or statistics must be provided")

  criterion = list(id = id ,
                   method = method ,
                   tests = tests ,
                   statistics = statistics ,
                   par = par ,
                   labels = labels)

  class(criterion) = "Criterion"
  return(criterion)
  invisible(criterion)
}
