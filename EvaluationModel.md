---
layout: page
title: Evaluation Model
header: Evaluation Model
group: navigation
---
{% include JB/setup %}

## About

Evaluation models are used within the Mediana package to specify the measures (metrics) for evaluating the performance of the selected clinical scenario (combination of data and analysis models).

## Initialization

An evaluation model can be initialized using the following command

{% highlight R %}
# EvaluationModel initialization
evaluation.model = EvaluationModel()
{% endhighlight %}

Initialization with this command is higlhy recommended as it will simplify the add of related objects, such as `Criterion` objects.

## Specific objects

### Criterion

#### Description

Specify the criteria that will be applied to the Clinical Scenario. A `Criterion` object is defined by six arguments:

- `id`, which defines the ID of the criterion.
- `method`, which defines the criterion method.
- `tests`, which defines the tests (pre-defined in the analysis model) to be used within the criterion method.  
- `statistics`, which defines the statistics (pre-defined in the analysis model) to be used within the criterion method.  
- `par`, which defines the parameter(s) of the criterion method.
- `label`, which defines the label(s) of the results.

Several methods are already implemented in the Mediana package (listed below, along with the required parameters to define in the par parameter):

- `MarginalPower`: generate the marginal power of all tests defined in the test argument. Required parameter: `alpha`.

- `WeightedPower`: generate the weighted power of all tests defined in the test argument. Required parameters: `alpha` and `weight `.

- `DisjunctivePower`: generate the disjunctive power (probability to reject at least one hypothesis defined in the test argument). Required parameter: `alpha`.

- `ConjunctivePower`: generate the conjunctive power (probability to reject all hypotheses defined in the test argument). Required parameter: `alpha`.

- `ExpectedRejPower`: generate the expected number of rejected hypotheses. Required parameter: `alpha`.

Several `Criterion` objects can be added to an `EvaluationModel`object.

For more information about the `Criterion` object, see the R documentation [Criterion]().

#### Examples

Example of `Criterion` objects:

- **Traditional Power (alpha = 0.025)**

{% highlight R %}
Criterion(id = "Marginal power",
          method = "MarginalPower",
          tests = tests("Placebo vs treatment"),
          labels = c("Placebo vs treatment"),
          par = parameters(alpha = 0.025))
{% endhighlight %}

- **Weighted Power (unequal weights, alpha = 0.025)**

{% highlight R %}
Criterion(id = "Weighted power",
          method = "WeightedPower",
          tests = tests("Placebo vs treatment - Endpoint 1",
                        "Placebo vs treatment - Endpoint 2"),
          labels = c("Placebo vs treatment - Endpoint 1",
                     "Placebo vs treatment - Endpoint 2"),
          par = parameters(alpha = 0.025,
                           weight = c(2/3, 1/3)))
{% endhighlight %}

- **Disjunctive Power**

{% highlight R %}
Criterion(id = "Disjunctive power",
          method = "DisjunctivePower",
          tests = tests("Placebo vs Dose H",
                        "Placebo vs Dose M",
                        "Placebo vs Dose L"),
          labels = c("Placebo vs Dose H",
                     "Placebo vs Dose M",
                     "Placebo vs Dose L"),
          par = parameters(alpha = 0.025))
{% endhighlight %}