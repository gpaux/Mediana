#' DataModel object
#'
#' \code{DataModel()} initializes an object of class \code{DataModel}.
#'
#' Data models define the process of generating patients data in a clinical
#' trial.
#'
#' \code{DataModel()} is used to create an object of class \code{DataModel}
#' incrementally, using the '+' operator to add objects to the existing
#' \code{DataModel} object. The advantage is to explicitely define which
#' objects are added to the \code{DataModel} object. Initialization with
#' \code{DataModel()} is highly recommended.
#'
#' Objects of class \code{OutcomeDist}, \code{SampleSize}, \code{Sample},
#' \code{Event} and \code{Design} can be added to an object of class
#' \code{DataModel}.
#'
#' @param \dots defines the arguments passed to create the object of class
#' \code{DataModel}.
#' @seealso See Also \code{\link{OutcomeDist}}, \code{\link{SampleSize}},
#' \code{\link{Sample}} and \code{\link{Design}}.
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
#' data.model = DataModel() +
#'             OutcomeDist(outcome.dist = "NormalDist") +
#'             SampleSize(c(50, 55, 60, 65, 70)) +
#'             Sample(id = "Placebo",
#'                    outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
#'             Sample(id = "Treatment",
#'                    outcome.par = parameters(outcome1.treatment, outcome2.treatment))
#'
#'
#' @export DataModel
DataModel = function(...) {
  UseMethod("DataModel")
}
