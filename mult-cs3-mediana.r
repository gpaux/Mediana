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
mult.cs3.data.model = DataModel() +
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

# Parameters of the Hochberg-based gatekeeping procedure 
family = families(family1 = c(1, 2), 
                  family2 = c(3, 4))

component.procedure = families(family1="HochbergAdj", 
                               family2="HochbergAdj")

gamma = families(family1 = 0.9, 
                 family2 = 1)

mult.adj = 
  MultAdjProc(proc = "MultipleSequenceGatekeepingAdj",
              par = parameters(family = family, 
                               proc = component.procedure,
                               gamma = gamma),
              tests = tests("Placebo vs Dose H - E1", 
                            "Placebo vs Dose L - E1", 
                            "Placebo vs Dose H - E2",
                            "Placebo vs Dose L - E2"))

# Analysis model
mult.cs3.analysis.model = AnalysisModel() +
  mult.adj +
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

# Custom evaluation criterion: Tradeoff-based disjunctive criterion
mult.cs3.TradeoffDisjunctivePower = function(test.result, statistic.result, parameter) {
  
  alpha = parameter$alpha
  weight = parameter$weight
  
  family1 = ((test.result[,1] <= alpha) | (test.result[,2] <= alpha))
  family2 = ((test.result[,3] <= alpha) | (test.result[,4] <= alpha))
  
  power = weight[1] * mean(family1) + weight[2] * mean(family2)
  
  return(power)
}

# Evaluation model
mult.cs3.evaluation.model = EvaluationModel() +
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
  # Disjunctive power criteria
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1", 
                          "Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power - Family 1",
            method = "DisjunctivePower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power - Family 2",
            method = "DisjunctivePower",
            tests = tests("Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Tradeoff-based disjunctive power (v1 = 0.5, v2 = 0.5)",
            method = "mult.cs3.TradeoffDisjunctivePower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1", 
                          "Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Tradeoff-based disjunctive power",
            par = parameters(alpha = 0.025, 
                             weight = c(0.5, 0.5))) +
  Criterion(id = "Tradeoff-based disjunctive power (v1 = 0.8, v2 = 0.2)",
            method = "mult.cs3.TradeoffDisjunctivePower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1", 
                          "Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Tradeoff-based disjunctive power",
            par = parameters(alpha = 0.025, 
                             weight = c(0.8, 0.2))) +
  # Weighted power criteria
  Criterion(id = "Weighted power - Family 1",
            method = "WeightedPower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1"),
            labels = "Weighted power",
            par = parameters(alpha = 0.025, 
                             weight = c(0.5, 0.5))) +
  Criterion(id = "Weighted power - Family 2",
            method = "WeightedPower",
            tests = tests("Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Weighted power",
            par = parameters(alpha = 0.025, 
                             weight = c(0.5, 0.5))) +
  Criterion(id = "Weighted power (v1 = 0.5, v2 = 0.5)",
            method = "WeightedPower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1", 
                          "Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Weighted power",
            par = parameters(alpha = 0.025, 
                             weight = c(0.5*0.5, 0.5*0.5, 0.5*0.5, 0.5*0.5))) +
  Criterion(id = "Weighted power (v1 = 0.8, v2 = 0.2)",
            method = "WeightedPower",
            tests = tests("Placebo vs Dose H - E1", 
                          "Placebo vs Dose L - E1", 
                          "Placebo vs Dose H - E2", 
                          "Placebo vs Dose L - E2"),
            labels = "Weighted power",
            par = parameters(alpha = 0.025, 
                             weight = c(0.8*0.5, 0.8*0.5, 0.2*0.5, 0.2*0.5)))

# Simulation Parameters
mult.cs3.sim.parameters =  SimParameters(n.sims = 100000,
                                         proc.load = "full",
                                         seed = 42938001)

# Perform clinical scenario evaluation
mult.cs3.results = CSE(mult.cs3.data.model, 
                       mult.cs3.analysis.model, 
                       mult.cs3.evaluation.model,
                       mult.cs3.sim.parameters)

# Summary of results
summary(mult.cs3.results)

# Presentation Model
mult.cs3.presentation.model = PresentationModel() +
  Project(username = "Gautier Paux",
          title = "Case study 3",
          description = "Simulation report for case study 3 of the Clinical Trials with Multiple Objectives chapter") +
  Section(by = "outcome.parameter") +
  CustomLabel(param = "multiplicity.adjustment",
              label= c("Procedure H")) +
  CustomLabel(param = "outcome.parameter",
              label=c("Scenario 1", "Scenario 2", "Scenario 3", "Scenario 4"))

# Generate Word-based report
GenerateReport(presentation.model = mult.cs3.presentation.model,
               cse.results = mult.cs3.results,
               report.filename = "mult-cs3-report.docx")


