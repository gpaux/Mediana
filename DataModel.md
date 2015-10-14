---
layout: page
title: Data Model
header: Data Model
group: navigation
---
{% include JB/setup %}

## About

Data models define the process of generating patient data in clinical trials.

## Initialization

A data model can be initialized using the following command
{% highlight R %}
# DataModel initialization
data.model = DataModel()
{% endhighlight %}

Initialization with this command is higlhy recommended as it will simplify the add of related objects, such as 
`OutcomeDist`, `Sample`, `SampleSize`, `Event`, `Design` objects. 

## Specific objects

Once a `DataModel` object has been initialized, specific objects can be added by using the '+' operator to add objects to it.

### OutcomeDist

#### Description

Specify the outcome distribution of the generated data. An `OutcomeDist` object is defined by two arguments:

- `outcome.dist`, which defines the outcome distribution.

- `outcome.type`, which defines the outcome type (optional). This arguments only accepts:

	- `standard`: for fixed design setting.

	- `event`: for event-driven design setting.

Several distributions are already implemented in the Mediana package (listed below, along with the required parameters to specify in the `outcome.par` argument of the Sample object) to be used in the `outcome.dist` argument:

- `UniformDist`: generate data following a **univariate distribution**. Required parameter: `max`.

- `NormalDist`: generate data following a **normal distribution**. Required parameters: `mean` and `sd`.

- `BinomDist`: generate data following a **binomial distribution**. Required parameter: `prop`.

- `ExpoDist`: generate data following an **exponential distribution**. Required parameter: `rate`.

- `PoissonDist`: generate data following a **Poisson distribution**. Required parameter: `lambda`.

- `NegBinomDist`: generate data following a **negative binomial distribution**. Required parameters: `dispersion` and `mean`.

- `MVNormalDist`: generate data following a **multivariate normal distribution**. Required parameters: `par` and `corr`. For each generated endpoint, the `par` parameter must contain the required parameters `mean` and `sd`. The `corr` parameter specifies the correlation matrix for the endpoints.

- `MVBinomDist`: generate data following a **multivariate binomial distribution**. Required parameters: `par` and `corr`. For each generated endpoint, the `par` parameter must contain the required parameter `prop`. The `corr` parameter specifies the correlation matrix for the endpoints.

- `MVExpoDist`: generate data following a **multivariate exponential distribution**. Required parameters: `par` and `corr`. For each generated endpoint, the `par` parameter must contain the required parameter `rate`. The `corr `parameter specifies the correlation matrix for the endpoints.

- `MVExpoPFSOSDist`: generate data following a **multivariate exponential distribution to generate PFS and OS endpoints**. The PFS value is imputed to the OS value if the latter occurs earlier. Required parameters: `par` and `corr`. For each generated endpoint, the `par` parameter must contain the required parameter `rate`. The` corr` parameter specifies the correlation matrix for the endpoints.

- `MVMixedDist`: generate data following a **multivariate mixed distribution**. Required parameters: `type`, `par` and `corr`. The type parameter can take the following values:

	- `NormalDist`

	- `BinomDist`

	- `ExpoDist`

  For each generated endpoint, the par parameter must contain the required parameters according to the type of distribution. The `corr` parameter specifies the correlation matrix for the endpoints.

A single `OutcomeDist` object can be added to a `DataModel`object.

For more information about the `OutcomeDist` object, see the R documentation [OutcomeDist](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

If a distribution is not implemented in the Mediana Package, the user can create his own function and use it within the Mediana Package (see [User-defined functions](#User-definedfunctions)).

#### Example

Example of `OutcomeDist` object:	

- **Univariate distributions**

{% highlight R %}
# Normal distribution
OutcomeDist(outcome.dist = "NormalDist")

# Binomial distribution
OutcomeDist(outcome.dist = "BinomDist")

# Exponential distribution
OutcomeDist(outcome.dist = "ExpoDist")
{% endhighlight %}

- **Mixed Multivariate distributions**
{% highlight R %}
# Multivariate Mixed distribution
OutcomeDist(outcome.dist = "MVMixedDist")
{% endhighlight %}
### Sample

#### Description

Specify a sample (e.g. treatment group). A `Sample` object is defined by three arguments:

- `id`, which defines the ID of the sample.

- `outcome.par`, which defines the parameters of the outcome distribution of the sample.

- `sample.size`, which defines the sample size of the sample (optional).

The `sample.size` argument is optional but must be used to define the sample size if unbalance samples have to be defined. The sample size must be either defined in the `Sample` object or in the `SampleSize` object, but not in both. 

Several `Sample` objects can be added to a `DataModel`object.

For more information about the `Sample` object, see the R documentation [Sample](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

#### Example

Example of `Sample` objects:

- **Continuous endpoint following a Normal distribution**

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

- **Binary endpoint following a Binomial distribution**

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

- **Time-to-event endpoint following an Exponential distribution**

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

- **Two key primary endpoints following a Binomial and a Normal distribution respectively**

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


### SampleSize

#### Description

Specify the sample size in case of balanced design (all samples will have the same sample size). A `SampleSize` object is defined by one argument:

- `sample.size`, which specifies a list or vector of sample size(s).

A single `SampleSize` object can be added to a `DataModel`object.

For more information about the `SampleSize` object, see the R documentation [SampleSize](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

#### Example

Example of `SampleSize` objects:

- **Equivalent specifications of SampleSize object**

{% highlight R %}
SampleSize(c(50, 55, 60, 65, 70))
SampleSize(list(50, 55, 60, 65, 70))
SampleSize(seq(50, 70, 5))
{% endhighlight %}

### Event

#### Description

Specify the total number of events among all samples in an event-driven clinical trial. A `Event` object is defined by two arguments:

- `n.events`, which defines a vector of number of events required.

- `rando.ratio`, which defines a vector of randomization ratios for each `Sample` object defined in the `DataModel`object.

A single `Event` object can be added to a `DataModel`object.

For more information about the `Event` object, see the R documentation [Event](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

#### Example

Example of `Event` object:

- **Specify the number of events with a 2:1 randomization ratio (Treatment:Placebo)**

{% highlight R %}
# Event parameters
event.count.total = c(390, 420)
randomization.ratio = c(1,2)

# Event object
Event(n.events = event.count.total, 
      rando.ratio = randomization.ratio)
{% endhighlight %}

### Design

#### Description

Specify the design parameters used in event-driven designs if the user is interested in modeling the enrollment (or accrual) and dropout (or loss to follow up) processes that will be applied to the Clinical Scenario. A `Design` object is defined by seven arguments:

- `enroll.period`, which defines the length of the enrollment period.

- `enroll.dist`, which defines the enrollment distribution.

- `enroll.dist.par`, which defines the parameters of the enrollment distribution (optional).

- `followup.period`, which defines the length of the follow-up period for each patient in study designs with a fixed follow-up period, i.e., the length of time from the enrollment to planned discontinuation is constant across patients. The user must specify either followup.period or study.duration.

- `study.duration`, which defines the total study duration in study designs with a variable follow-up period. The total study duration is defined as the length of time from the enrollment of the first patient to the discontinuation of the last patient.

- `dropout.dist`, which defines the dropout distribution.

- `dropout.dist.par`, which defines the parameters of the dropout distribution.

Several `Design` objects can be added to a `DataModel`object.

For more information about the `Design` object, see the R documentation [Design](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

#### Example

Example of `Design` object: 

- **Modelling the inclusion and dropout of patients**

{% highlight R %}
# Design parameters (in months)
Design(enroll.period = 9,
       study.duration = 21,
       enroll.dist = "UniformDist",
       dropout.dist = "ExpoDist",
       dropout.dist.par = parameters(rate = 0.0115)) 
{% endhighlight %}

## User-defined functions

If a distribution is not implemented by default in the Mediana package, the user can defined his own function. In order to be used within the package, the user must respect the following templates.

### Template for outcome distributions

The following template can be used by the user to create his own function to generate data. The parts of the function that has to be modified are identified within a block.

As an example, this function is used to generate data following a `Template` distribution and has two parameters, `parameter1` and `parameter2`.

{% highlight R %}
# Template of a function to generate data
TemplateDist = function(parameter) {

  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    # The number of patients to generate
    n = parameter[[1]]

    ##############################################################
    # To modify according to the function
    # Get the other parameter (kept in the parameter[[2]] list)
    parameter1 = parameter[[2]]$parameter1
    parameter2 = parameter[[2]]$parameter2
    ##############################################################

    # Error checks (other checks could be added by the user if needed)
    if (n%%1 != 0)
      stop("Data model: TemplateDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: TemplateDist distribution: Number of observations must be positive.")

    ##############################################################
    # To modify according to the function
    # Data are generated using the function "fundist" and assign to the object result
    result = fundist(n = n, parameter1 = parameter1, parameter2 = parameter2)
    ##############################################################

  } else {
    # Provide information about the distribution function
    if (call == TRUE) {

      ##############################################################
      # To modify according to the function
      # The labels of the distributional parameters and the label of the distribution must be put in the list
      result = list(list(parameter1 = "parameter1", parameter2 = "parameter2"),
                    list("Template"))
      ##############################################################

    }
  }
  return(result)

}
{% endhighlight %}

The R template code can be downloaded below.

<center>
  <div class="col-md-12">
    <a href="TemplateDist.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>