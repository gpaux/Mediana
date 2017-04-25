######################################################################################################################

# Function: HolmAdj.CI
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m)
# Description: Holm multiple testing procedure.

HolmAdj.CI = function(est, par) {

  # Number of point estimate
  m = length(est)

  # Extract the vector of hypothesis weights (1 x m)
  if (is.null(par[[2]]$weight)) w = rep(1/m, m)
  else w = par[[2]]$weight

  # Extract the sample size
  if (is.null(par[[2]]$n)) stop("Holm procedure: Sample size must be specified (n).")
  n = par[[2]]$n

  # Extract the standard deviation
  if (is.null(par[[2]]$sd)) stop("Holm procedure: Standard deviation must be specified (sd).")
  sd = par[[2]]$sd

  # Extract the simultaneous coverage probability
  if (is.null(par[[2]]$covprob)) stop("Holm procedure: Coverage probability must be specified (covprob).")
  covprob = par[[2]]$covprob

  # Error checks
  if (length(w) != m) stop("Holm procedure: Length of the weight vector must be equal to the number of hypotheses.")
  if (m != length(est)) stop("Holm procedure: Length of the point estimate vector must be equal to the number of hypotheses.")
  if (m != length(sd)) stop("Holm procedure: Length of the standard deviation vector must be equal to the number of hypotheses.")
  if (sum(w)!=1) stop("Holm procedure: Hypothesis weights must add up to 1.")
  if (any(w < 0)) stop("Holm procedure: Hypothesis weights must be greater than 0.")
  if (covprob>=1 | covprob<=0) stop("Holm procedure: simultaneous coverage probability must be >0 and <1")

  # Standard errors
  stderror = sd*sqrt(2/n)
  # T-statistics associated with each test
  stat = est/stderror
  # Compute degrees of freedom
  nu = 2*(n-1)

  # Compute raw one-sided p-values
  rawp = 1-stats::pt(stat,nu)

  # Compute the adjusted p-values
  adjustpval = HolmAdj(rawp, list("Analysis", list(weight = w)))

  # Compute the simultaneous confidence interval
  alpha = 1-covprob
  ci = rep(0,m)
  rejected = (adjustpval <= alpha)
  adjalpha = (alpha*w)/sum(w[!rejected])
  if(all(rejected)){
    # All null hypotheses are rejected
    ci = pmax(0,est - stderror*stats::qnorm(1-(alpha*w)))
  } else {
    # Some null hypotheses are accepted and some are rejected
    ci[rejected] = 0
    ci[!rejected] = est[!rejected]-(stderror[!rejected]*stats::qnorm(1-adjalpha[!rejected]))
  }

  return(ci)
}
# End of HolmAdj.CI
