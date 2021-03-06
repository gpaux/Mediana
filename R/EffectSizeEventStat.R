######################################################################################################################

# Compute the log hazard ratio based on non-missing values in the combined sample

EffectSizeEventStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the statistic or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=2)
      stop("Analysis model: Two samples must be specified in the EffectSizeEventStat statistic.")

    if (is.na(parameter[[2]])) method = "Log-Rank"
    else {
      if (!(parameter[[2]]$method %in% c("Log-Rank", "Cox")))
        stop("Analysis model: HazardRatioStat statistic : the method must be Log-Rank or Cox.")

      method = parameter[[2]]$method
    }

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]
    # Observed events in Sample 1 (negation of censoring indicators)
    event1 = !sample.list[[1]][, "patient.censor.indicator"]
    event1.complete = event1[stats::complete.cases(outcome1)]
    # Sample size in Sample 1
    n1 = length(outcome1.complete)

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]
    # Observed events in Sample 2 (negation of censoring indicators)
    event2 = !sample.list[[2]][, "patient.censor.indicator"]
    event2.complete = event2[stats::complete.cases(outcome2)]
    # Sample size in Sample 2
    n2 = length(outcome2.complete)

    # Create combined samples of outcomes, censoring indicators (all events are observed) and treatment indicators
    outcome = c(outcome1.complete, outcome2.complete)
    event = c(event1.complete, event2.complete)
    treatment = c(rep(0, n1), rep(1, n2))

    # Get the HR
    if (method == "Log-Rank"){
      surv.test = survival::survdiff(survival::Surv(outcome, event) ~ treatment)
      result = -log((surv.test$obs[2]/surv.test$exp[2])/(surv.test$obs[1]/surv.test$exp[1]))
    } else if (method == "Cox"){
      result = -log(summary(survival::coxph(survival::Surv(outcome, event) ~ treatment))$coef[,"exp(coef)"])
    }

  }

  else if (call == TRUE) {
    if (is.na(parameter[[2]])) result = list("Effect size (event)")
    else {
      result = list("Effect size (event)", "method = ")
    }
  }

  return(result)
}
# End of EffectSizeEventStat
