\name{Mediana-package}
\alias{Mediana-package}
\alias{Mediana}
\docType{package}
\title{
Clinical Trial Simulations
}
\description{
Provides a general framework for clinical trial simulations based on the Clinical Scenario Evaluation (CSE) approach. The package supports a broad class of data models (including clinical trials with continuous, binary, survival-type and count-type endpoints as well as multivariate outcomes that are based on combinations of different endpoints), analysis strategies and commonly used evaluation criteria.
}
\details{
\tabular{ll}{
Package: \tab Mediana\cr
Type: \tab Package\cr
Version: \tab 1.0.6\cr
Date: \tab 2017-08-02\cr
License: \tab GPL-2\cr
}
%~~ An overview of how to use the package, including the most important functions ~~
}
\author{
Gautier Paux, Alex Dmitrienko

Maintainer: Gautier Paux <gautier@paux.fr>
}
\references{
Benda, N., Branson, M., Maurer, W., Friede, T. (2010). Aspects of modernizing drug development using clinical scenario planning and evaluation. Drug Information Journal. 44, 299-315.

Dmitrienko, A., Paux, G., Brechenmacher, T. (2016). Power calculations in clinical trials with complex clinical objectives. Journal of the Japanese Society of Computational Statistics. 28, 15-50.

Dmitrienko, A., Paux, G., Pulkstenis, E., Zhang, J. (2016). Tradeoff-based optimization criteria in clinical trials with multiple objectives and adaptive designs. Journal of Biopharmaceutical Statistics. 26, 120-140.

Dmitrienko, A. and Pulkstenis, E. (2017). Clinical Trial Optimization Using R. New-York : CRC Press.

Friede, T., Nicholas, R., Stallard, N., Todd, S., Parsons, N.R., Valdes-Marquez, E., Chataway, J. (2010). Refinement of the clinical scenario evaluation framework for assessment of competing development strategies with an application to multiple sclerosis. Drug Information Journal 44:713-718.


\url{http://gpaux.github.io/Mediana/}

}
%~~ Optionally other standard keywords, one per line, from file KEYWORDS in the R documentation directory ~~
\keyword{ package }
\examples{
\dontrun{
# Clinical trial in patients with rheumatoid arthritis

# Variable types
var.type = parameters("BinomDist", "NormalDist")

# Outcome distribution parameters
plac.par = parameters(parameters(prop = 0.3),
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
outcome1.plac = parameters(type = var.type,
                           par = plac.par,
                           corr = corr.matrix)
outcome1.dosel = parameters(type = var.type,
                            par = dosel.par1,
                            corr = corr.matrix)
outcome1.doseh = parameters(type = var.type,
                            par = doseh.par1,
                            corr = corr.matrix)

# Outcome parameter set 2
outcome2.plac = parameters(type = var.type,
                           par = plac.par,
                           corr = corr.matrix)
outcome2.dosel = parameters(type = var.type,
                            par = dosel.par2,
                            corr = corr.matrix)
outcome2.doseh = parameters(type = var.type,
                            par = doseh.par2,
                            corr = corr.matrix)

# Outcome parameter set 3
outcome3.plac = parameters(type = var.type,
                           par = plac.par,
                           corr = corr.matrix)
outcome3.doseh = parameters(type = var.type,
                            par = doseh.par3,
                            corr = corr.matrix)
outcome3.dosel = parameters(type = var.type,
                            par = dosel.par3,
                            corr = corr.matrix)

# Data model
data.model = DataModel() +
  OutcomeDist(outcome.dist = "MVMixedDist") +
  SampleSize(c(100, 120)) +
  Sample(id = list("Plac ACR20", "Plac HAQ-DI"),
         outcome.par = parameters(outcome1.plac, outcome2.plac, outcome3.plac)) +
  Sample(id = list("DoseL ACR20", "DoseL HAQ-DI"),
         outcome.par = parameters(outcome1.dosel, outcome2.dosel, outcome3.dosel)) +
  Sample(id = list("DoseH ACR20", "DoseH HAQ-DI"),
         outcome.par = parameters(outcome1.doseh, outcome2.doseh, outcome3.doseh))

family = families(family1 = c(1, 2), family2 = c(3, 4))
component.procedure = families(family1 ="HolmAdj", family2 = "HolmAdj")
gamma = families(family1 = 0.8, family2 = 1)

# Tests to which the multiplicity adjustment will be applied
test.list = tests("Pl vs DoseH - ACR20",
                  "Pl vs DoseL - ACR20",
                  "Pl vs DoseH - HAQ-DI",
                  "Pl vs DoseL - HAQ-DI")

# Analysis model
analysis.model = AnalysisModel() +
  MultAdjProc(proc = "MultipleSequenceGatekeepingAdj",
              par = parameters(family = family,
                               proc = component.procedure,
                               gamma = gamma),
              tests = test.list) +
  Test(id = "Pl vs DoseL - ACR20",
       method = "PropTest",
       samples = samples("Plac ACR20", "DoseL ACR20")) +
  Test(id = "Pl vs DoseH - ACR20",
       method = "PropTest",
       samples = samples("Plac ACR20", "DoseH ACR20")) +
  Test(id = "Pl vs DoseL - HAQ-DI",
       method = "TTest",
       samples = samples("DoseL HAQ-DI", "Plac HAQ-DI")) +
  Test(id = "Pl vs DoseH - HAQ-DI",
       method = "TTest",
       samples = samples("DoseH HAQ-DI", "Plac HAQ-DI"))

# Evaluation model
evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Pl vs DoseL - ACR20",
                          "Pl vs DoseH - ACR20",
                          "Pl vs DoseL - HAQ-DI",
                          "Pl vs DoseH - HAQ-DI"),
            labels = c("Pl vs DoseL - ACR20",
                       "Pl vs DoseH - ACR20",
                       "Pl vs DoseL - HAQ-DI",
                       "Pl vs DoseH - HAQ-DI"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power - ACR20",
            method = "DisjunctivePower",
            tests = tests("Pl vs DoseL - ACR20",
                          "Pl vs DoseH - ACR20"),
            labels = "Disjunctive power - ACR20",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power - HAQ-DI",
            method = "DisjunctivePower",
            tests = tests("Pl vs DoseL - HAQ-DI",
                          "Pl vs DoseH - HAQ-DI"),
            labels = "Disjunctive power - HAQ-DI",
            par = parameters(alpha = 0.025))

# Simulation Parameters
sim.parameters =  SimParameters(n.sims = 1000, proc.load = 2, seed = 42938001)

# Perform clinical scenario evaluation
results = CSE(data.model,
              analysis.model,
              evaluation.model,
              sim.parameters)

# Reporting
presentation.model = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study",
          description = "Clinical trial in patients with rheumatoid arthritis") +
  Section(by = c("outcome.parameter")) +
  Table(by = c("multiplicity.adjustment")) +
  CustomLabel(param = "sample.size",
              label = paste0("N = ", c(100, 120)))

# Report Generation
GenerateReport(presentation.model = presentation.model,
               cse.results = results,
               report.filename = "Case study.docx")

}
}
