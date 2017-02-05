######################################################################################################################

# Compute the ratio of effect sizes for HR (time-to-event) based on non-missing values in the combined sample

RatioEffectSizeEventStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the statistic or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=4)
      stop("Analysis model: Four samples must be specified in the RatioEffectSizeEventStat statistic.")

    if (is.na(parameter[[2]])) method = "Log-Rank"
    else {
      if (!(parameter[[2]]$method %in% c("Log-Rank", "Cox")))
        stop("Analysis model: HazardRatioStat statistic : the method must be Log-Rank or Cox.")

      method = parameter[[2]]$method
    }

    result1 = EffectSizeEventStat(list(sample.list[[1]], sample.list[[2]]), parameter)

    result2 = EffectSizeEventStat(list(sample.list[[3]], sample.list[[4]]), parameter)

    # Caculate the ratio of effect size
    result = result1 / result2
  }

  else if (call == TRUE) {
    if (is.na(parameter[[2]])) result = list("Ratio of effect size (event)")
    else {
      result = list("Ratio of effect size (event)", "method = ")
    }
  }

  return(result)
}
# End of RatioEffectSizeEventStat
