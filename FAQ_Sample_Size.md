---
layout: page
title: How to perform sample size calculations?
header: How to perform sample size calculations?
group: navigation
---
{% include JB/setup %}


## Summary

The Mediana R package has been designed to perform power calculations based on a set of pre-specified sample sizes in a clinical trial. The following steps need to be taken to calculate the required sample size for a desirable power level. 

The first step is to define a number of sample size scenarios. As indicated in the [specification of a Data Model](DataModel.html), the sample size in a trial can be defined using either the `SampleSize` object (in case of balanced randomization), or directly specified within each `Sample` defined in a data model. Since the principle is the same, we will only focus on this page on the specification of sample sizes in trials with a balanced randomization scheme.

A simple example will be used to illustrate this step. We will consider a case study with two arms and a normally distributed endpoint. This case study is based on a Phase III clinical trial in patients with pulmonary arterial hypertension (PAH) where the primary endpoint is the change in the six-minute walk distance. In this simple setting, the required sample size can be computed using an analytical approach.

Suppose that the trial's sponsor is interested in estimating the sample size required to guarantee 90% power under a certain treatment effect scenario based on a Phase II trial.

## Data Model

As mentioned previously, the outcome distribution is normal. Let's assume that a single treatment effect scenario is specified: the mean change in the six-minute walk distance in the placebo arm is set to &mu;= 0, the mean change in the six-minute walk distance in the experimental arm is set to  &mu;= 40 and the common standard deviation is &sigma;= 70.

Several sets of sample sizes will be evaluated, from 55 patients per treatment arm to 75, with a step of 5 patients. 

Based on the information presented above, the data model can be specified as follows:

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

The data and analysis models specified above collectively define a Clinical Scenario to be examined in the PAH clinical trial. Clinical scenarios are evaluated using success criteria or metrics that are aligned with the clinical objectives of the trial. In this case it is most appropriate to use regular power or, more formally, *marginal power*, i.e., the probability of establishing a statistically significant treatment effect in the trial. This success criterion is specified in the evaluation model.

{% highlight R %}
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))
{% endhighlight %}

## Perform Clinical Scenario Evaluation

After the clinical scenarios (data and analysis models) and evaluation model have been defined, the second step is to evaluate the success criteria specified in the evaluation model by calling the `CSE` function. 

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

The simulation results are summarized in the following table.

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

Based on the review of the simulation results, the required sample size corresponding to power of at least 90% is 60 patients per treatment arm (the third sample size scenario in the table displayed above).



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