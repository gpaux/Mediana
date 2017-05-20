# Load the Mediana R package
library(Mediana)

# Correlation between two endpoints
corr.matrix = matrix(c(1.0, 0.5,
                       0.5, 1.0), 2, 2)

# Outcome parameters - Scenario 1
outcome.placebo.sc1 = parameters(par = parameters(parameters(mean = -12, sd = 20),
                                                  parameters(mean = -0.8, sd = 1)),
                                 corr = corr.matrix)

outcome.dosel.sc1 = parameters(par = parameters(parameters(mean = -18, sd = 20),
                                                parameters(mean = -1.1, sd = 1)),
                               corr = corr.matrix)

outcome.doseh.sc1 = parameters(par = parameters(parameters(mean = -20, sd = 20),
                                                parameters(mean = -1.1, sd = 1)),
                               corr = corr.matrix)

# Outcome parameters - Scenario 2
outcome.placebo.sc2 = parameters(par = parameters(parameters(mean = -12, sd = 20),
                                                  parameters(mean = -0.8, sd = 1)),
                                 corr = corr.matrix)

outcome.dosel.sc2 = parameters(par = parameters(parameters(mean = -18, sd = 20),
                                                parameters(mean = -1.1, sd = 1)),
                               corr = corr.matrix)

outcome.doseh.sc2 = parameters(par = parameters(parameters(mean = -18, sd = 20),
                                                parameters(mean = -1.1, sd = 1)),
                               corr = corr.matrix)

# Outcome parameters - Scenario 3
outcome.placebo.sc3 = parameters(par = parameters(parameters(mean = -12, sd = 20),
                                                  parameters(mean = -0.8, sd = 1)),
                                 corr = corr.matrix)

outcome.dosel.sc3 = parameters(par = parameters(parameters(mean = -18, sd = 20),
                                                parameters(mean = -1.2, sd = 1)),
                               corr = corr.matrix)

outcome.doseh.sc3 = parameters(par = parameters(parameters(mean = -20, sd = 20),
                                                parameters(mean = -1.2, sd = 1)),
                               corr = corr.matrix)

# Outcome parameters - Scenario 4
outcome.placebo.sc4 = parameters(par = parameters(parameters(mean = -12, sd = 20),
                                                  parameters(mean = -1.2, sd = 1)),
                                 corr = corr.matrix)

outcome.dosel.sc4 = parameters(par = parameters(parameters(mean = -18, sd = 20),
                                                parameters(mean = -1.2, sd = 1)),
                               corr = corr.matrix)

outcome.doseh.sc4 = parameters(par = parameters(parameters(mean = -18, sd = 20),
                                                parameters(mean = -1.2, sd = 1)),
                               corr = corr.matrix)

# Data model
mult.cs2.data.model = DataModel() +
  OutcomeDist(outcome.dist = "MVNormalDist") +
  Sample(id = c("Placebo - E1", "Placebo - E2"),
         outcome.par = parameters(outcome.placebo.sc1, 
                                  outcome.placebo.sc2, 
                                  outcome.placebo.sc3,
                                  outcome.placebo.sc4),
         sample.size = 100) +
  Sample(id = c("Dose L - E1", "Dose L - E2"),
         outcome.par = parameters(outcome.dosel.sc1, 
                                  outcome.dosel.sc2, 
                                  outcome.dosel.sc3,
                                  outcome.dosel.sc4),
         sample.size = 200) +
  Sample(id = c("Dose H - E1", "Dose H - E2"),
         outcome.par = parameters(outcome.doseh.sc1, 
                                  outcome.doseh.sc2, 
                                  outcome.doseh.sc3,
                                  outcome.doseh.sc4),
         sample.size = 200)

# Analysis model
# Parameters of the Procedure B1
# Vector of hypothesis weights
chain.weight = c(1, 0, 0, 0)

# Matrix of transition parameters
chain.transition = matrix(c(0, 0.8, 0.2, 0,
                            0, 0, 0, 1,
                            0, 0, 0, 0,
                            0, 0, 0, 0), 4, 4, byrow = TRUE)

# MultAdjProc
mult.adj1 = MultAdjProc(proc = "ChainAdj",
                        par = parameters(weight = chain.weight,
                                         transition = chain.transition))



# Parameters of the Procedure B2
# Vector of hypothesis weights
chain.weight = c(1, 0, 0, 0)

# Matrix of transition parameters
chain.transition = matrix(c(0, 1, 0, 0,
                            0, 0, 0, 1 ,
                            0, 1, 0, 0,
                            0, 0, 1, 0), 4, 4, byrow = TRUE)

# MultAdjProc
mult.adj2 = MultAdjProc(proc = "ChainAdj",
                        par = parameters(weight = chain.weight,
                                         transition = chain.transition))


mult.cs2.analysis.model = 
  AnalysisModel() +
  MultAdj(mult.adj1,mult.adj2) +
  Test(id = "Placebo vs Dose H - E1",
       samples = samples("Dose H - E1", "Placebo - E1"),
       method = "TTest") +
  Test(id = "Placebo vs Dose L - E1",
       samples = samples("Dose L - E1", "Placebo - E1"),
       method = "TTest") +
  Test(id = "Placebo vs Dose H - E2",
       samples = samples("Dose H - E2", "Placebo - E2"),
       method = "TTest") +
  Test(id = "Placebo vs Dose L - E2",
       samples = samples("Dose L - E2", "Placebo - E2"),
       method = "TTest")

# Evaluation model 
# Custom evaluation criterion: Subset disjunctive power
mult.cs2.SubsetDisjunctivePower = function(test.result, statistic.result, parameter) {
  
  alpha = parameter$alpha
  
  # Outcome: Reject (H1 or H2) and (H3 or H4)
  power = mean(((test.result[,1] <= alpha) | (test.result[,2] <= alpha)) & 
                 ((test.result[,3] <= alpha) | (test.result[,4] <= alpha)))
  
  return(power)
}
# Custom evaluation criterion: Partition-based weighted power
mult.cs2.PartitionBasedWeightedPower = function(test.result, statistic.result, parameter) {
  
  # Parameters
  alpha = parameter$alpha
  weight = parameter$weight
  
  # Outcomes
  # Outcome1: reject exactly one hypothesis in the primary family
  outcome1 = ((test.result[,1] <= alpha) + (test.result[,2] <= alpha)) == 1
  # Outcome2: reject both hypotheses in the primary family and less than two in the secondary family
  outcome2 = (((test.result[,1] <= alpha) + (test.result[,2] <= alpha)) == 2) &  
    (((test.result[,3] <= alpha) + (test.result[,4] <= alpha)) <= 1)
  # Outcome3: reject both hypotheses in the primary and secondary families
  outcome3 = ((test.result[,1] <= alpha) & (test.result[,2] <= alpha) & (test.result[,3] <= alpha) & (test.result[,4] <= alpha))
  
  # Weighted power
  power = mean(outcome1) * weight[1] + mean(outcome2) * weight[2] + mean(outcome3) * weight[3] 
  
  return(power)
}

mult.cs2.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1", 
                          "Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = c("Placebo vs Dose H - E1", 
                       "Placebo vs Dose L - E1", 
                       "Placebo vs Dose H - E2", 
                       "Placebo vs Dose L - E2"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1", 
                          "Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Subset Disjunctive power",
            method = "mult.cs2.SubsetDisjunctivePower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1", 
                          "Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Subset Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Weighted power",
            method = "WeightedPower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1", 
                          "Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Weighted power (v1 = 0.4, v2 = 0.4, v3 = 0.1, v4 = 0.1)",
            par = parameters(alpha = 0.025, 
                             weight = c(0.4, 0.4, 0.1, 0.1))) +
  Criterion(id = "Partition-based weighted power",
            method = "mult.cs2.PartitionBasedWeightedPower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1", 
                          "Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Partition-based weighted power (v1 = 0.20, v2 = 0.35, v3 = 0.45)",
            par = parameters(alpha = 0.025, 
                             weight = c(0.20, 0.35, 0.45)))


# Simulation Parameters
mult.cs2.sim.parameters =  SimParameters(n.sims = 100000,
                                         proc.load = "full",
                                         seed = 42938001)

# Perform clinical scenario evaluation
mult.cs2.results = CSE(mult.cs2.data.model,
                       mult.cs2.analysis.model,
                       mult.cs2.evaluation.model,
                       mult.cs2.sim.parameters)

# Summary of results
summary(mult.cs2.results)

# Presentation Model
mult.cs2.presentation.model = PresentationModel() +
  Project(username = "Gautier Paux",
          title = "Case study 2",
          description = "Simulation report for case study 2 of the Clinical Trials with Multiple Objectives chapter") +
  Section(by = "outcome.parameter") +
  Table(by = "multiplicity.adjustment") +
  CustomLabel(param = "multiplicity.adjustment",
              label= c("Procedure B1", "Procedure B2")) +
  CustomLabel(param = "outcome.parameter",
              label=c("Scenario 1", "Scenario 2", "Scenario 3", "Scenario 4"))

# Generate Word-based report
GenerateReport(presentation.model = mult.cs2.presentation.model,
               cse.results = mult.cs2.results,
               report.filename = "mult-cs2-report.docx")

