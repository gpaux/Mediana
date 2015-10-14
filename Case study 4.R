library(Mediana)

###################################################################
# Case study 4
# Clinical trial in patients with metastatic colorectal cancer
###################################################################

# Outcome parameters: Progression-free survival
median.time.pfs.placebo = 6
rate.pfs.placebo = log(2)/median.time.pfs.placebo
outcome.pfs.placebo = parameters(rate = rate.pfs.placebo)
median.time.pfs.treatment = 9

rate.pfs.treatment = log(2)/median.time.pfs.treatment
outcome.pfs.treatment = parameters(rate = rate.pfs.treatment)
hazard.pfs.ratio = rate.pfs.treatment/rate.pfs.placebo

# Outcome parameters: Overall survival
median.time.os.placebo = 15
rate.os.placebo = log(2)/median.time.os.placebo
outcome.os.placebo = parameters(rate = rate.os.placebo)
median.time.os.treatment = 19

rate.os.treatment = log(2)/median.time.os.treatment
outcome.os.treatment = parameters(rate = rate.os.treatment)
hazard.os.ratio = rate.os.treatment/rate.os.placebo

# Parameter lists
placebo.par = parameters(parameters(rate = rate.pfs.placebo), 
                         parameters(rate = rate.os.placebo))

treatment.par = parameters(parameters(rate = rate.pfs.treatment), 
                           parameters(rate = rate.os.treatment))

# Correlation between two endpoints
corr.matrix = matrix(c(1.0, 0.3,
                       0.3, 1.0), 2, 2)

# Outcome parameters
outcome.placebo = parameters(par = placebo.par, corr = corr.matrix)
outcome.treatment = parameters(par = treatment.par, corr = corr.matrix)

# Number of events
event.count.total = c(270, 300)
randomization.ratio = c(1, 2)

# Data model
case.study4.data.model = DataModel() +
  OutcomeDist(outcome.dist = "MVExpoPFSOSDist") +
  Event(n.events = event.count.total, 
        rando.ratio = randomization.ratio) +
  Sample(id = list("Placebo PFS", "Placebo OS"),
         outcome.par = parameters(outcome.placebo)) +
  Sample(id = list("Treatment PFS", "Treatment OS"),
         outcome.par = parameters(outcome.treatment))

# Parameters of the chain procedure (fixed-sequence procedure)
# Vector of hypothesis weights
chain.weight = c(1, 0)
# Matrix of transition parameters
chain.transition = matrix(c(0, 1,
                            0, 0), 2, 2, byrow = TRUE)

# Analysis model
case.study4.analysis.model = AnalysisModel() +
  MultAdjProc(proc = "ChainAdj",
              par = parameters(weight = chain.weight, transition = chain.transition)) +
  Test(id = "PFS test",
       samples = samples("Placebo PFS", "Treatment PFS"),
       method = "LogrankTest") +
  Test(id = "OS test",
       samples = samples("Placebo OS", "Treatment OS"),
       method = "LogrankTest")

# Evaluation model
case.study4.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("PFS test",
                          "OS test"),
            labels = c("PFS test",
                       "OS test"),
            par = parameters(alpha = 0.025))

# Simulation Parameters
case.study4.sim.parameters =  SimParameters(n.sims = 1000, 
                                            proc.load = "full", 
                                            seed = 42938001)

# Perform clinical scenario evaluation
case.study4.results = CSE(case.study4.data.model,
                          case.study4.analysis.model,
                          case.study4.evaluation.model,
                          case.study4.sim.parameters)

# Reporting
case.study4.presentation.model = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 4",
          description = "Clinical trial in patients with metastatic colorectal cancer") +
  Section(by = "outcome.parameter") +
  Table(by = "multiplicity.adjustment") +
  CustomLabel(param = "event", 
              label= paste0("Total number of events = ",c(270, 300))) +
  CustomLabel(param = "multiplicity.adjustment", 
              label= "Fixed-sequence procedure")

# Report Generation
GenerateReport(presentation.model = case.study4.presentation.model,
               cse.results = case.study4.results,
               report.filename = "Case study 4.docx")
