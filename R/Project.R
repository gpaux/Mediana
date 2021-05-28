#' Project object
#'
#' This function creates an object of class \code{Project} which can be added
#' to an object of class \code{PresentationModel}.
#'
#' Objects of class \code{Project} are used in objects of class
#' \code{PresentationModel} to add more details on the project, such as the
#' author, a title and a destiption of the project. This information will be
#' added in the report generated using the \code{GenerateReport} function. A
#' single object of class \code{Project} can be added to an object of class
#' \code{PresentationModel}.
#'
#' @param username defines the username to be printed in the report.
#' @param title defines the title of the project to be printed in the report.
#' @param description defines the description of the project to be printed in
#' the report.
#' @seealso See Also \code{\link{PresentationModel}} and
#' \code{\link{GenerateReport}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' # Reporting
#' presentation.model = PresentationModel() +
#'   Project(username = "[Mediana's User]",
#'           title = "Case study 1",
#'           description = "Clinical trial in patients with pulmonary arterial hypertension") +
#'   Section(by = "outcome.parameter") +
#'   Table(by = "sample.size") +
#'   CustomLabel(param = "sample.size",
#'               label= paste0("N = ",c(50, 55, 60, 65, 70))) +
#'   CustomLabel(param = "outcome.parameter",
#'               label=c("Standard 1", "Standard 2"))
#'
#' @export Project
Project = function(username = "[Unknown User]", title = "[Unknown title]", description = "[No description]") {

  # Error checks
  if (!is.character(username)) stop("Project: username must be character.")
  if (!is.character(title)) stop("Project: title must be character.")
  if (!is.character(description)) stop("Project: description must be character.")

  project = list(username = username, title = title, description = description)

  class(project) = "Project"
  return(project)
  invisible(project)
}
