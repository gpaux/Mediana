library(Mediana)

###################################################################
# Case study 1
# Clinical trial in patients with metastatic colorectal cancer with censoring
###################################################################

# Number of events parameters
event.count.total = c(390, 420)
randomization.ratio = c(1,2)

# Outcome parameters
median.time.placebo = 6
rate.placebo = log(2)/median.time.placebo
outcome.placebo = parameters(rate = rate.placebo)
median.time.treatment = 9
rate.treatment = log(2)/median.time.treatment
outcome.treatment = parameters(rate = rate.treatment)

# Dropout parameters
dropout.par = parameters(rate = 0.0115)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "ExpoDist") +
  Event(n.events = event.count.total, rando.ratio = randomization.ratio) +
  Design(enroll.period = 9,
         study.duration = 21,
         enroll.dist = "UniformDist",
         dropout.dist = "ExpoDist",
         dropout.dist.par = dropout.par) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome.treatment))

# Analysis model
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "LogrankTest") +
  Statistic(id = "Events Placebo",
            samples = samples("Placebo"),
            method = "EventCountStat") +
  Statistic(id = "Events Treatment",
            samples = samples("Treatment"),
            method = "EventCountStat")  +
  Statistic(id = "Patients Placebo",
            samples = samples("Placebo"),
            method = "PatientCountStat") +
  Statistic(id = "Patients Treatment",
            samples = samples("Treatment"),
            method = "PatientCountStat")

# Evaluation model
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))  +
  Criterion(id = "Mean Events Placebo",
            method = "MeanSumm",
            statistics = statistics("Events Placebo"),
            labels = c("Mean Events")) +
  Criterion(id = "Mean Events Treatment ",
            method = "MeanSumm",
            statistics = statistics("Events Treatment"),
            labels = c("Mean Events"))  +
  Criterion(id = "Mean Patients Placebo",
            method = "MeanSumm",
            statistics = statistics("Patients Placebo"),
            labels = c("Mean Patients")) +
  Criterion(id = "Mean Patients Treatment",
            method = "MeanSumm",
            statistics = statistics("Patients Treatment"),
            labels = c("Mean Patients"))

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
          description = "Clinical trial in patients with metastatic colorectal cancer") +
  Section(by = "outcome.parameter") +
  Table(by = "event")

# Report Generation
GenerateReport(presentation.model = case.study1.presentation.model,
               cse.results = case.study1.results,
               report.filename = "Case study 1 (survival-type endpoint with censoring).docx")

