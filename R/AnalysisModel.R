#' AnalysisModel object
#'
#' \code{AnalysisModel()} initializes an object of class \code{AnalysisModel}.
#'
#' Analysis models define statistical methods that are applied to the study
#' data in a clinical trial.
#'
#' \code{AnalysisModel()} is used to create an object of class
#' \code{AnalysisModel} incrementally, using the '+' operator to add objects to
#' the existing \code{AnalysisModel} object. The advantage is to explicitely
#' define which objects are added to the \code{AnalysisModel} object.
#' Initialization with \code{AnalysisModel()} is higlhy recommended.
#'
#' Objects of class \code{Test}, \code{MultAdjProc}, \code{MultAdjStrategy},
#' \code{MultAdj} and \code{Statistic} can be added to an object of class
#' \code{AnalysisModel}.
#'
#' @param \dots defines the arguments passed to create the object of class
#' \code{AnalysisModel}.
#' @seealso See Also \code{\link{Test}}, \code{\link{MultAdjProc}},
#' \code{\link{MultAdjStrategy}}, \code{\link{MultAdj}} and
#' \code{\link{Statistic}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' ## Initialize an AnalysisModel and add objects to it
#' analysis.model = AnalysisModel() +
#'                  Test(id = "Placebo vs treatment",
#'                       samples = samples("Placebo", "Treatment"),
#'                       method = "TTest")
#'
#' @export AnalysisModel
AnalysisModel = function(...) {
  UseMethod("AnalysisModel")
}
