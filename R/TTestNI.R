######################################################################################################################

# Function: TTestNI .
# Argument: Data set and parameter (call type and non-inferiority margin).
# Description: Computes one-sided p-value based on two-sample t-test with a non-inferiority margin.

TTestNI = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    if (is.null(parameter[[2]]$margin))
      stop("Analysis model: TTestNI test: Non-inferiority margin must be specified.")

    margin = as.numeric(parameter[[2]]$margin)

    # Check if larger treatment effect is expected for the second sample or not (default = TRUE)
    if (is.null(parameter[[2]]$larger)) larger = TRUE
    else {
      if (!is.logical(parameter[[2]]$larger))
        stop("Analysis model: TTestNI test: the larger argument must be logical (TRUE or FALSE).")
      larger = parameter[[2]]$larger
    }


    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    # One-sided p-value (treatment effect in sample 2 is expected to be greater than in sample 1)
    if (larger) result = stats::t.test(outcome2.complete  + margin, outcome1.complete, alternative = "greater")$p.value
    else result = stats::t.test(outcome1.complete  + margin, outcome2.complete, alternative = "greater")$p.value
  }
  else if (call == TRUE) {
    result=list("Student's t-test (non-inferiority)")
  }

  return(result)
}
# End of TTestNI
