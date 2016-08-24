library(Mediana)

###################################################################
# Case study 2
# Clinical trial in patients with schizophrenia
###################################################################

# Outcome parameters
outcome.placebo = parameters(mean = 16, sd = 18)
outcome.dosel = parameters(mean = 19.5, sd = 18)
outcome.dosem = parameters(mean = 21, sd = 18)
outcome.doseh = parameters(mean = 21, sd = 18)

# Data model
case.study2.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  SampleSize(seq(220, 260, 20)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.placebo)) +
  Sample(id = "Dose L",
         outcome.par = parameters(outcome.dosel)) +
  Sample(id = "Dose M",
         outcome.par = parameters(outcome.dosem)) +
  Sample(id = "Dose H",
         outcome.par = parameters(outcome.doseh))

# Analysis model
case.study2.analysis.model = AnalysisModel() +
  MultAdjProc(proc = "HochbergAdj") +
  Test(id = "Placebo vs Dose L",
       samples = samples("Placebo", "Dose L"),
       method = "TTest") +
  Test(id = "Placebo vs Dose M",
       samples = samples ("Placebo", "Dose M"),
       method = "TTest") +
  Test(id = "Placebo vs Dose H",
       samples = samples("Placebo", "Dose H"),
       method = "TTest")

# Custom evaluation criterion (Dose H and at least one of the two other doses are significant)
case.study2.criterion = function(test.result, statistic.result, parameter) {

  alpha = parameter
  significant = ((test.result[,3] <= alpha) & ((test.result[,1] <= alpha) | (test.result[,2] <= alpha)))
  power = mean(significant)
  return(power)
}

# Evaluation model
case.study2.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs Dose L",
                          "Placebo vs Dose M",
                          "Placebo vs Dose H"),
            labels = c("Placebo vs Dose L",
                       "Placebo vs Dose M",
                       "Placebo vs Dose H"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("Placebo vs Dose L",
                          "Placebo vs Dose M",
                          "Placebo vs Dose H"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Dose H and at least one dose",
            method = "case.study2.criterion",
            tests = tests("Placebo vs Dose L",
                          "Placebo vs Dose M",
                          "Placebo vs Dose H"),
            labels = "Dose H and at least one of the two other doses are significant",
            par = parameters(alpha = 0.025))

# Simulation Parameters
case.study2.sim.parameters =  SimParameters(n.sims = 1000,
                                            proc.load = "full",
                                            seed = 42938001)

# Perform clinical scenario evaluation
case.study2.results = CSE(case.study2.data.model,
                          case.study2.analysis.model,
                          case.study2.evaluation.model,
                          case.study2.sim.parameters)
# Reporting
case.study2.presentation.model = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 2",
          description = "Clinical trial in patients with schizophrenia") +
  Section(by = "outcome.parameter") +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size",
              label= paste0("N = ", seq(220, 260, 20)))

# Report Generation
GenerateReport(presentation.model = case.study2.presentation.model,
               cse.results = case.study2.results,
               report.filename = "Case study 2.docx")

# Get the data generated in the CSE
case.study2.data.stack = DataStack(data.model = case.study2.data.model,
                                   sim.parameters = case.study2.sim.parameters)

