---
layout: page
title: Case study 2
header: Case study 2
group: 
---

{% include JB/setup %}

## Summary

This clinical trial example deals with settings where no analytical methods are available to support power calculations. However, as demonstrated below, simulation-based approaches are easily applied to perform а comprehensive assessment of the relevant operating characteristics within the clinical scenario evaluation framework.

Case study 2 is based on a clinical trial example introduced in Dmitrienko and D'Agostino (2013, Section 10). This example deals with a Phase III clinical trial in a schizophrenia population. Three doses of a new treatment, labelled Dose L, Dose M and Dose H, will be tested versus placebo. The trial will be declared successful if a beneficial treatment effect is demonstrated in any of the three dosing groups compared to the placebo group.

The primary endpoint is defined as the reduction in the Positive and Negative Syndrome Scale (PANSS) total score compared to baseline and a larger reduction in the PANSS total score indicates treatment benefit. This endpoint is normally distributed and the treatment effect assumptions in the four treatment arms are displayed in the next table.

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>Treatment Arm</th>
                <th>Mean</th>
                <th>Standard deviation</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Placebo</td>
                <td>16</td>
                <td>18</td>
            </tr>
            <tr>
                <td>Dose L</td>
                <td>19.5</td>
                <td>18</td>
            </tr>
            <tr>
                <td>Dose M</td>
                <td>21</td>
                <td>18</td>
            </tr>
            <tr>
                <td>Dose H</td>
                <td>21</td>
                <td>18</td>
            </tr>
        </tbody>
    </table>
</div>

## Define a Data Model

The treatment effect assumptions presented in the table above define a single outcome parameter set and the common sample size is set to 260 patients. These parameters are specified in the following data model:

{% highlight R %}
# Outcome parameters
outcome.pl = parameters(mean = 16, sd = 18)
outcome.dosel = parameters(mean = 19.5, sd = 18)
outcome.dosem = parameters(mean = 21, sd = 18)
outcome.doseh = parameters(mean = 21, sd = 18)

# Data model
case.study2.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  SampleSize(seq(220, 260, 20)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.pl)) +
  Sample(id = "Dose L",
         outcome.par = parameters(outcome.dosel)) +
  Sample(id = "Dose M",
         outcome.par = parameters(outcome.dosem)) +
  Sample(id = "Dose H",
         outcome.par = parameters(outcome.doseh))
{% endhighlight %}

## Define an Analysis Model

The analysis model, shown below, defines the three individual tests that will be carried out in the schizophrenia clinical trial. Each test corresponds to a dose-placebo comparison such as:

- H1: Null hypothesis of no difference between Dose L and placebo.

- H2: Null hypothesis of no difference between Dose M and placebo.

- H3: Null hypothesis of no difference between Dose H and placebo.

Each comparison will be carried out based on a one-sided two-sample *t*-test (`TTest` method defined in each `Test` object).

As indicated earlier, the overall success criterion in the trial is formulated in terms of demonstrating a beneficial effect at any of the three doses. Due to multiple opportunities to claim success, the overall Type I error rate will be inflated and the Hochberg procedure is introduced to protect the error rate at the nominal level.

Since no procedure parameters are defined, the three significance tests (or, equivalently, three null hypotheses of no effect) are assumed to be equally weighted. The corresponding analysis model is defined below:

{% highlight R %}
# Analysis model
case.study2.analysis.model = AnalysisModel() +
  MultAdjProc(proc = "HochbergAdj") +
  Test(id = "Placebo vs Dose L",
       samples = samples("Placebo", "Dose L"),
       method = "TTest") +
  Test(id = "Placebo vs Dose M",
       samples = samples ("Placebo", "Dose M"),
       method = "TTest") +
  Test(id = "Placebo vs Dose H",
       samples = samples("Placebo", "Dose H"),
       method = "TTest")
{% endhighlight %}

To request the Hochberg procedure with unequally weighted  hypotheses, the user needs to assign a list of hypothesis weights to the `par` argument of the `MultAdjProc` object. The weights typically reflect the relative importance of the individual null hypotheses. Assume, for example, that 60% of the overall weight is assigned to H3 and the remainder is split between H1 and H2. In this case, the `MultAdjProc` object should be defined as follow:

{% highlight R %}
MultAdjProc(proc = "HochbergAdj",
            par = parameters(weight = c(0.2, 0.2, 0.6)))
{% endhighlight %}

It should be noted that the order of the weights must be identical to the order of the `Test` objects defined in the analysis model.

## Define an Evaluation Model

An evaluation model specifies clinically relevant criteria for assessing the performance of the individual tests defined in the corresponding analysis model or composite measures of success. In virtually any setting, it is of interest to compute the probability of achieving a significant outcome in each individual test, e.g., the probability of a significant difference between placebo and each dose. This is accomplished by requesting a `Criterion` object with `method = "MarginalPower"`.

Since the trial will be declared successful if at least one dose-placebo comparison is significant, it is natural to compute the overall success probability, which is defined as the probability of demonstrating treatment benefit in one of more dosing groups. This is equivalent to evaluating disjunctive power in the trial (`method = "DisjunctivePower"`).

In addition, the user can easily define a custom evaluation criterion. Suppose that, based on the results of the previously conducted trials, the sponsor expects a much larger treatment treatment difference at Dose H compared to Doses L and M. Given this, the sponsor may be interested in evaluating the probability of observing a significant treatment effect at Dose H and at least one other dose. The associated evaluation criterion is implemented in the following function:

{% highlight R %}
# Custom evaluation criterion (Dose H and at least one of the two other doses are significant)
case.study2.criterion = function(test.result, statistic.result, parameter) {
  
  alpha = parameter
  significant = ((test.result[,3] <= alpha) & ((test.result[,1] <= alpha) | (test.result[,2] <= alpha)))
  power = mean(significant)
  return(power)
}
{% endhighlight %}

The function's first argument (`test.result`) is a matrix of p-values produced by the `Test` objects defined in the analysis model and the second argument (`statistic.result`) is a matrix of results produced by the `Statistic` objects defined in the analysis model. In this example, the criteria will only use the `test.result` argument, which will contain the p-values produced by the tests associated with the three dose-placebo comparisons. The last argument (`parameter`) contains the optional parameter(s) defined by the user in the `Criterion` object. In this example, the `par` argument contains the overall alpha level.

The `case.study2.criterion` function computes the probability of a significant treatment effect at Dose H (`test.result[,3] <= alpha`) and a significant treatment difference at Dose L or Dose M (`(test.result[,1] <= alpha) | (test.result[,2]<= alpha)`). Since this criterion assumes that the third test is based on the comparison of Dose H versus Placebo, the order in which the tests are included in the evaluation model is important.

The following evaluation model specifies marginal and disjunctive power as well as the custom evaluation criterion defined above:

{% highlight R %}
# Evaluation model
case.study2.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs Dose L",
                          "Placebo vs Dose M",
                          "Placebo vs Dose H"),
            labels = c("Placebo vs Dose L",
                       "Placebo vs Dose M",
                       "Placebo vs Dose H"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("Placebo vs Dose L",
                          "Placebo vs Dose M",
                          "Placebo vs Dose H"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Dose H and at least one dose",
            method = "case.study2.criterion",
            tests = tests("Placebo vs Dose L",
                          "Placebo vs Dose M",
                          "Placebo vs Dose H"),
            labels = "Dose H and at least one of the two other doses are significant",
            par = parameters(alpha = 0.025))
{% endhighlight %}

Another potential option is to apply the conjunctive criterion which is met if a significant treatment difference is detected simultaneously in all three dosing groups (`method = "ConjunctivePower"`). This criterion helps characterize the likelihood of a consistent treatment effect across the doses.

The user can also use the `metric.tests` parameter to choose the specific tests to which the disjunctive and conjunctive criteria are applied (the resulting criteria are known as subset disjunctive and conjunctive criteria). To illustrate, the following statement computes the probability of a significant treatment effect at Dose M or Dose H (Dose L is excluded from this calculation):

{% highlight R %}
Criterion(id = "Disjunctive power",
          method = "DisjunctivePower",
          tests = tests("Pl vs Dose M",
                        "Pl vs Dose H"),
          labels = "Disjunctive power",
          par = parameters(alpha = 0.025))
{% endhighlight %}

## Download

Click on the icons below to download the R code used in this case study and report that summarizes the results of Clinical Scenario Evaluation:

<center>
  <div class="col-md-6">
    <a href="Case study 2.docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
  <div class="col-md-6">
    <a href="Case study 2.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>