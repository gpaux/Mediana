######################################################################################################################

# Function: FallbackAdj.
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m) matrix of transition parameters (m x m)
# Description: Fixed sequence procedure.

FallbackAdj = function(p, par) {

  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")

  # Number of p-values
  m = length(p)

  # Extract the vector of hypothesis weights (1 x m)
  if (!any(is.na(par[[2]]))) {
    if (is.null(par[[2]]$weight)) stop("Analysis model: Fallback procedure: Hypothesis weights must be specified.")
    w = par[[2]]$weight
  } else {
    w = rep(1/m, m)
  }

  if (any(call == FALSE) | any(is.na(call))) {
    # Error checks
    if (length(w) != m) stop("Analysis model: Fallback procedure: Length of the weight vector must be equal to the number of hypotheses.")
    if (sum(w)!=1) stop("Analysis model: Fallback procedure: Hypothesis weights must add up to 1.")
    if (any(w < 0)) stop("Analysis model: Fallback procedure: Hypothesis weights must be greater than 0.")

    # number of intersection
    nbint <- 2^m - 1

    # matrix of intersection hypotheses
    int <- matrix(0, nbint, m)
    for (i in 1:m) {
      for (j in 0:(nbint - 1)) {
        k <- floor(j/2^(m - i))
        if (k/2 == floor(k/2))
          int[j + 1, i] <- 1
      }
    }
    #int = as.matrix(expand.grid(rep(list(0:1),m)))[-1,]

    # calculate all intersection local p-values
    int.all.pval = t(apply(int, 1, function(x) p/fallback_weight(w,x)))

    # calculate the intersection p-values
    #int.pval = int*apply(int.all.pval, 1, min)

    # calculate the adjusted p-values
    result = pmin(1, apply(int*apply(int.all.pval, 1, min), 2, max))

    }
  else if (call == TRUE) {
    weight = paste0("Weight={",paste(round(w,2), collapse = ","),"}")
    result=list(list("Fallback procedure"),list(weight))

  }

  return(result)
}
# End of FallbackAdj

# add-on function used in the FallbackAdj function
fallback_weight = function(w,int){
  v = rep(0,length(w))
  v[1] = int[1]*w[1]
  for (i in 2:length(w)){
    v[i] = int[i] * (sum(w[1:i])-sum(v[1:(i-1)]))
  }
  v
}
