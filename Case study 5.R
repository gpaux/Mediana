library(Mediana)

###################################################################
# Case study 5
# Clinical trial in patients with rheumatoid arthritis
###################################################################

# Variable types
var.type = list("BinomDist", "NormalDist")

# Outcome distribution parameters
placebo.par = parameters(parameters(prop = 0.3),
                         parameters(mean = -0.10, sd = 0.5))

dosel.par1 = parameters(parameters(prop = 0.40),
                        parameters(mean = -0.20, sd = 0.5))
dosel.par2 = parameters(parameters(prop = 0.45),
                        parameters(mean = -0.25, sd = 0.5))
dosel.par3 = parameters(parameters(prop = 0.50),
                        parameters(mean = -0.30, sd = 0.5))

doseh.par1 = parameters(parameters(prop = 0.50),
                        parameters(mean = -0.30, sd = 0.5))
doseh.par2 = parameters(parameters(prop = 0.55),
                        parameters(mean = -0.35, sd = 0.5))
doseh.par3 = parameters(parameters(prop = 0.60),
                        parameters(mean = -0.40, sd = 0.5))

# Correlation between two endpoints
corr.matrix = matrix(c(1.0, 0.5,
                       0.5, 1.0), 2, 2)

# Outcome parameter set 1
outcome1.placebo = parameters(type = var.type,
                              par = placebo.par,
                              corr = corr.matrix)
outcome1.dosel = parameters(type = var.type,
                            par = dosel.par1,
                            corr = corr.matrix)
outcome1.doseh = parameters(type = var.type,
                            par = doseh.par1,
                            corr = corr.matrix)

# Outcome parameter set 2
outcome2.placebo = parameters(type = var.type,
                              par = placebo.par,
                              corr = corr.matrix)
outcome2.dosel = parameters(type = var.type,
                            par = dosel.par2,
                            corr = corr.matrix)
outcome2.doseh = parameters(type = var.type,
                            par = doseh.par2,
                            corr = corr.matrix)

# Outcome parameter set 3
outcome3.placebo = parameters(type = var.type,
                              par = placebo.par,
                              corr = corr.matrix)
outcome3.doseh = parameters(type = var.type,
                            par = doseh.par3,
                            corr = corr.matrix)
outcome3.dosel = parameters(type = var.type,
                            par = dosel.par3,
                            corr = corr.matrix)

# Data model
case.study5.data.model = DataModel() +
  OutcomeDist(outcome.dist = "MVMixedDist") +
  SampleSize(c(100, 120)) +
  Sample(id = list("Placebo ACR20", "Placebo HAQ-DI"),
         outcome.par = parameters(outcome1.placebo, outcome2.placebo, outcome3.placebo)) +
  Sample(id = list("DoseL ACR20", "DoseL HAQ-DI"),
         outcome.par = parameters(outcome1.dosel, outcome2.dosel, outcome3.dosel)) +
  Sample(id = list("DoseH ACR20", "DoseH HAQ-DI"),
         outcome.par = parameters(outcome1.doseh, outcome2.doseh, outcome3.doseh))

# Parameters of the gatekeeping procedure procedure (multiple-sequence gatekeeping procedure)
# Tests to which the multiplicity adjustment will be applied
test.list = tests("Placebo vs DoseH - ACR20",
                  "Placebo vs DoseL - ACR20",
                  "Placebo vs DoseH - HAQ-DI",
                  "Placebo vs DoseL - HAQ-DI")

# Families of hypotheses
family = families(family1 = c(1, 2),
                  family2 = c(3, 4))

# Component procedures for each family
component.procedure = families(family1 ="HolmAdj",
                               family2 = "HolmAdj")

# Truncation parameter for each family
gamma = families(family1 = 0.8,
                 family2 = 1)


# Analysis model
case.study5.analysis.model = AnalysisModel() +
  MultAdjProc(proc = "MultipleSequenceGatekeepingAdj",
              par = parameters(family = family,
                               proc = component.procedure,
                               gamma = gamma),
              tests = test.list) +
  Test(id = "Placebo vs DoseL - ACR20",
       method = "PropTest",
       samples = samples("Placebo ACR20", "DoseL ACR20")) +
  Test(id = "Placebo vs DoseH - ACR20",
       method = "PropTest",
       samples = samples("Placebo ACR20", "DoseH ACR20")) +
  Test(id = "Placebo vs DoseL - HAQ-DI",
       method = "TTest",
       samples = samples("DoseL HAQ-DI", "Placebo HAQ-DI")) +
  Test(id = "Placebo vs DoseH - HAQ-DI",
       method = "TTest",
       samples = samples("DoseH HAQ-DI", "Placebo HAQ-DI"))

# Evaluation model
case.study5.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs DoseL - ACR20",
                          "Placebo vs DoseH - ACR20",
                          "Placebo vs DoseL - HAQ-DI",
                          "Placebo vs DoseH - HAQ-DI"),
            labels = c("Placebo vs DoseL - ACR20",
                       "Placebo vs DoseH - ACR20",
                       "Placebo vs DoseL - HAQ-DI",
                       "Placebo vs DoseH - HAQ-DI"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power - ACR20",
            method = "DisjunctivePower",
            tests = tests("Placebo vs DoseL - ACR20",
                          "Placebo vs DoseH - ACR20"),
            labels = "Disjunctive power - ACR20",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power - HAQ-DI",
            method = "DisjunctivePower",
            tests = tests("Placebo vs DoseL - HAQ-DI",
                          "Placebo vs DoseH - HAQ-DI"),
            labels = "Disjunctive power - HAQ-DI",
            par = parameters(alpha = 0.025))

# Simulation Parameters
case.study5.sim.parameters =  SimParameters(n.sims = 1000,
                                            proc.load = "full",
                                            seed = 42938001)

# Perform clinical scenario evaluation
case.study5.results = CSE(case.study5.data.model,
                          case.study5.analysis.model,
                          case.study5.evaluation.model,
                          case.study5.sim.parameters)

# Reporting
case.study5.presentation.model = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 5",
          description = "Clinical trial in patients with rheumatoid arthritis") +
  Section(by = "outcome.parameter") +
  Table(by = "multiplicity.adjustment") +
  CustomLabel(param = "outcome.parameter",
              label = c("Conservative", "Standard", "Optimistic")) +
  CustomLabel(param = "sample.size",
              label = paste0("N = ", c(100, 120))) +
  CustomLabel(param = "multiplicity.adjustment",
              label = "Multiple-sequence gatekeeping procedure")

# Report Generation
GenerateReport(presentation.model = case.study5.presentation.model,
               cse.results = case.study5.results,
               report.filename = "Case study 5.docx")

# Get the data generated in the CSE
case.study5.data.stack = DataStack(data.model = case.study5.data.model,
                                   sim.parameters = case.study5.sim.parameters)
