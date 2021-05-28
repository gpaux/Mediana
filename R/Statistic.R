#' Statistic object
#'
#' This function creates an object of class \code{Statistic} which can be added
#' to an object of class \code{AnalysisModel}.
#'
#' Objects of class \code{Statistic} are used in objects of class
#' \code{AnalysisModel} to define the statistics to produce. Several objects of
#' class \code{Statistic} can be added to an object of class
#' \code{AnalysisModel}.
#'
#' \code{method} argument defines the statistical method. Several methods are
#' already implemented in the Mediana package (listed below, along with the
#' required parameters to define in the \code{par} parameter): \itemize{ \item
#' \code{MedianStat}: compute the median of the sample defined in the
#' \code{samples} argument. \item \code{MeanStat}: compute the mean of the
#' sample defined in the \code{samples} argument. \item \code{SdStat}: compute
#' the standard deviation of the sample defined in the \code{samples} argument.
#' \item \code{MinStat}: compute the minimum of the sample defined in the
#' \code{samples} argument. \item \code{MaxStat}: compute the maximum of the
#' sample defined in the \code{samples} argument. \item \code{DiffMeanStat}:
#' compute the difference of means between the two samples defined in the
#' \code{samples} argument. Two samples must be defined. \item
#' \code{EffectSizeContStat}: compute the effect size for a continuous
#' endpoint. Two samples must be defined. \item \code{RatioEffectSizeContStat}:
#' compute the ratio of two effect sizes for a continuous endpoint. Four
#' samples must be defined. \item \code{PropStat}: compute the proportion of
#' the sample defined in the \code{samples} argument. \item
#' \code{DiffPropStat}: compute the difference of the proportions between the
#' two samples defined in the \code{samples} argument. Two samples must be
#' defined. \item \code{EffectSizePropStat}: compute the effect size for a
#' binary endpoint. Two samples must be defined. \item
#' \code{RatioEffectSizePropStat}: compute the ratio of two effect sizes for a
#' binary endpoint. Four samples must be defined. \item \code{HazardRatioStat}:
#' compute the hazard ratio of the two samples defined in the \code{samples}
#' argument. Two samples must be defined. By default the Log-Rank method is
#' used. Optional argument: \code{method} taking as value \code{Log-Rank} or
#' \code{Cox}. \item \code{EffectSizeEventStat}: compute the effect size for a
#' survival endpoint (log of the HR). Two samples must be defined. Two samples
#' must be defined. By default the Log-Rank method is used. Optional argument:
#' \code{method} taking as value \code{Log-Rank} or \code{Cox}. \item
#' \code{RatioEffectSizeEventStat}: compute the ratio of two effect sizes for a
#' survival endpoint. Four samples must be defined. By default the Log-Rank
#' method is used. Optional argument: \code{method} taking as value
#' \code{Log-Rank} or \code{Cox}. \item \code{EventCountStat}: compute the
#' number of events observed in the sample(s) defined in the \code{samples}
#' argument. \item \code{PatientCountStat}: compute the number of patients
#' observed in the sample(s) defined in the \code{samples} argument. }
#'
#' @param id defines the ID of the statistic.
#' @param method defines the type of statistics/method for computing the
#' statistic.
#' @param samples defines a list of sample(s) (defined in the data model) to be
#' used by the statistic method.
#' @param par defines the parameter(s) of the method for computing the
#' statistic.
#' @seealso See Also \code{\link{AnalysisModel}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' # Analysis model
#' analysis.model = AnalysisModel() +
#'                  Test(id = "Placebo vs treatment",
#'                       samples = samples("Placebo", "Treatment"),
#'                       method = "TTest") +
#'                  Statistic(id = "Mean Treatment",
#'                            method = "MeanStat",
#'                            samples = samples("Treatment"))
#'
#' @export Statistic
Statistic = function(id, method, samples, par = NULL) {

  # Error checks
  if (!is.character(id)) stop("Statistic: ID must be character.")
  if (!is.character(method)) stop("Statistic: statistical method must be character.")
  if (!is.list(samples)) stop("Statistic: samples must be wrapped in a list.")
  if (any(lapply(samples, is.character) == FALSE)) stop("Statistic: samples must be character.")
  if (!is.null(par) & !is.list(par)) stop("MultAdj: par must be wrapped in a list.")

  statistic = list(id = id, method = method, samples = samples, par = par)

  class(statistic) = "Statistic"
  return(statistic)
  invisible(statistic)
}
