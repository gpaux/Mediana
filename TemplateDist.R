# Template of a function to generate data
TemplateDist = function(parameter) {
  
  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")
  
  # Generate random variables
  if (call == FALSE) {
    # The number of patients to generate
    n = parameter[[1]]
    
    ##############################################################
    # To modify according to the function
    # Get the other parameter (kept in the parameter[[2]] list)
    parameter1 = parameter[[2]]$parameter1
    parameter2 = parameter[[2]]$parameter2
    ##############################################################
    
    # Error checks (other checks could be added by the user if needed)
    if (n%%1 != 0)
      stop("Data model: TemplateDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: TemplateDist distribution: Number of observations must be positive.")
    
    ##############################################################
    # To modify according to the function
    # Data are generated using the function "fundist" and assign to the object result
    result = fundist(n = n, parameter1 = parameter1, parameter2 = parameter2)
    ##############################################################
    
  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      
      ##############################################################
      # To modify according to the function
      # The labels of the distributional parameters and the label of the distribution must be put in the list
      result = list(list(parameter1 = "parameter1", parameter2 = "parameter2"),
                    list("Template Dist"))
      ##############################################################
      
    }
  }
  return(result)
  
}
