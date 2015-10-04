---
layout: page
title: Analysis Model
header: Analysis Model
group: navigation
---
{% include JB/setup %}

## About


Analysis models define statistical methods that are applied to the study data in a clinical trial.

## Initialization

An Analysis Model can be initialized using the following command

{% highlight R %}
# AnalysisModel initialization
analysis.model = AnalysisModel()
{% endhighlight %}

Initialization with this command is higlhy recommended as it will simplify the add of related objects, such as 
`MultAdj`, `MultAdjProc`, `MultAdjStrategy`, `Test`, `Statistic` objects.

## Specific objects

Once an `AnalysisModel` object has been initialized, specific objects can be added by using the '+' operator to add objects to it.


### Test

#### Description

Specify a statistical test that will be applied to the data. A `Test` object is defined by four arguments:

- `id`, which defines the ID of the test.
- `method`, which defines the statistical test method.
- `samples`, which defines the samples (pre-defined in the data model) to be used within the statistical test method.  
- `par`, which defines the parameter(s) of the statistical test method.

Several methods are already implemented in the Mediana package (listed below, along with the required parameters to define in the par parameter):

- `TTest`: perform a **two-sample t-test** between the two samples defined in the samples argument.

- `TTestNI`: perform a **non-inferiority two-sample t-test** between the two samples defined in the samples argument. Required parameter: `delta`.

- `WilcoxTest`: perform a **Wilcoxon-Mann-Whitney test** between the two samples defined in the samples argument.

- `PropTest`: perform a **two-sample test for proportions** between the two samples defined in the samples argument. Optional parameter: `yates` (Yates' continuity correction `TRUE` or `FALSE`).

- `FisherTest`: perform a **Fisher exact test** between the two samples defined in the samples argument.

- `GLMPoissonTest`: perform a **Poisson regression test** between the two samples defined in the samples argument.

- `GLMNegBinomTest`: perform a **Negative-binomial regression test** between the two samples defined in the samples argument.

- `LogrankTest`: perform a **Log-rank test** between the two samples defined in the samples argument.

It is to be noted that the statistical tests implemented are **one-sided** and thus the sample order is important. In particular, the Mediana package assumes that a numerically larger value of the endpoint is expected in Sample 2 compared to Sample 1. Suppose, for example, that a higher treatment response indicates a beneficial effect (e.g., higher improvement rate). In this case Sample 1 should include control patients whereas
Sample 2 should include patients allocated to the experimental treatment arm. The sample order needs to be reversed if a beneficial treatment effect is associated with a lower value of the endpoint (e.g., lower blood pressure).

Several `Test` objects can be added to an `AnalysisModel`object.

For more information about the `Test` object, see the R documentation [Test]().

#### Example

Example of `Test` objects:

- **Two-sample t-test**

{% highlight R %}
# Placebo and Treatment samples have been previously defined in the data model
Test(id = "Placebo vs treatment",
     samples = samples("Placebo", "Treatment"),
     method = "TTest")
{% endhighlight %}


- **Two-sample t-test with pooled samples**

{% highlight R %}
# Placebo M-, Placebo M+, Treatment M- and Treatment M+ samples have been previously defined in the data model
Test(id = "OP test",
     samples = samples(c("Placebo M-", "Placebo M+"),
                       c("Treatment M-", "Treatment M+")),
     method = "TTest") +
{% endhighlight %}

### Statistic

#### Description

Specify a statistical calculations that will be applied to the data. A `Statistic` object is defined by four arguments:

- `id`, which defines the ID of the statistic.
- `method`, which defines the type of statistics/method for computing the statistic.
- `samples`, which defines the samples (pre-defined in the data model) to be used within the statistic method.  
- `par`, which defines the parameter(s) of the statistic method.

Several methods are already implemented in the Mediana package (listed below, along with the required parameters to define in the par parameter):

- `MedianStat`: generate the **median** of the sample defined in the samples argument.

- `MeanStat`: generate the **mean** of the sample defined in the samples argument.

- `SdStat`: generate the **standard deviation** of the sample defined in the samples argument.

- `MinStat`: generate the **minimum** of the sample defined in the samples argument.

- `MaxStat`: generate the **maximum** of the sample defined in the samples argument.

- `DiffMeanStat`: generate the **difference of means** between the two samples defined in the samples argument. Two samples must be defined.

- `EffectSizeContStat`: generate the **effect size** for a continuous endpoint. Two samples must be defined.

- `RatioEffectSizeContStat`: generate the **ratio of two effect sizes** for a continuous endpoint. Four samples must be defined.

- `DiffPropStat`: generate the **difference of the proportions** between the two samples defined in the samples argument. Two samples must be defined.

- `EffectSizePropStat`: generate the **effect size** for a binary endpoint. Two samples must be defined.

- `RatioEffectSizePropStat`: generate the **ratio of two effect sizes** for a binary endpoint. Four samples must be defined.

- `HazardRatioStat`: generate the **hazard ratio** of the two samples defined in the samples argument. Two samples must be defined.

- `EffectSizeEventStat`: generate the **effect size** for a survival endpoint (log of the HR). Two samples must be defined. Two samples must be defined.

- `RatioEffectSizeEventStat`: generate the **ratio of two effect sizes** for a survival endpoint. Four samples must be defined.

- `EventCountStat`: generate the **number of events** observed in the sample(s) defined in the samples argument.

- `PatientCountStat`: generate the **number of patients** observed in the sample(s) defined in the samples argument

Several `Statistic` objects can be added to an `AnalysisModel`object.

For more information about the `Statistic` object, see the R documentation [Statistic]().

#### Example

Example of `Statistic` objects:
- **Mean statistic**
{% highlight R %}
# Placebo and Treatment samples have been previously defined in the data model
Statistic(id = "Mean Treatment",
          method = "MeanStat",
          samples = samples("Treatment"))
{% endhighlight %}


### MultAdjProc

#### Description

Specify a multiplicity adjustment procedure that will be applied to the statistical tests to adjust the p-value in order to protect the overall Type-I error rate. A `MultAdjProc` object is defined by three arguments:

- `proc`, which defines a multiplicity adjustment procedure.
- `par`, which defines the parameter(s) of the multiplicity adjustment procedure (optional).
- `tests`, which defines the tests (pre-defined in the analysis model) to be used within the multiplicity adjustment procedure.  

If no `tests` are defined, the multiplicity adjustment procedure will be applied to all tests defined in the `AnalysisModel` object.

Several procedures are already implemented in the Mediana package (listed below, along with the required or optional parameters to specify in the par argument):

- `BonferroniAdj`: **Bonferroni** procedure. Optional parameter: `weight`.

- `HolmAdj`: **Holm** procedure. Optional parameter: `weight`.

- `HochbergAdj`: **Hochberg** procedure. Optional parameter: `weight`.

- `HommelAdj`: **Hommel** procedure. Optional parameter: `weight`.

- `ChainAdj`: Family of **chain procedures**. Required parameters: `weight` and `transition`.

- `NormalParamAdj`: **Parametric multiple testing procedure** derived from a multivariate normal distribution. Required parameter: `corr`. Optional parameter: `weight`.

- `ParallelGatekeepingAdj`: Family of **parallel gatekeeping procedures**. Required parameters: `family`, `proc`, `gamma`.

- `MultipleSequenceGatekeepingAdj`: Family of **multiple-sequence gatekeeping procedures**. Required parameters: `family`, `proc`, `gamma`.

Several `MultAdjProc` objects can be added to an `AnalysisModel`object, using the '+' operator or by grouping them into a MultAdj object.

For more information about the `MultAdjProc` object, see the R documentation [MultAdjProc]().

#### Example

Example of `MultAdjProc` objects:

- **Chain procedure**

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

- **Multiple-sequence gatekeeping procedure**

{% highlight R %}
# Parameters of the Multiple-sequence gatekeeping procedure
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

### MultAdjStrategy

#### Description

Specify a multiplicity adjustment strategy that will be applied to the Clinical Scenario Evaluation. This function can be used when several Multiplicity Adjustment Procedures have to be used, e.g. when several case studies are simulated into the same Clinical Scenario Evaluation.

A `MultAdjStrategy` object wraps up object of class `MultAdjProc`.

For more information about the `MultAdjStrategy` object, see the R documentation [MultAdjStrategy]().

#### Examples

Examples of `MultAdjStrategy` object:

- **Clinical Scenario Evaluation with two clinical trials and three endpoints**

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


### MultAdj

#### Description

This function can be used to wrap-up several objects of class `MultAdjProc` or `MultAdjStrategy` and add them to an object of class `AnalysisModel`. Its use is optional as objects of class `MultAdjProc` or `MultAdjStrategy` can be added to an object of class `AnalysisModel` incrementally using the '+' operator.

For more information about the `MultAdj` object, see the R documentation [MultAdj]().

#### Examples

Examples of `MultAdj` object:

- **Clinical Scenario Evaluation with three Multiplicity Adjustment Procedures to compare**

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

# Equivalent to:
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