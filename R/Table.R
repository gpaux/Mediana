#' Table object
#'
#' This function creates an object of class \code{Table} which can be added to
#' an object of class \code{PresentationModel}.
#'
#' Objects of class \code{Table} are used in objects of class
#' \code{PresentationModel} to define how the results will be sorted in the
#' results tables of the report. If a \code{Table} object is added to a
#' \code{PresentationModel} object, the report will generate tables sorted
#' according to the parameter defined in the \code{by} argument. A single
#' object of class \code{Table} can be added to an object of class
#' \code{PresentationModel}.
#'
#' One or several parameters can be defined in the \code{by} argument:
#' \itemize{ \item \code{"sample.size"} \item \code{"event"} \item
#' \code{"outcome.parameter"} \item \code{"design.parameter"} \item
#' \code{"multiplicity.adjustment"} }
#'
#' @param by defines the parameter to sort the table in the report.
#' @seealso See Also \code{\link{PresentationModel}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' # Reporting
#' presentation.model = PresentationModel() +
#'   Section(by = "outcome.parameter") +
#'   Table(by = "sample.size") +
#'   CustomLabel(param = "sample.size",
#'               label= paste0("N = ",c(50, 55, 60, 65, 70))) +
#'   CustomLabel(param = "outcome.parameter",
#'               label=c("Standard 1", "Standard 2"))
#'
#' # In this report, one section will be created for each outcome parameter assumption.
#' # The tables presented within each section will be sorted by sample size.
#'
#' @export Table
Table = function(by) {

  # Error checks
  if (!is.character(by)) stop("Table: by must be character.")
  if (!any(by %in% c("sample.size", "event", "outcome.parameter", "design.parameter", "multiplicity.adjustment"))) stop("Table: the variables included in by are invalid.")

  table.report = list(by = by)

  class(table.report) = "Table"
  return(table.report)
  invisible(table.report)
}
