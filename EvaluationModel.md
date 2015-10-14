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

For more information about the `Criterion` object, see the R documentation [Criterion](https://cran.r-project.org/web/packages/Mediana/Mediana.pdf).

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

## User-defined functions

If a criterion is not implemented by default in the Mediana package, the user can defined his own function. In order to be used within the package, the user must respect the following templates.

### Template for criterion

The following template can be used by the user to create his own function to perform an evaluation based on a custom criterion. The parts of the function that has to be modified are identified within a block.

As an example, this function is used to perform an evaluation based on two tests and one statistic.  This function is named `Template` and has two parameters, `parameter1` that will be compared to the tests results, and `parameter2` that will be compared to statistics results. To be successfull, at least one of the two test result must be lower than the parameter 1 and the statistic result must be greater than parameter 2.

{% highlight R %}
# Template of a function to perform an evaluation
TemplateCriterion = function(test.result, statistic.result, parameter)  {
  
  ##############################################################
  # To modify according to the function
  # Get the parameter (kept in the parameter[[1]] list)
  parameter1 = parameter[[1]]
  parameter2 = parameter[[2]]
  ##############################################################
  
  ##############################################################
  # To modify according to the function
  # Binary variable (success/failure of the criterion)
  # If the criterion is based on p-value returned by Test object, the test.result matrix must be used
  # test.result matrix has as many row as the number of simulations, and as many columns as the number
  # of tests specified in the Criterion argument tests
  # If the criterion is based on statistics returned by Statistic object, the statistic.result matrix must be used
  # statistic.result matrix has as many row as the number of simulations, and as many columns as the number
  # of statistics specified in the Criterion argument statistics
  # Example with two tests and one statistics (at least one test must be significant, 
  # and the statistics must be greater than a threshold)
  significant = ((test.result[,1] <= parameter1) | ((test.result[,2] <= parameter1) | (statistic.result[,2] > parameter2)))
  ##############################################################

  power = mean(significant)
  return(power)
}
{% endhighlight %}

The R template code can be downloaded below.

<center>
  <div class="col-md-12">
    <a href="TemplateCriterion.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>