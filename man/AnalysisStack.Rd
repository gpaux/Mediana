\name{AnalysisStack}
\alias{AnalysisStack}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{AnalysisStack object
}
\description{
This function generates analysis results according to the specified data and analysis models.
}
\usage{
AnalysisStack(data.model,
              analysis.model,
              sim.parameters)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data.model}{
defines a \code{DataModel} object.
}
  \item{analysis.model}{
defines a \code{AnalysisModel} object.
}
  \item{sim.parameters}{
defines a \code{SimParameters} object.
}
}
\value{
This function generates an analysis stack according to the data and analysis models and the simulation parameters objetcs. The object returned by the function is a AnalysisStack object containing:
  \item{description }{a description of the object.}
  \item{analysis.set }{a list of size \code{n.sims} defined in the \code{sim.parameters} object. This list contains the analysis results generated for each data scenario (first level), and for each test and statistic defined in the \code{analysis.parameters} object. The results generated for the \code{i}th simulation runs and the \code{j}th data scenario are stored in \code{analysis.stack$analysis.set[[i]][[j]]$result}. Then, this list is composed of three lists:
\itemize{
\item \code{tests} return the unadjusted p-values for to the tests defined in the \code{AnalysisModel} object.
\item \code{statistic} return the statistic defined in the \code{AnalysisModel} object.
\item \code{test.adjust} return a list of adjusted p-values according to the multiple testing procedure defined in the \code{AnalysisModel} object. The lenght of this list corresponds to the number of \code{MultAdjProc} objects defined in the \code{AnalysisModel} object.
where \code{analysis.stack} is a \code{AnalysisStack} object.
}
}
  \item{analysis.scenario.grid }{a data frame indicating all analysis scenarios according to the \code{DataModel} and \code{AnalysisModel} objects.}
  \item{analysis.structure }{a list containing the analysis structure according to the \code{AnalysisModel} object.}
  \item{sim.parameters }{a list containing the simulation parameters according to \code{SimParameters} object.}

  A specific \code{analysis.set} of a \code{AnalysisStack} object can be extracted using the \code{ExtractAnalysisStack} function.

}

\references{
http://gpaux.github.io/Mediana/
}

\seealso{
See Also \code{\link{DataModel}}, \code{\link{AnalysisModel}} and \code{\link{SimParameters}} and \code{\link{ExtractAnalysisStack}}.
}
\examples{
\dontrun{
# Generation of an AnalysisStack object
##################################

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
       method = "TTest") +
  Statistic(id = "Mean Treatment",
            method = "MeanStat",
            samples = samples("Treatment"))


# Simulation Parameters
case.study1.sim.parameters = SimParameters(n.sims = 100,
                                           proc.load = 2,
                                           seed = 42938001)

# Generate data
case.study1.analysis.stack = AnalysisStack(data.model = case.study1.data.model,
                                           analysis.model = case.study1.analysis.model,
                                           sim.parameters = case.study1.sim.parameters)

# Print the analysis results generated in the 100th simulation run
# for the 2nd data scenario for both samples
case.study1.analysis.stack$analysis.set[[100]][[2]]

# Extract the same set of data
case.study1.extracted.analysis.stack =
  ExtractAnalysisStack(analysis.stack = case.study1.analysis.stack,
                       data.scenario = 2,
                       simulation.run = 100)

# A carefull attention should be paid on the index of the result.
# As only one data.scenario has been requested
# the result for data.scenario = 2 is now in the first position ($analysis.set[[1]][[1]]).
}
}
