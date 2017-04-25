######################################################################################################################

# Function: StepDownDunnettAdj.CI
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m)
# Description: Dunnett multiple testing procedure.

StepDownDunnettAdj.CI = function(est, par) {

  # Number of point estimate
  m = length(est)

  # Extract the sample size
  if (is.null(par[[2]]$n)) stop("Step-down Dunnett procedure: Sample size must be specified (n).")
  n = par[[2]]$n

  # Extract the standard deviation
  if (is.null(par[[2]]$sd)) stop("Step-down Dunnett procedure: Standard deviation must be specified (sd).")
  sd = par[[2]]$sd

  # Extract the simultaneous coverage probability
  if (is.null(par[[2]]$covprob)) stop("Step-down Dunnett procedure: Coverage probability must be specified (covprob).")
  covprob = par[[2]]$covprob

  # Error checks
  if (m != length(est)) stop("Step-down Dunnett procedure: Length of the point estimate vector must be equal to the number of hypotheses.")
  if (m != length(sd)) stop("Step-down Dunnett procedure: Length of the standard deviation vector must be equal to the number of hypotheses.")
  if (covprob>=1 | covprob<=0) stop("Step-down Dunnett procedure: simultaneous coverage probability must be >0 and <1")

  # Standard errors
  stderror = sd*sqrt(2/n)
  # T-statistics associated with each test
  stat = est/stderror
  # Compute degrees of freedom of the test statistic
  nu = 2*(n-1)
  # Compute raw one-sided p-values
  rawp = 1-stats::pt(stat,nu)
  # Compute the adjusted p-values
  adjustpval = StepDownDunnettAdj(rawp, list("Analysis", list(n = n)))

  # Alpha
  alpha = 1-covprob
  # Compute the degree of freedom for the Step-down Dunnett procedure
  nu_dunnett = (m+1)*(n-1)

  ci = rep(0,m)
  rejected = (adjustpval <= alpha)

  if (all(rejected)){
    # All null hypotheses are rejected
    # Critical value
    critical_value = stats::qt(1-alpha, nu_dunnett)
    ci <- pmax(0, est-critical_value*stderror)
  } else {
    critical_value = qdunnett(1-alpha,nu, m-sum(rejected))
    ci[!rejected] = est[!rejected] - critical_value*stderror[!rejected]
  }

  return(ci)
}
# End of StepDownDunnettAdj.CI
