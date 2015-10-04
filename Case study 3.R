library(Mediana)

###################################################################
# Case study 3
# Clinical trial in patients with asthma
###################################################################

# Outcome parameters
outcome.plac.minus = parameters(mean = 0.12, sd = 0.45)
outcome.plac.plus = parameters(mean = 0.12, sd = 0.45)
outcome.treat.minus = parameters(mean = 0.24, sd = 0.45)
outcome.treat.plus = parameters(mean = 0.30, sd = 0.45)

# Sample size parameters
sample.size.total = c(330, 340, 350)
sample.size.plac.minus = as.list(0.3 * sample.size.total)
sample.size.plac.plus = as.list(0.2 * sample.size.total)
sample.size.treat.minus = as.list(0.3 * sample.size.total)
sample.size.treat.plus = as.list(0.2 * sample.size.total)

# Data model
case.study3.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  Sample(id = "Plac M-",
         sample.size = sample.size.plac.minus,
         outcome.par = parameters(outcome.plac.minus)) +
  Sample(id = "Plac M+",
         sample.size = sample.size.plac.plus,
         outcome.par = parameters(outcome.plac.plus)) +
  Sample(id = "Treat M-",
         sample.size = sample.size.treat.minus,
         outcome.par = parameters(outcome.treat.minus)) +
  Sample(id = "Treat M+",
         sample.size = sample.size.treat.plus,
         outcome.par = parameters(outcome.treat.plus))

# Analysis model
case.study3.analysis.model = AnalysisModel() +
  MultAdjProc(proc = "HochbergAdj") +
  Test(id = "OP test",
       samples = samples(c("Plac M-", "Plac M+"),
                         c("Treat M-", "Treat M+")),
       method = "TTest") +
  Test(id = "M+ test",
       samples = samples("Plac M+", "Treat M+"),
       method = "TTest")

# Evaluation model
case.study3.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("OP test",
                          "M+ test"),
            labels = c("OP test",
                       "M+ test"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("OP test",
                          "M+ test"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Conjunctive power",
            method = "ConjunctivePower",
            tests = tests("OP test",
                          "M+ test"),
            labels = "Conjunctive power",
            par = parameters(alpha = 0.025))

# Simulation Parameters
case.study3.sim.parameters =  SimParameters(n.sims = 1000, 
                                            proc.load = "full", 
                                            seed = 42938001)

# Perform clinical scenario evaluation
case.study3.results = CSE(case.study3.data.model,
                          case.study3.analysis.model,
                          case.study3.evaluation.model,
                          case.study3.sim.parameters)

# Reporting
case.study3.presentation.model = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 3",
          description = "Clinical trial in patients with asthma") +
  Section(by = c("outcome.parameter")) +
  Table(by = c("multiplicity.adjustment")) +
  CustomLabel(param = "sample.size", 
              label= paste0("N = ",c(330, 340, 350))) +
  CustomLabel(param = "multiplicity.adjustment", 
              label= "Hochberg adjustment")

# Report Generation
GenerateReport(presentation.model = case.study3.presentation.model,
               cse.results = case.study3.results,
               report.filename = "Case study 3.docx")

