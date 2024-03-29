% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CSE.R
\name{CSE}
\alias{CSE}
\title{Clinical Scenario Evaluation}
\usage{
CSE(data, analysis, evaluation, simulation)
}
\arguments{
\item{data}{defines a \code{DataModel} or a \code{DataStack} object}

\item{analysis}{defines an \code{AnalysisModel} object}

\item{evaluation}{defines an \code{EvaluationModel} object}

\item{simulation}{defines a \code{SimParameters} object}
}
\value{
The \code{CSE} function returns a list containing:
\item{simulation.results }{a data frame containing the results of the
simulations for each scenario.} \item{analysis.scenario.grid }{a data frame
containing the grid of the combination of data and analysis scenarios.}
\item{data.structure }{a list containing the data structure according to the
\code{DataModel} object.} \item{analysis.structure }{a list containing the
analysis structure according to the \code{AnalysisModel} object.}
\item{evaluation.structure }{a list containing the evaluation structure
according to the \code{EvaluationModel} object.} \item{sim.parameters }{a
list containing the simulation parameters according to \code{SimParameters}
object.} \item{timestamp }{a list containing information about the start
time, end time and duration of the simulation runs.}
}
\description{
This function is used to perform the Clinical Scenario Evaluation according
to the objects of class \code{DataModel}, \code{AnalysisModel} and
\code{EvaluationModel} specified respectively in the arguments \code{data},
\code{analysis} and \code{evaluation} of the function.
}
\examples{

\dontrun{
# Outcome parameter set 1
outcome1.placebo = parameters(mean = 0, sd = 70)
outcome1.treatment = parameters(mean = 40, sd = 70)

# Outcome parameter set 2
outcome2.placebo = parameters(mean = 0, sd = 70)
outcome2.treatment = parameters(mean = 50, sd = 70)

# Data model
case.study1.data.model = DataModel() +
                         OutcomeDist(outcome.dist = "NormalDist") +
                         SampleSize(c(50, 55, 60, 65, 70)) +
                         Sample(id = "Placebo",
                                outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
                         Sample(id = "Treatment",
                                outcome.par = parameters(outcome1.treatment, outcome2.treatment))


# Analysis model
case.study1.analysis.model = AnalysisModel() +
                             Test(id = "Placebo vs treatment",
                                  samples = samples("Placebo", "Treatment"),
                                  method = "TTest")

# Evaluation model
case.study1.evaluation.model = EvaluationModel() +
                               Criterion(id = "Marginal power",
                                         method = "MarginalPower",
                                         tests = tests("Placebo vs treatment"),
                                         labels = c("Placebo vs treatment"),
                                         par = parameters(alpha = 0.025))

# Simulation Parameters
case.study1.sim.parameters = SimParameters(n.sims = 1000, proc.load = 2, seed = 42938001)

# Perform clinical scenario evaluation
case.study1.results = CSE(case.study1.data.model,
                          case.study1.analysis.model,
                          case.study1.evaluation.model,
                          case.study1.sim.parameters)

# Summary of the simulation results
summary(case.study1.results)

# Get the data generated for the simulation
case.study1.data.stack = DataStack(data.model = case.study1.data.model,
                                   sim.parameters = case.study1.sim.parameters)

}


\dontrun{
#Alternatively, a DataStack object can be used in the CSE function
# (not recommanded as the computational time is increased)

# Generate data
case.study1.data.stack = DataStack(data.model = case.study1.data.model,
                                   sim.parameters = case.study1.sim.parameters)

# Perform clinical scenario evaluation with data stack
case.study1.results = CSE(case.study1.data.stack,
                          case.study1.analysis.model,
                          case.study1.evaluation.model,
                          case.study1.sim.parameters)
}

}
\references{
Benda, N., Branson, M., Maurer, W., Friede, T. (2010). Aspects
of modernizing drug development using clinical scenario planning and
evaluation. Drug Information Journal. 44, 299-315.

\url{http://gpaux.github.io/Mediana/}
}
\seealso{
See Also \code{\link{DataModel}}, \code{\link{DataStack}},
\code{\link{AnalysisModel}}, \code{\link{EvaluationModel}},
\code{\link{SimParameters}}.
}
