---
layout: page
title: Analysis Stack
header: Analysis Stack
group: navigation
---
{% include JB/setup %}

## `AnalysisStack` function

The `AnalysisStack` function can be used to get the results generated in the Clinical Scenario Evaluation. The generation of the analysis stack is based on the pre-defined `DataModel`, `AnalysisModel` and `SimParameters` objects. 

### Description

#### Inputs

The `AnalysisStack` function requires the input of three pre-specified objects defined in the following three arguments:

- `data.model` defines a `DataModel` object, as described in this [page](DataModel).

- `analysis.model` defines an `AnalysisModel` object, as described in this [page](AnalysisModel).

- `sim.parameters` defines a `SimParameters` object, as described in this [page](CSE.html#SimParametersobject).

#### Outputs

The `AnalysisStack` function returns an `AnalysisStack` object containing a list with the following components:

- `description`: a description of the object.

- `analysis.set`: a list of size `n.sims` defined in the `SimParameters` object. This list contains the analysis results generated for each data scenario (first level), and for each test and statistic defined in the `AnalysisModel` object. The results generated for the *i*th simulation runs and the *j*th data scenario are stored in `analysis.stack$analysis.set[[i]][[j]]$result` (where `analysis.stack` is a `AnalysisStack` object). Then, this list is composed of three lists:

	- `tests` return the unadjusted p-values for to the tests defined in the `AnalysisModel` object.

	- `statistic` return the statistic defined in the `AnalysisModel` object.

	- `test.adjust` return a list of adjusted p-values according to the multiple testing procedure(s) defined in the `AnalysisModel` object. The lenght of this list corresponds to the number of `MultAdjProc` objects defined in the `AnalysisModel` object. Note that if no `MultAdjProc` objects have been defined, this list contains the unadjusted p-values.
	
- `analysis.scenario.grid`: a data frame indicating all data and analysis scenarios according to the `DataModel` and `AnalysisModel` objects.

- `analysis.structure`: a list containing the analysis structure according to the `AnalysisModel` object.

- `sim.parameters`: a list containing the simulation parameters according to `SimParameters` object.

### Example

The following example illustrates the use of the `AnalysisStack` function.

In this example, we will use the data model and simulation parameters specified in the Case study 1 for normally distributed endpoints (see [Case study 1](CaseStudy01.html#Normallydistributedendpoint)). 

#### Specification of the `DataModel` object

The data model is specified below:

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
{% endhighlight %}

#### Specification of the `AnalysisModel` object

The analysis model is specified below:

{% highlight R %}
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "TTest") +
  Statistic(id = "Mean Treatment",
            method = "MeanStat",
            samples = samples("Treatment"))
{% endhighlight %}

#### Specification of the `SimParameters` object

Additionally, the simulation parameters are specified:

{% highlight R %}
# Simulation Parameters
case.study1.sim.parameters = SimParameters(n.sims = 1000, proc.load = 2, seed = 42938001)
{% endhighlight %}

#### Data generation

The results generated in the CSE function can be obtained using the `AnalysisStack` function as follows:

{% highlight R %}
# Generate results
case.study1.analysis.stack = AnalysisStack(data.model = case.study1.data.model,
                                           analysis.model = case.study1.analysis.model,
                                           sim.parameters = case.study1.sim.parameters)
{% endhighlight %}

### Manipulation of an `AnalysisStack` object

Once the `AnalysisStack` object has been generated, the user can manipulate the object easily as it is structure as a `list` object. Basically, the results sets are stored in the `analysis.set` level of the object. This length of the list corresponds to the number of simulations specified in the `SimParameters` object. 

{% highlight R %}
# Print all data sets generated for all simulations
case.study1.analysis.stack$analysis.set
{% endhighlight %}

Within each simulation run, a nested list is used to store the results set for each data and analysis scenario, for each test and statistic. For example, the user can access to the results generated in the 100th simulation run for the 2nd data scenario as follows:

{% highlight R %}
# Print the data set generated in the 100th simulation run for the 2nd data scenario
case.study1.analysis.stack$analysis.set[[100]][[2]]
{% endhighlight %}

## `ExtractAnalysisStack` function

To ease the manipulation of a `AnalysisStack` object, a function has been created to extract a particular set of results stack according to the data scenario and simulation runs index.

### Description

#### Inputs

The `ExtractAnalysisStack` function requires the input of a pre-specified object defined in the following two arguments:

- `analysis.stack` defines a `AnalysisStack` object, as described above.

- `data.scenario` defines the data scenario index to extract. By default all data scenarios will be extracted.

- `simulation.run` defines the simulation run index. By default all simulation runs will be extracted.

#### Outputs

The `ExtractAnalysisStack` function returns a list having the same structure as the `analysis.set` argument of a `AnalysisStack` object

- `analysis.set`: a list of size corresponding to the number of simulation runs specified by the user defined in the `simulation.run` argument. This list contains the results generated for each data scenario (`data.scenario` argument) specified by the user.

### Example

Returning to our example, the user can extract the results generated for the 100th simulation run and the 2nd data scenario as follows:

{% highlight R %}
case.study1.extracted.analysis.stack =
  ExtractAnalysisStack(analysis.stack = case.study1.analysis.stack,
                       data.scenario = 2,
                       simulation.run = 100)
{% endhighlight %}

A carefull attention should be paid on the index of the nested lists. As only one simulation run index has been specified in this example, the result for the 100th simulation runs is stored in the first level of the list (`case.study1.extracted.analysis.stack$analysis.set[[1]]`). Similarly, as only one data scenario has been requested, the result for the 2nd data scenario is now in the first position (`case.study1.extracted.analysis.stack$analysis.set[[1][[1]]`).