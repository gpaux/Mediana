# Load the Mediana R package
library(Mediana)

# Outcome parameters
outcome.placebo.neg = parameters(mean = 0.12, sd = 0.45)
outcome.placebo.pos = parameters(mean = 0.12, sd = 0.45)
outcome.treatment.neg = parameters(mean = 0.21, sd = 0.45)
outcome.treatment.pos = parameters(mean = 0.345, sd = 0.45)

# Sample size parameters
prevalence.pos = 0.4
sample.size.total = 310

sample.size.placebo.neg = (1-prevalence.pos) / 2 * sample.size.total
sample.size.placebo.pos = prevalence.pos / 2 * sample.size.total
sample.size.treatment.neg = (1-prevalence.pos) / 2 * sample.size.total
sample.size.treatment.pos = prevalence.pos / 2 * sample.size.total

# Data model
subgroup.cs1.data.model = 
  DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  Sample(id = "Placebo Bio-Neg",
         sample.size = sample.size.placebo.neg,
         outcome.par = parameters(outcome.placebo.neg)) +
  Sample(id = "Placebo Bio-Pos",
         sample.size = sample.size.placebo.pos,
         outcome.par = parameters(outcome.placebo.pos)) +
  Sample(id = "Treatment Bio-Neg",
         sample.size = sample.size.treatment.neg,
         outcome.par = parameters(outcome.treatment.neg)) +
  Sample(id = "Treatment Bio-Pos",
         sample.size = sample.size.treatment.pos,
         outcome.par = parameters(outcome.treatment.pos))

# Analysis model
subgroup.cs1.analysis.model = 
  AnalysisModel() +
  Test(id = "OP test",
       samples = samples(c("Placebo Bio-Neg", "Placebo Bio-Pos"),
                         c("Treatment Bio-Neg", "Treatment Bio-Pos")),
       method = "TTest") +
  Test(id = "Bio-Pos test",
       samples = samples("Placebo Bio-Pos", "Treatment Bio-Pos"),
       method = "TTest") +
  MultAdjProc(proc = "BonferroniAdj",
              par = parameters(weight = c(0.8, 0.2))) +
  MultAdjProc(proc = "HochbergAdj",
              par = parameters(weight = c(0.8, 0.2)))

# Custom evaluation criterion based on weighted power
subgroup.cs1.WeightedPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  v1 = parameter$v1
  v2 = parameter$v2
  
  # Broad claim: Reject OP test
  broad.claim = (test.result[,1] <= alpha)
  # Restricted claim: Reject Bio-Pos test but not OP test
  restricted.claim = ((test.result[,1] > alpha) & (test.result[,2] <= alpha))
  
  power = v1 * mean(broad.claim) + v2 * mean(restricted.claim)
  
  return(power)
}

# Custom evaluation criterion based on the probability of a restricted claim
subgroup.cs1.RestrictedClaimPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  
  # Restricted claim: Reject Bio-Pos test but not OP test
  restricted.claim = ((test.result[,1] > alpha) & (test.result[,2] <= alpha))
  
  power = mean(restricted.claim)
  
  return(power)
}

# Evaluation model
subgroup.cs1.evaluation.model = 
  EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("OP test", "Bio-Pos test"),
            labels = c("OP test","Bio-Pos test"),
            par = parameters(alpha = 0.025)) + 
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("OP test", "Bio-Pos test"),
            labels = c("Disjunctive power"),
            par = parameters(alpha = 0.025)) + 
  Criterion(id = "Weighted power",
            method = "subgroup.cs1.WeightedPower",
            tests = tests("OP test", "Bio-Pos test"),
            labels = c("Weighted power"),
            par = parameters(alpha = 0.025, 
                             v1 = 1 / (1 + prevalence.pos), 
                             v2 = prevalence.pos / 
                               (1 + prevalence.pos))) + 
  Criterion(id = "Probability of a restricted claim",
            method = "subgroup.cs1.RestrictedClaimPower",
            tests = tests("OP test", "Bio-Pos test"),
            labels = c("Probability of a restricted claim"),
            par = parameters(alpha = 0.025))


# Simulation Parameters
subgroup.cs1.sim.parameters = SimParameters(n.sims = 100000, 
                                            proc.load = "full",
                                            seed = 42938001)

# Perform clinical scenario evaluation
subgroup.cs1.results = CSE(subgroup.cs1.data.model,
                           subgroup.cs1.analysis.model,
                           subgroup.cs1.evaluation.model,
                           subgroup.cs1.sim.parameters)

# Summary of results
summary(subgroup.cs1.results)

# Presentation Model
subgroup.cs1.presentation.model = PresentationModel() +
  Project(username = "Gautier Paux",
          title = "Case study 1",
          description = "Simulation report for case study 1 of the Subgroup Analysis in Clinical Trials") +
  Section(by = "outcome.parameter") +
  Table(by = "multiplicity.adjustment") +
  CustomLabel(param = "multiplicity.adjustment",
              label= c("Bonferroni", "Hochberg"))

# Generate Word-based report
GenerateReport(presentation.model = subgroup.cs1.presentation.model,
               cse.results = subgroup.cs1.results,
               report.filename = "subgroup-cs1-report.docx")
