#' Subsection object
#'
#' This function creates an object of class \code{Subsection} which can be
#' added to an object of class \code{PresentationModel}.
#'
#' Objects of class \code{Subsection} are used in objects of class
#' \code{PresentationModel} to define how the results will be presented in the
#' report. If a \code{Subsection} object is added to a \code{PresentationModel}
#' object, the report will have subsections according to the parameter defined
#' in the \code{by} argument. A single object of class \code{Subsection} can be
#' added to an object of class \code{PresentationModel}.
#'
#' One or several parameters can be defined in the \code{by} argument:
#' \itemize{ \item \code{"sample.size"} \item \code{"event"} \item
#' \code{"outcome.parameter"} \item \code{"design.parameter"} \item
#' \code{"multiplicity.adjustment"} }
#'
#' A object of class \code{Subsection} must be added to an object of class
#' \code{PresentationModel} only if a \code{Section} object has been defined.
#'
#' @param by defines the parameter to create the subsection in the report.
#' @seealso See Also \code{\link{PresentationModel}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' # Reporting
#' presentation.model = PresentationModel() +
#'   Section(by = "outcome.parameter") +
#'   Subsection(by = "sample.size") +
#'   CustomLabel(param = "sample.size",
#'               label= paste0("N = ",c(50, 55, 60, 65, 70))) +
#'   CustomLabel(param = "outcome.parameter",
#'               label=c("Standard 1", "Standard 2"))
#'
#' # In this report, one section will be created for each outcome parameter assumption
#' # and within each section, a subsection will be created for each sample size.
#'
#'
#' @export Subsection
Subsection = function(by) {

  # Error checks
  if (!is.character(by)) stop("Subsection: by must be character.")
  if (!any(by %in% c("sample.size", "event", "outcome.parameter", "design.parameter", "multiplicity.adjustment"))) stop("Subsection: the variables included in by are invalid.")


  subsection.report = list(by = by)

  class(subsection.report) = "Subsection"
  return(subsection.report)
  invisible(subsection.report)
}
