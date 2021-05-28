#' ExtractDataStack function
#'
#' This function extracts data stack according to the data scenario, sample id
#' and simulation run specified.
#'
#'
#' @param data.stack defines a \code{DataStack} object.
#' @param data.scenario defines the data scenario index to extract. By default
#' all data scenarios will be extracted.
#' @param sample.id defines the sample id to extract. By default all sample ids
#' will be extracted.
#' @param simulation.run defines the simulation run index. By default all
#' simulation runs will be extracted.
#' @return This function extract a particular set of data stack according to
#' the data scenario, sample id and simulation runs index. The object returned
#' by the function is a list having the same structure as the \code{data.set}
#' argument of a \code{DataStack} object: \item{data.set }{a list of size
#' corresponding to the number of simulation runs specified by the user defined
#' in the \code{simulation.run} argument. This list contains the data generated
#' for each data scenario (\code{data.scenario} argument) and each sample
#' specified by the user (\code{sample.id} argument).}
#' @seealso See Also \code{\link{DataStack}}.
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
#'   case.study1.data.stack$data.set[[100]]$data.scenario[[2]]$sample
#'
#'   # Extract the same set of data
#'   case.study1.extracted.data.stack = ExtractDataStack(data.stack = case.study1.data.stack,
#'                                                       data.scenario = 2,
#'                                                       simulation.run = 100)
#'
#'   # A carefull attention should be paid on the index of the result.
#'   # As only one data.scenario has been requested
#'   # the result for data.scenario = 2 is now in the first position (data.scenario[[1]]).
#' }
#'
#'
#' @export ExtractDataStack
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
