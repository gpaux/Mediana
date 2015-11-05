# Template of a function to implement a success criterion
TemplateCriterion = function(test.result, statistic.result, parameter)  {
  
  ##############################################################
  # Criterion-specific component
  # Get the criterion's parameter (stored in the parameter list)
  parameter1 = parameter[[1]]
  parameter2 = parameter[[2]]
  ##############################################################
  
  ##############################################################
  # Criterion-specific component
  # Binary variable (success/failure of the criterion)
  # If the criterion is based on a p-value returned by a Test object, the test.result 
  # matrix must be used. The test.result matrix has as many rows as the number of simulations, 
  # and as many columns as the number of tests specified in the tests argument of this criterion.
  # If the criterion is based on a descriptive statistic returned by a Statistic object, 
  # the statistic.result matrix must be used. This matrix has as many rows as the number 
  # of simulations, and as many columns as the number of statistics specified in the 
  # the statistics argument of this criterion.
  # Two tests and one statistic are used in this example. At least one test value must 
  # be less than parameter1 and the statistic must be greater than parameter2.
  significant = ((test.result[,1] <= parameter1) | ((test.result[,2] <= parameter1) | (statistic.result[,2] > parameter2)))
  ##############################################################

  power = mean(significant)
  return(power)
}