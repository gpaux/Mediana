library(Mediana)

###################################################################
# Case study 6
# Clinical trial in patients with schizophrenia
###################################################################

# Outcome parameters
# Standard
outcome1.placebo = parameters(mean = 16, sd = 18)
outcome1.dosel = parameters(mean = 19.5, sd = 18)
outcome1.dosem = parameters(mean = 21, sd = 18)
outcome1.doseh = parameters(mean = 21, sd = 18)

# Optimistic
outcome2.placebo = parameters(mean = 16, sd = 18)
outcome2.dosel = parameters(mean = 20, sd = 18)
outcome2.dosem = parameters(mean = 21, sd = 18)
outcome2.doseh = parameters(mean = 22, sd = 18)

# Data model
case.study6.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  SampleSize(seq(220, 260, 20)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
  Sample(id = "Dose L",
         outcome.par = parameters(outcome1.dosel, outcome2.dosel)) +
  Sample(id = "Dose M",
         outcome.par = parameters(outcome1.dosem, outcome2.dosem)) +
  Sample(id = "Dose H",
         outcome.par = parameters(outcome1.doseh, outcome2.doseh))

# Multiplicity adjustments
# No adjustment
mult.adj1 = MultAdjProc(proc = NA)

# Bonferroni adjustment (with unequal weights)
mult.adj2 = MultAdjProc(proc = "BonferroniAdj",
                        par = parameters(weight = c(1/4,1/4,1/2)))

# Holm adjustment (with unequal weights)
mult.adj3 = MultAdjProc(proc = "HolmAdj",
                        par = parameters(weight = c(1/4,1/4,1/2)))

# Hochberg adjustment (with unequal weights)
mult.adj4 = MultAdjProc(proc = "HochbergAdj",
                        par = parameters(weight = c(1/4,1/4,1/2)))

# Analysis model
case.study6.analysis.model = AnalysisModel() +
  MultAdj(mult.adj1, mult.adj2, mult.adj3, mult.adj4) +
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
case.study6.criterion = function(test.result, statistic.result, parameter) {

  alpha = parameter
  significant = ((test.result[,3] <= alpha) & ((test.result[,1] <= alpha) | (test.result[,2] <= alpha)))
  power = mean(significant)
  return(power)
}

# Evaluation model
case.study6.evaluation.model = EvaluationModel() +
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
            method = "case.study6.criterion",
            tests = tests("Placebo vs Dose L",
                          "Placebo vs Dose M",
                          "Placebo vs Dose H"),
            labels = "Dose H and at least one of the two other doses are significant",
            par = parameters(alpha = 0.025))

# Simulation Parameters
case.study6.sim.parameters =  SimParameters(n.sims = 1000,
                                            proc.load = "full",
                                            seed = 42938001)

# Perform clinical scenario evaluation
case.study6.results = CSE(case.study6.data.model,
                          case.study6.analysis.model,
                          case.study6.evaluation.model,
                          case.study6.sim.parameters)

# Reporting
case.study6.presentation.model.default = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 6",
          description = "Clinical trial in patients with schizophrenia - Several MTPs") +
  Table(by = "sample.size") +
  CustomLabel(param = "outcome.parameter",
              label = c("Standard", "Optimistic")) +
  CustomLabel(param = "sample.size",
              label = paste0("N = ", seq(220, 260, 20))) +
  CustomLabel(param = "multiplicity.adjustment",
              label = c("No adjustment", "Bonferroni adjustment", "Holm adjustment", "Hochberg adjustment"))

# Reporting 1 - Without subsections
case.study6.presentation.model1 = case.study6.presentation.model.default +
  Section(by = "outcome.parameter")

# Report Generation
GenerateReport(presentation.model = case.study6.presentation.model1,
               cse.results = case.study6.results,
               report.filename = "Case study 6 - Without subsections.docx")

# Reporting 2 - With subsections
case.study6.presentation.model2 = case.study6.presentation.model.default +
  Section(by = "outcome.parameter") +
  Subsection(by = "multiplicity.adjustment")

# Report Generation
GenerateReport(presentation.model = case.study6.presentation.model2,
               cse.results = case.study6.results,
               report.filename = "Case study 6 - With subsections.docx")


# Reporting 3 - Combined sections
case.study6.presentation.model3 = case.study6.presentation.model.default +
  Section(by = c("outcome.parameter", "multiplicity.adjustment"))

# Report Generation
GenerateReport(presentation.model = case.study6.presentation.model3,
               cse.results = case.study6.results,
               report.filename = "Case study 6 - Combined Sections.docx")

# Get the data generated in the CSE
case.study6.data.stack = DataStack(data.model = case.study6.data.model,
                                   sim.parameters = case.study6.sim.parameters)

