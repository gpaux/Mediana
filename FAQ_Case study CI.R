library(Mediana)

###################################################################
# Case study sample size
# Clinical trial in patients with pulmonary arterial hypertension
###################################################################

# Outcome parameter set 1
outcome1.placebo = parameters(mean = 0, sd = 70)
outcome1.treatment = parameters(mean = 40, sd = 70)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  SampleSize(seq(55,75,5)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome1.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome1.treatment))

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
case.study1.sim.parameters = SimParameters(n.sims = 10000,
                                           proc.load = "full",
                                           seed = 42938001)

# Perform clinical scenario evaluation
case.study1.results = CSE(case.study1.data.model,
                          case.study1.analysis.model,
                          case.study1.evaluation.model,
                          case.study1.sim.parameters)

# Print the simulation results
summary(case.study1.results)

############################################################################################################################
# Function: PowerConfidenceInterval
# Argument: CSE (object returned by the CSE function) and ci (level of the ci)
# Description: Compute binomial confidence interval based on normal approximation.
PowerConfidenceInterval = function(CSE, ci) {

  # Error check
  if (class(CSE) != "CSE") stop("PowerConfidenceInterval: a CSE object must be used in the CSE argument.")
  results = CSE$simulation.results
  n.sims = CSE$sim.parameters$n.sims

  if (ci <= 0 | ci >=1) stop("PowerConfidenceInterval: ci parameter must lies between 0 and 1.")

  q = qnorm(1-(1-ci)/2)
  power = results$result


  ci_l = pmax(0, round(power - q * sqrt(power* (1 - power) / n.sims), nchar(n.sims)))
  ci_u = pmin(1, round(power + q * sqrt(power* (1 - power) / n.sims), nchar(n.sims)))

  CSE$simulation.results = cbind(results,
                                 ci_l = ci_l,
                                 ci_u = ci_u)
  return(CSE)

}
# End of PowerConfidenceInterval

# Compute 95% confidence interval
case.study1.results = PowerConfidenceInterval(CSE = case.study1.results,
                                              ci = 0.95)
summary(case.study1.results)
