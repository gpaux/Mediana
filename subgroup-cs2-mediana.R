# Load the Mediana R package
library(Mediana)

# Outcome parameters
outcome1.placebo.neg = parameters(mean = 0.12, sd = 0.45)
outcome1.placebo.pos = parameters(mean = 0.12, sd = 0.45)
outcome1.treatment.neg = parameters(mean = 0.21, sd = 0.45)
outcome1.treatment.pos = parameters(mean = 0.345, sd = 0.45)

# Sample size parameters
prevalence.pos = 0.4
sample.size.total = 310

sample.size.placebo.neg = (1-prevalence.pos) / 2 * sample.size.total
sample.size.placebo.pos = prevalence.pos / 2 * sample.size.total
sample.size.treatment.neg = (1-prevalence.pos) / 2 * sample.size.total
sample.size.treatment.pos = prevalence.pos / 2 * sample.size.total

# Data model
subgroup.cs2.data.model = 
  DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  Sample(id = "Placebo Bio-Neg",
         sample.size = sample.size.placebo.neg,
         outcome.par = parameters(outcome1.placebo.neg)) +
  Sample(id = "Placebo Bio-Pos",
         sample.size = sample.size.placebo.pos,
         outcome.par = parameters(outcome1.placebo.pos)) +
  Sample(id = "Treatment Bio-Neg",
         sample.size = sample.size.treatment.neg,
         outcome.par = parameters(outcome1.treatment.neg)) +
  Sample(id = "Treatment Bio-Pos",
         sample.size = sample.size.treatment.pos,
         outcome.par = parameters(outcome1.treatment.pos))

# Analysis model
subgroup.cs2.analysis.model = 
  AnalysisModel() +
  Test(id = "OP test",
       samples = samples(c("Placebo Bio-Neg", "Placebo Bio-Pos"),
                         c("Treatment Bio-Neg", "Treatment Bio-Pos")),
       method = "TTest") +
  Test(id = "Bio-Pos test",
       samples = samples("Placebo Bio-Pos", 
                         "Treatment Bio-Pos"),
       method = "TTest") +
  Statistic(id = "Effect Size in Bio-Neg", 
            samples = samples("Placebo Bio-Neg", 
                              "Treatment Bio-Neg"),
            method = "EffectSizeContStat") +
  MultAdjProc(proc = "HochbergAdj",
              par = parameters(weight = c(0.8, 0.2)))

# Custom evaluation criterion based on weighted power
subgroup.cs2.WeightedPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  v1 = parameter$v1
  v2 = parameter$v2
  influence_threshold = parameter$influence_threshold
  
  # Broad claim: (1) Reject OP test but not Bio-Pos or (2) Reject OP and Bio-Pos test and influence condition is met
  broad.claim = ((test.result[,1] <= alpha & test.result[,2] > alpha) | 
                   (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] >= influence_threshold))
  
  # Restricted claim: (1) Reject Bio-Pos test but not OP or (2) Reject Bio-Pos and OP test and influence not met
  restricted.claim = ((test.result[,1] > alpha & test.result[,2] <= alpha) | 
                        (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] < influence_threshold))
  
  power = v1 * mean(broad.claim) + v2 * mean(restricted.claim)
  
  return(power)
}

# Custom evaluation criterion based on the probability of a broad claim
subgroup.cs2.BroadClaimPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  influence_threshold = parameter$influence_threshold
  
  # Broad claim: Reject OP test but not Bio-Pos test or reject both and influence condition is met
  broad.claim = ((test.result[,1] <= alpha & test.result[,2] > alpha) | 
                   (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] >= influence_threshold))
  
  power = mean(broad.claim)
  
  return(power)
}

# Custom evaluation criterion based on the probability of a restricted claim
subgroup.cs2.RestrictedClaimPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  influence_threshold = parameter$influence_threshold
  
  # Restricted claim: Reject Bio-Pos test but not OP test or reject both and influence condition is not met
  restricted.claim = ((test.result[,1] > alpha & test.result[,2] <= alpha) | 
                        (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] < influence_threshold))
  
  power = mean(restricted.claim)
  
  return(power)
}

# Evaluation model
subgroup.cs2.evaluation.model = 
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
            method = "subgroup.cs2.WeightedPower",
            tests = tests("OP test", "Bio-Pos test"),
            statistics = statistics("Effect Size in Bio-Neg"),
            labels = c("Weighted power"),
            par = parameters(alpha = 0.025, 
                             v1 = 1 / (1 + prevalence.pos), 
                             v2 = prevalence.pos / (1 + prevalence.pos),
                             influence_threshold = 0.186)) + 
  Criterion(id = "Probability of a broad claim",
            method = "subgroup.cs2.BroadClaimPower",
            tests = tests("OP test", "Bio-Pos test"),
            statistics = statistics("Effect Size in Bio-Neg"),
            labels = c("Probability of a broad claim"),
            par = parameters(alpha = 0.025,
                             influence_threshold = 0.186)) + 
  Criterion(id = "Probability of a restricted claim",
            method = "subgroup.cs2.RestrictedClaimPower",
            tests = tests("OP test", "Bio-Pos test"),
            statistics = statistics("Effect Size in Bio-Neg"),
            labels = c("Probability of a restricted claim"),
            par = parameters(alpha = 0.025,
                             influence_threshold = 0.186)) 


# Simulation Parameters
subgroup.cs2.sim.parameters = SimParameters(n.sims = 100000, 
                                            proc.load = "full", 
                                            seed = 42938001)

# Perform clinical scenario evaluation
subgroup.cs2.results = CSE(subgroup.cs2.data.model,
                           subgroup.cs2.analysis.model,
                           subgroup.cs2.evaluation.model,
                           subgroup.cs2.sim.parameters)

# Summary of results
summary(subgroup.cs2.results)

# Presentation Model
subgroup.cs2.presentation.model = PresentationModel() +
  Project(username = "Gautier Paux",
          title = "Case study 2",
          description = "Simulation report for case study 2 of the Subgroup Analysis in Clinical Trials") +
  Section(by = "outcome.parameter") +
  Table(by = "multiplicity.adjustment") +
  CustomLabel(param = "multiplicity.adjustment",
              label= c("Hochberg"))

# Generate Word-based report
GenerateReport(presentation.model = subgroup.cs2.presentation.model,
               cse.results = subgroup.cs2.results,
               report.filename = "subgroup-cs2-report.docx")
