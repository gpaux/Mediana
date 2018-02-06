---
layout: page
title: How create a data model by resampling from an existing data set?
header: How create a data model by resampling from an existing data set?
group: navigation
---
{% include JB/setup %}


## Summary

The Mediana R package uses Monte-Carlo simulations to generate data. However, it is also possible to create a data model by resampling from an existing data set. This will be illustrated in the following page.

A simple example will be used to illustrate how to create a data model by resampling from an existing data set. We will consider a pool of three Phase II clinical trials with 200 patients, where data on the Phase III primary endpoint have been collected for the treatment arm. Control data have been collected in several previously conducted trial with several experimental drugs and a large database with 3000 patients exists.

The objective for the sponsor is to estimate the statistical power by sampling from these existing datasets. 

For simplicity, we will consider a Phase III clinical trial with two arms and a normally distributed endpoints (a Phase III clinical trial in patients with pulmonary arterial hypertension where the primary endpoint is the change in the six-minute walk distance).

## Data Model

As mentioned previously, the data model will be constructed by sampling from pre-existing dataset. For the purpose of illustration, we will generate these pre-existing datasets. 

For the treatment arm, we consider the data collected from three Phase II clinical trial with respectively 75, 75 and 50 patients. The observed mean and SD of the six-minute walking test in each trial is used to generate the data, then the data are merged within a dataset. Data are generated using a normal distribution.

{% highlight R %}
treatment_PhaseII_data1 = data.frame(trt = rep(1,75),
                                     y = rnorm(75, mean = 40, sd = 68))
treatment_PhaseII_data2 = data.frame(trt = rep(1,75),
                                     y = rnorm(75, mean = 35, sd = 62))
treatment_PhaseII_data3 = data.frame(trt = rep(1,50),
                                     y = rnorm(50, mean = 42, sd = 74))
treatment_PhaseII_data = rbind(treatment_PhaseII_data1, 
                               treatment_PhaseII_data2,
                               treatment_PhaseII_data3)
{% endhighlight %}

For the placebo group, data are obtained using a pooled database with data collected from several research development program in the same indications. 3000 placebo patients compose this dataset. As for the treatment group, data of the 3000 patients are generated using a normal distribution with observed mean and SD.

{% highlight R %}
control_data = data.frame(trt = rep(2,3000),
                          y = rnorm(3000, mean = 0, sd = 70))
{% endhighlight %}

The data model will be constructed by sampling data from these pre-existing datasets. Several sample size scenarios will be evaluated, from 40 patients per treatment arm to 70, with a step of 10 patients. 

In order to sample from these datasets, a new outcome distribution function have to be implemented. The key idea of this function will simply be to sample data from the dataset. To create a customized outcome distribution function, please refer to this [page](CustomFunctions.html#User-definedfunctionsforadatamodel). This function will require two specific parameters in addition to the sample size, the pre-existing data, and a boolean indicating whether or not the sampling will be done with or without replacement. The customized function is presented below.

{% highlight R %}
# Custom function to sample from a pre-existing dataset
SamplingDist <- function(parameter){
  # Determine the function call, either to generate distribution or to return the distribution's description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    # The number of observations to generate
    n = parameter[[1]]
    
    ##############################################################
    # Distribution-specific component
    # Get the distribution's parameters (stored in the parameter[[2]] list)
    dataset = parameter[[2]]$dataset
    replace = parameter[[2]]$replace
    ##############################################################
    
    # Error checks (other checks could be added by the user if needed)
    if (n%%1 != 0)
      stop("Data model: SamplingDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: SamplingDist distribution: Number of observations must be positive.")
    
    # Error checks on replace
    if (!is.logical(replace))
      stop("Data model: SamplingDist distribution: replace argument must be TRUE or FALSE.")
      
    if (!replace & (n > length(dataset)))
      stop("Data model: SamplingDist distribution: replace cannot be set to FALSE if the sample size is greater than the data set length.")


    # Error checks on dataset
    if (!is.vector(dataset))
      stop("Data model: SamplingDist distribution: dataset argument must be vector of values to sample from.")
    
    ##############################################################
    # Distribution-specific component
    # Observations are sampled from the dataset
    result = sample(x = dataset, size = n, replace = replace)
    ##############################################################

  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      
      ##############################################################
      # Distribution-specific component
      # The labels of the distributional parameters and the distribution's label must be stored in the "result" list
      result = list(list(dataset = "dataset", replace = "replace"),
                    list("SamplingDist"))
      ##############################################################
      
    }
  }
  return(result)
}
{% endhighlight %}



The key part of this function named `SamplingDist` are within blocks. The first block is used to get the parameters of the function, i.e., the dataset and the replacement indicator. The second block is used to sample `n` values from the `dataset` with the option to `replace`  or not. Lastly, the third block is used for the purpose of creating the simulation report and will not be described here. 

For the purpose of illustration, we will consider a sampling with replacement. The outcome parameters for each group and the data model can be defined as follows. The outcome distribution specified in the `OutcomeDist` object is `SamplingDist`.

{% highlight R %}

outcome.control = parameters(dataset = control_data$y,

                             replace = TRUE)
outcome.treatment = parameters(dataset = treatment_PhaseII_data$y,
                               replace = TRUE)

# Data model
case.study1.data.model = DataModel() +
  OutcomeDist(outcome.dist = "SamplingDist") +
  SampleSize(seq(40,70,10)) +
  Sample(id = "Placebo",
         outcome.par = parameters(outcome.control)) +
  Sample(id = "Treatment",
         outcome.par = parameters(outcome.treatment))

{% endhighlight %}

Then the analysis model and the evaluation model can be defined as usual. 

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

## Download

Click on the icons below to download the R code used in this case study and report that summarizes the results of Clinical Scenario Evaluation:

<center>
  <div class="col-md-6">
    <a href="Case study resampling.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>