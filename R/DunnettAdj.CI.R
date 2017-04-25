######################################################################################################################

# Function: DunnettAdj.CI
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m)
# Description: Dunnett multiple testing procedure.

DunnettAdj.CI = function(est, par) {

  # Number of point estimate
  m = length(est)

  # Extract the sample size
  if (is.null(par[[2]]$n)) stop("Dunnett procedure: Sample size must be specified (n).")
  n = par[[2]]$n

  # Extract the standard deviation
  if (is.null(par[[2]]$sd)) stop("Dunnett procedure: Standard deviation must be specified (sd).")
  sd = par[[2]]$sd

  # Extract the simultaneous coverage probability
  if (is.null(par[[2]]$covprob)) stop("Dunnett procedure: Coverage probability must be specified (covprob).")
  covprob = par[[2]]$covprob

  # Error checks
  if (m != length(est)) stop("Dunnett procedure: Length of the point estimate vector must be equal to the number of hypotheses.")
  if (m != length(sd)) stop("Dunnett procedure: Length of the standard deviation vector must be equal to the number of hypotheses.")
  if (covprob>=1 | covprob<=0) stop("Dunnett procedure: simultaneous coverage probability must be >0 and <1")

  # Standard errors
  stderror = sd*sqrt(2/n)
  # T-statistics associated with each test
  stat = est/stderror

  # Alpha
  alpha = 1-covprob
  # Compute the degree of freedom for the Dunnett procedure
  nu_dunnett = (m+1)*(n-1)
  # Critical value of Dunett
  critical_value = qdunnett(1-alpha,nu_dunnett,m)
  # Lower simultaneous confidence limit
  ci = est - critical_value*stderror

  return(ci)
}
# End of DunnettAdj.CI
