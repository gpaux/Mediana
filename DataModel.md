---
layout: page
title: Data Model
header: Data Model
group: navigation
---
{% include JB/setup %}

## About

----------

Data models define the process of generating patient data in clinical trials.

## Initialization

----------

A data model can be initialized using the following command
{% highlight R %}
# DataModel initialization
data.model = DataModel()
{% endhighlight %}

Initialization with this command is higlhy recommended as it will simplify the add of related objects, such as 
`OutcomeDist`, `Sample`, `SampleSize`, `Event`, `Design` objects. 

## Specific objects

----------

Once a `DataModel` object has been initialized, specific objects can be added by using the '+' operator to add objects to it.

### OutcomeDist
Specify the outcome distribution of the generated data. An `OutcomeDist` object is defined by two arguments:

- `outcome.dist`, which defines the outcome distribution.
- `outcome.type`, which defines the outcome type (optional). This arguments only accepts:

	- `standard`: for fixed design setting.
	- `event`: for event-driven design setting.

A single `OutcomeDist` object can be added to a `DataModel`object.

For more information about the `OutcomeDist` object, see the R documentation [OutcomeDist](). A summary of available outcome distributions is presented below:

[insert a table with all available outcome distributions]

Example of `OutcomeDist` object:	
{% highlight R %}
# Outcome distribution
OutcomeDist(outcome.dist = "NormalDist")
{% endhighlight %}

### Sample
Specify a sample (e.g. treatment group). A `Sample` object is defined by three arguments:

- `id`, which defines the ID of the sample.
- `outcome.par`, which defines the parameters of the outcome distribution of the sample.
- `sample.size`, which defines the sample size of the sample (optional).

The `sample.size` argument is optional but must be used to define the sample size if unbalance samples have to be defined. The sample size must be either defined in the `Sample` object or in the `SampleSize` object, but not in both. 

Several `Sample` objects can be added to a `DataModel`object.

For more information about the `Sample` object, see the R documentation [Sample]().

Example of `Sample` objects:

{% highlight R %}
# Outcome parameter set 1
outcome1.placebo = parameters(mean = 0, sd = 70)
outcome1.treatment = parameters(mean = 40, sd = 70)

# Outcome parameter set 2
outcome2.placebo = parameters(mean = 0, sd = 70)
outcome2.treatment = parameters(mean = 50, sd = 70)

# Placebo sample object
Sample(id = "Placebo",
       outcome.par = parameters(outcome1.placebo, outcome2.placebo))

# Treatment sample object
Sample(id = "Treatment",
       outcome.par = parameters(outcome1.treatment, outcome2.treatment))
{% endhighlight %}


### SampleSize
Specify the sample size in case of balanced design (all samples will have the same sample size). A `SampleSize` object is defined by one argument:

- `sample.size`, which specifies a list or vector of sample size(s).

A single `SampleSize` object can be added to a `DataModel`object.

For more information about the `SampleSize` object, see the R documentation [SampleSize]().

Example of `SampleSize` objects:

{% highlight R %}
# Equivalent specification of SampleSize object
SampleSize(c(50, 55, 60, 65, 70))
SampleSize(list(50, 55, 60, 65, 70))
SampleSize(seq(50, 70, 5))
{% endhighlight %}

### Event
Specify the total number of events among all samples in an event-driven clinical trial. A `Event` object is defined by two arguments:

- `n.events`, which defines a vector of number of events required.
- `rando.ratio`, which defines a vector of randomization ratios for each `Sample` object defined in the `DataModel`object.

A single `Event` object can be added to a `DataModel`object.

For more information about the `Event` object, see the R documentation [Event]().

Example of `Event` object with a  2:1 randomization ratio (Treatment:Placebo):

{% highlight R %}
# Event parameters
event.count.total = c(390, 420)
randomization.ratio = c(1,2)

# Event object
Event(n.events = event.count.total, 
      rando.ratio = randomization.ratio)
{% endhighlight %}

### Design
Specify the design parameters used in event-driven designs if the user is interested in modeling the enrollment (or accrual) and dropout (or loss to follow up) processes that will be applied to the Clinical Scenario. A `Design` object is defined by seven arguments:

- `enroll.period`, which defines the length of the enrollment period.
- `enroll.dist`, which defines the enrollment distribution.
- `enroll.dist.par`, which defines the parameters of the enrollment distribution (optional).
- `followup.period`, which defines the length of the follow-up period for each patient in study designs with a fixed follow-up period, i.e., the length of time from the enrollment to planned discontinuation is constant across patients. The user must specify either followup.period or study.duration.
- `study.duration`, which defines the total study duration in study designs with a variable follow-up period. The total study duration is defined as the length of time from the enrollment of the first patient to the discontinuation of the last patient.
- `dropout.dist`, which defines the dropout distribution.
- `dropout.dist.par`, which defines the parameters of the dropout distribution.

Several `Design` objects can be added to a `DataModel`object.

For more information about the `Design` object, see the R documentation [Design]().

Example of `Design` object: 
{% highlight R %}
# Design parameters
Design(enroll.period = 9,
       study.duration = 21,
       enroll.dist = "UniformDist",
       dropout.dist = "ExpoDist",
       dropout.dist.par = parameters(rate = 0.0115)) 
{% endhighlight %}