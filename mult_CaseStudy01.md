---
layout: page
title: Case study 1
header: Case study 1
group: 
---

{% include JB/setup %}

## Summary

The clinical trial example used in this case study is based on the Phase III clinical trial presented in Keystone et al. (2004). The trial was conducted to evaluate the efficacy and safety of a novel treatment in the population of patients with rheumatoid arthritis who had an inadequate response to methotrexate. The primary analysis was based on the American College of Rheumatology (ACR) definition of improvement and patients were classified as responders if they experienced an improvement of at least 20% in the core criteria at Week 24 (the resulting primary endpoint is known as ACR20). Two doses of the experimental treatment were tested in the trial against a placebo.

## Define a Data Model
The data model defines parameters used for generating patient data in the clinical trial. In this case study, a set of outcome distribution parameters is
specified for each of the three samples in the data model to represent different assumptions on the expected proportions of patients who meet the ACR20
response criterion at Week 24. The sets correspond to the three scenarios defined in the following table :

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th rowspan="2">Outcome parameter set</th>
                <th colspan="2" class="text-center">Response rate</th>
            </tr>
            <tr>
                <th>Placebo</th>
                <th>Dose L</th>
                <th>Dose H</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Scenario 1</td>
                <td>30%</td>
                <td>50%</td>
                <td>50%</td>
            </tr>
            <tr>
                <td>Scenario 2</td>
                <td>30%</td>
                <td>40%</td>
                <td>50%</td>
            </tr>
            <tr>
                <td>Scenario 3</td>
                <td>30%</td>
                <td>50%</td>
                <td>45%</td>
            </tr>
        </tbody>
    </table>
</div>

The outcome parameters are specified using the following R code.

{% highlight R %}
# Outcome parameters - Scenario 1
outcome.placebo.sc1 = parameters(prop = 0.30)
outcome.dosel.sc1 = parameters(prop = 0.50)
outcome.doseh.sc1 = parameters(prop = 0.50)

# Outcome parameters - Scenario 2
outcome.placebo.sc2 = parameters(prop = 0.30)
outcome.dosel.sc2 = parameters(prop = 0.40)
outcome.doseh.sc2 = parameters(prop = 0.50)

# Outcome parameters - Scenario 3
outcome.placebo.sc3 = parameters(prop = 0.30)
outcome.dosel.sc3 = parameters(prop = 0.50)
outcome.doseh.sc3 = parameters(prop = 0.45)
{% endhighlight %}

The sample size is set to 100 patients per arm and a simplified assumption that all patients complete the trial is made in this case study. In the Mediana package, a dropout mechanism can be introduced to model more realistic settings with incomplete outcomes. This can be easily accomplished by specifying the dropout distribution and associated parameters (enrollment distribution, follow-up duration) in a Design object. For example, the dropout process can be modeled using an exponential distribution. As the primary endpoint is evaluated at Week 24, the follow-up duration is considered fixed for all patients, i.e., 24 weeks, and the enrollment period is estimated to be approximately 2 years, i.e., 104 weeks.

{% highlight R %}
# Design parameters (in weeks)
Design(enroll.period = 104,
       followup.period = 24,
       enroll.dist = "UniformDist",
       dropout.dist = "ExpoDist",
       dropout.dist.par = parameters(rate = 0.01))
{% endhighlight %}

The data model is initialized using the `DataModel` object and each component
of this object can be added one at a time. The outcome distribution
is defined using the `OutcomeDist` object with the `BinomDist` distribution, the
common sample size per arm is specified in the `SampleSize` object and the
outcome distribution parameters for each trial arm are specified in `Sample`
objects.

{% highlight R %}
# Data model
mult.cs1.data.model = 
  DataModel() +
  OutcomeDist(outcome.dist = "BinomDist") +
  SampleSize(100) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.placebo.sc1, 
                                  outcome.placebo.sc2, 
                                  outcome.placebo.sc3)) +
  Sample(id = "Dose L",
         outcome.par = parameters(outcome.dosel.sc1, 
                                  outcome.dosel.sc2, 
                                  outcome.dosel.sc3)) +
  Sample(id = "Dose H",
         outcome.par = parameters(outcome.doseh.sc1, 
                                  outcome.doseh.sc2, 
                                  outcome.doseh.sc3))
{% endhighlight %}

## Define an Analysis Model

The analysis model is composed of the two statistical tests that will be performed
to compare Doses L and H to Placebo as well as the multiplicity
adjustment procedures used to control the Type I error rate.

Each dose-placebo comparison will be carried out using a two-sample test
for proportions, defined in the Test object with the `PropTest` method. Since
the statistical tests are one-sided, the order of the two samples in the samples
argument is important. If a higher numerical value of the endpoint indicates
a beneficial effect, which is the case with the ACR20 response rate, the first
sample must correspond to the sample expected to have the lower value of
the endpoint. Thus `"Placebo"` is included as the first sample in the test
specification.

Concerning the multiplicity adjustment procedures, three procedures are
defined in this analysis model using the `MultAdjProc` object. First, in order to request a straightforward analysis without any adjustment, an empty object
is set up, i.e., `MultAdjProc(proc = NA)`. The fixed-sequence procedure
(Procedure F) is defined using a `FixedSeqAdj` method while the Hochberg adjustment
procedure (Procedure H) is defined using the `HochbergAdj` method.


{% highlight R %}
# Analysis model
mult.cs1.analysis.model = AnalysisModel() +
  MultAdjProc(proc = NA) +
  MultAdjProc(proc = "FixedSeqAdj") +
  MultAdjProc(proc = "HochbergAdj") +
  Test(id = "Placebo vs Dose H",
       samples = samples("Placebo", "Dose H"),
       method = "PropTest") +
  Test(id = "Placebo vs Dose L",
       samples = samples("Placebo", "Dose L"),
       method = "PropTest")
{% endhighlight %}

It is worth noting that, by default, the multiplicity adjustment procedures
defined in the analysis model will be applied to all tests included in the
`AnalysisModel` object in the order specified. Specifically, the fixed-sequence
procedure will begin with the test of Dose H versus Placebo and then examine
the test of Dose L versus Placebo.

## Define an Evaluation Model

The evaluation model specifies the metrics for assessing the performance of the
analysis model based on the assumptions defined in the data model. In this
case study, several criteria are evaluated to assess the performance of the three
analysis methods (no multiplicity adjustment, Procedure F and Procedure H).
First, the disjunctive criterion, is defined as the probability to reject at
least one null hypothesis, i.e., the probability of demonstrating a statistically
significant effect with at least one dose. This criterion is defined using the
`DisjunctivePower` method.

The second criterion is based on simple weighted power, which corresponds
to the weighted sum of the marginal power functions of the two
dose-placebo tests. This criterion can be defined in the evaluation model using
the `WeightedPower` method, where the weights associated with each test
are specified in the par argument.

Finally, the partition-based weighted criterion is a custom criterion, which
is not currently implemented in the Mediana package. Nonetheless, a custom
criterion function can be created and used within the evaluation model. This
custom function includes three arguments. The first argument (`test.result`)
is a matrix of p-values associated with the tests defined in the tests argument
of the `Criterion` object. Similarly, the second argument (`statistic.result`)
is a matrix of results corresponding to the statistics defined in the `statistics` argument of the `Criterion` object. In this case study, no `Statistic` objects
were specified in the analysis model and this criterion will only use the p-
values returned by the tests associated with the two dose-placebo comparisons.
Finally, the last argument (`parameter`) contains the optional parameter(s)
defined in the par argument of the `Criterion` object. For the partition-based
weighted power, the `par` argument must contain the weights associated with
each of the three outcomes:

- Reject H1 only

- Reject H2 only

- Simultaneously reject H1 and H2 

The `mult.cs1.PartitionBasedWeightedPower` function evaluates the probability
of each outcome and then computes the weighted sum.

{% highlight R %}
# Custom evaluation criterion: Partition-based weighted power
mult.cs1.PartitionBasedWeightedPower = function(test.result, statistic.result, parameter) {
  
  # Parameters
  alpha = parameter$alpha
  weight = parameter$weight
  
  # Outcomes
  H1_only = ((test.result[,1] <= alpha) & (test.result[,2] > alpha))
  H2_only = ((test.result[,1] > alpha) & (test.result[,2] <= alpha))
  H1_H2 = ((test.result[,1] <= alpha) & (test.result[,2] <= alpha))
  
  # Weighted power
  power = mean(H1_only) * weight[1] + mean(H2_only) * weight[2] + mean(H1_H2) * weight[3] 
  
  return(power)
}
{% endhighlight %}

It needs to be noted that the order of tests in the `tests` argument of this
custom function is important. The first test should be the one corresponding
to the comparison of Dose H versus Placebo and the second test is based on
the comparison of Dose L versus Placebo.
Finally, the evaluationmodel can be constructed by specifying each `Criterion` object. In addition, marginal power of each test can be computed using the
`MarginalPower` method.

{% highlight R %}
# Evaluation model
mult.cs1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs Dose H",
                          "Placebo vs Dose L"),
            labels = c("Placebo vs Dose H",
                       "Placebo vs Dose L"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("Placebo vs Dose H",
                          "Placebo vs Dose L"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Weighted power",
            method = "WeightedPower",
            tests = tests("Placebo vs Dose H",
                          "Placebo vs Dose L"),
            labels = "Weighted power (v1 = 0.4, v2 = 0.6)",
            par = parameters(alpha = 0.025, 
                             weight = c(0.4, 0.6))) +
  Criterion(id = "Partition-based weighted power",
            method = "mult.cs1.PartitionBasedWeightedPower",
            tests = tests("Placebo vs Dose H",
                          "Placebo vs Dose L"),
            labels = "Partition-based weighted power (v1 = 0.15, v2 = 0.25, v12 = 0.6)",
            par = parameters(alpha = 0.025, 
                             weight = c(0.15, 0.25, 0.6)))
{% endhighlight %}


## Perform Clinical Scenario Evaluation

Using the data, analysis and evaluation models, simulation-based Clinical Scenario Evaluation is performed by calling the `CSE` function:

{% highlight R %}
# Simulation Parameters
mult.cs1.sim.parameters =  SimParameters(n.sims = 100000,
                                         proc.load = "full",
                                         seed = 42938001)

# Perform clinical scenario evaluation
mult.cs1.results = CSE(mult.cs1.data.model,
                       mult.cs1.analysis.model,
                       mult.cs1.evaluation.model,
                       mult.cs1.sim.parameters)
{% endhighlight %}

## Download

Click on the icons below to download the R code used in this case study and report that summarizes the results of Clinical Scenario Evaluation:

<center>
  <div class="col-md-6">
    <a href="mult-cs1-report.docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
	<br>
  </div>
  <div class="col-md-6">
    <a href="mult-cs1-mediana.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>
