# Load the Mediana R package
library(Mediana)

# Outcome parameters - Scenario 1
outcome.placebo.sc1 = parameters(prop = 0.30)
outcome.dosel.sc1 = parameters(prop = 0.50)
outcome.doseh.sc1 = parameters(prop = 0.50)

# Outcome parameters - Scenario 2
outcome.placebo.sc2 = parameters(prop = 0.30)
outcome.dosel.sc2 = parameters(prop = 0.40)
outcome.doseh.sc2 = parameters(prop = 0.50)

# Outcome parameters - Scenario 3
outcome.placebo.sc3 = parameters(prop = 0.30)
outcome.dosel.sc3 = parameters(prop = 0.50)
outcome.doseh.sc3 = parameters(prop = 0.45)

# Data model
mult.cs1.data.model = 
  DataModel() +
  OutcomeDist(outcome.dist = "BinomDist") +
  SampleSize(100) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.placebo.sc1, 
                                  outcome.placebo.sc2, 
                                  outcome.placebo.sc3)) +
  Sample(id = "Dose L",
         outcome.par = parameters(outcome.dosel.sc1, 
                                  outcome.dosel.sc2, 
                                  outcome.dosel.sc3)) +
  Sample(id = "Dose H",
         outcome.par = parameters(outcome.doseh.sc1, 
                                  outcome.doseh.sc2, 
                                  outcome.doseh.sc3))

# Analysis model
mult.cs1.analysis.model = AnalysisModel() +
  MultAdjProc(proc = NA) +
  MultAdjProc(proc = "FixedSeqAdj") +
  MultAdjProc(proc = "HochbergAdj") +
  Test(id = "Placebo vs Dose H",
       samples = samples("Placebo", "Dose H"),
       method = "PropTest") +
  Test(id = "Placebo vs Dose L",
       samples = samples("Placebo", "Dose L"),
       method = "PropTest")

# Evaluation model
# Custom evaluation criterion: Partition-based weighted power
mult.cs1.PartitionBasedWeightedPower = function(test.result, statistic.result, parameter) {
  
  # Parameters
  alpha = parameter$alpha
  weight = parameter$weight
  
  # Outcomes
  H1_only = ((test.result[,1] <= alpha) & (test.result[,2] > alpha))
  H2_only = ((test.result[,1] > alpha) & (test.result[,2] <= alpha))
  H1_H2 = ((test.result[,1] <= alpha) & (test.result[,2] <= alpha))
  
  # Weighted power
  power = mean(H1_only) * weight[1] + mean(H2_only) * weight[2] + mean(H1_H2) * weight[3] 
  
  return(power)
}


mult.cs1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs Dose H",
                          "Placebo vs Dose L"),
            labels = c("Placebo vs Dose H",
                       "Placebo vs Dose L"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("Placebo vs Dose H",
                          "Placebo vs Dose L"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Weighted power",
            method = "WeightedPower",
            tests = tests("Placebo vs Dose H",
                          "Placebo vs Dose L"),
            labels = "Weighted power (v1 = 0.4, v2 = 0.6)",
            par = parameters(alpha = 0.025, 
                             weight = c(0.4, 0.6))) +
  Criterion(id = "Partition-based weighted power",
            method = "mult.cs1.PartitionBasedWeightedPower",
            tests = tests("Placebo vs Dose H",
                          "Placebo vs Dose L"),
            labels = "Partition-based weighted power (v1 = 0.15, v2 = 0.25, v12 = 0.6)",
            par = parameters(alpha = 0.025, 
                             weight = c(0.15, 0.25, 0.6)))

# Simulation Parameters
mult.cs1.sim.parameters =  SimParameters(n.sims = 100000,
                                         proc.load = "full",
                                         seed = 42938001)

# Perform clinical scenario evaluation
mult.cs1.results = CSE(mult.cs1.data.model,
                       mult.cs1.analysis.model,
                       mult.cs1.evaluation.model,
                       mult.cs1.sim.parameters)

# Summary of results
summary(mult.cs1.results)

# Presentation Model
mult.cs1.presentation.model = PresentationModel() +
  Project(username = "Gautier Paux",
          title = "Case study 1",
          description = "Simulation report for case study 1 of the Clinical Trials with Multiple Objectives chapter") +
  Section(by = "outcome.parameter") +
  Table(by = "multiplicity.adjustment") +
  CustomLabel(param = "multiplicity.adjustment",
              label= c("No adjustment", "Procedure F", "Procedure H")) +
  CustomLabel(param = "outcome.parameter",
              label=c("Scenario 1", "Scenario 2", "Scenario 3"))

# Generate Word-based report
GenerateReport(presentation.model = mult.cs1.presentation.model,
               cse.results = mult.cs1.results,
               report.filename = "mult-cs1-report.docx")
