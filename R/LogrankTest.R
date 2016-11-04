######################################################################################################################

# Function: LogrankTest .
# Argument: Data set and parameter.
# Description: Computes one-sided p-value based on log-rank test.

LogrankTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Sample list is assumed to include two data frames that represent two analysis samples

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

    data = data.frame(time = outcome,
                      event = event,
                      treatment = treatment)
    data = data[order(data$time),]
    data$event1 = data$event*(data$treatment==0)
    data$event2 = data$event*(data$treatment==1)
    data$eventtot = data$event1 + data$event2
    data$n.risk1.prior = length(outcome1) - cumsum(data$treatment==0) + (data$treatment==0)
    data$n.risk2.prior = length(outcome2) - cumsum(data$treatment==1) + (data$treatment==1)
    data$n.risk.prior = data$n.risk1.prior + data$n.risk2.prior

    data$e1 = data$n.risk1.prior*data$eventtot/data$n.risk.prior
    data$u1 = data$event1 - data$e1
    data$v1 = ifelse(data$n.risk.prior > 1,
                     (data$n.risk1.prior*data$n.risk2.prior*data$eventtot*(data$n.risk.prior - data$eventtot))/(data$n.risk.prior**2*(data$n.risk.prior-1)),
                     0)

    stat.test = sum(data$u1)/sqrt(sum(data$v1))

    # Compute one-sided p-value
    result = stats::pnorm(stat.test, lower.tail = FALSE)

  }

  else if (call == TRUE) {
    result = list("Log-rank test")
  }

  return(result)
}
# End of LogrankTest
