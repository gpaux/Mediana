library(Mediana)

###################################################################
# Case study resampling
# Clinical trial in patients with pulmonary arterial hypertension
###################################################################
# Custom function to sample from a pre-existing dataset
SamplingDist <- function(parameter){
  # Determine the function call, either to generate distribution or to return the distribution's description
  call = (parameter[[1]] == "description")
  
  # Generate random variables
  if (call == FALSE) {
    # The number of observations to generate
    n = parameter[[1]]
    
    ##############################################################
    # Distribution-specific component
    # Get the distribution's parameters (stored in the parameter[[2]] list)
    dataset = parameter[[2]]$dataset
    replace = parameter[[2]]$replace
    ##############################################################
    
    # Error checks (other checks could be added by the user if needed)
    if (n%%1 != 0)
      stop("Data model: SamplingDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: SamplingDist distribution: Number of observations must be positive.")
    
    # Error checks on replace
    if (!is.logical(replace))
      stop("Data model: SamplingDist distribution: replace argument must be TRUE or FALSE.")
    
    if (!replace & (n > length(dataset)))
      stop("Data model: SamplingDist distribution: replace cannot be set to FALSE if the sample size is greater than the data set length.")
    
    # Error checks on dataset
    if (!is.vector(dataset))
      stop("Data model: SamplingDist distribution: dataset argument must be vector of values to sample from.")
    
    ##############################################################
    # Distribution-specific component
    # Observations are sampled from the dataset
    result = sample(x = dataset, size = n, replace = replace)
    ##############################################################
    
  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      
      ##############################################################
      # Distribution-specific component
      # The labels of the distributional parameters and the distribution's label must be stored in the "result" list
      result = list(list(dataset = "dataset", replace = "replace"),
                    list("SamplingDist"))
      ##############################################################
      
    }
  }
  return(result)
}

# Pre-existing dataset (for the purpose of illustration we will generate this pre-existing dataset)
# Treatment arm
# Three phase II data have been collected on 3 distinct trials with respectively 75, 75 and 50 patients per arm
# The observed mean and sd are used to generate the pre-existing datasets
set.seed(123456789)
treatment_PhaseII_data1 = data.frame(trt = rep(1,75),
                                     y = rnorm(75, mean = 40, sd = 68))
treatment_PhaseII_data2 = data.frame(trt = rep(1,75),
                                     y = rnorm(75, mean = 35, sd = 62))
treatment_PhaseII_data3 = data.frame(trt = rep(1,50),
                                     y = rnorm(50, mean = 42, sd = 74))
treatment_PhaseII_data = rbind(treatment_PhaseII_data1, 
                               treatment_PhaseII_data2,
                               treatment_PhaseII_data3)

outcome.treatment = parameters(dataset = treatment_PhaseII_data$y,
                               replace = TRUE)
# Control arm
# A pool of data for the control arm is available with 3000 patients
# The observed mean and sd are used to generate the pool of data
control_data = data.frame(trt = rep(2,3000),
                          y = rnorm(3000, mean = 0, sd = 70))

outcome.control = parameters(dataset = control_data$y,
                             replace = TRUE)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "SamplingDist") +
  SampleSize(seq(40,70,10)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.control)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome.treatment))

# Get the data generated in the CSE (only 10 first simulations)
case.study1.data.stack = DataStack(data.model = case.study1.data.model,
                                   sim.parameters = SimParameters(n.sims = 10,
                                                                  proc.load = "full",
                                                                  seed = 42938001))

# Get the data from simulation number 2
ExtractDataStack(data.stack = case.study1.data.stack, 
                 simulation.run = 2)

# Analysis model
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "TTest")

# Evaluation model
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))

# Simulation Parameters
case.study1.sim.parameters = SimParameters(n.sims = 1000,
                                           proc.load = "full",
                                           seed = 42938001)

# Perform clinical scenario evaluation
case.study1.results = CSE(case.study1.data.model,
                          case.study1.analysis.model,
                          case.study1.evaluation.model,
                          case.study1.sim.parameters)

# Print the simulation results
summary(case.study1.results)
