library(Mediana)

###################################################################
# Case study 1
# Clinical trial in patients with pulmonary arterial hypertension
###################################################################

# Outcome parameter set 1
outcome1.placebo = parameters(mean = 0, sd = 70)
outcome1.treatment = parameters(mean = 40, sd = 70)

# Outcome parameter set 2
outcome2.placebo = parameters(mean = 0, sd = 70)
outcome2.treatment = parameters(mean = 50, sd = 70)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  SampleSize(c(50, 55, 60, 65, 70)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome1.treatment, outcome2.treatment))

# Analysis model
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "TTest") +
  Statistic(id = "Mean Treatment",
            method = "MeanStat",
            samples = samples("Treatment"))

# Evaluation model
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))  +
  Criterion(id = "Average Mean",
            method = "MeanSumm",
            statistics = statistics("Mean Treatment"),
            labels = c("Average Mean Treatment"))

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
case.study1.results
summary(case.study1.results)

# Reporting
case.study1.presentation.model =   PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 1",
          description = "Clinical trial in patients with pulmonary arterial hypertension") +
  Section(by = "outcome.parameter") +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size", 
              label= paste0("N = ",c(50, 55, 60, 65, 70))) +
  CustomLabel(param = "outcome.parameter", 
              label=c("Standard", "Optimistic"))

# Report Generation
GenerateReport(presentation.model = case.study1.presentation.model,
               cse.results = case.study1.results,
               report.filename = "Case study 1 (normally distributed endpoint).docx")