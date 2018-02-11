---
layout: page
title: How create a data model by resampling from an existing data set?
header: How create a data model by resampling from an existing data set?
group: navigation
---
{% include JB/setup %}


## Summary

The Mediana R package uses Monte-Carlo simulations to generate patient outcomes in a clinical trial. The simulation parameter are specified in a data model. In addition, as explained below, a data model can also be created by resampling from an existing data set, e.g., a clinical trial database. 

The following case study will be used to illustrate how to create a data model by resampling from an existing data set. We will consider a database of three Phase II clinical trials. This database contains data on the primary endpoint to be used in an upcoming Phase III trial for the experimental treatment. Furthermore, a large database with control data collected in several previously conducted trials with other investigational treatments is available. The sponsor wishes to estimate statistical power in the Phase III trial by sampling from these existing databases. 

For simplicity, we will consider a Phase III clinical trial with two arms and a normally distributed endpoint (a Phase III clinical trial in patients with pulmonary arterial hypertension where the primary endpoint is the change in the six-minute walk distance).

## Data Model

The data model will be constructed by sampling from several pre-existing datasets. For the purposes of illustration, we will generate these datasets. 

Beginning with the database containing treatment data, we consider the outcome data collected from three Phase II clinical trials with 75, 75 and 50 patients, respectively. The observed means and SDs of the primary endpoint in each trial will be used to generate the treatment database as shown below:

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

For the control database, consider a database set up by pooling outcome data from several development programs with the same indications (there are 3000 patients in this database). The control database will be generated using an approach similar to the one utilized above:

{% highlight R %}
control_data = data.frame(trt = rep(2,3000),
                          y = rnorm(3000, mean = 0, sd = 70))
{% endhighlight %}

The data model in this case study will be constructed by sampling data from these two databases. Several sample size scenarios will be evaluated to compute power in the Phase III trial, from 40 patients per treatment arm to 70, with a step of 10 patients. 

In order to sample from the treatment and control data sets, a new outcome distribution function needs to be implemented. The key idea behind this function is to simply enable sampling outcome data from the two data sets. To create a custom outcome distribution function, please refer to this [page](CustomFunctions.html#User-definedfunctionsforadatamodel). This function will require two parameters in addition to the sample size per arm, name of the existing data set and a boolean variable indicating whether the sampling will be done with or without replacement. The custom function, named `SamplingDist`, is presented below.

{% highlight R %}
# Custom function to sample from a pre-existing data set
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
    # Patient outcomes are sampled from the data set
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

The first block in the `SamplingDist` function is used to get the function's parameters, i.e., the data set's name and the boolean indicator. The second block focuses on sampling `n` values from the `dataset` with an option to sample with or without replacement (based on `replace`). Lastly, the third block creates an object that will be used in a simulation report and will not be discussed here. 

For the purpose of illustration, we will consider a sampling scheme with replacement. The outcome parameters for each trial arm and the data model can be defined as follows. The outcome distribution specified in the `OutcomeDist` object is `SamplingDist`.

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

After the data model has been set up, the analysis model and the evaluation model can be defined using a standard approach. 

## Analysis model

The analysis model defines a single significance test that will be carried out in the Phase III trial (treatment versus placebo). The treatment effect will be assessed using the one-sided two-sample *t*-test:

{% highlight R %}
case.study1.analysis.model = AnalysisModel() +
  Test(id = "Placebo vs treatment",
       samples = samples("Placebo", "Treatment"),
       method = "TTest")
{% endhighlight %}

## Evaluation model

The data and analysis models specified above define the Clinical Scenarios that will be examined in the Phase III trial. In general, clinical scenarios are evaluated using success criteria based on the trial's clinical objectives. Regular power, also known as *marginal power*, will be computed in this trial. This success criterion is specified in the following evaluation model.

{% highlight R %}
case.study1.evaluation.model = EvaluationModel() +
  Criterion(id = "Marginal power",
            method = "MarginalPower",
            tests = tests("Placebo vs treatment"),
            labels = c("Placebo vs treatment"),
            par = parameters(alpha = 0.025))
{% endhighlight %}

## Perform Clinical Scenario Evaluation

After the clinical scenarios (data and analysis models) and evaluation model have been defined, the user is ready to evaluate the success criteria specified in the evaluation model by invoking the `CSE` function. The simulation parameters need to be defined in a `SimParameters` object:

{% highlight R %}
# Simulation parameters
case.study1.sim.parameters = SimParameters(n.sims = 10000, 
                                           proc.load = "full", 
                                           seed = 42938001)
{% endhighlight %}

The `CSE` call specifies the individual components of Clinical Scenario Evaluation in this case study as well as the simulation parameters:
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