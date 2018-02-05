######################################################################################################################

# Function: OrdinalLogisticRegTest
# Argument: Data set and parameter (call type).
# Description: Computes one-sided p-value based on Ordinal Logistic regression.

OrdinalLogisticRegTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # No parameters are defined
    if (is.na(parameter[[2]])) {
      larger = TRUE
    }
    else {
      if (!all(names(parameter[[2]]) %in% c("larger"))) stop("Analysis model: OrdinalRegTest test: this function accepts only one argument (larger)")
      # Parameters are defined but not the larger argument
      if (!is.logical(parameter[[2]]$larger)) stop("Analysis model: OrdinalRegTest test: the larger argument must be logical (TRUE or FALSE).")
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

    # Data frame
    data.complete = data.frame(rbind(cbind(2, outcome2.complete),
                                     cbind(1, outcome1.complete)))
    colnames(data.complete) = c("TRT", "RESPONSE")
    data.complete$TRT=as.factor(data.complete$TRT)
    # Order the level of the response
    data.complete$RESPONSE=factor(data.complete$RESPONSE, levels = 1:max(data.complete$RESPONSE), ordered = TRUE)

    # One-sided p-value (to be checked)
    z = summary(MASS::polr(RESPONSE ~ TRT, data = data.complete, Hess = TRUE))$coefficients["TRT2", "t value"]
    result = stats::pnorm(z, lower.tail = !larger)
  }
  else if (call == TRUE) {
    result=list("Ordinal logistic regression test")
  }

  return(result)
}
# End of OrdinalRegTest
