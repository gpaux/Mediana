library(Mediana)

###################################################################
# Case study 1
# Clinical trial in patients with rheumatoid arthritis
###################################################################

# Outcome parameter set 1
outcome1.placebo = parameters(prop = 0.30)
outcome1.treatment = parameters(prop = 0.50)

# Outcome parameter set 2
outcome2.placebo = parameters(prop = 0.30)
outcome2.treatment = parameters(prop = 0.55)

# Outcome parameter set 3
outcome3.placebo = parameters(prop = 0.30)
outcome3.treatment = parameters(prop = 0.60)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "BinomDist") +
  SampleSize(c(80, 90, 100, 110)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome1.placebo, outcome2.placebo,  outcome3.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome1.treatment, outcome2.treatment, outcome3.treatment))

# Analysis model
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "PropTest")

# Evaluation model
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))


# Simulation Parameters
case.study1.sim.parameters =  SimParameters(n.sims = 1000, 
                                            proc.load = "full", 
                                            seed = 42938001)

# Perform clinical scenario evaluation
case.study1.results = CSE(case.study1.data.model,
                          case.study1.analysis.model,
                          case.study1.evaluation.model,
                          case.study1.sim.parameters)

# Reporting
case.study1.presentation.model =   PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 1",
          description = "Clinical trial in patients with rheumatoid arthritis") +
  Section(by = "outcome.parameter") +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size", 
              label= paste0("N = ",c(80, 90, 100, 110))) +
  CustomLabel(param = "outcome.parameter", 
              label=c("Pessimist", "Standard", "Optimist"))

# Report Generation
GenerateReport(presentation.model = case.study1.presentation.model,
               cse.results = case.study1.results,
               report.filename = "Case study 1 (binary endpoint).docx")