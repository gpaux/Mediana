---
layout: page
title: CSE
header: CSE
group: navigation
---
{% include JB/setup %}

## About

Clinical Scenario Evaluation (CSE) is performed according to the data, analysis and evaluation models. The simulation parameters are specified in a `SimParameter` object.

## Clinical Trial Simulations

### SimParameters

#### Description

Specify the simulation parameters. A `SimParameter` object is defined by three arguments:

- `n.sims`, which defines the number of simulations.
- `seed`, which defines the seed for the simulations.
- `proc.load`, which defines the load of the processor (parallel computation).

The `proc.load` argument is used to define the number of clusters dedicated to the simulations. Numeric value can be defined as well as character value which automatically detect the number of cores:

- `low`: 1 processor core.

- `med`: Number of available processor cores / 2.

- `high`: Number of available processor cores 1.

- `full`: All available processor cores.

#### Examples

Example of `SimParameter` objects:

- **10000 simulation runs using all available processor cores**

{% highlight R %}
SimParameters(n.sims = 10000, 
              proc.load = "full", 
              seed = 42938001)
{% endhighlight %}

- **10000 simulation runs using 2 processor cores**

{% highlight R %}
SimParameters(n.sims = 10000, 
              proc.load = 2, 
              seed = 42938001)
{% endhighlight %}


### CSE

#### Description

This `CSE` is used to perform the Clinical Scenario Evaluation according to the `DataModel`, `AnalysisModel` and `EvaluationModel` objects specified respectively in the arguments `data`, `analysis` and `evaluation` of the function.

The `CSE` function uses four arguments:

- `data`, which defines a `DataModel` object

- `analysis`, which defines an `AnalysisModel` object

- `evaluation`, which defines an `EvaluationModel` object

- `simulation`, which defines a `SimParameters` object

#### Examples

Example of use of the `CSE` function:

{% highlight R %}
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
{% endhighlight %}


### Summary of results

Once the Clinical Scenario Evaluation has been performed, the `CSE`  object returned by the `CSE` function contains a list with:

- `simulation.results`, a data frame containing the results of the simulations for each scenario.

- `analysis.scenario.grid`, a data frame containing the grid of the combination of data and analysis scenarios.

- `data.structure`, a list containing the data structure according to the `DataModel` object.

- `analysis.structure`, a list containing the analysis structure according to the `AnalysisModel` object.

- `evaluation.structure`, a list containing the evaluation structure according to the `EvaluationModel` object.

- `sim.parameters`, a list containing the simulation parameters according to SimParameters object.

- `timestamp`, a list containing information about the start time, end time and duration of the simulation runs.

The simulation results can be summarized in the R console using the function `summary`:

{% highlight R %}
summary(case.study1.results)
{% endhighlight %}

A word-based simulation report can be generated using the function `GenerateReport`, presented in the page [Reporting](Reporting.html).

