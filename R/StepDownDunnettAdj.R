######################################################################################################################

# Function: StepDownDunnettAdj.
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: common sample size per trial arm (1 x 1)
# Description: Step-down Dunnett procedure.

StepDownDunnettAdj = function(p, par) {
  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")

  # Number of p-value
  m = length(p)

  # Extract the common sample size per trial arm (1 x 1)
  if (!any(is.na(par[[2]]))) {
    if (is.null(par[[2]]$n))
      stop(
        "Analysis model: Step-down Dunnett procedure: Common sample size per trial arm must be specified."
      )
    n = par[[2]]$n
  }

  # Error checks
  if (n < 0)
    stop(
      "Analysis model: Step-down Dunnett procedure: Common sample size per trial arm must be greater than 0."
    )

  # Number of degrees of freedom
  nu = (m + 1) * (n - 1)

  # Compute test statistics from p-values (assuming that each test statistic follows a t distribution)
  stat = stats::qt(1 - p, df = 2 * (n - 1))

  if (any(call == FALSE) | any(is.na(call))) {
    temp = rep(1, m)
    adjpvalue = rep(1, m)
    # Sort test statistics from largest to smallest
    ordered = order(stat, decreasing = TRUE)
    sorted = stat[ordered]

    temp[1] = 1 - CDFDunnett(sorted[1], nu, m)
    maxp = temp[1]

    for (i in 2:(m-1))
    {
      temp[i] = max(maxp, 1 - CDFDunnett(sorted[i], nu, m - i + 1))
      maxp = max(maxp, temp[i])
    }

    temp[m] = max(maxp, 1 - stats::pt(sorted[m], nu))
  # Return to the original ordering
  adjpvalue[ordered] = temp
  result = adjpvalue
}
else if (call == TRUE) {
  n = paste0("Common sample size={", n, "}")
  result = list(list("Step-down Dunnett procedure"), list(n))
}

return(result)
}
# End of StepDownDunnettAdj
