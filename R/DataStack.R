#' DataStack object
#'
#' This function generates data according to the specified data model.
#'
#'
#' @param data.model defines a \code{DataModel} object.
#' @param sim.parameters defines a \code{SimParameters} object.
#' @return This function generates a data stack according to the data model and
#' the simulation parameters objetcs. The object returned by the function is a
#' DataStack object containing: \item{description }{a description of the
#' object.} \item{data.set }{a list of size \code{n.sims} defined in the
#' \code{sim.parameters} object. This list contains the data generated for each
#' data scenario (\code{data.scenario} level) and each sample (\code{sample}
#' level). The data generated for the \code{i}th simulation runs, the
#' \code{j}th data scenario and the \code{k}th sample is stored in
#' \code{data.stack$data.set[[i]]$data.scenario[[j]]$sample[[k]]} where
#' \code{data.stack} is a \code{DataStack} object.} \item{data.scenario.grid
#' }{a data frame indicating all data scenarios according to the
#' \code{DataModel} object.} \item{data.structure }{a list containing the data
#' structure according to the \code{DataModel} object.} \item{sim.parameters
#' }{a list containing the simulation parameters according to
#' \code{SimParameters} object.}
#'
#' A specific \code{data.set} of a \code{DataStack} object can be extracted
#' using the \code{ExtractDataStack} function.
#' @seealso See Also \code{\link{DataModel}} and \code{\link{SimParameters}}
#' and \code{\link{ExtractDataStack}}.
#' @references http://gpaux.github.io/Mediana/
#' @examples
#'
#' \dontrun{
#'   # Generation of a DataStack object
#'   ##################################
#'
#'   # Outcome parameter set 1
#'   outcome1.placebo = parameters(mean = 0, sd = 70)
#'   outcome1.treatment = parameters(mean = 40, sd = 70)
#'
#'   # Outcome parameter set 2
#'   outcome2.placebo = parameters(mean = 0, sd = 70)
#'   outcome2.treatment = parameters(mean = 50, sd = 70)
#'
#'   # Data model
#'   case.study1.data.model = DataModel() +
#'     OutcomeDist(outcome.dist = "NormalDist") +
#'     SampleSize(c(50, 55, 60, 65, 70)) +
#'     Sample(id = "Placebo",
#'            outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
#'     Sample(id = "Treatment",
#'            outcome.par = parameters(outcome1.treatment, outcome2.treatment))
#'
#'
#'   # Simulation Parameters
#'   case.study1.sim.parameters = SimParameters(n.sims = 1000,
#'                                              proc.load = 2,
#'                                              seed = 42938001)
#'
#'   # Generate data
#'   case.study1.data.stack = DataStack(data.model = case.study1.data.model,
#'                                      sim.parameters = case.study1.sim.parameters)
#'
#'   # Print the data set generated in the 100th simulation run
#'   # for the 2nd data scenario for both samples
#'   case.study1.data.stack$data.set[[100]]$data.scenario[[2]]
#'
#'   # Extract the same set of data
#'   case.study1.extracted.data.stack = ExtractDataStack(data.stack = case.study1.data.stack,
#'                                                       data.scenario = 2,
#'                                                       simulation.run = 100)
#'   # The same dataset can be obtained using
#'   case.study1.extracted.data.stack$data.set[[1]]$data.scenario[[1]]$sample
#'   # A carefull attention should be paid on the index of the result.
#'   # As only one data.scenario has been requested
#'   # the result for data.scenario = 2 is now in the first position (data.scenario[[1]]).
#' }
#'
#'
#' \dontrun{
#'   #Use of a DataStack object in the CSE function
#'   ##############################################
#'
#'   # Outcome parameter set 1
#'   outcome1.placebo = parameters(mean = 0, sd = 70)
#'   outcome1.treatment = parameters(mean = 40, sd = 70)
#'
#'   # Outcome parameter set 2
#'   outcome2.placebo = parameters(mean = 0, sd = 70)
#'   outcome2.treatment = parameters(mean = 50, sd = 70)
#'
#'   # Data model
#'   case.study1.data.model = DataModel() +
#'     OutcomeDist(outcome.dist = "NormalDist") +
#'     SampleSize(c(50, 55, 60, 65, 70)) +
#'     Sample(id = "Placebo",
#'            outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
#'     Sample(id = "Treatment",
#'            outcome.par = parameters(outcome1.treatment, outcome2.treatment))
#'
#'
#'   # Simulation Parameters
#'   case.study1.sim.parameters = SimParameters(n.sims = 1000,
#'                                              proc.load = 2,
#'                                              seed = 42938001)
#'
#'   # Generate data
#'   case.study1.data.stack = DataStack(data.model = case.study1.data.model,
#'                                      sim.parameters = case.study1.sim.parameters)
#'
#'   # Analysis model
#'   case.study1.analysis.model = AnalysisModel() +
#'     Test(id = "Placebo vs treatment",
#'          samples = samples("Placebo", "Treatment"),
#'          method = "TTest")
#'
#'   # Evaluation model
#'   case.study1.evaluation.model = EvaluationModel() +
#'     Criterion(id = "Marginal power",
#'               method = "MarginalPower",
#'               tests = tests("Placebo vs treatment"),
#'               labels = c("Placebo vs treatment"),
#'               par = parameters(alpha = 0.025))
#'
#'   # Simulation Parameters
#'   case.study1.sim.parameters = SimParameters(n.sims = 1000, proc.load = 2, seed = 42938001)
#'
#'   # Perform clinical scenario evaluation
#'   case.study1.results = CSE(case.study1.data.stack,
#'                             case.study1.analysis.model,
#'                             case.study1.evaluation.model,
#'                             case.study1.sim.parameters)
#' }
#'
#' @export DataStack
DataStack = function(data.model, sim.parameters) {
  UseMethod("DataStack")
}
