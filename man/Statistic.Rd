\name{Statistic}
\alias{Statistic}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Statistic object
}
\description{
This function creates an object of class \code{Statistic} which can be added to an object of class \code{AnalysisModel}.
}
\usage{
Statistic(id, method, samples, par = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{id}{
defines the ID of the statistic.
}
  \item{method}{
defines the type of statistics/method for computing the statistic.
}
  \item{samples}{
defines a list of sample(s) (defined in the data model) to be used by the statistic method.
}
  \item{par}{
defines the parameter(s) of the method for computing the statistic.
}
}
\details{
Objects of class \code{Statistic} are used in objects of class \code{AnalysisModel} to define the statistics to produce. Several objects of class \code{Statistic} can be added to an object of class \code{AnalysisModel}.

\code{method} argument defines the statistical method. Several methods are already implemented in the Mediana package (listed below, along with the required parameters to define in the \code{par} parameter):
\itemize{
\item \code{MedianStat}: generate the median of the sample defined in the \code{samples} argument.
\item \code{MeanStat}: generate the mean of the sample defined in the \code{samples} argument.
\item \code{SdStat}: generate the standard deviation of the sample defined in the \code{samples} argument.
\item \code{MinStat}: generate the minimum of the sample defined in the \code{samples} argument.
\item \code{MaxStat}: generate the maximum of the sample defined in the \code{samples} argument.
\item \code{DiffMeanStat}: generate the difference of means between the two samples defined in the \code{samples} argument. Two samples must be defined.
\item \code{EffectSizeContStat}: generate the effect size for a continuous endpoint. Two samples must be defined.
\item \code{RatioEffectSizeContStat}: generate the ratio of two effect sizes for a continuous endpoint. Four samples must be defined.
\item \code{DiffPropStat}: generate the difference of the proportions between the two samples defined in the \code{samples} argument. Two samples must be defined.
\item \code{EffectSizePropStat}: generate the effect size for a binary endpoint. Two samples must be defined.
\item \code{RatioEffectSizePropStat}: generate the ratio of two effect sizes for a binary endpoint. Four samples must be defined.
\item \code{HazardRatioStat}: generate the hazard ratio of the two samples defined in the \code{samples} argument. Two samples must be defined.
\item \code{EffectSizeEventStat}: generate the effect size for a survival endpoint (log of the HR). Two samples must be defined. Two samples must be defined.
\item \code{RatioEffectSizeEventStat}: generate the ratio of two effect sizes for a survival endpoint. Four samples must be defined.
\item \code{EventCountStat}: generate the number of events observed in the sample(s) defined in the \code{samples} argument.
\item \code{PatientCountStat}: generate the number of patients observed in the sample(s) defined in the \code{samples} argument.
}
}

\references{
\url{http://biopharmnet.com/mediana}
}

\seealso{
See Also \code{\link{AnalysisModel}}.
}
\examples{
# Analysis model
analysis.model = AnalysisModel() +
                 Test(id = "Placebo vs treatment",
                      samples = samples("Placebo", "Treatment"),
                      method = "TTest") +
                 Statistic(id = "Mean Treatment",
                           method = "MeanStat",
                           samples = samples("Treatment"))
}
