# Load the Mediana R package
library(Mediana)

# Outcome parameters
outcome.placebo.neg = parameters(rate = log(2)/7.5)
outcome.treatment.neg = parameters(rate = log(2)/8.5)
outcome.placebo.pos = parameters(rate = log(2)/7.5)
outcome.treatment.pos = parameters(rate = log(2)/12.5)

# Sample size parameters
prevalence.pos = 0.55
sample.size.total = 270

sample.size.placebo.neg = round(((1-prevalence.pos) / 2) * sample.size.total)
sample.size.placebo.pos = round((prevalence.pos / 2 * sample.size.total))
sample.size.treatment.neg = round(((1-prevalence.pos) / 2) * sample.size.total)
sample.size.treatment.pos = round((prevalence.pos / 2 * sample.size.total))

# Data model
subgroup.cs3.data.model = 
  DataModel() +
  OutcomeDist(outcome.dist = "ExpoDist") +
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
subgroup.cs3.analysis.model = 
  AnalysisModel() +
  Test(id = "OP test",
       samples = samples(c("Placebo Bio-Neg", "Placebo Bio-Pos"),
                         c("Treatment Bio-Neg", "Treatment Bio-Pos")),
       method = "LogrankTest") +
  Test(id = "Bio-Pos test",
       samples = samples("Placebo Bio-Pos", 
                         "Treatment Bio-Pos"),
       method = "LogrankTest") +
  Statistic(id = "Effect Size in Bio-Neg", 
            samples = samples("Placebo Bio-Neg", "Treatment Bio-Neg"),
            method = "EffectSizeEventStat") +
  Statistic(id = "Ratio Effect Size Bio-Pos vs Bio-Neg", 
            samples = samples("Placebo Bio-Pos", 
                              "Treatment Bio-Pos", 
                              "Placebo Bio-Neg", 
                              "Treatment Bio-Neg"),
            method = "RatioEffectSizeEventStat")   +
  MultAdjProc(proc = "HochbergAdj",
              par = parameters(weight = c(0.8, 0.2)))

# Custom evaluation criterion based on weighted power
subgroup.cs3.WeightedPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  v1 = parameter$v1
  v2 = parameter$v2
  v3 = parameter$v3
  influence_threshold = parameter$influence_threshold
  interaction_threshold = parameter$interaction_threshold
  
  
  # Broad claim: (1) Reject OP test but not Bio-Pos or (2) Reject OP and Bio-Pos test and influence condition is met but the interaction condition is not met
  broad.claim = ((test.result[,1] <= alpha & test.result[,2] > alpha) | 
                   (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] >= influence_threshold & statistic.result[,2] < interaction_threshold))
  
  # Restricted claim: (1) Reject Bio-Pos test but not OP or (2) Reject Bio-Pos and OP test and influence not met
  restricted.claim = ((test.result[,1] > alpha & test.result[,2] <= alpha) | 
                        (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] < influence_threshold))
  
  # Enhanced claim: (1) Reject Bio-Pos and OP test or reject both and influence not met
  enhanced.claim = ((test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] >= influence_threshold & statistic.result[,2] >= interaction_threshold))
  
  power = v1 * mean(broad.claim) + v2 * mean(restricted.claim) + v3 * mean(enhanced.claim)
  
  return(power)
}

# Custom evaluation criterion based on the probability of a broad claim
subgroup.cs3.BroadClaimPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  influence_threshold = parameter$influence_threshold
  interaction_threshold = parameter$interaction_threshold
  
  # Broad claim: (1) Reject OP test but not Bio-Pos or (2) Reject OP and Bio-Pos test and influence condition is met but the interaction condition is not met
  broad.claim = ((test.result[,1] <= alpha & test.result[,2] > alpha) | (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] >= influence_threshold & statistic.result[,2] < interaction_threshold))
  
  power = mean(broad.claim)
  
  return(power)
}

# Custom evaluation criterion based on the probability of a restricted claim
subgroup.cs3.RestrictedClaimPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  influence_threshold = parameter$influence_threshold
  
  # Restricted claim: (1) Reject Bio-Pos test but not OP or (2) Reject Bio-Pos and OP test and influence not met
  restricted.claim = ((test.result[,1] > alpha & test.result[,2] <= alpha) | (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] < influence_threshold))
  
  power = mean(restricted.claim)
  
  return(power)
}

# Custom evaluation criterion based on the probability of an enhanced claim
subgroup.cs3.EnhancedClaimPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  influence_threshold = parameter$influence_threshold
  interaction_threshold = parameter$interaction_threshold
  
  # Enhanced claim: (1) Reject Bio-Pos and OP test or reject both and influence not met
  enhanced.claim = ((test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] >= influence_threshold & statistic.result[,2] >= interaction_threshold))
  
  power = mean(enhanced.claim)
  
  return(power)
}

# Evaluation model
subgroup.cs3.evaluation.model = 
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
            method = "subgroup.cs3.WeightedPower",
            tests = tests("OP test", "Bio-Pos test"),
            statistics = statistics("Effect Size in Bio-Neg",
                                    "Ratio Effect Size Bio-Pos vs Bio-Neg"),
            labels = c("Weighted power (with conditions)"),
            par = parameters(alpha = 0.025, 
                             v1 = 1 / (2 * (1 + prevalence.pos)), 
                             v2 = prevalence.pos / (2 * (1 + prevalence.pos)),
                             v3 = 1/2,
                             influence_threshold = 0.15,
                             interaction_threshold = 1.5)) + 
  Criterion(id = "Probability of a broad claim",
            method = "subgroup.cs3.BroadClaimPower",
            tests = tests("OP test", "Bio-Pos test"),
            statistics = statistics("Effect Size in Bio-Neg",
                                    "Ratio Effect Size Bio-Pos vs Bio-Neg"),
            labels = c("Probability of a broad claim"),
            par = parameters(alpha = 0.025, 
                             influence_threshold = 0.15,
                             interaction_threshold = 1.5)) + 
  Criterion(id = "Probability of a restricted claim",
            method = "subgroup.cs3.RestrictedClaimPower",
            tests = tests("OP test", "Bio-Pos test"),
            statistics = statistics("Effect Size in Bio-Neg",
                                    "Ratio Effect Size Bio-Pos vs Bio-Neg"),
            labels = c("Probability of a restricted claim"),
            par = parameters(alpha = 0.025, 
                             influence_threshold = 0.15,
                             interaction_threshold = 1.5)) + 
  Criterion(id = "Probability of an enhanced claim",
            method = "subgroup.cs3.EnhancedClaimPower",
            tests = tests("OP test", "Bio-Pos test"),
            statistics = statistics("Effect Size in Bio-Neg",
                                    "Ratio Effect Size Bio-Pos vs Bio-Neg"),
            labels = c("Probability of an enhanced claim"),
            par = parameters(alpha = 0.025, 
                             influence_threshold = 0.15,
                             interaction_threshold = 1.5))

# Simulation Parameters
subgroup.cs3.sim.parameters = SimParameters(n.sims = 100000, 
                                            proc.load = "full", 
                                            seed = 42938001)

# Perform clinical scenario evaluation
subgroup.cs3.results = CSE(subgroup.cs3.data.model,
                           subgroup.cs3.analysis.model,
                           subgroup.cs3.evaluation.model,
                           subgroup.cs3.sim.parameters)

# Summary of results
summary(subgroup.cs3.results)

# Presentation Model
subgroup.cs3.presentation.model = PresentationModel() +
  Project(username = "Gautier Paux",
          title = "Case study 3",
          description = "Simulation report for case study 3 of the Subgroup Analysis in Clinical Trials") +
  Section(by = "outcome.parameter") +
  Table(by = "multiplicity.adjustment") +
  CustomLabel(param = "multiplicity.adjustment",
              label= c("Hochberg"))

# Generate Word-based report
GenerateReport(presentation.model = subgroup.cs3.presentation.model,
               cse.results = subgroup.cs3.results,
               report.filename = "subgroup-cs3-report.docx")
