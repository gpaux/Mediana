# Function: TruncatedExpoDist
# Argument: List of parameters (number of observations, rate, truncation parameter).
# Description: This function is used to generate outcomes from a truncated exponential distribution.

TruncatedExpoDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: TruncatedExpoDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$rate))
    stop("Data model: TruncatedExpoDist distribution: rate parameter must be specified.")
  if (is.null(parameter[[2]]$trunc))
    stop("Data model: TruncatedExpoDist distribution: trunc parameter must be specified.")

  rate = parameter[[2]]$rate
  trunc = parameter[[2]]$trunc

  # Parameters check
  if (rate <= 0) stop("Data model: TruncatedExpoDist distribution: rate parameter must be positive")
  if (trunc <= 0) stop("Data model: TruncatedExpoDist distribution: trunc parameter must be positive")

  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    # Error checks
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: TruncatedExpoDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: TruncatedExpoDist distribution: Number of observations must be positive.")

    result = -log(1 - stats::runif(n) * (1 - exp(-rate * trunc))) / rate


  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      result = list(list("rate", "trunc"),list("Truncated Exponential"))
    }
  }
  return(result)

}
# End of TruncatedExpoDist
