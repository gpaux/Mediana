---
layout: page
title: Case study 7
header: Case study 7
group: 
---

{% include JB/setup %}

## Summary

This case study illustrates the use of a complex tree-structured sequence of hypotheses testing, contrary to [Case study 5](CaseStudy05.html) which uses multiple sequence of hypotheses. In this setting, a mixture-based gatekeeping procedure (Dmitrienko *et al.* (2011)) should be used in order to protect the overall Type I error rate.

Consider a two-arm Phase III clinical trial for the treatment of hyperthension, with four endpoints, one primary endpoint (Endpoint 1), two secondary endpoints (Endpoint 2 and 3) and a tertiary endpoint (Endpoint 4). The endpoints are defined as follows:

- Endpoint 1 (P): Mean reduction in Systolic Blood Pressure (SBP).
 
- Endpoint 2 (S1): Mean reduction in Diastolic Blood Pressure (DBP).

- Endpoint 3 (S2): Proportion of patients with controlled Systolic/Disatolic Blood Pressure.
 
- Endpoint 4 (T): Average blood pressure based on ambulatory blood pressure monitoring.

For each endpoint, two tests will be carried out, resulting in eight null hypotheses of interest. The primary comparison is non-inferiority, with a switch to superiority if non-inferiority has been shown.

The endpoints have different marginal distributions. Endpoint 1, 2 and 4 is continuous and follows a normal distribution whereas Endpoint 3 is binary.
	
The efficacy profile of the new treatment will be compared to that of a placebo using the following decision rules. If non-inferiority is shown for Endpoint 1, a superiority analysis for this endpoint as well as non-inferiority for Endpoint 2 and 3 will be performed. Then, if non-inferiority is shown for either Endpoint 3 or 3 (or both), superiority can be tested for that endpoint and non-inferiority for Endpoint 4 can be tested. Eventually, if non-inferiority is shown for Endpoint 4, superiority will be tested. The decision rules are illustrated in Figure 1.

A single treatment effect scenarios for each endpoint are displayed in the table below.

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>Endpoint</th>
                <th>Placebo</th>
                <th>Treatment</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Endpoint 1</td>
                <td>30%</td>
                <td>40%</td>
            </tr>
            <tr>
                <td>Endpoint 2</td>
                <td>30%</td>
                <td>45%</td>
            </tr>
            <tr>
                <td>Endpoint 3</td>
                <td>30%</td>
                <td>50%</td>
            </tr>
            <tr>
                <td>Endpoint 4</td>
                <td>30%</td>
                <td>50%</td>
            </tr>
        </tbody>
    </table>
</div>

## Define a Data Model

As in [Case study 4](CaseStudy04.html), several endpoints are evaluated for each patient in this clinical trial example, which means that their joint distribution needs to be specified. The `MVMixedDist` method will be utilized for specifying a bivariate distribution with binomial and normal marginals (`var.type = list("NormalDist", "NormalDist", "BinomDist", "NormalDist")`).

Three parameters must be defined to specify the joint distribution of the four endpoints in this clinical trial example:

- Variable types (normal, normal, binomial and normal, respectively).

- Outcome distribution parameters (mean and SD for Endpoint 1,2 and 4; proportion for Endpoint 3) based on the assumptions listed in the Table  above.

- Correlation matrix of the multivariate normal distribution used in the copula method.

These parameters are combined to define the outcome parameter set (`outcome.plac `,  `outcome.treat `) that will be included in the `Sample` object in the data model. 

{% highlight R %}
# Variable types
var.type = list("NormalDist", "NormalDist", "BinomDist", "NormalDist")

# Outcome distribution parameters
placebo.par = parameters(parameters(mean = -0.10, sd = 0.5),
                         parameters(mean = -0.10, sd = 0.5),
                         parameters(prop = 0.3), 
                         parameters(mean = -0.10, sd = 0.5))

treatment.par = parameters(parameters(mean = -0.20, sd = 0.5),
                         parameters(mean = -0.20, sd = 0.5),
                         parameters(prop = 0.5), 
                         parameters(mean = -0.20, sd = 0.5))

# Correlation between two endpoints
corr.matrix = matrix(c(1.0, 0.5, 0.5, 0.5,
                       0.5, 1.0, 0.5, 0.5,
					   0.5, 0.5, 1.0, 0.5,
					   0.5, 0.5, 0.5, 1.0,), byrow = TRUE, 4, 4)

# Outcome parameter set 1
outcome.placebo = parameters(type = var.type, 
                             par = placebo.par, 
                             corr = corr.matrix)
outcome.treatment = parameters(type = var.type, 
                               par = treatment.par, 
                               corr = corr.matrix)
{% endhighlight %}

These outcome parameter set are then combined within each `Sample` object and the common sample size per treatment arm ranges between 100 and 120:

{% highlight R %}
# Data model
case.study5.data.model = DataModel() +
  OutcomeDist(outcome.dist = "MVMixedDist") +
  SampleSize(c(100, 120)) +
  Sample(id = list("Placebo - E1", "Placebo - E2", "Placebo - E3", "Placebo - E4"),
         outcome.par = parameters(outcome.placebo)) +
  Sample(id = list("Treatment - E1", "Treatment - E2", "Treatment - E3", "Treatment - E4"),
         outcome.par = parameters(outcome.treatment))
{% endhighlight %}

## Define an Analysis Model

To set up the analysis model in this clinical trial example, note that the treatment comparisons for each endpoint will be carried out based on two different statistical tests:

- Endpoint 1, 2 and 4: superiority two-sample t-test (`method = "TTest"`) and non-inferiority two-sample t-test (`method = "TTestNI"`).
- 
- Endpoint 3: superiority two-sample test for comparing proportions (`method = "PropTest"`) and non-inferiority two-sample test (`method = "PropTestNI"`).

As described in the summary, eight null hypotheses will be tested using a tree-structure sequence identified in Figure 1:

H1: Null hypothesis of inferiority of treatment versus placebo with respect to Endpoint 1.

H2: Null hypothesis of inferiority of treatment versus placebo with respect to Endpoint 2.

H3: Null hypothesis of no difference between treatment and placebo with respect to Endpoint 1.

H4: Null hypothesis of inferiority of treatment versus placebo with respect to Endpoint 3.

H5: Null hypothesis of no difference between treatment and placebo with respect to Endpoint 2.

H6: Null hypothesis of inferiority of treatment versus placebo with respect to Endpoint 4.

H7: Null hypothesis of no difference between treatment and placebo with respect to Endpoint 3.

H8: Null hypothesis of no difference between treatment and placebo with respect to Endpoint 4.

<center>
  <div class="col-md-12">
    <img src="CaseStudy07-fig1.png" class="img-responsive">
  </div>
</center>

A multiple testing procedure known as the mixture-based gatekeeping procedure will be applied to account for the hierarchical structure of this multiplicity problem ([Dmitrienko et al. (2011)](http://onlinelibrary.wiley.com/doi/10.1002/sim.4008/abstract). This gatekeeping procedure is specified by defining the following three parameters:

- Families of null hypotheses (`family`).
 
- Component procedures used in the families (`component.procedure`).

- Truncation parameters used in the families (`gamma`).

- Parallel rejection set for each null hypothesis (`parallel`).

- Serial rejection set for each null hypothesis (`serial`).

{% highlight R %}
# Parameters of the gatekeeping procedure procedure (mixture-based gatekeeping procedure)
# Tests to which the multiplicity adjustment will be applied
test.list = tests("E1 - Non-Inferiority", 
                  "E2 - Non-Inferiority", 
                  "E1 - Superiority", 
                  "E3 - Non-Inferiority", 
                  "E2 - Superiority", 
                  "E4 - Non-Inferiority",
                  "E3 - Superiority", 
                  "E4 - Superiority")

# Families of hypotheses
family = families(family1 = c(1), 
                  family2 = c(2, 3, 4),
                  family3 = c(5, 6, 7),
                  family4 = c(8))

# Component procedures for each family
component.procedure = families(family1 = "HolmAdj", 
                               family2 = "HolmAdj",
                               family3 = "HolmAdj", 
                               family4 = "HolmAdj")

# Truncation parameter for each family
gamma = families(family1 = 0.8, 
                 family2 = 0.8,
                 family3 = 0.8, 
                 family4 = 1)

# Parallel rejection set for each null hypothesis
parallel = parameters(c(0,0,0,0,0,0,0,0),
                      c(0,0,0,0,0,0,0,0),
                      c(0,0,0,0,0,0,0,0),
                      c(0,0,0,0,0,0,0,0),
                      c(0,0,0,0,0,0,0,0),
                      c(0,1,0,1,0,0,0,0),
                      c(0,0,0,0,0,0,0,0),
                      c(0,0,0,0,0,0,0,0))

# Serial rejection set for each null hypothesis
serial = parameters(c(0,0,0,0,0,0,0,0),
                    c(1,0,0,0,0,0,0,0),
                    c(1,0,0,0,0,0,0,0),
                    c(1,0,0,0,0,0,0,0),
                    c(0,1,0,0,0,0,0,0),
                    c(0,0,0,0,0,0,0,0),
                    c(0,0,0,1,0,0,0,0),
                    c(0,0,0,0,0,1,0,0))
{% endhighlight %}

These parameters are included in the `MultAdjProc` object defined below. The tests to which the multiplicity adjustment will be applied are defined in the `tests` argument. The use of this argument is optional if all tests included in the analysis model are to be included. The argument `family` states that the null hypotheses will be grouped into two families:

- Family 1: H1.

- Family 2: H2, H3 and H4.

- Family 3: H5, H6 and H7.
 
- Family 4: H8.

It is to be noted that the order corresponds to the order of the tests defined in the analysis model, except if the tests are specifically specified in the `tests` argument of the `MultAdjProc` object.

The families will be tested sequentially and a truncated Holm procedure will be applied within each family (`component.procedure`). Lastly, the truncation parameter will be set to 0.8 in Family 1, 2 and 3 and to 1 in Family 4 (`gamma`). The serial and parallel rejection sets are used to define the logical relationship among the null hypotheses. For example, the parallel set states that H6 will be tested if either (or both) H2 and H4 are rejected.

The resulting parameters are included in the `par` argument of the `MultAdjProc` object and, as before, the `proc` argument is used to specify the multiple testing procedure (`MixtureGatekeepingAdj`).

The test are then specified in the analysis model and the overall analysis model is defined as follows:

{% highlight R %}
# Analysis model
case.study5.analysis.model = AnalysisModel() +
  MultAdjProc(proc = "MultipleSequenceGatekeepingAdj",
              par = parameters(family = family, 
                               proc = component.procedure, 
                               gamma = gamma,
                               serial = serial
                               parallel = parallel),
              tests = test.list)
{% endhighlight %}

Recall that a numerically lower value indicates a beneficial effect for the HAQ-DI score and, as a result, the experimental treatment arm must be defined prior to the placebo arm in the test.samples parameters corresponding to the HAQ-DI tests, e.g., `samples = samples("DoseL HAQ-DI", "Placebo HAQ-DI")`.

## Define an Evaluation Model

In order to assess the probability of success in this clinical trial, a hybrid criterion based on the conjunctive criterion (both trial endpoints must be significant) and disjunctive criterion (at least one dose-placebo comparison must be significant) can be considered. 

This criterion will be met if a significant effect is established at one or two doses on Endpoint 1 (ACR20) and also at one or two doses on Endpoint 2 (HAQ-DI). However, due to the hierarchical structure of the testing strategy (see Figure), this is equivalent to demonstrating a significant difference between Placebo and at least one dose with respect to Endpoint 2. The corresponding criterion is a subset disjunctive criterion based on the two Endpoint 2 tests (subset disjunctive power was briefly mentioned in [Case study 2](CaseStudy02)). 

In addition, the sponsor may also be interested in evaluating marginal power as well as subset disjunctive power based on the Endpoint 1 tests. The latter criterion will be met if a significant difference between Placebo and at least one dose is established with respect
to Endpoint 1. Additionally, as in [Case study 2](CaseStudy02), the user could consider defining custom evaluation criteria. The three resulting evaluation criteria (marginal power, subset disjunctive criterion based on the Endpoint 1 tests and subset disjunctive criterion based on the Endpoint 2 tests) are included in the following evaluation model.

{% highlight R %}
# Evaluation model
case.study5.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs DoseL - ACR20",
                          "Placebo vs DoseH - ACR20",
                          "Placebo vs DoseL - HAQ-DI",
                          "Placebo vs DoseH - HAQ-DI"),
            labels = c("Placebo vs DoseL - ACR20",
                       "Placebo vs DoseH - ACR20",
                       "Placebo vs DoseL - HAQ-DI",
                       "Placebo vs DoseH - HAQ-DI"),
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power - ACR20",
            method = "DisjunctivePower",
            tests = tests("Placebo vs DoseL - ACR20",
                          "Placebo vs DoseH - ACR20"),
            labels = "Disjunctive power - ACR20",
            par = parameters(alpha = 0.025)) +
  Criterion(id = "Disjunctive power - HAQ-DI",
            method = "DisjunctivePower",
            tests = tests("Placebo vs DoseL - HAQ-DI",
                          "Placebo vs DoseH - HAQ-DI"),
            labels = "Disjunctive power - HAQ-DI",
            par = parameters(alpha = 0.025))
{% endhighlight %}

## Download

Click on the icons below to download the R code used in this case study and report that summarizes the results of Clinical Scenario Evaluation:

<center>
  <div class="col-md-6">
    <a href="Case study 5.docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
  <div class="col-md-6">
    <a href="Case study 5.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</div>
</center>