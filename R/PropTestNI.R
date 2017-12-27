#############################################################################################

# Function: PropTestNI.
# Argument: Data set and parameter (call type and Yates' correction and non-inferiority margin).
# Description: Computes one-sided p-value based on two-sample proportion test.

PropTestNI = function(sample.list, parameter) {
  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    if (is.null(parameter[[2]]$margin))
      stop("Analysis model: PropTestNI test: Non-inferiority margin must be specified.")

    if (parameter[[2]]$margin <= 0 | parameter[[2]]$margin > 1)
      stop("Analysis model: PropTestNI test: Non-inferiority margin must be between 0 and 1 not included.")

    # Non-inferiority margin
    margin = as.numeric(parameter[[2]]$margin)

    # Yates' correction is set up by default to FALSE
    if(is.null(parameter[[2]]$yates)) yates = FALSE
    else {
      if (!is.logical(parameter[[2]]$yates))
        stop("Analysis model: PropTestNI test: the yates argument must be logical (TRUE or FALSE).")
      yates = parameter[[2]]$yates
    }
    # Check if larger treatment effect is expected for the second sample or not (default = TRUE)
    if (is.null(parameter[[2]]$larger)) larger = TRUE
    else {
      if (!is.logical(parameter[[2]]$larger))
        stop("Analysis model: PropTestNI test: the larger argument must be logical (TRUE or FALSE).")
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
    if (larger) result = stats::prop.test(c(min(sum(outcome2.complete) + margin * length(outcome2.complete), length(outcome2.complete)),
                                            sum(outcome1.complete)),
                                          n = c(length(outcome2.complete), length(outcome1.complete)),
                                          alternative = "greater", correct = yates)$p.value
    else result = stats::prop.test(c(min(sum(outcome1.complete) + margin * length(outcome1.complete), length(outcome1.complete)),
                                     sum(outcome2.complete)),
                                   n = c(length(outcome1.complete), length(outcome2.complete)),
                                   alternative = "greater", correct = yates)$p.value
  }
  else if (call == TRUE) {
    result=list("Non-inferiority test for proportions")
  }

  return(result)
}
# End of PropTestNI
