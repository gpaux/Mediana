#' ExtractAnalysisStack function
#'
#' This function extracts data stack according to the data scenario, sample id
#' and simulation run specified.
#'
#'
#' @param analysis.stack defines a \code{AnalysisStack} object.
#' @param data.scenario defines the data scenario index to extract. By default
#' all data scenarios will be extracted.
#' @param simulation.run defines the simulation run index. By default all
#' simulation runs will be extracted.
#' @return This function extract a particular set of analysis stack according
#' to the data scenario and simulation runs index. The object returned by the
#' function is a list having the same structure as the \code{analysis.set}
#' argument of a \code{AnalysisStack} object: \item{analysis.set }{a list of
#' size corresponding to the index number of simulation runs specified by the
#' user defined in the \code{simulation.run} argument. This list contains the
#' results generated for each data scenario (\code{data.scenario} argument).}
#' @seealso See Also \code{\link{AnalysisStack}}.
#' @references http://gpaux.github.io/Mediana/
#' @examples
#'
#' \dontrun{
#' # Generation of an AnalysisStack object
#' ##################################
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
#' case.study1.data.model = DataModel() +
#'   OutcomeDist(outcome.dist = "NormalDist") +
#'   SampleSize(c(50, 55, 60, 65, 70)) +
#'   Sample(id = "Placebo",
#'          outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
#'   Sample(id = "Treatment",
#'          outcome.par = parameters(outcome1.treatment, outcome2.treatment))
#'
#' # Analysis model
#' case.study1.analysis.model = AnalysisModel() +
#'   Test(id = "Placebo vs treatment",
#'        samples = samples("Placebo", "Treatment"),
#'        method = "TTest") +
#'   Statistic(id = "Mean Treatment",
#'             method = "MeanStat",
#'             samples = samples("Treatment"))
#'
#'
#' # Simulation Parameters
#' case.study1.sim.parameters = SimParameters(n.sims = 1000,
#'                                            proc.load = 2,
#'                                            seed = 42938001)
#'
#' # Generate data
#' case.study1.analysis.stack = AnalysisStack(data.model = case.study1.data.model,
#'                                            analysis.model = case.study1.analysis.model,
#'                                            sim.parameters = case.study1.sim.parameters)
#'
#' # Print the analysis results generated in the 100th simulation run
#' # for the 2nd data scenario for both samples
#' case.study1.analysis.stack$analysis.set[[100]][[2]]
#'
#' # Extract the same set of data
#' case.study1.extracted.analysis.stack =
#'   ExtractAnalysisStack(analysis.stack = case.study1.analysis.stack,
#'                        data.scenario = 2,
#'                        simulation.run = 100)
#'
#' # A carefull attention should be paid on the index of the result.
#' # As only one data.scenario has been requested
#' # the result for data.scenario = 2 is now in the first position ($analysis.set[[1]][[1]]).
#' }
#'
#'
#' @export ExtractAnalysisStack
ExtractAnalysisStack = function(analysis.stack, data.scenario = NULL, simulation.run = NULL){

  # Add error checks
  # Check class of analysis stack
  if (class(analysis.stack)!="AnalysisStack") stop("ExtractAnalysisStack: an AnalysisStack object must be specified in the analysis.stack argument")
  # Check if the number defined in the data.scenario exists in the analysis.stack$analysis.scenario.grid
  if (!is.null(data.scenario) & any(!(data.scenario %in% 1:nrow(analysis.stack$analysis.scenario.grid)))) stop(paste0("ExtractAnalysisStack: the specified data.scenario does not exist (",nrow(analysis.stack$analysis.scenario.grid)," analysis scenarios have been specified in the AnalysisModel)."))
  # Check if simulatin run exists
  if (!is.null(simulation.run) & any(!(simulation.run %in% 1:length(analysis.stack$analysis.set)))) stop(paste0("ExtractAnalysisStack: the specified simulation.runs does not exist (",length(analysis.stack$analysis.set)," simulation runs have been performed)."))

  # Get the simulation index specified by the user
  # If null, all simulation runs are selected
  if (is.null(simulation.run)) simularion.run.index = 1:analysis.stack$sim.parameters$n.sims
  else simularion.run.index = simulation.run

  # Get the data.scenario specified by the user
  if (is.null(data.scenario)) data.scenario.index = 1:nrow(analysis.stack$analysis.scenario.grid)
  else data.scenario.index = data.scenario

  # Create the list containing the requested analysis.stack
  analysis.stack.temp = list()
  analysis.stack.temp$analysis.set = lapply(analysis.stack$analysis.set[simularion.run.index], function(x) x[data.scenario.index])

  return(analysis.stack.temp)
}
