# Template of a function to generate observations
TemplateDist = function(parameter) {

  # Determine the function call, either to generate distribution or to return the distribution's description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    # The number of observations to generate
    n = parameter[[1]]

    ##############################################################
    # Distribution-specific component
    # Get the distribution's parameters (stored in the parameter[[2]] list)
    parameter1 = parameter[[2]]$parameter1
    parameter2 = parameter[[2]]$parameter2
    ##############################################################

    # Error checks (other checks could be added by the user if needed)
    if (n%%1 != 0)
      stop("Data model: TemplateDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: TemplateDist distribution: Number of observations must be positive.")

    ##############################################################
    # Distribution-specific component
    # Observations are generated using the "fundist" function and assigned to the "result" object
    result = fundist(n = n, parameter1 = parameter1, parameter2 = parameter2)
    ##############################################################

  } else {
    # Provide information about the distribution function
    if (call == TRUE) {

      ##############################################################
      # Distribution-specific component
      # The labels of the distributional parameters and the distribution's label must be stored in the "result" list
      result = list(list(parameter1 = "parameter1", parameter2 = "parameter2"),
                    list("Template"))
      ##############################################################

    }
  }
  return(result)

}