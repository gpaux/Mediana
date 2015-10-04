library(Mediana)

###################################################################
# Case study 6
# Clinical trial in patients with schizophrenia
###################################################################

# Outcome parameters
outcome1.pl = parameters(mean = 16, sd = 18)
outcome1.dosel = parameters(mean = 19.5, sd = 18)
outcome1.dosem = parameters(mean = 21, sd = 18)
outcome1.doseh = parameters(mean = 21, sd = 18)

outcome2.pl = parameters(mean = 16, sd = 20)
outcome2.dosel = parameters(mean = 19.5, sd = 20)
outcome2.dosem = parameters(mean = 21, sd = 20)
outcome2.doseh = parameters(mean = 21, sd = 20)

# Data model
case.study6.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  SampleSize(c(250, 275, 300)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome1.pl, outcome2.pl)) +
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
  Test(id = "Pl vs Dose L",
       samples = samples("Placebo", "Dose L"),
       method = "TTest") +
  Test(id = "Pl vs Dose M",
       samples = samples ("Placebo", "Dose M"),
       method = "TTest") +
  Test(id = "Pl vs Dose H",
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
            tests = tests("Pl vs Dose L",
                          "Pl vs Dose M",
                          "Pl vs Dose H"),
            labels = c("Pl vs Dose L",
                       "Pl vs Dose M",
                       "Pl vs Dose H"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("Pl vs Dose L",
                          "Pl vs Dose M",
                          "Pl vs Dose H"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Dose H and at least one dose",
            method = "case.study6.criterion",
            tests = tests("Pl vs Dose L",
                          "Pl vs Dose M",
                          "Pl vs Dose H"),
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
case.study6.presentation.model = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 6",
          description = "Clinical trial in patients with schizophrenia - Several MTPs") +
  Section(by = "outcome.parameter") +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size", 
              label = paste0("N = ", c(250, 275, 300))) +
  CustomLabel(param = "multiplicity.adjustment", 
              label = c("No adjustment", "Bonferroni adjustment", "Holm adjustment", "Hochberg adjustment"))

# Report Generation
GenerateReport(presentation.model = case.study6.presentation.model,
               cse.results = case.study6.results,
               report.filename = "Case study 6 - Without subsections.docx")

# Reporting
case.study6.presentation.model = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 6",
          description = "Clinical trial in patients with schizophrenia - Several MTPs") +
  Section(by = "outcome.parameter") +
  Subsection(by = "multiplicity.adjustment") +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size", 
              label = paste0("N = ", c(250, 275, 300))) +
  CustomLabel(param = "multiplicity.adjustment", 
              label = c("No adjustment", "Bonferroni adjustment", "Holm adjustment", "Hochberg adjustment"))

# Report Generation
GenerateReport(presentation.model = case.study6.presentation.model,
               cse.results = case.study6.results,
               report.filename = "Case study 6 - With subsections.docx")

case.study6.presentation.model = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 6",
          description = "Clinical trial in patients with schizophrenia - Several MTPs") +
  Section(by = c("outcome.parameter", "multiplicity.adjustment")) +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size", 
              label= paste0("N = ", c(250, 275, 300))) +
  CustomLabel(param = "multiplicity.adjustment", 
              label = c("No adjustment", "Bonferroni adjustment", "Holm adjustment", "Hochberg adjustment"))

# Report Generation
GenerateReport(presentation.model = case.study6.presentation.model,
               cse.results = case.study6.results,
               report.filename = "Case study 6 - Combined Sections.docx")



