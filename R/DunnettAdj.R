######################################################################################################################

# Function: DunnettAdj.
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: common sample size per trial arm (1 x 1)
# Description: Single-step Dunnett procedure.

DunnettAdj = function(p, par) {

  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")

  # Number of test statistics
  m = length(p)

  # Extract the common sample size per trial arm (1 x 1)
  if (!any(is.na(par[[2]]))) {
    if (is.null(par[[2]]$n)) stop("Analysis model: Single-step Dunnett procedure: Common sample size per trial arm must be specified.")
    n = par[[2]]$n
  }

  # Error checks
  if (n < 0) stop("Analysis model: Single-step Dunnett procedure: Common sample size per trial arm must be greater than 0.")

  # Number of degrees of freedom
  nu = (m + 1) * (n - 1)

  # Compute test statistics from p-values (assuming that each test statistic follows a t distribution)
  stat = stats::qt(1 - p, df = 2 * (n - 1))

  if (any(call == FALSE) | any(is.na(call))) {
    # Adjusted p-values
    result = sapply(stat, function(x) 1 - CDFDunnett(x,nu,m))
  }
  else if (call == TRUE) {
    n = paste0("Common sample size={",n,"}")
    result=list(list("Single-step Dunnett procedure"),list(n))
  }

  return(result)
}
# End of DunnettAdj
