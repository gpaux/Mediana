######################################################################################################################

# Function: PropTest .
# Argument: Data set and parameter (call type and Yates' correction).
# Description: Computes one-sided p-value based on two-sample proportion test.

PropTest = function(sample.list, parameter) {
  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # No parameters are defined
    if (is.na(parameter[[2]])) {
      yates = FALSE
      larger = TRUE
    }
    else {
      if (!all(names(parameter[[2]]) %in% c("larger", "yates"))) stop("Analysis model: PropTest test: this function accepts only one argument (larger)")
      # Yates' correction is set up by default to FALSE
      if(is.null(parameter[[2]]$yates)) yates = FALSE
      else {
        if (!is.logical(parameter[[2]]$yates))
          stop("Analysis model: PropTest test: the yates argument must be logical (TRUE or FALSE).")
        yates = parameter[[2]]$yates
      }
      # Check if larger treatment effect is expected for the second sample or not (default = TRUE)
      if (is.null(parameter[[2]]$larger)) larger = TRUE
      else {
        if (!is.logical(parameter[[2]]$larger))
          stop("Analysis model: PropTest test: the larger argument must be logical (TRUE or FALSE).")
        larger = parameter[[2]]$larger
      }
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
    if (larger) result = stats::prop.test(c(sum(outcome2.complete), sum(outcome1.complete)),
                                          n = c(length(outcome2.complete), length(outcome1.complete)), alternative = "greater", correct = yates)$p.value
    else result = stats::prop.test(c(sum(outcome2.complete), sum(outcome1.complete)),
                                   n = c(length(outcome2.complete), length(outcome1.complete)), alternative = "less", correct = yates)$p.value

  }
  else if (call == TRUE) {
    result=list("Test for proportions")
  }

  return(result)
}
# End of PropTest
