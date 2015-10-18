---
layout: page
title: Case study 6
header: Case study 6
group: 
---

{% include JB/setup %}

## About

Case study 6 is an extension of [Case study 2](CaseStudy02.html) where the objective of the sponsor is to compare several Multiple Testing Procedures (MTPs). The main difference is in the specification of the analysis model.

## Data Model

The same data model as in [Case study 2](CaseStudy02.html) will be used in this case study. However, a new set of outcome parameters will be added in this case study (optimistic).

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>Outcome parameter</th>
                <th>Treatment Arm</th>
                <th>Mean</th>
                <th>Standard deviation</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td rowspan="4">Standard</td>
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
            <tr>
                <td rowspan="4">Optimistic</td>
                <td>Placebo</td>
                <td>16</td>
                <td>18</td>
            </tr>
            <tr>
                <td>Dose L</td>
                <td>20</td>
                <td>18</td>
            </tr>
            <tr>
                <td>Dose M</td>
                <td>21</td>
                <td>18</td>
            </tr>
            <tr>
                <td>Dose H</td>
                <td>22</td>
                <td>18</td>
            </tr>
        </tbody>
    </table>
</div>

{% highlight R %}
# Standard
outcome1.placebo = parameters(mean = 16, sd = 18)
outcome1.dosel = parameters(mean = 19.5, sd = 18)
outcome1.dosem = parameters(mean = 21, sd = 18)
outcome1.doseh = parameters(mean = 21, sd = 18)

# Optimistic
outcome2.placebo = parameters(mean = 16, sd = 18)
outcome2.dosel = parameters(mean = 20, sd = 18)
outcome2.dosem = parameters(mean = 21, sd = 18)
outcome2.doseh = parameters(mean = 22, sd = 18)

# Data model
case.study6.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NormalDist") +
  SampleSize(seq(220, 260, 20)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
  Sample(id = "Dose L",
         outcome.par = parameters(outcome1.dosel, outcome2.dosel)) +
  Sample(id = "Dose M",
         outcome.par = parameters(outcome1.dosem, outcome2.dosem)) +
  Sample(id = "Dose H",
         outcome.par = parameters(outcome1.doseh, outcome2.doseh))
{% endhighlight %}

## Analysis Model

As in case study 2, each Placebo comparisons will be done using a one-sided two-sample *t*-test (`TTest` method defined in each `Test` object). The same nomenclature will be used to define the hypothesis, i.e.:

- H1: Null hypothesis of no difference between Dose L and placebo.

- H2: Null hypothesis of no difference between Dose M and placebo.

- H3: Null hypothesis of no difference between Dose H and placebo.

In this case study, as in [Case study 2](CaseStudy02.html), the overall success criterion in the trial is formulated in terms of demonstrating a beneficial effect at any of the three doses, inducing an inflation of the overall Type I error rate. In this case study, the sponsor is interested in comparing several Multiple Testing Procedures, such as the weighted Bonferroni, Holm and Hochberg procedures. These MTPs are defined as below:

{% highlight R %}
# Multiplicity adjustments
# No adjustment
mult.adj1 = MultAdjProc(proc = NA)

# Bonferroni adjustment (with unequal weights)
mult.adj2 = MultAdjProc(proc = "BonferroniAdj",
                        par = parameters(weight = c(1/4,1/4,1/2)))

# Holm adjustment (with unequal weights)
mult.adj3 = MultAdjProc(proc = "HolmAdj", 
                        par = parameters(weight = c(1/4,1/4,1/2)))

# Hochberg adjustment (with unequal weights)
mult.adj4 = MultAdjProc(proc = "HochbergAdj", 
                        par = parameters(weight = c(1/4,1/4,1/2)))
{% endhighlight %}

The `mult.adj1` object, which specified that no adjustment will be used, is defined in order to observe the decrease in power induced by each MTPs.

It should be noted that for each weighted procedure, a higher weight is assigned to the test of Placebo vs Dose H (1/2), and the remaining weight is equally assigned to the two other tests (i.e. 1/4 for each test). These parameters are specified in the `par` argument of each MTP.

The analysis model is defined as follows:

{% highlight R %}
# Analysis model
case.study6.analysis.model = AnalysisModel() +
  MultAdj(mult.adj1, mult.adj2, mult.adj3, mult.adj4) +
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

For the sake of compactness, all MTPs are wraped in a `MultAdj` object, but it is worth mentionning that each MTPs could have been directly added to the `AnalysisModel` object using the `+` operator.

## Evaluation Model

As for the data model, the same evaluation model as in [Case study 2](CaseStudy02.html) will be used in this case study. Refer to [Case study 2](CaseStudy02.html) for more information.

{% highlight R %}
# Evaluation model
case.study6.evaluation.model = EvaluationModel() +
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
            method = "case.study6.criterion",
            tests = tests("Placebo vs Dose L",
                          "Placebo vs Dose M",
                          "Placebo vs Dose H"),
            labels = "Dose H and at least one of the two other doses are significant",
            par = parameters(alpha = 0.025))
{% endhighlight %}

The last `Criterion` object specifies the custom criterion which computes the probability of a significant treatment effect at Dose H and a significant treatment difference at Dose L or Dose M. 

## Clinical Scenario Evaluation

Using the data, analysis and evaluation models, the Clinical Scenario Evaluation can be performed:

{% highlight R %}
# Simulation Parameters
case.study6.sim.parameters =  SimParameters(n.sims = 1000, 
                                            proc.load = "full", 
                                            seed = 42938001)

# Perform clinical scenario evaluation
case.study6.results = CSE(case.study6.data.model,
                          case.study6.analysis.model,
                          case.study6.evaluation.model,
                          case.study6.sim.parameters)
{% endhighlight %}

## Summary of results and reporting

This case study will also illustrate how to customize the Word-based report, by defining sections and subsections.

### Reporting

#### Presentation Model

Several presentation models will be used in order to customize the report:

- A report without subsections,

- A report with subsections,

- A report with combined sections.

A default `PresentationModel` object (`case.study6.presentation.model.default`) will firstly be created, to specify the related objects that do not change between each presentation model. The information about the project (`Project` object), the sorting of the table (`Table` object) and the specification of the customized labels (`CustomLabel` objects) are included in this object.

{% highlight R %}
case.study6.presentation.model.default = PresentationModel() +
  Project(username = "[Mediana's User]",
          title = "Case study 6",
          description = "Clinical trial in patients with schizophrenia - Several MTPs") +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size", 
              label = paste0("N = ", seq(220, 260, 20))) +
  CustomLabel(param = "multiplicity.adjustment", 
              label = c("No adjustment", "Bonferroni adjustment", "Holm adjustment", "Hochberg adjustment"))
{% endhighlight %}


#### Report without subsections

The first generated report will contains a section for each outcome parameter set. A `Section` object is added to the default `PresentationModel` object and the report is generated.

{% highlight R %}
# Reporting 1 - Without subsections
case.study6.presentation.model1 = case.study6.presentation.model.default +
  Section(by = "outcome.parameter")

# Report Generation
GenerateReport(presentation.model = case.study6.presentation.model1,
               cse.results = case.study6.results,
               report.filename = "Case study 6 - Without subsections.docx")
{% endhighlight %}

#### Report with subsections

The second generated report will contains a section for each outcome parameter and a subsection for each multiplicity adjustment procedures. A `Section` and a `Subsection` objects are added to the default `PresentationModel` object and the report is generated.

{% highlight R %}
# Reporting 2 - With subsections
case.study6.presentation.model2 = case.study6.presentation.model.default +
  Section(by = "outcome.parameter") +
  Subsection(by = "multiplicity.adjustment") 

# Report Generation
GenerateReport(presentation.model = case.study6.presentation.model2,
               cse.results = case.study6.results,
               report.filename = "Case study 6 - With subsections.docx")
{% endhighlight %}

#### Report with combined sections

The last generated report will contains a section for each combination of each outcome parameter each MTPs. A `Section` object is added to the default `PresentationModel` object and specifies both the outcome parameter and the multiplicity adjustment in the `by` argument.

{% highlight R %}
# Reporting 3 - Combined sections
case.study6.presentation.model3 = case.study6.presentation.model.default +
  Section(by = c("outcome.parameter", "multiplicity.adjustment"))

# Report Generation
GenerateReport(presentation.model = case.study6.presentation.model3,
               cse.results = case.study6.results,
               report.filename = "Case study 6 - Combined Sections.docx")
{% endhighlight %}

## Download

The R code utilized and the Clinical Scenario Evaluation Report generated in this case study can be dowloaded below.

<center>
  <div class="col-md-6">
    <a href="Case study 6.docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
  <div class="col-md-6">
    <a href="Case study 6.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</div>
</center>
