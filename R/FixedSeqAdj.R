######################################################################################################################

# Function: FixedSeqAdj.
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m) matrix of transition parameters (m x m)
# Description: Fixed sequence procedure.

FixedSeqAdj = function(p, par) {

  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")

  if (any(call == FALSE) | any(is.na(call))) {
    result = cummax(p)
  }
  else if (call == TRUE) {
    result=list(list("Fixed-sequence procedure"),NULL)
  }



  return(result)
}
# End of FixedSeqAdj
