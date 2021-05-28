#' Design object
#'
#' This function creates an object of class \code{Design} which can be added to
#' an object of class \code{DataModel}.
#'
#' Objects of class \code{Design} are used in objects of class \code{DataModel}
#' to specify the design parameters used in event-driven designs if the user is
#' interested in modeling the enrollment (or accrual) and dropout (or loss to
#' follow up) processes that will be applied to the Clinical Scenario. Several
#' objects of class \code{Design} can be added to an object of class
#' \code{DataModel}.
#'
#' Note that the length of the enrollment period, total study duration and
#' follow-up periods are measured using the same time units.
#'
#' If \code{enroll.dist = "UniformDist"}, the \code{enroll.dist.par} should be
#' let to \code{NULL} (then enrollment distribution will be uniform during the
#' enrollment period).
#'
#' If \code{enroll.dist = "BetaDist"}, the \code{enroll.dist.par} should
#' contain the parameter of the beta distribution (\code{a} and \code{b}).
#' These parameters must be derived according to the expected enrollment at a
#' specific timepoint. For example, if half the patients are expected to be
#' enrolled at 75\% of the enrollment period, the beta distribution is a
#' \code{Beta(log(0.5)/log(0.75), 1)}. Generally, let \code{q} be the
#' proportion of enrolled patients at \code{p}\% of the enrollment period, the
#' Beta distribution can be derived as follows: \itemize{ \item If \code{q} >
#' \code{p}, the Beta distribution is \code{Beta(a,1)} with \code{a = log(p) /
#' log(q)} \item If \code{q} < \code{p}, the Beta distribution is \code{Beta
#' (1,b)} with \code{b = log(1-p) / log(1-q)} \item Otherwise the Beta
#' distribution is \code{Beta(1,1)} }
#'
#' If \code{dropout.dist = "UniformDist"}, the \code{dropout.dist.par} should
#' contain the dropout rate. This parameter must be specified using the
#' \code{prop} parameter, such as \code{dropout.dist.par = parameters(prop =
#' 0.1)} for a 10\% dropout rate.
#'
#' @param enroll.period defines the length of the enrollment period.
#' @param enroll.dist defines the enrollment distribution.
#' @param enroll.dist.par defines the parameters of the enrollment distribution
#' (optional).
#' @param followup.period defines the length of the follow-up period for each
#' patient in study designs with a fixed follow-up period, i.e., the length of
#' time from the enrollment to planned discontinuation is constant across
#' patients. The user must specify either \code{followup.period} or
#' \code{study.duration}.
#' @param study.duration defines the total study duration in study designs with
#' a variable follow-up period. The total study duration is defined as the
#' length of time from the enrollment of the first patient to the
#' discontinuation of the last patient.
#' @param dropout.dist defines the dropout distribution.
#' @param dropout.dist.par defines the parameters of the dropout distribution.
#' @seealso See Also \code{\link{DataModel}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' ## Create DataModel object with a Design Object
#' data.model = DataModel() +
#'              Design(enroll.period = 9,
#'                     study.duration = 21,
#'                     enroll.dist = "UniformDist",
#'                     dropout.dist = "ExpoDist",
#'                     dropout.dist.par = parameters(rate = 0.0115))
#'
#' ## Create DataModel object with several Design Objects
#' design1 = Design(enroll.period = 9,
#'                  study.duration = 21,
#'                  enroll.dist = "UniformDist",
#'                  dropout.dist = "ExpoDist",
#'                  dropout.dist.par = parameters(rate = 0.0115))
#'
#' design2 = Design(enroll.period   = 18,
#'                  study.duration = 24,
#'                  enroll.dist = "UniformDist",
#'                  dropout.dist = "ExpoDist",
#'                  dropout.dist.par = parameters(rate = 0.0115))
#'
#' data.model = DataModel() +
#'              design1 +
#'              design2
#'
#' @export Design
Design = function(enroll.period = NULL,  enroll.dist = NULL, enroll.dist.par = NULL, followup.period = NULL, study.duration = NULL, dropout.dist = NULL, dropout.dist.par = NULL) {

  # Error checks
  if (!is.null(enroll.period) & !is.numeric(enroll.period)) stop("Design: enrollment period must be numeric.")
  if (!is.null(enroll.dist) & !is.character(enroll.dist)) stop("Design: enrollment distribution must be character.")
  if (!is.null(enroll.dist.par) & !is.list(enroll.dist.par)) stop("Design: enrollment distribution parameters must be provided in a list.")
  if (!is.null(followup.period) & !is.numeric(followup.period)) stop("Design: follow-up period must be provided in a list.")
  if (!is.null(study.duration) & !is.numeric(study.duration)) stop("Design: study duration must be provided in a list.")
  if (!is.null(dropout.dist) & !is.character(dropout.dist)) stop("Design: dropout distribution must be character.")
  if (!is.null(dropout.dist.par) & !is.list(dropout.dist.par)) stop("Design: enrollment distribution parameters must be provided in a list.")
  if (is.null(followup.period) & is.null(study.duration)) stop("Design: follow-up period or study duration must be defined")
  if (!is.null(followup.period) & !is.null(study.duration)) stop("Design: either follow-up period or study duration must be defined")
  if (is.null(enroll.dist) & !is.null(dropout.dist)) stop("Design: Dropout parameters cannot be specified without enrollment parameters.")

  design = list(enroll.period = enroll.period,
                enroll.dist = enroll.dist,
                enroll.dist.par = enroll.dist.par,
                followup.period = followup.period,
                study.duration = study.duration,
                dropout.dist = dropout.dist,
                dropout.dist.par = dropout.dist.par)


  class(design) = "Design"
  return(design)
  invisible(design)

}
