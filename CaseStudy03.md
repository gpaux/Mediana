---
layout: page
title: Case study 3
header: Case study 3
group: 
---

{% include JB/setup %}

## About

This case study deals with a Phase III clinical trial in patients with mild or moderate asthma (it is based on a clinical trial example from Millen et al., 2014, Section 2.2). The trial is intended to support a tailoring strategy. In particular, the treatment effect of a single dose of a new treatment will be compared to that of placebo in the overall population of patients as well as a pre-specified subpopulation of patients with a marker-positive status at baseline (for compactness, the overall population
is denoted by OP, marker-positive subpopulation is denoted by M+ and marker- negative subpopulation is denoted by M−). 

Marker-positive patients are more likely to receive benefit from the experimental treatment. The overall objective of the clinical trial accounts for the fact that the treatment’s effect may, in fact, be limited to the marker-positive subpopulation. The trial will be declared successful if the treatment’s beneficial effect is established in the overall population of patients or, alternatively, the effect is established only in
the subpopulation. The primary endpoint in the clinical trial is defined as an increase from baseline in the forced expiratory volume in one second (FEV1). This endpoint is normally distributed and improvement is associated with a larger change in FEV1.

## Data Model

To set up a data model for this clinical trial, it is natural to define samples (mutually exclusive groups of patients) as follows:

- Sample 1: Marker-negative patients in the placebo arm.

- Sample 2: Marker-positive patients in the placebo arm.

- Sample 3: Marker-negative patients in the treatment arm.

- Sample 4: Marker-positive patients in the treatment arm.

Using this definition of samples, the trial’s sponsor can model the fact that the treatment’s effect is most pronounced in patients with a marker-positive status.

The treatment effect assumptions in the four samples are summarized in the next table (expiratory volume in FEV1 is measured in liters). As shown in the table, the mean change in FEV1 is constant across the marker-negative and marker-positive subpopulations in the placebo arm (Samples 1 and 2). A positive treatment effect is expected in both subpopulations in the treatment arm but marker-positive patients will experience most of the beneficial effect (Sample 4).

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
                <td>Placebo M-</td>
                <td>0.12</td>
                <td>0.45</td>
            </tr>
            <tr>
                <td>Placebo M+</td>
                <td>0.12</td>
                <td>0.45</td>
            </tr>
            <tr>
                <td>Treatment M-</td>
                <td>0.24</td>
                <td>0.45</td>
            </tr>
            <tr>
                <td>Treatment M+</td>
                <td>0.30</td>
                <td>0.45</td>
            </tr>
        </tbody>
    </table>
</div>

The following data model incorporates the assumptions displayed in Table 1.10 by defining a single set of outcome parameters. The data model includes three sample size sets (total sample size is set to 330, 340 and 350 patients). The sizes of the individual samples are computed based on historic information (40% of patients in the population of interest are expected to have a marker-positive status). In order to define specific sample size for each sample, they will be specified within each `Sample` object.

{% highlight R %}
# Outcome parameters
outcome.placebo.minus = parameters(mean = 0.12, sd = 0.45)
outcome.placebo.plus = parameters(mean = 0.12, sd = 0.45)
outcome.treatment.minus = parameters(mean = 0.24, sd = 0.45)
outcome.treatment.plus = parameters(mean = 0.30, sd = 0.45)

# Sample size parameters
sample.size.total = c(330, 340, 350)
sample.size.placebo.minus = as.list(0.3 * sample.size.total)
sample.size.placebo.plus = as.list(0.2 * sample.size.total)
sample.size.treatment.minus = as.list(0.3 * sample.size.total)
sample.size.treatment.plus = as.list(0.2 * sample.size.total)

# Data model
case.study3.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  Sample(id = "Placebo M-",
         sample.size = sample.size.placebo.minus,
         outcome.par = parameters(outcome.placebo.minus)) +
  Sample(id = "Placebo M+",
         sample.size = sample.size.placebo.plus,
         outcome.par = parameters(outcome.placebo.plus)) +
  Sample(id = "Treatment M-",
         sample.size = sample.size.treatment.minus,
         outcome.par = parameters(outcome.treatment.minus)) +
  Sample(id = "Treatment M+",
         sample.size = sample.size.treatment.plus,
         outcome.par = parameters(outcome.treatment.plus))
{% endhighlight %}

## Analysis Model

The analysis model in this clinical trial example is generally similar to that used in [Case study 2](CaseStudy02.html) but there is an important difference which is described below.

As in [Case study 2](CaseStudy02.html), the primary endpoint follows a normal distribution and thus the treatment effect will be assessed using the two-sample *t*-test. 

Since two null hypotheses are tested in this trial (null hypotheses of no effect in the overall population of patients and subpopulation of marker-positive patients), a multiplicity adjustment needs to be applied. The Hochberg procedure with equally weighted null hypotheses will be used for this purpose.

A key feature of the analysis strategy in this case study is that the samples defined in the data model are different from the samples used in the analysis of the primary endpoint. As shown in the Table, four samples are included in the data model. However, from the analysis perspective, the sponsor in interested in examining the treatment effect in two samples, namely, the overall population and marker-positive subpopulation. As shown below, to perform a comparison in the overall population, the *t*-test is applied to the following analysis samples:

- **Placebo arm:** Samples 1 and 2 (`Placebo M-` and `Placebo M+`) are merged.
 
- **Treatment arm:** Samples 3 and 4 (`Treatment M-` and `Treatment M+`) are merged.
 
Further, the treatment effect test in the subpopulation of marker-positive patients is carried out based on these analysis samples:

- **Placebo arm:** Sample 2 (`Placebo M+`).

- **Treatment arm:** Sample 4 (`Treatment M+`).

These analysis samples are specified in the analysis model below. The samples defined in the data model are merged using `c()` or `list()` function, e.g., c("Placebo M-", "Placebo M+") defines the placebo arm and list("Treatment M-", "Treatment M+") defines the experimental treatment arm in the overall population test.

{% highlight R %}
# Analysis model
case.study3.analysis.model = AnalysisModel() +
  MultAdjProc(proc = "HochbergAdj") +
  Test(id = "OP test",
       samples = samples(c("Placebo M-", "Placebo M+"),
                         c("Treatment M-", "Treatment M+")),
       method = "TTest") +
  Test(id = "M+ test",
       samples = samples("Placebo M+", "Treatment M+"),
       method = "TTest")
{% endhighlight %}

## Evaluation Model
It is reasonable to consider the following success criteria in this case study:

- **Marginal power:** Probability of a significant outcome in each patient population.

- **Disjunctive power:** Probability of a significant treatment effect in the overall population (OP) or marker-positive subpopulation (M+). This metric defines the overall probability of success in this clinical trial.
 
- **Conjunctive power:** Probability of simultaneously achieving significance in the overall population and marker-positive subpopulation. This criterion will be useful if the trial’s sponsor is interested in pursuing an enhanced efficacy claim (Millen et al., 2012).
 
The following evaluation model applies the three criteria to the two tests listed in the analysis model:

{% highlight R %}
# Evaluation model
case.study3.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("OP test",
                          "M+ test"),
            labels = c("OP test",
                       "M+ test"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power",
            method = "DisjunctivePower",
            tests = tests("OP test",
                          "M+ test"),
            labels = "Disjunctive power",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Conjunctive power",
            method = "ConjunctivePower",
            tests = tests("OP test",
                          "M+ test"),
            labels = "Conjunctive power",
            par = parameters(alpha = 0.025))
{% endhighlight %}

## Download

The R code utilized and the Clinical Scenario Evaluation Report generated in this case study can be dowloaded below.

<center>
  <div class="col-md-6">
    <a href="Case study 3.docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
  <div class="col-md-6">
    <a href="Case study 3.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</div>
</center>