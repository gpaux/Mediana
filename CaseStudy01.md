---
layout: page
title: Case study 1
header: Case study 1
group: 
---

{% include JB/setup %}

Case study 1 deals with a simple setting, a clinical trial with two treatment arms (experimental treatment versus placebo) and a single endpoint, where power calculations can be performed analytically. In this setting, closed-form expressions for the sample size can be derived using the central limit theorem or other approximations and operating characteristics of candidate designs are easily evaluated.

Several distribution will be illustrated in this case study:

- [Normally distributed endpoint](CaseStudy01.html#Normallydistributedendpoint)

- [Binary endpoint](CaseStudy01.html#Binaryendpoint)

- [Survival-type endpoint](CaseStudy01.html#Survival-typeendpoint)

- [Survival-type endpoint (with censoring)](CaseStudy01.html#Survival-typeendpoint(withcensoring))

- [Count-type endpoint](CaseStudy01.html#Count-typeendpoint)

## Normally distributed endpoint

Suppose that a sponsor is designing a Phase III clinical trial in patients with pulmonary arterial hypertension (PAH). The efficacy of experimental treatments for PAH is commonly evaluated using a six-minute walk test and the primary endpoint is defined as the change from baseline to the end of the 16-week treatment period in the six-minute walk distance.

### Data Model

The first step is to initialize the Data Model. 
{% highlight R %}
case.study1.data.model = DataModel()
{% endhighlight %}

After the initialization, specific objects can be added to the `DataModel` object incrementally using the `+` operator.

The change from baseline in the six-minute walk distance is assumed to follow a normal distribution and the distribution of the primary endpoint is defined in the `OutcomeDist` object.
{% highlight R %}
case.study1.data.model =  case.study1.data.model +
  OutcomeDist(outcome.dist = "NormalDist")
{% endhighlight %}

The sponsor would like to perform power evaluation over a broad range of sample sizes in each treatment arm.
{% highlight R %}
case.study1.data.model =  case.study1.data.model +
  SampleSize(c(50, 55, 60, 65, 70)) 
{% endhighlight %}

As a side note, the `seq` function can be used to compactly define sample sizes in
a data model:
{% highlight R %}
case.study1.data.model =  case.study1.data.model +
  SampleSize(seq(50, 70, 5)) 
{% endhighlight %}

The sponsor is interested in performing power calculations under two treatment effect scenarios (standard and optimistic scenarios). Under these scenarios, the experimental treatment is expected to improve the six-minute walk distance by 40 or 50 meters compared to placebo, respectively, with the common standard deviation of 70 meters.

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th rowspan="2">Scenario</th>
                <th colspan="2" class="text-center">Mean (SD)</th>
            </tr>
            <tr>
                <th>Placebo</th>
                <th>Treatment</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Standard</td>
                <td>0 (70)</td>
                <td>0 (70)</td>
            </tr>
            <tr>
                <td>Optimistic</td>
                <td>40 (70)</td>
                <td>50 (70)</td>
            </tr>
        </tbody>
    </table>
</div>

Therefore, the mean change in the placebo arm is set to &mu; = 0 and the mean changes in the six-minute walk distance in the experimental arm are set to &mu; = 40 (standard scenario) or &mu; = 50 (optimistic scenario). The common standard deviation is  &sigma; = 70.

{% highlight R %}
# Outcome parameter set 1
outcome1.placebo = parameters(mean = 0, sd = 70)
outcome1.treatment = parameters(mean = 40, sd = 70)

# Outcome parameter set 2
outcome2.placebo = parameters(mean = 0, sd = 70)
outcome2.treatment = parameters(mean = 50, sd = 70)
{% endhighlight %}

Note that the mean and standard deviation are explicitly identified in each list.
This is done mainly for the user’s convenience. The use of named items such as
mean and sd is mandatory.

After having defined the outcome parameters for each sample, the `Sample` objects can be created and added to the `DataModel` object:

{% highlight R %}
case.study1.data.model =  case.study1.data.model +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome1.placebo, outcome2.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome1.treatment, outcome2.treatment))
{% endhighlight %}

### Analysis Model

As for the Data Model, the Analysis Model must be initialized:
{% highlight R %}
case.study1.analysis.model = AnalysisModel()
{% endhighlight %}

Only one test is planned to performed in the PAH clinical trial (treatment versus placebo) and the treatment comparison will be carried out using the one-sided two-sample
*t*-test.

{% highlight R %}
case.study1.analysis.model = case.study1.analysis.model +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "TTest")
{% endhighlight %}

According to the specifications, the two-sample t-test will be applied to Sample 1 (Placebo) and Sample 2 (Treatment). These sample IDs come from the Data Model
defied earlier. As explained in the [Analysis Model page](AnalysisModel.html#Description), the sample order is determined by the expected direction of the treatment effect. In this case, an increase in the six-minute walk distance indicates a beneficial effect and a numerically larger value of the primary endpoint is expected in Sample 2 compared to Sample 1. This implies that the list of samples to be passed to the t-test should include Sample 1 followed by Sample 2.

To illustrate the use of the `Statistic` object, the mean statistic will be produced:
{% highlight R %}
case.study1.analysis.model = case.study1.analysis.model +
  Statistic(id = "Mean Treatment",
            method = "MeanStat",
            samples = samples("Treatment"))
{% endhighlight %}

### Evaluation Model

The Data and Analysis models specified above collectively define the Clinical Scenarios to be examined in the PAH clinical trial. The scenarios are evaluated using metrics that are aligned with the clinical objectives of the trial, e.g., in this case it is most appropriate to use regular power or, more formally, *marginal power*. This metric is specified using an Evaluation Model.

Again, the Evaluation Model must be initialized:
{% highlight R %}
case.study1.evaluation.model = EvaluationModel()
{% endhighlight %}

The metric of interest (marginal power) is defined using the `Criterion` object:
{% highlight R %}
case.study1.evaluation.model = case.study1.evaluation.model +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))
{% endhighlight %}

The `tests` argument lists the IDs of the tests (defined in the analysis model) to which each metric is applied (more than one test can be specified). The test IDs link the evaluation with the corresponding analysis model. In this particular case, marginal power will be computed for the t-test which compares the mean change in the six-minute walk
distance in the placebo and treatment arms (Placebo vs treatment).

In order to get the average over the simulation runs of the treatment mean, another `Criterion` object must be added:
{% highlight R %}
case.study1.evaluation.model = case.study1.evaluation.model +
  Criterion(id = "Average Mean",
            method = "MeanSumm",
            statistics = statistics("Mean Treatment"),
            labels = c("Average Mean Treatment"))
{% endhighlight %}

As for the marginal power criterion, the `statistics` argument lists the IDs of the statistics (defined in the analysis model) to with the metric is applied (e.g. `Mean Treatment`).

### Clinical Scenario Evaluation

After the clinical scenarios (data and analysis models) and evaluation model have been defined, the user is ready to evaluate the operating characteristics by calling the `CSE` function. 

The first step, is to define the simulation parameters in a `SimParameters` object:
{% highlight R %}
# Simulation Parameters
case.study1.sim.parameters = SimParameters(n.sims = 1000, 
                                           proc.load = "full", 
                                           seed = 42938001)
{% endhighlight %}

As shown below, the function call specifies the individual components of the Clinical Scenario Evaluation
in this case study as well as the simulation parameters:
{% highlight R %}
# Perform clinical scenario evaluation
case.study1.results = CSE(case.study1.data.model,
                          case.study1.analysis.model,
                          case.study1.evaluation.model,
                          case.study1.sim.parameters)
{% endhighlight %}

The results are saved in an evaluation object (result). The object contains complete information about this particular evaluation, including the data, analysis and evaluation models. The most important component of this object is the data frame contained in the list named *simulation.results*, which includes the power and the statistics results based on the metrics in the evaluation model.

### Summary of results and reporting

#### Summary of results in R console 

To facilitate the review of the results, the user can invoke the summary function, which reports in the R console the data frame containing the simulation results.

{% highlight R %}
# Print the simulation results in the R console
summary(case.study1.results)
{% endhighlight %}

This data frame can also be assigned to an object in order to be used for graphical summaries using the [ggplot2](http://ggplot2.org/) R package:
{% highlight R %}
# Print the simulation results in the R console
case.study1.simulation.results = summary(case.study1.results)
{% endhighlight %}

#### Reporting

##### Presentation Model

Another feature of the Mediana package is to provide a Clinical Scenario Evaluation Report in a Word-based format. The first step is to create a `PresentationModel` object.

As for other models, it must be  initialized:
{% highlight R %}
case.study1.presentation.model = PresentationModel()
{% endhighlight %}

Project information can be added to the report using the `Project` object:
{% highlight R %}
case.study1.presentation.model = case.study1.presentation.model +
  Project(username = "[Mediana's User]",
          title = "Case study 1",
          description = "Clinical trial in patients with pulmonary arterial hypertension")
{% endhighlight %}

The user can also customize his report by defining the structure of the result section. In this example, a section will be created for each outcome parameters scenarios (using the `Section` object) and the tables will be sorted by sample size (using the `Table` object). In order to explicitely define the outcome parameters scenarios and the sample size, labels will be assigned using the `CustomLabel` object:
{% highlight R %}
case.study1.presentation.model = case.study1.presentation.model +
  Section(by = "outcome.parameter") +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size", 
              label= paste0("N = ",c(50, 55, 60, 65, 70))) +
  CustomLabel(param = "outcome.parameter", 
              label=c("Standard", "Optismistic"))
{% endhighlight %}

##### Generation of report

Once the Presentation Model has been defined, the report is ready to be generated using the `GenerateReport` function:
{% highlight R %}
# Report Generation
GenerateReport(presentation.model = case.study1.presentation.model,
               cse.results = case.study1.results,
               report.filename = "Case study 1 (normally distributed endpoint).docx")
{% endhighlight %}

### Download

The R code utilized and the Clinical Scenario Evaluation Report generated in this case study can be dowloaded below.

<center>
  <div class="col-md-6">
    <a href="Case study 1 (normally distributed endpoint).docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
  <div class="col-md-6">
    <a href="Case study 1 (normally distributed endpoint).R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</div>
</center>

## Binary endpoint

Consider a Phase III clinical trial for the treatment of rheumatoid arthritis (RA). The primary endpoint is a response rate based on the American College of Rheumatology (ACR) definition of improvement. The trial’s sponsor in interested
in performing power calculations using the treatment effect assumptions listed below:

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th rowspan="2">Outcome parameter set</th>
                <th colspan="2" class="text-center">Response rate</th>
            </tr>
            <tr>
                <th>Placebo</th>
                <th>Treatment</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>30%</td>
                <td>50%</td>
            </tr>
            <tr>
                <td>2</td>
                <td>30%</td>
                <td>55%</td>
            </tr>
            <tr>
                <td>3</td>
                <td>30%</td>
                <td>60%</td>
            </tr>
        </tbody>
    </table>
</div>

### Data Model

{% highlight R %}

{% endhighlight %}

### Analysis Model

{% highlight R %}

{% endhighlight %}

### Evaluation Model

{% highlight R %}

{% endhighlight %}

### Clinical Scenario Evaluation

{% highlight R %}

{% endhighlight %}

### Summary of results and reporting

#### Summary of results in R console 

{% highlight R %}

{% endhighlight %}

#### Reporting

##### Presentation Model

{% highlight R %}

{% endhighlight %}

##### Generation of report

{% highlight R %}

{% endhighlight %}

### Download

The R code utilized and the Clinical Scenario Evaluation Report generated in this case study can be dowloaded below.

<center>
  <div class="col-md-6">
    <a href="Case study 1 (binary endpoint).docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
  <div class="col-md-6">
    <a href="Case study 1 (binary endpoint).R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</div>
</center>

## Survival-type endpoint

Clinical trial in patients with metastatic colorectal cancer.

### Data Model

{% highlight R %}

{% endhighlight %}

### Analysis Model

{% highlight R %}

{% endhighlight %}

### Evaluation Model

{% highlight R %}

{% endhighlight %}

### Clinical Scenario Evaluation

{% highlight R %}

{% endhighlight %}

### Summary of results and reporting

#### Summary of results in R console 

{% highlight R %}

{% endhighlight %}

#### Reporting

##### Presentation Model

{% highlight R %}

{% endhighlight %}

##### Generation of report

{% highlight R %}

{% endhighlight %}

### Download

The R code utilized and the Clinical Scenario Evaluation Report generated in this case study can be dowloaded below.

<center>
  <div class="col-md-6">
    <a href="Case study 1 (survival-type endpoint).docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
  <div class="col-md-6">
    <a href="Case study 1 (survival-type endpoint).R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</div>
</center>

## Survival-type endpoint (with censoring)

Clinical trial in patients with metastatic colorectal cancer.

### Data Model

{% highlight R %}

{% endhighlight %}

### Analysis Model

{% highlight R %}

{% endhighlight %}

### Evaluation Model

{% highlight R %}

{% endhighlight %}

### Clinical Scenario Evaluation

{% highlight R %}

{% endhighlight %}

### Summary of results and reporting

#### Summary of results in R console 

{% highlight R %}

{% endhighlight %}

#### Reporting

##### Presentation Model

{% highlight R %}

{% endhighlight %}

##### Generation of report

{% highlight R %}

{% endhighlight %}

### Download

The R code utilized and the Clinical Scenario Evaluation Report generated in this case study can be dowloaded below.

<center>
  <div class="col-md-6">
    <a href="Case study 1 (survival-type endpoint with censoring).docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
  <div class="col-md-6">
    <a href="Case study 1 (survival-type endpoint with censoring).R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</div>
</center>

## Count-type endpoint

Clinical trial in patients with pulmonary arterial hypertension.

### Data Model

{% highlight R %}

{% endhighlight %}

### Analysis Model

{% highlight R %}

{% endhighlight %}

### Evaluation Model

{% highlight R %}

{% endhighlight %}

### Clinical Scenario Evaluation

{% highlight R %}

{% endhighlight %}

### Summary of results and reporting

#### Summary of results in R console 

{% highlight R %}

{% endhighlight %}

#### Reporting

##### Presentation Model

{% highlight R %}

{% endhighlight %}

##### Generation of report

{% highlight R %}

{% endhighlight %}

### Download

The R code utilized and the Clinical Scenario Evaluation Report generated in this case study can be dowloaded below.

<center>
  <div class="col-md-6">
    <a href="Case study 1 (count-type endpoint).docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
  <div class="col-md-6">
    <a href="Case study 1 (count-type endpoint).R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</div>
</center>
