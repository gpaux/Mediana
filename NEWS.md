# Mediana 1.0.6

## New features

* Addition of the Proportion statistic (`PropStat`, see [Analysis model](http://gpaux.github.io/Mediana/AnalysisModel.html#Statisticobject)).
 
* Addition of the Fallback procedure (`FallbackAdj`, see [Analysis model](http://gpaux.github.io/Mediana/AnalysisModel.html#MultAdjProcobject)).
 
* Addition of a function to get the analysis results generated in the CSE using the `AnalysisStack` function (see [Analysis stack](http://gpaux.github.io/Mediana/AnalysisStack.html)).
 
* Addition of the `ExtractAnalysisStack` function to extract a specific set of results in an `AnalysisStack` object (see [Analysis stack](http://gpaux.github.io/Mediana/AnalysisStack.html#ExtractAnalysisStack.html)).

* Creation of a vignette to describe the functions implementing the adjusted *p*-values (`AdjustPvalues`) and one-sided simultaneous confidence intervals (`AdjustCIs`).

* Minor revisions of the generated report

* It is now possible to use an option to specify the desirable direction of the treatment effect in a test, e.g., `larger = TRUE` means that numerically larger values are expected in the second sample compared to the first sample and `larger = FALSE` otherwise.  This is an optional argument for all two-sample statistical tests to be included in the Test object. By default, if this argument is not specified, it is expected that a numerically larger value is expected in the second sample (i.e., by default `larger = TRUE`).

## Bug fixes

* Due to difficulties for several users to install the Mediana R package because of java issue, the `ReporteRs` R pacakage is not required anymore (remove from Imports). However, to be able to generate the report, the user will require to have the `ReporteRs` R package installed.

* Minor revision to the two-sample non-inferiority test for proportions to ensure that the number of successes is not greater than the sample size
 
# Mediana 1.0.5

## New features

* Addition of the `AdjustPvalues` function which can be used to get adjusted p-values from a Multiple Testing Procedure. This function cannot be used within the CSE framework but it is an add-on function to compute adjusted p-values.

* Addition of the `AdjustCIs` function which can be used to get simultaneous confidence intervals from a Multiple Testing Procedure. This function cannot be used within the CSE framework but it is an add-on function to simultaneous confidence intervals.

* Creation of vignettes
 
## Bug fixes

* Revision of the dropout generation mechanism for time-to-event endpoints.

# Mediana 1.0.4

## New features

* Addition of the Fixed-sequence procedure (`FixedSeqAdj`, see [Analysis model](http://gpaux.github.io/Mediana/AnalysisModel.html#MultAdjProcobject)).

* Addition of the Cox method to calculate the HR, effect size and ratio of effect size for time-to-event endpoint. This can be accomplished by setting the  `method` argument in the parameter list to set-up the calculation based on the Cox method. (`par = parameters(method = "Cox"`), see [Analysis model](http://gpaux.github.io/Mediana/AnalysisModel.html#Statisticobject)).

* Addition of the package version information in the report.
 
## Bug fixes

* Revision of one-sided p-value computation for Log-Rank test.

* Revision of the call for Statistic in the core function (not visible).

* Revision of the function to calculate the Hazard Ratio Statistic (HazardRatioStat method). By default, this calculation is now based on the log-rank statistic ((O2/E2)/(O1/E1) where O and E are Observed and Expected event in sample 2 and sample 1. A parameter can be added using the `method` argument in the parameter list to set-up the calculation based on the Cox method (`par = parameters(method = "Cox"`), see [Analysis model](http://gpaux.github.io/Mediana/AnalysisModel.html#Statisticobject)).

* Revision of the function to calculate the effect size for time-to-event endpoint (`EffectSizeEventStat` method, based on the `HazardRatioStat` method)

* Revision of the functions to calculate the ratio of effect size for continuous (`RatioEffectSizeContStat` method), binary (`RatioEffectSizePropStat` method) and event (`RatioEffectSizeEventStat method`) endpoint.

* Revision of the function to generate the Test, Statistic, Design and result tables in the report.

# Mediana 1.0.3

## New features

* Addition of the Beta distribution (`BetaDist`, see [Data model](http://gpaux.github.io/Mediana/DataModel.html#OutcomeDistobject)).

* Addition of the Truncated exponential distribution, which could be used as enrollment distribution (`TruncatedExpoDist`, see [Data model](http://gpaux.github.io/Mediana/DataModel.html#OutcomeDistobject)).

* Addition of the Non-inferiority test for proportion (`PropTestNI`, see [Analysis model](http://gpaux.github.io/Mediana/AnalysisModel.html#Testobject)).

* Addition of the mixture-based gatekeeping procedure (`MixtureGatekeepingAdj` see [Analysis model](http://gpaux.github.io/Mediana/AnalysisModel.html#MultAdjProcobject)).

* Addition of a function to get the data generated in the CSE using the `DataStack` function (see [Data stack](http://gpaux.github.io/Mediana/DataStack.html)).

* Addition of a function to extract a specific set of data in a `DataStack` object (see [Data stack](http://gpaux.github.io/Mediana/DataStack.html#ExtractDataStack)).

* Addition of the "Evaluation Model" section in the generated report describing the criteria and their parameters (see [Simulation report](http://gpaux.github.io/Mediana/Reporting.html#Description18)).


## Bug fixes

* Revision of the generation of dropout time.

* Correction of the `NormalParamAdj` function.

* Correction of the `FisherTest` function.
