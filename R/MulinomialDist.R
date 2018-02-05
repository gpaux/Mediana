# Function: MultinomialDist
# Argument: List of parameters (number of observations, list(probabilities)).
# Description: This function is used to generate multinomial (possibly ordered) outcomes.

MultinomialDist = function(parameter) {

  # Determine the function call, either to generate distribution or to return the distribution's description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    # The number of observations to generate
    n = parameter[[1]]

    ##############################################################
    # Distribution-specific component
    # Get the distribution's parameters (stored in the parameter[[2]] list)
    prob = parameter[[2]]$prob
    ##############################################################

    # Error checks (other checks could be added by the user if needed)
    if (n%%1 != 0)
      stop("Data model: MultinomialDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: MultinomialDist distribution: Number of observations must be positive.")

    # Error cheks on prob
    if (any(prob < 0 | prob > 1))
      stop("Data model: MultinomialDist distribution: Probabilities must be between 0 and 1.")
    if (sum(prob)!=1)
      stop("Data model: MultinomialDist distribution: The sum of probabilities must be equal to 1.")


    ##############################################################
    # Distribution-specific component
    # Observations are generated using the "fundist" function and assigned to the "result" object
    #result = fundist(n = n, parameter1 = parameter1, parameter2 = parameter2)
    #result = which((rmultinom(n, size = 1, prob = prob)==1), arr.ind = TRUE)[,'row']
    result = sample.int(length(prob), n, replace = TRUE, prob = prob)
    ##############################################################

  } else {
    # Provide information about the distribution function
    if (call == TRUE) {

      ##############################################################
      # Distribution-specific component
      # The labels of the distributional parameters and the distribution's label must be stored in the "result" list
#      result = list(list(parameter1 = "parameter1", parameter2 = "parameter2"),
#                    list("Template"))
      result = list(list(prob = "prob"), list("Multinomial"))
      ##############################################################

    }
  }
  return(result)

}
