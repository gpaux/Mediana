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

## User-defined functions

If the user wishes to apply a custom success criterion that is not included in the Mediana package, the guidelines presented below must be followed to create a valid custom function that implements this criterion.

### Custom functions for implementing a success criterion

The following template must be used by the user to define a function that implements a success criterion in an evaluation model. The components that need to be modified if the user wishes to implement a different criterion are identified in the comments.

As an illustration, the function defined below implements a criterion named `TemplateCriterion` based on two significance tests and one descriptive statistic with two required parameters. The first parameter, labeled `parameter1`, is applied to the significance tests and the second parameter, labeled `parameter2`, is applied to the statistic. Success is achieved if at least one of the two tests is less than `parameter1` and the statistic is greater than `parameter2`.

{% highlight R %}
# Template of a function to implement a success criterion
TemplateCriterion = function(test.result, statistic.result, parameter)  {
  
  ##############################################################
  # Criterion-specific component
  # Get the criterion's parameter (stored in the parameter list)
  parameter1 = parameter[[1]]
  parameter2 = parameter[[2]]
  ##############################################################
  
  ##############################################################
  # Criterion-specific component
  # Binary variable (success/failure of the criterion)
  # If the criterion is based on a p-value returned by a Test object, the test.result 
  # matrix must be used. The test.result matrix has as many rows as the number of simulations, 
  # and as many columns as the number of tests specified in the tests argument of this criterion.
  # If the criterion is based on a descriptive statistic returned by a Statistic object, 
  # the statistic.result matrix must be used. This matrix has as many rows as the number 
  # of simulations, and as many columns as the number of statistics specified in the 
  # the statistics argument of this criterion.
  # Two tests and one statistic are used in this example. At least one test value must 
  # be less than parameter1 and the statistic must be greater than parameter2.
  significant = ((test.result[,1] <= parameter1) | ((test.result[,2] <= parameter1) | (statistic.result[,2] > parameter2)))
  ##############################################################

  power = mean(significant)
  return(power)
}
{% endhighlight %}

### Download 

Click on the icon to download this template:

<center>
  <div class="col-md-12">
    <a href="TemplateCriterion.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>