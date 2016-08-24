############################################################################################################################

# Function: ExtractDataStack
# Argument: Data stack, data.scenario, sample.id and simulation.run
# Description: This function extract the specified datasets according to the data scenario, sample id and simulation run
# specified by the user.
#' @export

ExtractDataStack = function(data.stack, data.scenario = NULL, sample.id = NULL, simulation.run = NULL){

  # Add error checks
  # Check class of data stack
  if (class(data.stack)!="DataStack") stop("ExtractDataStack: a DataStack object must be specified in the data.stack argument")
  # Check if the number defined in the data.scenario exists in the data.stack$data.scenario.grid
  if (!is.null(data.scenario) & any(!(data.scenario %in% 1:nrow(data.stack$data.scenario.grid)))) stop(paste0("ExtractDataStack: the specified data.scenario does not exist (",nrow(data.stack$data.scenario.grid)," data scenarios have been specified in the DataModel)."))
  # Check if sample is defined in the data structure
  if (!is.null(sample.id) & any(!(sample.id %in% unlist(data.stack$data.structure$id)))) stop(paste0("ExtractDataStack: the specified sample.id does not exist (the sample id ", paste0(unlist(data.stack$data.structure$id), collapse = ", ")," have been specified in the DataModel)."))
  # Check if simulatin run exists
  if (!is.null(simulation.run) & any(!(simulation.run %in% 1:length(data.stack$data.set)))) stop(paste0("ExtractDataStack: the specified simulation.runs does not exist (",length(data.stack$data.set)," simulation runs have been performed)."))

  # Get the simulation index specified by the user
  # If null, all simulation runs are selected
  if (is.null(simulation.run)) simularion.run.index = 1:data.stack$sim.parameters$n.sims
  else simularion.run.index = simulation.run

  # Get the data.scenario specified by the user
  if (is.null(data.scenario)) data.scenario.index = 1:nrow(data.stack$data.scenario.grid)
  else data.scenario.index = data.scenario

  # Get the sample.id specified by the user
  if (is.null(sample.id)) sample.id.index = 1:length(unlist(data.stack$data.structure$id))
  else sample.id.index = which(unlist(data.stack$data.structure$id) %in% sample.id)

  # Create the list containing the requested data.stack
  data.stack.temp = list()
  data.stack.temp$data.set = lapply(data.stack$data.set[simularion.run.index], function(x) {
    y = list()
    y$data.scenario = lapply(x$data.scenario[data.scenario.index], function(y){
      z=list()
      z$sample = y$sample[sample.id.index]
      return(z)
    })
    return(y)
  })

  return(data.stack.temp)
}
