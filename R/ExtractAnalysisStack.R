############################################################################################################################

# Function: ExtractAnalysisStack
# Argument: Analysis stack, data.scenario, simulation.run
# Description: This function extract the specified results according to the data scenario and simulation run
# specified by the user.
#' @export

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
