# Mediana 1.0.4

## New features

## Bug fixes


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
