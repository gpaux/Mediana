#' CustomLabel object
#'
#' This function creates an object of class \code{CustomLabel} which can be
#' added to an object of class \code{PresentationModel}.
#'
#' Objects of class \code{CustomLabel} are used in objects of class
#' \code{PresentationModel} to specify the labels that will be assigned to the
#' parameter. Several objects of class \code{CustomLabel} can be added to an
#' object of class \code{PresentationModel}.
#'
#' The argument \code{param} only accepts the following values: \itemize{ \item
#' \code{"sample.size"} \item \code{"event"} \item \code{"outcome.parameter"}
#' \item \code{"design.parameter"} \item \code{"multiplicity.adjustment"} }
#'
#' @param param defines a parameter for which the labels will be assigned.
#' @param label defines the label(s) to assign to the parameter.
#' @seealso See Also \code{\link{PresentationModel}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' ## Create a PresentationModel object with customized label
#' presentation.model = PresentationModel() +
#'   Section(by = "outcome.parameter") +
#'   Table(by = "sample.size") +
#'   CustomLabel(param = "sample.size",
#'               label= paste0("N = ",c(50, 55, 60, 65, 70))) +
#'   CustomLabel(param = "outcome.parameter", label=c("Standard 1", "Standard 2"))
#'
#' @export CustomLabel
CustomLabel = function(param, label) {

  # Error checks
  if (!is.character(param)) stop("CustomLabel: param must be character.")
  if (!(param %in% c("sample.size", "event", "outcome.parameter", "design.parameter", "multiplicity.adjustment"))) stop("CustomLabel: param is invalid.")
  if (!is.character(label)) stop("CustomLabel: label must be character.")

  custom.label = list(param = param, label = label)

  class(custom.label) = "CustomLabel"
  return(custom.label)
  invisible(custom.label)
}
