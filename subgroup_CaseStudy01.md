---
layout: page
title: Case study 1
header: Case study 1
group: 
---

{% include JB/setup %}

## Summary

This case study deals with a Phase III clinical trial in patients with mild or moderate asthma (it is based on a clinical trial example from Millen et al., 2014, Section 2.2). The trial is intended to support a tailoring strategy. In particular, the treatment effect of a single dose of a new treatment will be compared to that of placebo in the overall population of patients as well as a pre-specified subpopulation of patients with a marker-positive status at baseline (for compactness, the overall population is denoted by OP, marker-positive subpopulation is denoted by M+ and marker-negative subpopulation is denoted by M−).

Marker-positive patients are more likely to receive benefit from the experimental treatment. The overall objective of the clinical trial accounts for the fact that the treatment’s effect may, in fact, be limited to the marker-positive subpopulation. The trial will be declared successful if the treatment’s beneficial effect is established in the overall population of patients or, alternatively, the effect is established only in the subpopulation. The primary endpoint in the clinical trial is defined as an increase from baseline in the forced expiratory volume in one second (FEV1). This endpoint is normally distributed and improvement is associated with a larger change in FEV1.

## Define a Data Model
A data model specifies a scheme for generating individual patients’ data in
the set of pre-defined samples, i.e., non-overlapping homogeneous groups of
patients, in a clinical trial. In this case study, the overall population of patients
is naturally split into four samples that are defined as follows:

- Sample 1 (`Placebo Bio-Neg`) includes biomarker-negative patients in the
placebo arm.

- Sample 2 (`Placebo Bio-Pos`) includes biomarker-positive patients in the
placebo arm.

- Sample 3 (`Treatment Bio-Neg`) includes biomarker-negative patients in
the treatment arm.

- Sample 4 (`Treatment Bio-Pos`) includes biomarker-positive patients in
the treatment arm.

Using this definition of samples, the trial’s sponsor can model the fact that the
treatment’s effect is most pronounced in patients with a biomarker-positive
status.

For each sample in the data model, the parameters of the outcome distribution
(i.e., mean and common standard deviation) defined in the following Table are
listed in a single set of outcome parameters.

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>Sample</th>
                <th>Mean</th>
                <th>Standard deviation</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Placebo Bio-Neg</td>
                <td>0.12</td>
                <td>0.45</td>
            </tr>
            <tr>
                <td>Placebo Bio-Pos</td>
                <td>0.12</td>
                <td>0.45</td>
            </tr>
            <tr>
                <td>Treatment Bio-Neg</td>
                <td>0.21</td>
                <td>0.45</td>
            </tr>
            <tr>
                <td>Treatment Bio-Pos</td>
                <td>0.345</td>
                <td>0.45</td>
            </tr>
        </tbody>
    </table>
</div>

The outcome parameters are specified using the following R code.

{% highlight R %}
# Outcome parameters
outcome.placebo.neg = parameters(mean = 0.12, sd = 0.45)
outcome.placebo.pos = parameters(mean = 0.12, sd = 0.45)
outcome.treatment.neg = parameters(mean = 0.21, sd = 0.45)
outcome.treatment.pos = parameters(mean = 0.345, sd = 0.45)
{% endhighlight %}

Consider, for the sake of illustration, a data model with a single set of sample-specific patient counts that corresponds to the total sample size of 310 patients. The number of patients in each individual samples is computed based on the expected prevalence of biomarker-positive patients (40% of patients in
the population of interest are expected to have a biomarker-positive status).

{% highlight R %}
# Sample size parameters
prevalence.pos = 0.4
sample.size.total = 310

sample.size.placebo.neg = (1-prevalence.pos) / 2 * sample.size.total
sample.size.placebo.pos = prevalence.pos / 2 * sample.size.total
sample.size.treatment.neg = (1-prevalence.pos) / 2 * sample.size.total
sample.size.treatment.pos = prevalence.pos / 2 * sample.size.total
{% endhighlight %}

Finally, the data model can be set up by initializing the `DataModel` object
and adding each component to it. The outcome distribution is defined using
the `OutcomeDist` object with the `NormalDist` distribution. The data model
is shown below.

{% highlight R %}
# Data model
subgroup.cs1.data.model = 
  DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  Sample(id = "Placebo Bio-Neg",
         sample.size = sample.size.placebo.neg,
         outcome.par = parameters(outcome.placebo.neg)) +
  Sample(id = "Placebo Bio-Pos",
         sample.size = sample.size.placebo.pos,
         outcome.par = parameters(outcome.placebo.pos)) +
  Sample(id = "Treatment Bio-Neg",
         sample.size = sample.size.treatment.neg,
         outcome.par = parameters(outcome.treatment.neg)) +
  Sample(id = "Treatment Bio-Pos",
         sample.size = sample.size.treatment.pos,
         outcome.par = parameters(outcome.treatment.pos))
{% endhighlight %}

## Define an Analysis Model

The analysis model, shown below, defines the two individual
tests that will be carried out to compare the treatment to placebo in the
overall population (`OP test`) and in the subset of biomarker-positive patients
(`Bio-Pos test`). Each comparison will be carried out based on a one-sided
two-sample t-test (`TTest` method defined in each `Test` object). A key feature
of the analysis strategy in this case study is that the samples defined in the
data model are different from the samples used in the analysis of the primary
endpoint. As shown in above, four samples were included in the data
model. However, from the analysis perspective, the sponsor is interested in
examining the treatment effect within two samples, namely, the placebo and
treatment samples within the overall population and within the biomarker-positive
subpopulation. As shown below, to perform a comparison in the
overall population (`OP test`), the t-test needs to applied to the following
analysis samples:

- Placebo arm is defined by merging the samples `Placebo Bio-Neg` and
`Placebo Bio-Pos`.
 
- Treatment arm is defined by merging the samples `Treatment Bio-Neg`
and `Treatment Bio-Pos`.

Further, the treatment effect test in the subpopulation of biomarker-positive
patients (Bio-Pos test) is carried out based on these analysis samples:

- Placebo arm is defined directly based on the sample `Placebo Bio-Pos`.
 
- Treatment armis defined directly based on the sample `Treatment Bio-Pos`.

In addition, the weighted Bonferroni and Hochberg procedures are requested
using the `MultAdjProc` objects. For the purpose of illustration, the
initial weight of the overall population test has been set to 0.8 and thus the
weight of the subpopulation test equals 0.2.

{% highlight R %}
# Analysis model
subgroup.cs1.analysis.model = 
  AnalysisModel() +
  Test(id = "OP test",
       samples = samples(c("Placebo Bio-Neg", "Placebo Bio-Pos"),
                         c("Treatment Bio-Neg", "Treatment Bio-Pos")),
       method = "TTest") +
  Test(id = "Bio-Pos test",
       samples = samples("Placebo Bio-Pos", "Treatment Bio-Pos"),
       method = "TTest") +
  MultAdjProc(proc = "BonferroniAdj",
              par = parameters(weight = c(0.8, 0.2))) +
  MultAdjProc(proc = "HochbergAdj",
              par = parameters(weight = c(0.8, 0.2)))
{% endhighlight %}

## Define an Evaluation Model

The evaluation model specifies clinically relevant criteria for assessing the
performance of the selected test and multiplicity adjustment defined in the
analysis model. As a starting point, it is of interest to compute the probability
of achieving a significant outcome in each individual test, e.g., the
probability of a significant difference between the treatment and placebo in
the overall population and subpopulation of biomarker-positive patents. This
is accomplished by requesting a `Criterion` object with the `MarginalPower`
method. The method is applied to the two tests defined in the analysis model,
i.e., to `OP test` and `Bio-Pos test`.

Further, considering more advanced evaluation criteria, the first criterion is based on disjunctive power which corresponds to
the probability of demonstrating a statistically significant treatment effect in
at least one population. This criterion is defined using the `DisjunctivePower`
method.

The second evaluation criterion corresponds to weighted power based on
combining the probabilities of broad and restricted claims, defined as shown below:

- **Broad claim** of treatment effectiveness in the overall population is made
if the null hypothesis assciated with the overall population (H0) is rejected.

- **Restricted claim** of treatment effectiveness in the subpopulation is made
if the null hypothesis assciated with the biomarker-positive subpopulation (H+) is rejected but H0 is not rejected.

This criterion is not included in the Mediana package but can be implemented as a custom
criterion. The user can define this criterion by creating a custom function as
described below. The function’s first argument (`test.result`) is a matrix of
p-values corresponding to the test ID defined in the `tests` argument of the
`Criterion` object and produced by the `Test` objects defined in the analysis
model. Similarly, the second argument (`statistic.result`) is a matrix of
results corresponding to the statistic ID defined in the `statistics` argument
of the `Criterion` objects produced by the `Statistic` objects defined in the
analysis model. In this example, the criteria will only use the `test.result`
argument, which will contain the p-values produced by the tests associated
with the two treatment-placebo comparisons in each population. The last
argument (`parameter`) contains the optional parameter(s) defined by the user
in the `Criterion` object. In this example, the `par` argument contains the
overall alpha level (`alpha`) as well as the importance values assigned to the
broad and restricted claims (`v1` and `v2`). The `subgroup.cs1.WeightedPower` function, defined below, computes
the probability of broad and restricted claims and then a weighted sum
of the two probabilities is calculated. The order in which the tests are included
in the evaluation model is important as the first one must correspond to the
test in the overall population.

{% highlight R %}
# Custom evaluation criterion based on weighted power
subgroup.cs1.WeightedPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  v1 = parameter$v1
  v2 = parameter$v2
  
  # Broad claim: Reject OP test
  broad.claim = (test.result[,1] <= alpha)
  # Restricted claim: Reject Bio-Pos test but not OP test
  restricted.claim = ((test.result[,1] > alpha) & (test.result[,2] <= alpha))
  
  power = v1 * mean(broad.claim) + v2 * mean(restricted.claim)
  
  return(power)
}
{% endhighlight %}

A similar approach can be applied to create a custom function for computing
the marginal probability of a restricted claim. This function is defined below.

{% highlight R %}
# Custom evaluation criterion based on the probability of a restricted claim
subgroup.cs1.RestrictedClaimPower = function(test.result, statistic.result, parameter)  {
  
  alpha = parameter$alpha
  
  # Restricted claim: Reject Bio-Pos test but not OP test
  restricted.claim = ((test.result[,1] > alpha) & (test.result[,2] <= alpha))
  
  power = mean(restricted.claim)
  
  return(power)
}
{% endhighlight %}

The evaluation model based on the two built-in evaluation criteria (marginal
power and disjunctive power) as well as two custom evaluation criteria (weighted
power and marginal probability of a restricted claim) is defined in the following evaluation model.

{% highlight R %}
# Evaluation model
subgroup.cs1.evaluation.model = 
  EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("OP test", "Bio-Pos test"),
            labels = c("OP test","Bio-Pos test"),
            par = parameters(alpha = 0.025)) + 
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("OP test", "Bio-Pos test"),
            labels = c("Disjunctive power"),
            par = parameters(alpha = 0.025)) + 
  Criterion(id = "Weighted power",
            method = "subgroup.cs1.WeightedPower",
            tests = tests("OP test", "Bio-Pos test"),
            labels = c("Weighted power"),
            par = parameters(alpha = 0.025, 
                             v1 = 1 / (1 + prevalence.pos), 
                             v2 = prevalence.pos / 
                               (1 + prevalence.pos))) + 
  Criterion(id = "Probability of a restricted claim",
            method = "subgroup.cs1.RestrictedClaimPower",
            tests = tests("OP test", "Bio-Pos test"),
            labels = c("Probability of a restricted claim"),
            par = parameters(alpha = 0.025))
{% endhighlight %}

## Perform Clinical Scenario Evaluation

Using the data, analysis and evaluation models, simulation-based Clinical Scenario Evaluation is performed by calling the `CSE` function:

{% highlight R %}
# Simulation Parameters
subgroup.cs1.sim.parameters = SimParameters(n.sims = 100000, 
                                            proc.load = "full",
                                            seed = 42938001)

# Perform clinical scenario evaluation
subgroup.cs1.results = CSE(subgroup.cs1.data.model,
                           subgroup.cs1.analysis.model,
                           subgroup.cs1.evaluation.model,
                           subgroup.cs1.sim.parameters)
{% endhighlight %}

## Download

Click on the icons below to download the R code used in this case study and report that summarizes the results of Clinical Scenario Evaluation:

<center>
  <div class="col-md-6">
    <a href="subgroup-cs1-report.docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
	<br>
  </div>
  <div class="col-md-6">
    <a href="subgroup-cs1-mediana.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>
