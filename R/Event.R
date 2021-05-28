#' Event object
#'
#' This function creates an object of class \code{Event} which can be added to
#' an object of class \code{DataModel}.
#'
#' This function can be used if the number of events needs to be fixed in an
#' event-driven clinical trial. Either objects of class \code{Event} or
#' \code{SampleSize} can be added to an object of class \code{DataModel} but
#' not both.
#'
#' @param n.events defines a vector of number of events required.
#' @param rando.ratio defines a vector of randomization ratios for each
#' \code{Sample} object defined in the \code{DataModel}.
#' @seealso See Also \code{\link{DataModel}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' # In this case study, the radomization ratio is 2:1 (Treatment:Placebo).
#'
#' # Sample size parameters
#' event.count.total = c(390, 420)
#' randomization.ratio = c(1,2)
#'
#' # Outcome parameters
#' median.time.placebo = 6
#' rate.placebo = log(2)/median.time.placebo
#' outcome.placebo = list(rate = rate.placebo)
#' median.time.treatment = 9
#' rate.treatment = log(2)/median.time.treatment
#' outcome.treatment = list(rate = rate.treatment)
#'
#' # Dropout parameters
#' dropout.par = parameters(rate = 0.0115)
#'
#' # Data model
#' data.model = DataModel() +
#'              OutcomeDist(outcome.dist = "ExpoDist") +
#'              Event(n.events = event.count.total, rando.ratio = randomization.ratio) +
#'              Design(enroll.period = 9,
#'                     study.duration = 21,
#'                     enroll.dist = "UniformDist",
#'                     dropout.dist = "ExpoDist",
#'                     dropout.dist.par = dropout.par) +
#'              Sample(id = "Placebo",
#'                     outcome.par = parameters(outcome.placebo)) +
#'              Sample(id = "Treatment",
#'                     outcome.par = parameters(outcome.treatment))
#'
#' @export Event
Event = function(n.events, rando.ratio=NULL) {

  # Error checks
  if (any(!is.numeric(unlist(n.events)))) stop("Event: number of events must be numeric.")
  if (any(unlist(n.events) %% 1 !=0)) stop("Event: number of events must be integer.")
  if (any(unlist(n.events) <=0)) stop("Event: number of events must be strictly positive.")

  if (!is.null(rando.ratio)){
    if (any(!is.numeric(unlist(rando.ratio)))) stop("Event: randomization ratio must be numeric.")
    if (any(unlist(rando.ratio) %% 1 !=0)) stop("Event: randomization ratio must be integer.")
    if (any(unlist(rando.ratio) <=0)) stop("Event: randomization ratio must be strictly positive.")
  }

  event = list(n.events = unlist(n.events), rando.ratio = unlist(rando.ratio))

  class(event) = "Event"
  return(event)
  invisible(event)

}
