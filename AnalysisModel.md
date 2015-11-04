---
layout: page
title: Analysis Model
header: Analysis Model
group: navigation
---
{% include JB/setup %}

## Summary

Analysis models define statistical methods (e.g., significance tests or descriptive statistics) that are applied to the study data in a clinical trial.

## Initialization

An analysis model can be initialized using the following command:

{% highlight R %}
# AnalysisModel initialization
analysis.model = AnalysisModel()
{% endhighlight %}

It is highly recommended to use this command to initialize an analysis model as it will simplify the process of specifying components of the data model, including the `MultAdj`, `MultAdjProc`, `MultAdjStrategy`, `Test`, `Statistic` objects.

## Components of an analysis model

After an `AnalysisModel` object has been initialized, components of the analysis model can be specified by adding objects to the model using the '+' operator as shown below.

### `Test` object

#### Description

This object specifies a significance test that will be applied to one or more samples defined in a data model. A `Test` object is defined by the following four arguments:

- `id` defines the test's unique ID (label).

- `method` defines the significance test.

- `samples` defines the IDs of the samples (defined in the data model) that the significance test is applied to.

- `par` defines the parameter(s) of the statistical test.

Several commonly used significance tests are already implemented in the Mediana package. In addition, the user can easily define custom significance tests. The built-in tests are listed below along with the required parameters that need to be included in the `par` argument:

- `TTest`: perform the **two-sample t-test** between the two samples defined in the `samples` argument.

- `TTestNI`: perform the **non-inferiority two-sample t-test** between the two samples defined in the `samples` argument. Required parameter: `delta` (positive non-inferiority margin).

- `WilcoxTest`: perform the **Wilcoxon-Mann-Whitney test** between the two samples defined in the `samples` argument.

- `PropTest`: perform the **two-sample test for proportions** between the two samples defined in the `samples` argument. Optional parameter: `yates` (Yates' continuity correction flag that is set to `TRUE` or `FALSE`).

- `FisherTest`: perform the **Fisher exact test** between the two samples defined in the `samples` argument.

- `GLMPoissonTest`: perform the **Poisson regression test** between the two samples defined in the `samples` argument.

- `GLMNegBinomTest`: perform the **Negative-binomial regression test** between the two `samples` defined in the `samples` argument.

- `LogrankTest`: perform the **Log-rank test** between the two samples defined in the `samples` argument.

It needs to be noted that the significance tests listed above are implemented as **one-sided** tests and thus the sample order in the `samples` argument is important. In particular, the Mediana package assumes that a numerically larger value of the endpoint is expected in Sample 2 compared to Sample 1. Suppose, for example, that a higher treatment response indicates a beneficial effect (e.g., higher improvement rate). In this case Sample 1 should include control patients whereas
Sample 2 should include patients allocated to the experimental treatment arm. The sample order needs to be reversed if a beneficial treatment effect is associated with a lower value of the endpoint (e.g., lower blood pressure).

Several `Test` objects can be added to an `AnalysisModel`object.

For more information about the `Test` object, see the package's documentation [Test](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf) on the CRAN web site.

#### Example

Examples of `Test` objects:

Carry out the two-sample t-test:

{% highlight R %}
# Placebo and Treatment samples were defined in the data model
Test(id = "Placebo vs treatment",
     samples = samples("Placebo", "Treatment"),
     method = "TTest")
{% endhighlight %}

Carry out the two-sample t-test with pooled samples:

{% highlight R %}
# Placebo M-, Placebo M+, Treatment M- and Treatment M+ samples were defined in the data model
Test(id = "OP test",
     samples = samples(c("Placebo M-", "Placebo M+"),
                       c("Treatment M-", "Treatment M+")),
     method = "TTest") +
{% endhighlight %}

### `Statistic` object

#### Description

This object specifies a descriptive statistic that will be computed based on one or more samples defined in a data model. A `Statistic` object is defined by four arguments:

- `id` defines the descriptive statistic's unique ID (label).

- `method` defines the type of statistic/method for computing the statistic.

- `samples` defines the samples (pre-defined in the data model) to be used for computing the statistic.  

- `par` defines the parameter(s) of the statistic.

Several methods for computing descriptive statistics are already implemented in the Mediana package and the user can also define custom functions for computing descriptive statistics. These methods are shown below along with the required parameters that need to be defined in the `par` argument:

- `MedianStat`: compute the **median** of the sample defined in the `samples` argument.

- `MeanStat`: compute the **mean** of the sample defined in the `samples` argument.

- `SdStat`: compute the **standard deviation** of the sample defined in the `samples` argument.

- `MinStat`: compute the **minimum** value in the sample defined in the `samples` argument.

- `MaxStat`: compute the **maximum** value in the sample defined in the `samples` argument.

- `DiffMeanStat`: compute the **difference of means** between the two samples defined in the `samples` argument. Two samples must be defined.

- `EffectSizeContStat`: compute the **effect size** for a continuous endpoint. Two samples must be defined.

- `RatioEffectSizeContStat`: compute the **ratio of two effect sizes** for a continuous endpoint. Four samples must be defined.

- `DiffPropStat`: compute the **difference of the proportions** between the two samples defined in the `samples` argument. Two samples must be defined.

- `EffectSizePropStat`: compute the **effect size** for a binary endpoint. Two samples must be defined.

- `RatioEffectSizePropStat`: compute the **ratio of two effect sizes** for a binary endpoint. Four samples must be defined.

- `HazardRatioStat`: compute the **hazard ratio** of the two samples defined in the samples argument. Two samples must be defined.

- `EffectSizeEventStat`: compute the **effect size** for a survival endpoint (log of the HR). Two samples must be defined. Two samples must be defined.

- `RatioEffectSizeEventStat`: compute the **ratio of two effect sizes** for a survival endpoint. Four samples must be defined.

- `EventCountStat`: compute the **number of events** observed in the sample(s) defined in the `samples` argument.

- `PatientCountStat`: compute the **number of patients** observed in the sample(s) defined in the `samples` argument

Several `Statistic` objects can be added to an `AnalysisModel` object.

For more information about the `Statistic` object, see the R documentation [Statistic](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

#### Example

Examples of `Statistic` objects:

Compute the mean of a single sample:

{% highlight R %}
# Treatment sample was defined in the data model
Statistic(id = "Mean Treatment",
          method = "MeanStat",
          samples = samples("Treatment"))
{% endhighlight %}


### `MultAdjProc` object

#### Description

This object specifies a multiplicity adjustment procedure that will be applied to the significance tests in order to protect the overall Type I error rate. A `MultAdjProc` object is defined by three arguments:

- `proc` defines a multiplicity adjustment procedure.

- `par` defines the parameter(s) of the multiplicity adjustment procedure (optional).

- `tests` defines the specific tests (defined in the analysis model) to which the multiplicity adjustment procedure will be applied.  

If no `tests` are defined, the multiplicity adjustment procedure will be applied to all tests defined in the `AnalysisModel` object.

Several commonly used multiplicity adjustment procedures are included in the Mediana package. In addition, the user can easily define custom multiplicity adjustments. The built-in multiplicity adjustments are defined below along with the required parameters that need to be included in the `par` argument:

- `BonferroniAdj`: **Bonferroni** procedure. Optional parameter: `weight` (vector of hypothesis weights).

- `HolmAdj`: **Holm** procedure. Optional parameter: `weight` (vector of hypothesis weights).

- `HochbergAdj`: **Hochberg** procedure. Optional parameter: `weight` (vector of hypothesis weights).

- `HommelAdj`: **Hommel** procedure. Optional parameter: `weight` (vector of hypothesis weights).

- `ChainAdj`: Family of **chain procedures**. Required parameters: `weight` (vector of hypothesis weights) and `transition` (matrix of transition parameters).

- `NormalParamAdj`: **Parametric multiple testing procedure** derived from a multivariate normal distribution. Required parameter: `corr` (correlation matrix of the multivariate normal distribution). Optional parameter: `weight` (vector of hypothesis weights).

- `ParallelGatekeepingAdj`: Family of **parallel gatekeeping procedures**. Required parameters: `family` (vectors of hypotheses included in each family), `proc` (vector of procedure names applied to each family), `gamma` (vector of truncation parameters).

- `MultipleSequenceGatekeepingAdj`: Family of **multiple-sequence gatekeeping procedures**. Required parameters: `family` (vectors of hypotheses included in each family), `proc` (vector of procedure names applied to each family), `gamma` (vector of truncation parameters).

Several `MultAdjProc` objects can be added to an `AnalysisModel`object using the '+' operator or by grouping them into a MultAdj object.

For more information about the `MultAdjProc` object, see the package's documentation [MultAdjProc](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

#### Example

Examples of `MultAdjProc` objects:

Apply a multiplicity adjustment based on the chain procedure:

{% highlight R %}
# Parameters of the chain procedure (fixed-sequence procedure)
# Vector of hypothesis weights
chain.weight = c(1, 0)
# Matrix of transition parameters
chain.transition = matrix(c(0, 1,
                            0, 0), 2, 2, byrow = TRUE)

# MultAdjProc
MultAdjProc(proc = "ChainAdj",
            par = parameters(weight = chain.weight,
                             transition = chain.transition))
{% endhighlight %}

Apply a multiple-sequence gatekeeping procedure:

{% highlight R %}
# Parameters of the multiple-sequence gatekeeping procedure
# Tests to which the multiplicity adjustment will be applied (defined in the AnalysisModel)
test.list = tests("Pl vs DoseH - ACR20", 
                  "Pl vs DoseL - ACR20", 
                  "Pl vs DoseH - HAQ-DI", 
                  "Pl vs DoseL - HAQ-DI")

# Hypothesis included in each family (the number corresponds to the position of the test in the test.list vector)
family = families(family1 = c(1, 2), 
                  family2 = c(3, 4))

# Component procedure of each family
component.procedure = families(family1 ="HolmAdj", 
                               family2 = "HolmAdj")

# Truncation parameter of each family
gamma = families(family1 = 0.8, 
                 family2 = 1)

# MultAdjProc
MultAdjProc(proc = "MultipleSequenceGatekeepingAdj",
            par = parameters(family = family, 
                             proc = component.procedure, 
                             gamma = gamma),
            tests = test.list)
{% endhighlight %}

### `MultAdjStrategy` object

#### Description

This object specifies a multiplicity adjustment strategy that can include several multiplicity adjustment procedures. A multiplicity adjustment strategy may be defined when the same Clinical Scenario Evaluation approach is applied to several clinical trials.

A `MultAdjStrategy` object serves as a wrapper for several `MultAdjProc` objects.

For more information about the `MultAdjStrategy` object, see the package's documentation [MultAdjStrategy](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

#### Example

Example of a `MultAdjStrategy` object:

Perform complex multiplicity adjustments based on gatekeeping procedures in two clinical trials with three endpoints:

{% highlight R %}
# Parallel gatekeeping procedure parameters
family = families(family1 = c(1), 
                  family2 = c(2, 3))

component.procedure = families(family1 ="HolmAdj", 
                               family2 = "HolmAdj")

gamma = families(family1 = 0.8, 
                 family2 = 1)

# Multiple sequence gatekeeping procedure parameters for Trial A
mult.adj.trialA = MultAdjProc(proc = "ParallelGatekeepingAdj",
                              par = parameters(family = family,
                                               proc = component.procedure,
                                               gamma = gamma),
                              tests = tests("Trial A Pla vs Trt End1",
                                            "Trial A Pla vs Trt End2",
                                            "Trial A Pla vs Trt End3"))

mult.adj.trialB = MultAdjProc(proc = "ParallelGatekeepingAdj",
                              par = parameters(family = family,
                                               proc = component.procedure,
                                               gamma = gamma),
                              tests = tests("Trial B Pla vs Trt End1",
                                            "Trial B Pla vs Trt End2",
                                            "Trial B Pla vs Trt End3"))

# Analysis model
analysis.model = AnalysisModel() +
  MultAdjStrategy(mult.adj.trialA, mult.adj.trialB) +
  # Tests for study A
  Test(id = "Trial A Pla vs Trt End1",
       method = "PropTest",
       samples = samples("Trial A Plac End1", "Trial A Trt End1")) +
  Test(id = "Trial A Pla vs Trt End2",
       method = "TTest",
       samples = samples("Trial A Plac End2", "Trial A Trt End2")) +
  Test(id = "Trial A Pla vs Trt End3",
       method = "TTest",
       samples = samples("Trial A Plac End3", "Trial A Trt End3")) +
  # Tests for study B
  Test(id = "Trial B Pla vs Trt End1",
       method = "PropTest",
       samples = samples("Trial B Plac End1", "Trial B Trt End1")) +
  Test(id = "Trial B Pla vs Trt End2",
       method = "TTest",
       samples = samples("Trial B Plac End2", "Trial B Trt End2")) +
  Test(id = "Trial B Pla vs Trt End3",
       method = "TTest",
       samples = samples("Trial B Plac End3", "Trial B Trt End3"))
{% endhighlight %}


### `MultAdj` function

#### Description

This function can be used to combine several `MultAdjProc` or  `MultAdjStrategy` objects and add them as a single object to an `AnalysisModel` object . This function is provided mainly for convenience and its use is optional.  Alternatively, `MultAdjProc` or `MultAdjStrategy` objects can be added to an `AnalysisModel` object incrementally using the '+' operator.

For more information about the `MultAdj` object, see the package's documentation [MultAdj](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

#### Example

Example of a `MultAdj` object:

Perform Clinical Scenario Evaluation to compare three candidate multiplicity adjustment procedures:

{% highlight R %}
# Multiplicity adjustments to compare
mult.adj1 = MultAdjProc(proc = "BonferroniAdj")
mult.adj2 = MultAdjProc(proc = "HolmAdj")
mult.adj3 = MultAdjProc(proc = "HochbergAdj")

# Analysis model
analysis.model = AnalysisModel() +
                 MultAdj(mult.adj1, mult.adj2, mult.adj3) +
                 Test(id = "Pl vs Dose L",
                      samples = samples("Placebo", "Dose L"),
                      method = "TTest") +
                 Test(id = "Pl vs Dose M",
                      samples = samples ("Placebo", "Dose M"),
                      method = "TTest") +
                 Test(id = "Pl vs Dose H",
                      samples = samples("Placebo", "Dose H"),
                      method = "TTest")

# Note that the code presented above is equivalent to:
analysis.model = AnalysisModel() +
                 mult.adj1 +
                 mult.adj2 +
                 mult.adj3 +
                 Test(id = "Pl vs Dose L",
                      samples = samples("Placebo", "Dose L"),
                      method = "TTest") +
                 Test(id = "Pl vs Dose M",
                      samples = samples ("Placebo", "Dose M"),
                      method = "TTest") +
                 Test(id = "Pl vs Dose H",
                      samples = samples("Placebo", "Dose H"),
                      method = "TTest")

{% endhighlight %}

## User-defined functions 

If a significance test, descriptive statistic or multiplicity adjustment procedure is not included in the Mediana package, the user can easily define a custom function that implements a test, computes a descriptive statistic or performs a multiplicity adjustment. The user must follow the guidelines presented below to create valid custom functions.

### Custom functions for implementing a significance test

The following template must be used by the user to define a function that implements a significance test in an analysis model. The test-specific components that need to be modified if the user wishes to implement a different test are identified in the comments.

As an example, the function defined below carries out a test named `TemplateTest` with a single required parameter labeled `parameter1`.

{% highlight R %}
# Template of a function to perform a significance test
TemplateTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  # Perform the test
  if (call == FALSE | is.na(call)) {

    ##############################################################
    # Test-specific component
    # Get the test's parameter (stored in the parameter[[2]] list)
    if (is.na(parameter[[2]]$parameter1))
      stop("Analysis model: TemplateTest test: parameter1 must be specified.")

    parameter1 = parameter[[2]]$parameter1
    ##############################################################


    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    ##############################################################
    # Test-specific component
    # The function must return a one-sided p-value (the treatment effect in sample 2 is expected to be numerically larger than the treatment effect in sample 1)
    # The one-sided p-value is computed by calling the "funtest" function and saved in the "result" object
    result = funtest(outcome2.complete, outcome1.complete, parameter1)$p.value
    ##############################################################
  }
  else if (call == TRUE) {
    result = list("TemplateTest", "Parameter1 = ")
  }

  return(result)
}
{% endhighlight %}

### Download 

Click on the icon to download this template:

<center>
  <div class="col-md-12">
    <a href="TemplateTest.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>