######################################################################################################################

# Function: FixedSeqAdj.CI
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m)
# Description: Fixed-sequence multiple testing procedure.

FixedSeqAdj.CI = function(est, par) {

  # Number of point estimate
  m = length(est)

  # Extract the sample size
  if (is.null(par[[2]]$n)) stop("Fixed-sequence procedure: Sample size must be specified (n).")
  n = par[[2]]$n

  # Extract the standard deviation
  if (is.null(par[[2]]$sd)) stop("Fixed-sequence procedure: Standard deviation must be specified (sd).")
  sd = par[[2]]$sd

  # Extract the simultaneous coverage probability
  if (is.null(par[[2]]$covprob)) stop("Fixed-sequence procedure: Coverage probability must be specified (covprob).")
  covprob = par[[2]]$covprob

  # Error checks
  if (m != length(est)) stop("Fixed-sequence procedure: Length of the point estimate vector must be equal to the number of hypotheses.")
  if (m != length(sd)) stop("Fixed-sequence procedure: Length of the standard deviation vector must be equal to the number of hypotheses.")
  if (covprob>=1 | covprob<=0) stop("Fixed-sequence procedure: simultaneous coverage probability must be >0 and <1")

  # Standard errors
  stderror = sd*sqrt(2/n)
  # T-statistics associated with each test
  stat = est/stderror
  # Compute degrees of freedom
  nu = 2*(n-1)

  # Compute raw one-sided p-values
  rawp = 1-stats::pt(stat,nu)

  # Compute the adjusted p-values
  adjustpval = FixedSeqAdj(rawp, list("Analysis"))

  # Compute the simultaneous confidence interval
  alpha = 1-covprob
  ci = rep(NA,m)
  rejected = (adjustpval <= alpha)
  if(all(rejected)){
    # All null hypotheses are rejected
    ci = min(est-stderror*stats::qnorm(1-alpha))
  } else if(!any(rejected)){
    # All null hypotheses are accepted
    ci[1] = est[1]-stderror[1]*stats::qnorm(1-alpha)
  } else if (any(rejected)){
    # Some null hypotheses are accepted and some are rejected
    last_rejected = utils::tail(which(rejected), n = 1)
    ci[1:(last_rejected)] = 0
    ci[last_rejected + 1] = est[last_rejected + 1]-stderror[last_rejected + 1]*stats::qnorm(1-alpha)
  }

  return(ci)
}
# End of FixedSeqAdj.CI
