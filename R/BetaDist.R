######################################################################################################################

# Function: BetaDist .
# Argument: List of parameters (number of observations, a, b).
# Description: This function is used to generate beta distributed outcomes.

BetaDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: BetaDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$a))
    stop("Data model: BetaDist distribution: Parameter a must be specified.")
  if (is.null(parameter[[2]]$b))
    stop("Data model: BetaDist distribution: Parameter b must be specified.")

  a = parameter[[2]]$a
  b = parameter[[2]]$b

  if (a <= 0 | b <= 0)
    stop("Data model: BetaDist distribution: Parameters a and b must be non-negative.")

  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    # Error checks
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: BetaDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: BetaDist distribution: Number of observations must be positive.")


    result = stats::rbeta(n = n, shape1 = a, shape2 = b)
  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      result = list(list(a = "a", b = "b"),list("Beta"))
    }
  }
  return(result)

}
#End of BetaDist