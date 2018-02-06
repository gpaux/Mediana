---
layout: page
title: How to perform Sample Size calculations?
header: How to perform Sample Size calculations?
group: navigation
---
{% include JB/setup %}


## Summary

The Mediana R package can be used to perform power calculations based on a set of pre-specified sample size. In order to calculate the required sample size for a desirable power, a set containing several sample size scenarios must be defined.

As indicated in the [specification of a Data Model](DataModel.html), the sample size can be defined using either the `SampleSize` object (in case of balanced randomization), or directly specified in each `Sample` included in the data model. Since the principle is the same, we will only focus on this page on the specification of sample size in case of balanced randomization.

A simple example will be used to illustrate this sample size calculation. We will consider a clinical trial with two arms and a normally distributed endpoints (a Phase III clinical trial in patients with pulmonary arterial hypertension where the primary endpoint is the change in the six-minute walk distance). In that case, sample size can be done using closed-form expression.

The objective for the sponsor is to estimate the sample size required to guarantee a 90% power under an expected scenario based on a Phase II trial.

## Data Model

As mentionned previously, the outcome distribution is normal. Let's assume that a single treatment effect scenario is expected, the mean change in the placebo arm is set to &mu;= 0 and the mean changes in the six-minute walk distance in the experimental arm are set to  &mu;= 40. The common standard deviation is   &sigma;= 70.

Several sample size scenarios will be evaluated, from 55 patients per treatment arm to 75, with a step of 5 patients. 

Based on the previous information, the data model can be specified as follows:
{% highlight R %}
# Outcome parameter set
outcome1.placebo = parameters(mean = 0, sd = 70)
outcome1.treatment = parameters(mean = 40, sd = 70)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  SampleSize(c(55, 60, 65, 70, 75)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome1.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome1.treatment))
{% endhighlight %}

## Analysis model

Only one significance test is planned to be carried out in the PAH clinical trial (treatment versus placebo). The treatment effect will be assessed using the one-sided two-sample *t*-test:

{% highlight R %}
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "TTest")
{% endhighlight %}

## Evaluation model

The data and analysis models specified above collectively define the Clinical Scenarios to be examined in the PAH clinical trial. The scenarios are evaluated using success criteria or metrics that are aligned with the clinical objectives of the trial. In this case it is most appropriate to use regular power or, more formally, *marginal power*. This success criterion is specified in the evaluation model.

{% highlight R %}
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))
{% endhighlight %}

## Perform Clinical Scenario Evaluation

After the clinical scenarios (data and analysis models) and evaluation model have been defined, the user is ready to evaluate the success criteria specified in the evaluation model by calling the `CSE` function. 

To accomplish this, the simulation parameters need to be defined in a `SimParameters` object:

{% highlight R %}
# Simulation parameters
case.study1.sim.parameters = SimParameters(n.sims = 10000, 
                                           proc.load = "full", 
                                           seed = 42938001)
{% endhighlight %}

The function call for `CSE` specifies the individual components of Clinical Scenario Evaluation in this case study as well as the simulation parameters:
{% highlight R %}
# Perform clinical scenario evaluation
case.study1.results = CSE(case.study1.data.model,
                          case.study1.analysis.model,
                          case.study1.evaluation.model,
                          case.study1.sim.parameters)
{% endhighlight %}

To facilitate the review of the simulation results produced by the `CSE` function, the user can invoke the `summary` function. This function displays the data frame containing the simulation results in the R console:

{% highlight R %}
# Print the simulation results in the R console
summary(case.study1.results)
{% endhighlight %}

The summary results are displayed in the following table.

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>Sample size scenario</th>
                <th>Sample size per arm</th>
                <th>Marginal power (%)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>55</td>
                <td>84.7</td>
            </tr>
    
            <tr>
                <td>2</td>
                <td>60</td>
                <td>87.7</td>
            </tr>
            <tr>
                <td>3</td>
                <td>65</td>
                <td>90.0</td>
            </tr>
            <tr>
                <td>4</td>
                <td>70</td>
                <td>92.1</td>
            </tr>
            <tr>
                <td>5</td>
                <td>75</td>
                <td>93.7</td>
            </tr>
        </tbody>
    </table>
</div>

## Conclusion
Based on the review of the results, the required sample size to obtain a statistical power of at least 90% is 60 patients per treatment arm (third sample size scenario).



## Download

Click on the icons below to download the R code used in this case study and report that summarizes the results of Clinical Scenario Evaluation:

<center>
  <div class="col-md-6">
    <a href="Case study sample size.docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
  <div class="col-md-6">
    <a href="Case study sample size.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>