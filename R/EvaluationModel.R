#' EvaluationModel object
#'
#' \code{EvaluationModel()} initializes an object of class
#' \code{EvaluationModel}.
#'
#' Evaluation models are used within the Mediana package to specify the
#' measures (metrics) for evaluating the performance of the selected clinical
#' scenario (combination of data and analysis models).
#'
#' \code{EvaluationModel()} is used to create an object of class
#' \code{EvaluationModel} incrementally, using the '+' operator to add objects
#' to the existing \code{EvaluationModel} object. The advantage is to
#' explicitely define which objects are added to the \code{EvaluationModel}
#' object. Initialization with \code{EvaluationModel()} is highly recommended.
#'
#' Object of Class \code{Criterion} can be added to an object of class
#' \code{EvaluationModel}.
#'
#' @param \dots defines the arguments passed to create the object of class
#' \code{EvaluationModel}.
#' @seealso See Also \code{\link{Criterion}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' ## Initialize a EvaluationModel and add objects to it
#' evaluation.model = EvaluationModel() +
#'                    Criterion(id = "Marginal power",
#'                              method = "MarginalPower",
#'                              tests = tests("Placebo vs treatment"),
#'                              labels = c("Placebo vs treatment"),
#'                              par = parameters(alpha = 0.025))
#'
#' @export EvaluationModel
EvaluationModel = function(...) {
  UseMethod("EvaluationModel")
}
