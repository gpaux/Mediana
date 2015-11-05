---
layout: page
title: User-defined functions
header: User-defined functions
group: navigation
---
{% include JB/setup %}

## Summary

If a certain feature (e.g. distribution, significance test, descriptive statistic or multiplicity adjustment procedure) is not implemented in the Mediana package, the user can defined a custom function and use it within the package. The user must follow the guidelines presented below to create valid custom functions.

## User-defined functions for Data Model

If a certain distribution is not implemented in the Mediana package, the user can defined a custom distribution function. The user must follow the guidelines presented below to create valid custom functions.

### Custom functions for defining distributions

The following template must be used by the user to define a custom distribution function that can be used to specify an outcome, enrollment or dropout distribution in a data model. The distribution-specific components that should be modified if a different distribution needs to be implemented are identified in the comments.

As an example, the following function is used to generate observations following the `Template` distribution that has two parameters, `parameter1` and `parameter2`.

{% highlight R %}
# Template of a function to generate observations
TemplateDist = function(parameter) {

  # Determine the function call, either to generate distribution or to return the distribution's description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    # The number of observations to generate
    n = parameter[[1]]

    ##############################################################
    # Distribution-specific component
    # Get the distribution's parameters (stored in the parameter[[2]] list)
    parameter1 = parameter[[2]]$parameter1
    parameter2 = parameter[[2]]$parameter2
    ##############################################################

    # Error checks (other checks could be added by the user if needed)
    if (n%%1 != 0)
      stop("Data model: TemplateDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: TemplateDist distribution: Number of observations must be positive.")

    ##############################################################
    # Distribution-specific component
    # Observations are generated using the "fundist" function and assigned to the "result" object
    result = fundist(n = n, parameter1 = parameter1, parameter2 = parameter2)
    ##############################################################

  } else {
    # Provide information about the distribution function
    if (call == TRUE) {

      ##############################################################
      # Distribution-specific component
      # The labels of the distributional parameters and the distribution's label must be stored in the "result" list
      result = list(list(parameter1 = "parameter1", parameter2 = "parameter2"),
                    list("Template"))
      ##############################################################

    }
  }
  return(result)

}
{% endhighlight %}

Click on the icon to download this template:

<center>
  <div class="col-md-12">
    <a href="TemplateDist.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>

## User-defined functions for Analysis Model

If a significance test, descriptive statistic or multiplicity adjustment procedure is not included in the Mediana package, the user can easily define a custom function that implements a test, computes a descriptive statistic or performs a multiplicity adjustment. The user must follow the guidelines presented below to create valid custom functions.

### Custom functions for implementing a significance test

The following template must be used by the user to define a function that implements a significance test in an analysis model. The test-specific components that need to be modified if the user wishes to implement a different test are identified in the comments.

As an example, the function defined below carries out a test named `TemplateTest` with a single required parameter labeled `parameter1`.

{% highlight R %}
# Template of a function to perform a significance test
TemplateTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  # Perform the test
  if (call == FALSE | is.na(call)) {

    ##############################################################
    # Test-specific component
    # Get the test's parameter (stored in the parameter[[2]] list)
    if (is.na(parameter[[2]]$parameter1))
      stop("Analysis model: TemplateTest test: parameter1 must be specified.")

    parameter1 = parameter[[2]]$parameter1
    ##############################################################


    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    ##############################################################
    # Test-specific component
    # The function must return a one-sided p-value (the treatment effect in sample 2 is expected to be numerically larger than the treatment effect in sample 1)
    # The one-sided p-value is computed by calling the "funtest" function and saved in the "result" object
    result = funtest(outcome2.complete, outcome1.complete, parameter1)$p.value
    ##############################################################
  }
  else if (call == TRUE) {
    result = list("TemplateTest", "Parameter1 = ")
  }

  return(result)
}
{% endhighlight %}

Click on the icon to download this template:

<center>
  <div class="col-md-12">
    <a href="TemplateTest.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>

### Custom functions for implementing a descriptive statistic

The following template must be used by the user to define a function that implements a descriptive statistic in an analysis model. The statistic-specific components that need to be modified if the user wishes to implement a different statistic are identified in the comments.

As an example, the function defined below carries out a descriptive statistic named `TemplateStatistic` with a single required parameter labeled `parameter1` and two samples.

{% highlight R %}
# Template of a function to perform a descriptive statistic
TemplateStatistic = function(sample.list, parameter) {

  # Determine the function call, either to generate the statistic or to return description
  call = (parameter[[1]] == "Description")

  # Perform the test
  if (call == FALSE | is.na(call)) {

    ##############################################################
    # Statistic-specific component
    # Get the statistic's parameter (stored in the parameter[[2]] list)
    if (is.na(parameter[[2]]$parameter1))
      stop("Analysis model: TemplateStatistic statistic: parameter1 must be specified.")

    parameter1 = parameter[[2]]$parameter1
    ##############################################################


    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    ##############################################################
    # Statistic-specific component
    # The function must return a single value
    # The statistic is computed by calling the "funstat" function and saved in the "result" object
    result = funstat(outcome1.complete, outcome2.complete, parameter1)$statistic
    ##############################################################
  }
  else if (call == TRUE) {
    result = list("TemplateStatistic", "Parameter1 = ")
  }

  return(result)
}
{% endhighlight %}

Click on the icon to download this template:

<center>
  <div class="col-md-12">
    <a href="TemplateStatistic.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>

## User-defined functions for Evaluation Model

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

Click on the icon to download this template:

<center>
  <div class="col-md-12">
    <a href="TemplateCriterion.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>