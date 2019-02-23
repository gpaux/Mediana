######################################################################################################################

# Function: errorfrac.
# Argument: k: Number of null hypotheses included in the intersection within the family.
#           n: Total number of null hypotheses in the family.
#       gamma: Truncation parameter (0<=GAMMA<1).

# Description: Evaluate error fraction function for a family based on Bonferroni, Holm, Hochberg or Hommel procedures

errorfrac = function(k, n, gamma) {
  if (k > 0){
        f = ifelse(k!=n, gamma + (1 - gamma) * k/n, 1)
  } else if (k == 0) f = 0
  return(f)
}
# End of errorfrac
