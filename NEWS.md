# Mediana 1.0.5

## New features

*
 
## Bug fixes

* 

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
