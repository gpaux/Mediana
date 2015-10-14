# Template of a function to perform an evaluation
TemplateCriterion = function(test.result, statistic.result, parameter)  {
  
  ##############################################################
  # To modify according to the function
  # Get the parameter (kept in the parameter[[1]] list)
  parameter1 = parameter[[1]]
  parameter2 = parameter[[2]]
  ##############################################################
  
  ##############################################################
  # To modify according to the function
  # Binary variable (success/failure of the criterion)
  # If the criterion is based on p-value returned by Test object, the test.result matrix must be used
  # test.result matrix has as many row as the number of simulations, and as many columns as the number
  # of tests specified in the Criterion argument tests
  # If the criterion is based on statistics returned by Statistic object, the statistic.result matrix must be used
  # statistic.result matrix has as many row as the number of simulations, and as many columns as the number
  # of statistics specified in the Criterion argument statistics
  # Example with two tests and one statistics (at least one test must be significant, 
  # and the statistics must be greater than a threshold)
  significant = ((test.result[,1] <= parameter1) | ((test.result[,2] <= parameter1) | (statistic.result[,2] > parameter2)))
  ##############################################################

  power = mean(significant)
  return(power)
}