library(Mediana)

###################################################################
# Case study 1
# Clinical trial in patients with relapsing-remitting multiple sclerosis
###################################################################

# Outcome parameters
outcome.placebo = parameters(dispersion = 0.5, mean = 13)
outcome.treatment = parameters(dispersion = 0.5, mean = 7.8)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NegBinomDist") +
  SampleSize(seq(100, 150, 10)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome.treatment))

# Analysis model
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "GLMNegBinomTest")

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
case.study1.presentation.model = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 1",
          description = "Clinical trial in patients with relapsing-remitting multiple sclerosis") +
  Section(by = c("outcome.parameter")) +
  Table(by = c("sample.size")) +
  CustomLabel(param = "sample.size", 
              label= paste0("N = ", seq(100,150,10)))

# Report Generation
GenerateReport(presentation.model = case.study1.presentation.model,
               cse.results = case.study1.results,
               report.filename = "Case study 1 (count-type endpoint).docx")
