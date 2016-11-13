######################################################################################################################

# Compute the ratio of effect sizes for HR (time-to-event) based on non-missing values in the combined sample

RatioEffectSizeEventStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the statistic or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=4)
      stop("Analysis model: Four samples must be specified in the RatioEffectSizeEventStat statistic.")

    result1 = EffectSizeEventStat(list(sample.list[[1]], sample.list[[2]]), parameter)

    result2 = EffectSizeEventStat(list(sample.list[[3]], sample.list[[4]]), parameter)

    # Caculate the ratio of effect size
    result = result1 / result2
  }

  else if (call == TRUE) {
    result = list("Ratio of effect size")
  }

  return(result)
}
# End of RatioEffectSizeEventStat
