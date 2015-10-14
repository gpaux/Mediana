# Template of a function to perform a test
TemplateTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  # Perform the test
  if (call == FALSE | is.na(call)) {

    ##############################################################
    # To modify according to the function
    # Get the other parameter (kept in the parameter[[2]] list)
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
    # To modify according to the function
    # The function must return a one-sided p-value (treatment effect in sample 2 is expected to be greater than in sample 1)
    result = funtest(outcome2.complete, outcome1.complete, parameter1)$p.value
    ##############################################################
  }
  else if (call == TRUE) {
    result = list("Template Test", "Parameter1 = ")
  }

  return(result)
}