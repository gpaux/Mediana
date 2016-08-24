############################################################################################################################

# Function: GenerateData
# Argument: ....
# Description: This function generate data according to the data model
#' @export
GenerateData.default = function(data.model, sim.parameters){

  # Check of class of the data.model and sim.parameters argument
  if (!(class(data.model) == ("DataModel"))) stop("GenerateData: a DataModel object must be specified in the data.model argument")
  if (!(class(sim.parameters) == c("SimParameters"))) stop("GenerateData: a SimParameters object must be specified in the sim.parameters argument")

  # Simulation parameters
  # Number of simulation runs
  if (is.null(sim.parameters$n.sims)) stop("GenerateData:The number of simulation runs must be provided (n.sims)")
  n.sims = sim.parameters$n.sims

  if (!is.numeric(n.sims))
    stop("GenerateData:Number of simulation runs must be an integer.")
  if (length(n.sims) > 1)
    stop("GenerateData: Number of simulation runs: Only one value must be specified.")
  if (n.sims%%1 != 0)
    stop("GenerateData: Number of simulation runs must be an integer.")
  if (n.sims <= 0)
    stop("GenerateData: Number of simulation runs must be positive.")

  # Seed
  if (is.null(sim.parameters$seed)) stop("The seed must be provided (seed)")
  seed = sim.parameters$seed

  if (!is.numeric(seed))
    stop("Seed must be an integer.")
  if (length(seed) > 1)
    stop("Seed: Only one value must be specified.")
  if (nchar(as.character(seed)) > 10)
    stop("Length of seed must be inferior to 10.")

  if (!is.null(sim.parameters$proc.load)){
    proc.load = sim.parameters$proc.load
    if (is.numeric(proc.load)){
      if (length(proc.load) > 1)
        stop("Number of cores: Only one value must be specified.")
      if (proc.load %%1 != 0)
        stop("Number of cores must be an integer.")
      if (proc.load <= 0)
        stop("Number of cores must be positive.")
      n.cores = proc.load
    }
    else if (is.character(proc.load)){
      n.cores=switch(proc.load,
                     low={1},
                     med={parallel::detectCores()/2},
                     high={parallel::detectCores()-1},
                     full={parallel::detectCores()},
                     {stop("Processor load not valid")})
    }
  } else n.cores = 1

  sim.parameters = list(n.sims = n.sims, seed = seed, proc.load = n.cores)

  
  # Simulation parameters
  # Use proc.load to generate the clusters
  cluster.mediana = parallel::makeCluster(getOption("cluster.mediana.cores", sim.parameters$proc.load))
  
  # To make this reproducible I used the same number as the seed
  set.seed(seed)
  parallel::clusterSetRNGStream(cluster.mediana, seed)
  
  #Export all functions in the global environment to each node
  parallel::clusterExport(cluster.mediana,ls(envir=.GlobalEnv))
  doParallel::registerDoParallel(cluster.mediana)
  
  # Simulation index initialisation
  sim.index=0

  # Generate the data
  data.stack.temp = foreach::foreach(sim.index=1:sim.parameters$n.sims, .packages=(.packages())) %dorng% {
    data = CreateDataStack(data.model = data.model, n.sims = 1)
    
  }
  
  # Stop the cluster
  parallel::stopCluster(cluster.mediana)
  #closeAllConnections()
  
  data.stack=list()
  data.stack$description= "data.stack"
  data.stack$data.set = lapply(data.stack.temp, function(x) x$data.set[[1]])
  data.stack$data.scenario.grid = data.stack.temp[[1]]$data.scenario.grid
  data.stack$data.structure = data.stack.temp[[1]]$data.structure
  data.stack$sim.parameters = sim.parameters
  class(data.stack) = "DataStack"

  return(data.stack)

}
