---
layout: page
title: Clinical Scenario Evaluation
header: Clinical Scenario Evaluation
group: navigation
---
{% include JB/setup %}

## Summary

Clinical Scenario Evaluation (CSE) is performed based on the data, analysis and evaluation models as well as simulation parameters specified by the user. The simulation parameters are defined using the `SimParameters` object.

## Clinical Scenario Evaluation

### `SimParameters` object

#### Description

The `SimParameters` object is a required argument of the `CSE` function and has the following arguments:

- `n.sims` defines the number of simulations.
- `seed` defines the seed to be used in the simulations.
- `proc.load` defines the processor load in parallel computations.

The `proc.load` argument is used to define the number of processor cores dedicated to the simulations. A numeric value can be defined as well as character value which automatically detects the number of cores:

- `low`: 1 processor core.

- `med`: Number of available processor cores / 2.

- `high`: Number of available processor cores 1.

- `full`: All available processor cores.

#### Examples

Examples of `SimParameters` object specification:

Perform 10000 simulations using all available processor cores:

{% highlight R %}
SimParameters(n.sims = 10000, 
              proc.load = "full", 
              seed = 42938001)
{% endhighlight %}

Perform 10000 simulations using 2 processor cores:

{% highlight R %}
SimParameters(n.sims = 10000, 
              proc.load = 2, 
              seed = 42938001)
{% endhighlight %}


### `CSE` function

#### Description

The `CSE` function is invoked to runs simulations under the Clinical Scenario Evaluation approach. This function uses four arguments:

- `data` defines a `DataModel` object.

- `analysis` defines an `AnalysisModel` object.

- `evaluation` defines an `EvaluationModel` object.

- `simulation` defines a `SimParameters` object.

#### Examples

The following example illustrates the use of the `CSE` function:

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

Once Clinical Scenario Evaluation-based simulations have been run, the `CSE` object returned by the `CSE` function contains a list with the following components:

- `simulation.results`: a data frame containing the results of the simulations for each scenario.

- `analysis.scenario.grid`: a data frame containing the grid of the combination of data and analysis scenarios.

- `data.structure`: a list containing the data structure according to the `DataModel` object.

- `analysis.structure`: a list containing the analysis structure according to the `AnalysisModel` object.

- `evaluation.structure`: a list containing the evaluation structure according to the `EvaluationModel` object.

- `sim.parameters`: a list containing the simulation parameters according to `SimParameters` object.

- `timestamp`: a list containing information about the start time, end time and duration of the simulation runs.

The simulation results can be summarized in the R console using the `summary` function:

{% highlight R %}
summary(case.study1.results)
{% endhighlight %}

A Microsoft Word-based simulation report can be generated from the simulation results produced by the `CSE` function using the `GenerateReport` function, see [Simulation report](Reporting.html).

