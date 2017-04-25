######################################################################################################################

# Function: CDFDunnett
# Argument: stat, Test statistic (1 x 1)
#           df, Number of degrees of freedom (1 x 1)
#           m, Number of comparisons (1 x 1)
# Description: Cumulative distribution function of the Dunnett distribution in one-sided
#              multiplicity problems with a balanced one-way layout and
#              equally weighted null hypotheses

CDFDunnett = function(stat, df, m) {
  # Correlation matrix
  corr = matrix(0.5, m, m)
  for (i in 1:m)
    corr[i, i] = 1
  p = mvtnorm::pmvt(
    lower = rep(-Inf, m),
    upper = rep(stat, m),
    delta = rep(0, m),
    df = df,
    corr = corr,
    algorithm = mvtnorm::GenzBretz(
      maxpts = 25000,
      abseps = 0.00001,
      releps = 0
    )
  )[1]
  return(p)
}
