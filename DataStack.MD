---
layout: page
title: Data Stack
header: Data Stack
group: navigation
---
{% include JB/setup %}

## `DataStack` function

The `DataStack` function can be used to get the data generated in the Clinical Scenario Evaluation. The generation of the data stack is based on the pre-defined `DataModel` and `SimParameters` objects. 

### Description

#### Inputs

The `DataStack` function requires the input of two pre-specified objects defined in the following two arguments:

- `data.model` defines a `DataModel` object, as described in this [page](DataModel).

- `sim.parameters` defines a `SimParameters` object, as described in this [page](CSE.html#SimParametersobject).

#### Outputs

The `DataStack` function returns a `DataStack` object containing a list with the following components:

- `description`: a description of the object.

- `data.set`: a list of size `n.sims` defined in the `SimParameters` object. This list contains the data generated for each data scenario (`data.scenario` level) and each sample (`sample` level). The data generated for the *i*th simulation run, the *j*th data scenario and the *k*th sample is stored in `data.stack$data.set[[i]]$data.scenario[[j]]$sample[[k]]` where `data.stack` is the `DataStack` object.

- `data.scenario.grid`: a data frame indicating all data scenarios according to the `DataModel` object.

- `data.structure`: a list containing the data structure according to the `DataModel` object.

- `sim.parameters`: a list containing the simulation parameters according to `SimParameters` object.

### Example

The following example illustrates the use of the `DataStack` function.

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

#### Specification of the `SimParameters` object

Additionally, the simulation parameters are specified:

{% highlight R %}
# Simulation Parameters
case.study1.sim.parameters = SimParameters(n.sims = 1000, proc.load = 2, seed = 42938001)
{% endhighlight %}

#### Data generation

The data generated in the CSE function can be obtained using the `DataStack` function as follows:

{% highlight R %}
# Generate data
case.study1.data.stack = DataStack(data.model = case.study1.data.model,
                                   sim.parameters = case.study1.sim.parameters)
{% endhighlight %}

### Manipulation of a `DataStack` object

Once the `DataStack` object has been generated, the user can manipulate the object easily as it is structure as a `list` object. Basically, the data sets are stored in the `data.set` level of the object. This length of the list corresponds to the number of simulations specified in the `SimParameters` object. 

{% highlight R %}
# Print all data sets generated for all simulations
case.study1.data.stack$data.set
{% endhighlight %}

Within each simulation run, a nested list is used to store the data set for each data scenario and each sample. For example, the user can access to the data generated in the 100th simulation run for the 2nd data scenario as follows:

{% highlight R %}
# Print the data set generated in the 100th simulation run for the 2nd data scenario
case.study1.data.stack$data.set[[100]]$data.scenario[[2]]
{% endhighlight %}

Finally, the data set generated for the first sample defined in the data model is accessible as follows:

{% highlight R %}
# Print the data set generated in the 100th simulation run for the 2nd data scenario for the first sample
case.study1.data.stack$data.set[[100]]$data.scenario[[2]]$sample[[1]]
{% endhighlight %}

## `ExtractDataStack` function

To ease the manipulation of a `DataStack` object, a function has been created to extract a particular set of data stack according to the data scenario, sample id and simulation runs index.

### Description

#### Inputs

The `ExtractDataStack` function requires the input of a pre-specified object defined in the following two arguments:

- `data.stack` defines a `DataStack` object, as described above.

- `data.scenario` defines the data scenario index to extract. By default all data scenarios will be extracted.

- `sample.id` defines the sample id to extract. By default all sample ids will be extracted.

- `simulation.run` defines the simulation run index. By default all simulation runs will be extracted.

#### Outputs

The `ExtractDataStack` function returns a list having the same structure as the `data.set` argument of a `DataStack` object

- `data.set`: a list of size corresponding to the number of simulation runs specified by the user defined in the `simulation.run` argument. This list contains the data generated for each data scenario (`data.scenario` argument) and each sample (`sample.id` argument) specified by the user.

### Example

Returning to our example, the user can extract the data set generated for the 100th simulation run and the 2nd data scenario as follows:

{% highlight R %}
case.study1.extracted.data.stack = ExtractDataStack(data.stack = case.study1.data.stack,
                                                    data.scenario = 2,
                                                    simulation.run = 100)
{% endhighlight %}

A carefull attention should be paid on the index of the nested lists. As only one simulation run index has been specified in this example, the result for the 100th simulation runs is stored in the first level of the list (`case.study1.extracted.data.stack$data.set[[1]]`). Similarly, as only one data scenario has been requested, the result for the 2nd data scenario is now in the first position (`case.study1.extracted.data.stack$data.set[[1]]$data.scenario[[1]]`).