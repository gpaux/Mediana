######################################################################################################################

# Function: WeibullDist.
# Argument: List of parameters (number of observations, shape, scale).
# Description: This function is used to generate Weibull distributed outcomes.

WeibullDist = function(parameter) {
  
  # Error checks
  if (missing(parameter))
    stop("Data model: WeibullDist distribution: List of parameters must be provided.")
  
  if (is.null(parameter[[2]]$shape))
    stop("Data model: WeibullDist distribution: shape parameter must be specified.")
  if (is.null(parameter[[2]]$scale))
    stop("Data model: WeibullDist distribution: scale parameter must be specified.")
  
  
  shape = parameter[[2]]$shape
  scale = parameter[[2]]$scale
  
  # Parameters check
  if (shape <= 0) stop("Data model: WeibullDist distribution: shape parameter must be positive")
  if (scale <= 0) stop("Data model: WeibullDist distribution: scale parameter must be positive")
  
  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")
  
  # Generate random variables
  if (call == FALSE) {
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: WeibullDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: WeibullDist distribution: Number of observations must be positive.")
    
    result = stats::rweibull(n = n, shape = shape, scale = scale)
  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      result = list(list(shape = "shape", scale = "scale"),list("Weibull"))
    }
  }
  return(result)
}
# End of WeibullDist