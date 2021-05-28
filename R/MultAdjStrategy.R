#' MultAdjStrategy object
#'
#' This function creates an object of class \code{MultAdjStrategy} which can be
#' added to objects of class \code{AnalysisModel}, \code{MultAdj} or
#' \code{MultAdjStrategy}.
#'
#' This function can be used when several multiplicity adjustment procedures
#' are used within a single Clinical Scenario Evaluation, for example when
#' several case studies are simulated into the same Clinical Scenario
#' Evaluation.
#'
#' Objects of class \code{MultAdjStrategy} are used in objects of class
#' \code{AnalysisModel} to define a Multiplicity Adjustment Procedure Strategy
#' that will be applied to the statistical tests to protect the overall Type I
#' error rate. Several objects of class \code{MultAdjStrategy} can be added to
#' an object of class \code{AnalysisModel}, using the '+' operator or by
#' grouping them into a \code{MultAdj} object.
#'
#' @param \dots defines an object of class \code{MultAdjProc}.
#' @seealso See Also \code{\link{MultAdj}}, \code{\link{MultAdjProc}} and
#' \code{\link{AnalysisModel}}.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @examples
#'
#' # Parallel gatekeeping procedure parameters
#' family = families(family1 = c(1), family2 = c(2, 3))
#' component.procedure = families(family1 ="HolmAdj", family2 = "HolmAdj")
#' gamma = families(family1 = 1, family2 = 1)
#'
#' # Multiple sequence gatekeeping procedure parameters for Trial A
#' mult.adj.trialA = MultAdjProc(proc = "ParallelGatekeepingAdj",
#'                               par = parameters(family = family,
#'                                                proc = component.procedure,
#'                                                gamma = gamma),
#'                               tests = tests("Trial A Pla vs Trt End1",
#'                                             "Trial A Pla vs Trt End2",
#'                                             "Trial A Pla vs Trt End3")
#' )
#'
#' mult.adj.trialB = MultAdjProc(proc = "ParallelGatekeepingAdj",
#'                               par = parameters(family = family,
#'                                                proc = component.procedure,
#'                                                gamma = gamma),
#'                               tests = tests("Trial B Pla vs Trt End1",
#'                                             "Trial B Pla vs Trt End2",
#'                                             "Trial B Pla vs Trt End3")
#' )
#'
#' mult.adj.pooled = MultAdjProc(proc = "ParallelGatekeepingAdj",
#'                               par = parameters(family = family,
#'                                                proc = component.procedure,
#'                                                gamma = gamma),
#'                               tests = tests("Pooled Pla vs Trt End1",
#'                                             "Pooled Pla vs Trt End2",
#'                                             "Pooled Pla vs Trt End3")
#' )
#'
#' # Analysis model
#' analysis.model = AnalysisModel() +
#'   MultAdjStrategy(mult.adj.trialA, mult.adj.trialB, mult.adj.pooled) +
#'   # Tests for study A
#'   Test(id = "Trial A Pla vs Trt End1",
#'        method = "PropTest",
#'        samples = samples("Trial A Plac End1", "Trial A Trt End1")) +
#'   Test(id = "Trial A Pla vs Trt End2",
#'        method = "TTest",
#'        samples = samples("Trial A Plac End2", "Trial A Trt End2")) +
#'   Test(id = "Trial A Pla vs Trt End3",
#'        method = "TTest",
#'        samples = samples("Trial A Plac End3", "Trial A Trt End3")) +
#'   # Tests for study B
#'   Test(id = "Trial B Pla vs Trt End1",
#'        method = "PropTest",
#'        samples = samples("Trial B Plac End1", "Trial B Trt End1")) +
#'   Test(id = "Trial B Pla vs Trt End2",
#'        method = "TTest",
#'        samples = samples("Trial B Plac End2", "Trial B Trt End2")) +
#'   Test(id = "Trial B Pla vs Trt End3",
#'        method = "TTest",
#'        samples = samples("Trial B Plac End3", "Trial B Trt End3")) +
#'   # Tests for pooled studies
#'   Test(id = "Pooled Pla vs Trt End1",
#'        method  = "PropTest",
#'        samples = samples(samples("Trial A Plac End1","Trial B Plac End1"),
#'                          samples("Trial A Trt End1","Trial B Trt End1"))) +
#'   Test(id = "Pooled Pla vs Trt End2",
#'        method  = "TTest",
#'        samples = samples(samples("Trial A Plac End2","Trial B Plac End2"),
#'                          samples("Trial A Trt End2","Trial B Trt End2"))) +
#'   Test(id = "Pooled Pla vs Trt End3",
#'        method  = "TTest",
#'        samples = samples(samples("Trial A Plac End3","Trial B Plac End3"),
#'                          samples("Trial A Trt End3","Trial B Trt End3")))
#'
#' @export MultAdjStrategy
MultAdjStrategy = function(...) {
  UseMethod("MultAdjStrategy")
}
