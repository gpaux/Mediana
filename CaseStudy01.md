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

Consider a Phase III clinical trial for the treatment of rheumatoid arthritis (RA). The primary endpoint is a response rate based on the American College of Rheumatology (ACR) definition of improvement. The trial’s sponsor in interested in performing power calculations using the treatment effect assumptions listed in the table below:

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
                <td>Pessimist</td>
                <td>30%</td>
                <td>50%</td>
            </tr>
            <tr>
                <td>Standard</td>
                <td>30%</td>
                <td>55%</td>
            </tr>
            <tr>
                <td>Optimist</td>
                <td>30%</td>
                <td>60%</td>
            </tr>
        </tbody>
    </table>
</div>

### Data Model
The three outcome parameter sets displayed in the table are combined with four sample size sets (`SampleSize(c(80, 90, 100, 110))`) and the distribution of the primary endpoint (`OutcomeDist(outcome.dist = "BinomDist")`) is specified in the data model object `case.study1.data.model`:

{% highlight R %}
# Outcome parameter set 1
outcome1.placebo = parameters(prop = 0.30)
outcome1.treatment = parameters(prop = 0.50)

# Outcome parameter set 2
outcome2.placebo = parameters(prop = 0.30)
outcome2.treatment = parameters(prop = 0.55)

# Outcome parameter set 3
outcome3.placebo = parameters(prop = 0.30)
outcome3.treatment = parameters(prop = 0.60)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "BinomDist") +
  SampleSize(c(80, 90, 100, 110)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome1.placebo, outcome2.placebo,  outcome3.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome1.treatment, outcome2.treatment, outcome3.treatment))

{% endhighlight %}

### Analysis Model
The analysis model uses a standard two-sample test for comparing proportions (`method = "PropTest"`) to assess the treatment effect in this clinical trial example.

{% highlight R %}
# Analysis model
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "PropTest")
{% endhighlight %}

### Evaluation Model
Power evaluations are easily performed in this clinical trial example using the same evaluation model utilized in the case of a normally distributed endpoint, i.e. evaluations rely on marginal power.
{% highlight R %}
# Evaluation model
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))
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

An extension of this clinical trial example is provided in [Case study 5](CaseStudy05.html). The extension deals with a more complex setting involving several trial endpoints and multiple treatment arms.

## Survival-type endpoint

If the trial’s primary objective is formulated in terms of analyzing the time to a clinically important event (progression or death in an oncology setting), data and analysis models can be set up based on an exponential distribution and the log-rank test.

As an illustration, consider a Phase III trial which will be conducted to
study a new treatment for metastatic colorectal cancer (MCC). Patients will be randomized in a 2:1 ratio to an experimental treatment or placebo (in addition to best supportive care).

The trial’s primary objective is to assess the effect of the experimental treatment on progression-free survival.

### Data Model

A single treatment effect scenario is considered in this clinical trial example. Specifically, the median time to progression is assumed to be:

- Placebo : t0 = 6 months,

- Treatment: t1 = 9 months. 

Under an exponential distribution assumption (i.e. specified using the `ExpoDist` distribution), the median times correspond to the following hazard rates:

- &lambda;0 = log(2)/t0 = 0.116, 

- &lambda;1 = log(2)/t1 = 0.077,

and the resulting hazard ratio (HR) is 0.077/0.116 = 0.67.

{% highlight R %}
# Outcome parameters
median.time.placebo = 6
rate.placebo = log(2)/median.time.placebo
outcome.placebo = parameters(rate = rate.placebo)

median.time.treatment = 9
rate.treatment = log(2)/median.time.treatment
outcome.treatment = parameters(rate = rate.treatment)
{% endhighlight %}

It is important to note that, if no censoring mechanisms are specified in a data model with a time-to-event endpoint, all patients will reach the endpoint of interest (e.g., progression) and thus the number of patients will be equal to the number of events. Using this property, power calculations can be done using either the `Event` object, or the `SampleSize` object. For the purpose of illustration, the `Event` object will be used in this example.

To define a data model in the MCC clinical trial, the total event count in the trial is assumed to range between 270 and 300. Since the group are not balanced, the randomization eatio needs to be specified within the `Event` object.

{% highlight R %}
# Number of events parameters
event.count.total = c(210, 300)
randomization.ratio = c(1,2)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "ExpoDist") +
  Event(n.events = event.count.total, rando.ratio = randomization.ratio) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome.treatment))
{% endhighlight %}

It is worth noting that the primary endpoint’s type (`outcome.type` argument in the `OutcomeDist` object) is not specified. By default, the outcome type is set to `fixed`, which means that a design with a fixed follow-up is assumed even though the primary endpoint in this clinical trial is clearly a time-to-event endpoint. This is due to the fact that, as was explained earlier in this case study, there is no censoring
in this design and all patients are followed until the event of interest is observed. In fact, it is easy to verify that the same results are obtained if the outcome type is set to `event`.

### Analysis Model
The analysis model in this clinical trial is very similar to the analysis models defined in the case study with normal and binomial distribution. The only difference is the choice of the statistical method utilized in the primary analysis (`method = "LogrankTest"`).

{% highlight R %}
# Analysis model
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "LogrankTest")
{% endhighlight %}

### Evaluation Model
An evaluation model identical to that used earlier in the case study with normal and binomial distribution can be applied to examine the power function at the selected event counts.

{% highlight R %}
# Evaluation model
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))
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

The power calculations presented earlier in the previous case study assumed an idealized setting where each patient is followed until the event of interest is observed. In this case, the sample size (number of patients) in each treatment arm is equal to the number of events. In reality, events are often censored and a sponsor is generally interested in determining the number of patients to be recruited in order to ensure a target number of events, which translates into desirable power.

The Mediana package can be used to perform power calculations in event-driven trials in the presence of censoring. This is accomplished by setting up design parameters such as the length of the enrollment and follow-up periods in the Data Model using a `Design` object.

In general, even though closed-form solutions have been derived for sample size calculations in event-driven designs, the available approaches force clinical trial researchers to make a variety of simplifying assumptions, e.g., assumptions on the enrollment distribution are commonly made, see, for example, Julious (2009, Chapter 15). A general simulation-based approach to power and sample size calculations implemented in the Mediana package enables clinical trial sponsors to remove these artificial restrictions and examine a very broad set of plausible design parameters.

### Data Model
Suppose, for example, that a standard design with a variable follow-up will be used in the MCC trial introduced in the previous case study. The total study duration will be 21 months, which includes a 9-month enrollment (accrual) period and a minimum follow-up of 12 months. The patients are assumed to be recruited at a uniform rate. The set of design parameters also includes the dropout distribution and its parameters. In this clinical trial, the dropout distribution is exponential with a rate determined from historical data. These desing parameters are specified in a `Design` object. 

{% highlight R %}
# Dropout parameters
dropout.par = parameters(rate = 0.0115)

# Design parameters
case.study1.design = Design(enroll.period = 9,
                            study.duration = 21,
                            enroll.dist = "UniformDist",
                            dropout.dist = "ExpoDist",
                            dropout.dist.par = dropout.par) 
{% endhighlight %}

Finally, the primary endpoint’s type is set to `event` in the `OutcomeDist` object to indicate that a variable follow-up will utilized in this clinical trial.

The complete data model for this case study is defined as:

{% highlight R %}
# Number of events parameters
event.count.total = c(390, 420)
randomization.ratio = c(1,2)

# Outcome parameters
median.time.placebo = 6
rate.placebo = log(2)/median.time.placebo
outcome.placebo = parameters(rate = rate.placebo)
median.time.treatment = 9
rate.treatment = log(2)/median.time.treatment
outcome.treatment = parameters(rate = rate.treatment)

# Dropout parameters
dropout.par = parameters(rate = 0.0115)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "ExpoDist", 
              outcome.type = "event") +
  Event(n.events = event.count.total, rando.ratio = randomization.ratio) +
  Design(enroll.period = 9,
         study.duration = 21,
         enroll.dist = "UniformDist",
         dropout.dist = "ExpoDist",
         dropout.dist.par = dropout.par) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome.treatment))
{% endhighlight %}

### Analysis Model

As in this example the number of events has been fixed, and some patients will not get the event of interest, it could be interesting to know approximately the number of patients required to get the number of events according to the design parameters. In the Mediana package, this can be accomplished by specifying `Statistic` object using the method `EventCountStat`. Another interesting statistics that could be get is the number of events that will be observed in each sample. In this case, a `Statistic` object with method `EventCountStat` can be used. 

{% highlight R %}
# Analysis model
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "LogrankTest") +
  Statistic(id = "Events Placebo",
            samples = samples("Placebo"),
            method = "EventCountStat") +
  Statistic(id = "Events Treatment",
            samples = samples("Treatment"),
            method = "EventCountStat")  +
  Statistic(id = "Patients Placebo",
            samples = samples("Placebo"),
            method = "PatientCountStat") +
  Statistic(id = "Patients Treatment",
            samples = samples("Treatment"),
            method = "PatientCountStat")
{% endhighlight %}

### Evaluation Model

In order to get a summary over the simulation runs of the number of patients and events in each sample, two `Criterion` objects will be specified, additionaly to the `Criterion` object defined to get the marginal power.

In these two `Criterion` objects, the IDs of the `Statistic` object will be specified in the `statistics` argument. 

{% highlight R %}
# Evaluation model
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))  +
  Criterion(id = "Mean Events",
            method = "MeanSumm",
            statistics = statistics("Events Placebo", "Events Treatment"),
            labels = c("Mean Events Placebo", "Mean Events Treatment")) +
  Criterion(id = "Mean Patients",
            method = "MeanSumm",
            statistics = statistics("Patients Placebo", "Patients Treatment"),
            labels = c("Mean Patients Placebo", "Mean Patients Treatment"))
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

The last clinical trial example within Case study 1 deals with a Phase III clinical trial in patients with relapsing-remitting multiple sclerosis (RRMS). The trial aims at assessing the safety and efficacy of a single dose of a novel treatment compared to placebo. The primary endpoint is the number of new gadolinium enhancing lesions seen during a 6-month period on monthly MRIs of the brain and a smaller number indicates treatment benefit. The distribution of such endpoints has been widely studied in the literature and Sormani et al. (1999a, 1999b) showed that a negative
binomial distribution provides a relatively good fit to the data.

The table below gives the expected treatment effect in the experimental treatment and placebo arms (the negative binomial distribution is parameterized using the mean rather than the probability of success in each trial).

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>Treatment Arm</th>
                <th>Mean number of new lesions</th>
                <th>Dispersion parameter</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Placebo</td>
                <td>13</td>
                <td>7.8</td>
            </tr>
            <tr>
                <td>Treatment</td>
                <td>7.8</td>
                <td>0.5</td>
            </tr>
        </tbody>
    </table>
</div>

The corresponding treatment effect, i.e., the relative reduction in the mean number of new lesions counts, is 100x(13 − 7.8)/13 = 40%. The assumptions in the table define a single outcome parameter set.

### Data Model

The `OutcomeDist` object defines the distribution of the trial endpoint (`NegBinomDist`). Further, a balanced design will be utilized in this clinical trial and the range of sample sizes is defined in the `SampleSize` object (it is convenient to do this using the seq function). The `Sample` objects includes the parameters required by the negative binomial distribution (dispersion and mean).

{% highlight R %}
# Outcome parameters
outcome.placebo = parameters(dispersion = 0.5, mean = 13)
outcome.treatment = parameters(dispersion = 0.5, mean = 7.8)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "NegBinomDist") +
  SampleSize(seq(100, 150, 10)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.placebo)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome.treatment))
{% endhighlight %}

### Analysis Model
The treatment effect will be assessed in this clinical trial example using a negative binomial generalized linear model (NBGLM). In the Mediana package, this test is defined in a `Test` object using the `GLMNegBinomTest` method. Of note, it should be noted that as a smaller value indicates a treatment benefit, the first sample defined in the `samples` argument must be `Treatment`.

{% highlight R %}
# Analysis model
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Treatment vs Placebo",
       samples = samples( "Treatment", "Placebo"),
       method = "GLMNegBinomTest")
{% endhighlight %}

### Evaluation Model

The objective of this clinical trial is identical to that of the clinical trials presented earlier in this page, i.e., evaluation will be based on marginal power of the primary endpoint test. As a consequence, the
same evaluation model can be applied.

{% highlight R %}
# Evaluation model
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Treatment vs Placebo"),
            labels = c("Treatment vs Placebo"),
            par = parameters(alpha = 0.025))
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
