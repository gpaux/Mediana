---
layout: page
title: Data Model
header: Data Model
group: navigation
---
{% include JB/setup %}

## Summary

Data models define the process of generating patient data in clinical trials.

## Initialization

A data model can be initialized using the following command

{% highlight R %}
# DataModel initialization
data.model = DataModel()
{% endhighlight %}

It is highly recommended to use this command as it will simplify the process of specifying components of the data model, e.g., `OutcomeDist`, `Sample`, `SampleSize`, `Event` and `Design` objects. 

## Components of a data model

Once the `DataModel` object has been initialized, components of the data model can be specified by adding objects to the model using the '+' operator as shown below.

{% highlight R %}
# Outcome parameter set 1
outcome1.placebo = parameters(mean = 0, sd = 70)
outcome1.treatment = parameters(mean = 40, sd = 70)

# Outcome parameter set 2
outcome2.placebo = parameters(mean = 0, sd = 70)
outcome2.treatment = parameters(mean = 50, sd = 70)

# Data model
case.study1.data.model =  DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  SampleSize(c(50, 55, 60, 65, 70)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome1.treatment, outcome2.treatment))
{% endhighlight %}


### `OutcomeDist` object

#### Description

This object specifies the distribution of patient outcomes in a data model. An `OutcomeDist` object is defined by two arguments:

- `outcome.dist` defines the outcome distribution.

- `outcome.type` defines the outcome type (optional). There are two acceptable values of this argument: `standard` (fixed-design setting) and `event` (event-driven design setting).

Several distributions that can be specified using the `outcome.dist` argument are already implemented in the Mediana package. These distributions are listed below along with the required parameters to be included in the `outcome.par` argument of the `Sample` object:

- `UniformDist`: generate data following a **univariate distribution**. Required parameter: `max`.
- `NormalDist`: generate data following a **normal distribution**. Required parameters: `mean` and `sd`.
- `BinomDist`: generate data following a **binomial distribution**. Required parameter: `prop`.
- `BetaDist`: generate data following a **beta distribution**. Required parameter: `a` and `b`.
- `ExpoDist`: generate data following an **exponential distribution**. Required parameter: `rate`.
- `WeibullDist`: generate data following a **weibull distribution**. Required parameter: `shape` and `scale`.
- `TruncatedExpoDist`: generate data following a **truncated exponential distribution**. Required parameter: `rate` an `trunc`.
- `PoissonDist`: generate data following a **Poisson distribution**. Required parameter: `lambda`.
- `NegBinomDist`: generate data following a **negative binomial distribution**. Required parameters: `dispersion` and `mean`.
- `MultinomialDist`: generate data following a **multinomial  distribution**. Required parameters: `prob`.
- `MVNormalDist`: generate data following a **multivariate normal distribution**. Required parameters: `par` and `corr`. For each generated endpoint, the `par` parameter must contain the required parameters `mean` and `sd`. The `corr` parameter specifies the correlation matrix for the endpoints.
- `MVBinomDist`: generate data following a **multivariate binomial distribution**. Required parameters: `par` and `corr`. For each generated endpoint, the `par` parameter must contain the required parameter `prop`. The `corr` parameter specifies the correlation matrix for the endpoints.
- `MVExpoDist`: generate data following a **multivariate exponential distribution**. Required parameters: `par` and `corr`. For each generated endpoint, the `par` parameter must contain the required parameter `rate`. The `corr `parameter specifies the correlation matrix for the endpoints.
- `MVExpoPFSOSDist`: generate data following a **multivariate exponential distribution to generate PFS and OS endpoints**. The PFS value is imputed to the OS value if the latter occurs earlier. Required parameters: `par` and `corr`. For each generated endpoint, the `par` parameter must contain the required parameter `rate`. The` corr` parameter specifies the correlation matrix for the endpoints.
- `MVMixedDist`: generate data following a **multivariate mixed distribution**. Required parameters: `type`, `par` and `corr`. The `type` parameter assumes the following values: `NormalDist`, `BinomDist` and `ExpoDist`. For each generated endpoint, the `par` parameter must contain the required parameters according to the distribution type. The `corr` parameter specifies the correlation matrix for the endpoints.


The `outcome.type` argument defines the outcome's type. This argument accepts only two values:

- `standard`: for fixed design setting.

- `event`: for event-driven design setting.

The outcome's type must be defined for each endpoint in case of multivariate disribution, e.g. `c("event","event")` in case of multivariate exponential distribution. The `outcome.type` argument is essential to get censored events for time-to-event endpoints if the `SampleSize` object is used to specify the number of patients to generate.

A single `OutcomeDist` object can be added to a `DataModel` object.

For more information about the `OutcomeDist` object, see the documentation for [OutcomeDist](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf) on the CRAN web site.

If a certain outcome distribution is not implemented in the Mediana package, the user can create a custom function and use it within the package (see [User-defined functions](CustomFunctions.html#User-definedfunctionsforDataModel)).

#### Example

Examples of `OutcomeDist` objects:	

Specify popular univariate distributions:

{% highlight R %}
# Normal distribution
OutcomeDist(outcome.dist = "NormalDist")

# Binomial distribution
OutcomeDist(outcome.dist = "BinomDist")

# Exponential distribution
OutcomeDist(outcome.dist = "ExpoDist")
{% endhighlight %}

Specify a mixed multivariate distribution:

{% highlight R %}
# Multivariate Mixed distribution
OutcomeDist(outcome.dist = "MVMixedDist")
{% endhighlight %}

### `Sample` object

#### Description

This object specifies parameters of a sample (e.g., treatment arm in a trial) in a data model. Samples are defined as mutually exclusive groups of patients, for example, treatment arms. A `Sample` object is defined by three arguments:

- `id` defines the sample's unique ID (label).

- `outcome.par` defines the parameters of the outcome distribution for the sample.

- `sample.size` defines the sample's size (optional).

The `sample.size` argument is optional but must be used to define the sample size only if an unbalanced design is considered (i.e., the sample size varies across the samples). The sample size must be either defined in the `Sample` object or in the `SampleSize` object, but not in both. 

Several `Sample` objects can be added to a `DataModel` object.

For more information about the `Sample` object, see the documentation [Sample](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf) on the CRAN web site.

#### Example

Examples of `Sample` objects:

Specify two samples with a continuous endpoint following a normal distribution:

{% highlight R %}
# Outcome parameters set 1
outcome1.placebo = parameters(mean = 0, sd = 70)
outcome1.treatment = parameters(mean = 40, sd = 70)

# Outcome parameters set 2
outcome2.placebo = parameters(mean = 0, sd = 70)
outcome2.treatment = parameters(mean = 50, sd = 70)

# Placebo sample object
Sample(id = "Placebo",
       outcome.par = parameters(outcome1.placebo, 
                                outcome2.placebo))

# Treatment sample object
Sample(id = "Treatment",
       outcome.par = parameters(outcome1.treatment, 
                                outcome2.treatment))
{% endhighlight %}

Specify two samples with a binary endpoint following a binomial distribution:

{% highlight R %}
# Outcome parameters set
outcome.placebo = parameters(prop = 0.30)
outcome.treatment = parameters(prop = 0.50)

# Placebo sample object
Sample(id = "Placebo",
       outcome.par = parameters(outcome1.placebo))

# Treatment sample object
Sample(id = "Treatment",
       outcome.par = parameters(outcome1.treatment))
{% endhighlight %}

Specify two samples with a time-to-event (survival) endpoint following an exponential distribution:

{% highlight R %}
# Outcome parameters
median.time.placebo = 6
rate.placebo = log(2)/median.time.placebo
outcome.placebo = parameters(rate = rate.placebo)

median.time.treatment = 9
rate.treatment = log(2)/median.time.treatment
outcome.treatment = parameters(rate = rate.treatment)

# Placebo sample object
Sample(id = "Placebo",
       outcome.par = parameters(outcome.placebo))

# Treatment sample object
Sample(id = "Treatment",
       outcome.par = parameters(outcome.treatment))
{% endhighlight %}

Specify three samples with two primary endpoints that follow a binomial and a normal distribution, respectively:

{% highlight R %}
# Variable types
var.type = list("BinomDist", "NormalDist")

# Outcome distribution parameters
placebo.par = parameters(parameters(prop = 0.3), 
                         parameters(mean = -0.10, sd = 0.5))

dosel.par = parameters(parameters(prop = 0.40), 
                       parameters(mean = -0.20, sd = 0.5))

doseh.par = parameters(parameters(prop = 0.50), 
                       parameters(mean = -0.30, sd = 0.5))

# Correlation between two endpoints
corr.matrix = matrix(c(1.0, 0.5,
                       0.5, 1.0), 2, 2)

# Outcome parameters set
outcome.placebo = parameters(type = var.type, 
                             par = plac.par, 
                             corr = corr.matrix)

outcome.dosel = parameters(type = var.type, 
                           par = dosel.par, 
                           corr = corr.matrix)

outcome.doseh = parameters(type = var.type, 
                           par = doseh.par, 
                           corr = corr.matrix)

# Placebo sample object
Sample(id = list("Plac ACR20", "Plac HAQ-DI"),
       outcome.par = parameters(outcome.placebo))

# Low Dose sample object
Sample(id = list("DoseL ACR20", "DoseL HAQ-DI"),
       outcome.par = parameters(outcome.dosel))

# High Dose sample object
Sample(id = list("DoseH ACR20", "DoseH HAQ-DI"),
       outcome.par = parameters(outcome.doseh))
{% endhighlight %}

### `SampleSize` object

#### Description

This object specifies the sample size in a balanced trial design (all samples will have the same sample size). A `SampleSize` object is defined by one argument:

- `sample.size` specifies a list or vector of sample size(s).

A single `SampleSize` object can be added to a `DataModel` object.

For more information about the `SampleSize` object, see the package's documentation [SampleSize](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

#### Example

Examples of `SampleSize` objects:

Several equivalent specifications of the `SampleSize` object:

{% highlight R %}
SampleSize(c(50, 55, 60, 65, 70))
SampleSize(list(50, 55, 60, 65, 70))
SampleSize(seq(50, 70, 5))
{% endhighlight %}

### `Event` object

#### Description

This object specifies the total number of events (total event count) among all samples in an event-driven clinical trial. An `Event` object is defined by two arguments:

- `n.events` defines a vector of the required event counts.

- `rando.ratio` defines a vector of randomization ratios for each `Sample` object defined in the `DataModel` object.

A single `Event` object can be added to a `DataModel` object.

For more information about the `Event` object, see the package's documentation [Event](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

#### Example

Examples of `Event` objects:

Specify the required number of events in a trial with a 2:1 randomization ratio (Treatment:Placebo):

{% highlight R %}
# Event parameters
event.count.total = c(390, 420)
randomization.ratio = c(1,2)

# Event object
Event(n.events = event.count.total, 
      rando.ratio = randomization.ratio)
{% endhighlight %}

### `Design` object

#### Description

This object specifies the design parameters used in event-driven designs if the user is interested in modeling the enrollment (or accrual) and dropout (or loss to follow up) processes. A `Design` object is defined by seven arguments:

- `enroll.period` defines the length of the enrollment period.

- `enroll.dist` defines the enrollment distribution.

- `enroll.dist.par` defines the parameters of the enrollment distribution (optional).

- `followup.period` defines the length of the follow-up period for each patient in study designs with a fixed follow-up period, i.e., the length of time from the enrollment to planned discontinuation is constant across patients. The user must specify either `followup.period` or `study.duration`.

- `study.duration` defines the total study duration in study designs with a variable follow-up period. The total study duration is defined as the length of time from the enrollment of the first patient to the discontinuation of the last patient.

- `dropout.dist` defines the dropout distribution.

- `dropout.dist.par` defines the parameters of the dropout distribution.

Several `Design` objects can be added to a `DataModel` object.

For more information about the `Design` object, see the package's documentation [Design](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

A convienient way to model non-uniform enrollment is to use a beta distribution (`BetaDist`). If `enroll.dist = "BetaDist"`, the `enroll.dist.par` should contain the parameter of the beta distribution (`a` and `b`). These parameters must be derived according to the expected enrollment at a specific timepoint. For example, if half the patients are expected to be enrolled at 75% of the enrollment period, the beta distribution is a `Beta(log(0.5)/log(0.75), 1)`. Generally, let `q` be the proportion of enrolled patients at 100`p`% of the enrollment period, the Beta distribution can be derived as follows:

- If `q < p`, the Beta distribution is `Beta(a,1)` with `a = log(q) / log(p)`

- If `q > p`, the Beta distribution is `Beta (1,b)` with `b = log(1-q) / log(1-p)`

- Otherwise the Beta distribution is `Beta(1,1)`



#### Example

Examples of `Design` objects: 

Specify parameters of the enrollment and dropout processes with a uniform enrollment distribution and exponential dropout distribution:

{% highlight R %}
# Design parameters (in months)
Design(enroll.period = 9,
       study.duration = 21,
       enroll.dist = "UniformDist",
       dropout.dist = "ExpoDist",
       dropout.dist.par = parameters(rate = 0.0115)) 
{% endhighlight %}