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