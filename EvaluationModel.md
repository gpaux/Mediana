---
layout: page
title: Evaluation Model
header: Evaluation Model
group: navigation
---
{% include JB/setup %}

## Summary

Evaluation models are used within the Mediana package to specify the success criteria or metrics for evaluating the performance of the selected clinical scenario (combination of data and analysis models).

## Initialization

An evaluation model can be initialized using the following command:

{% highlight R %}
# EvaluationModel initialization
evaluation.model = EvaluationModel()
{% endhighlight %}

It is highly recommended to use this command to initialize an evaluation model because it simplifies the process of specifying components of the evaluation model such as `Criterion` objects. 

## Components of an evaluation model

### `Criterion` object

#### Description

This object specifies the success criteria that will be applied to a clinical scenario to evaluate the performance of selected analysis methods. A `Criterion` object is defined by six arguments:

- `id` defines the criterion's unique ID (label). 

- `method` defines the criterion.

- `tests` defines the IDs of the significance tests (defined in the analysis model) that the criterion is applied to.

- `statistics` defines the IDs the descriptive statistics (defined in the analysis model) that the criterion is applied to. 

- `par` defines the parameter(s) of the criterion.

- `label` defines the label(s) of the criterion values (the label(s) will be used in the simulation report).

Several commonly used success criteria are implemented in the Mediana package. The user can also define custom significance criteria. The built-in success criteria are listed below along with the required parameters that need to be included in the `par` argument:

- `MarginalPower`: compute the marginal power of all tests included in the `test` argument. Required parameter: `alpha` (significance level used in each test).

- `WeightedPower`: compute the weighted power of all tests included in the `test` argument. Required parameters: `alpha` (significance level used in each test) and `weight` (vector of weights assigned to the significance tests).

- `DisjunctivePower`: compute the disjunctive power (probability of achieving statistical significance in at least one test included in the `test` argument). Required parameter: `alpha` (significance level used in each test).

- `ConjunctivePower`: compute the conjunctive power (probability of achieving statistical significance in all tests included in the `test` argument). Required parameter: `alpha` (significance level used in each test).

- `ExpectedRejPower`: compute the expected number of statistical significant tests. Required parameter: `alpha`(significance level used in each test).

Several `Criterion` objects can be added to an `EvaluationModel` object.

For more information about the `Criterion` object, see the package's documentation [Criterion](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

If a certain success criterion is not implemented in the Mediana package, the user can create a custom function and use it within the package (see [User-defined functions](CustomFunctions.html#User-definedfunctionsforEvaluationModel)).

#### Examples

Examples of `Criterion` objects:

Compute marginal power with alpha = 0.025:

{% highlight R %}
Criterion(id = "Marginal power",
          method = "MarginalPower",
          tests = tests("Placebo vs treatment"),
          labels = c("Placebo vs treatment"),
          par = parameters(alpha = 0.025))
{% endhighlight %}

Compute weighted power with alpha = 0.025 and unequal test-specific weights:

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

Compute disjunctive power with alpha = 0.025:

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

