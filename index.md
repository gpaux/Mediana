---
layout: page
title: Mediana R package
tagline:
---
{% include JB/setup %}

## About
----------

Mediana is an R package which provides a general framework for clinical trial simulations based on the Clinical Scenario Evaluation approach. The package supports a broad class of data models (including clinical trials with continuous, binary, survival-type and count-type endpoints as well as multivariate outcomes that are based on combinations of different endpoints), analysis strategies and commonly used evaluation criteria.

Find out more at [http://biopharmnet.com/mediana/](http://biopharmnet.com/mediana/), and check out the case studies.

## Installation
----------

### Official release

Get the official released version from CRAN in R:

{% highlight R %}
install.packages("Mediana")
{% endhighlight %}

Or by downloading the package from the [CRAN website](https://cran.r-project.org/web/packages/Mediana/index.html).

### Development version

The up-to-date development version can be found and installed directly from GitHub. Its installation requires the package *devtools*:

{% highlight R %}
# install.packages("devtools")
devtools::install_github("gpaux/Mediana")
{% endhighlight %}


## Clinical Scenario Evaluation Framework
----------
The Mediana R package was developed to provide a general software implementation of the Clinical Scenario Evaluation framework. This framework introduced by [Benda et al. (2010)]() and [Friede et al. (2010)]() recognizes that sample size calculation and power evaluation in clinical trials are high-dimensional statistical problems. This approach helps to decompose this complex problem by identifying key elements of the evaluation process. These components are termed models:


- [Data models](DataModel.html) define the process of generating trial data (e.g., sample sizes and randomization ratios, outcome distribution and parameters).
- [Analysis models](AnalysisModel.html) define the statistical methods applied to the trial data (e.g., statistical tests, multiplicity adjustments, timing of interim analysis).
- [Evaluation models](EvaluationModel.html) specify the measures for evaluating the performance of the analysis strategies (e.g. traditional success criteria such as disjunctive or weighted power).

Wihtin the Mediana R package, these models are used to perform the Clinical Scenario Evaluation. Find out more about each model and how to define them in the dedicated pages.

## Case studies
----------

Case studies facilitating the implementation of the Clinical Scenario Evaluation for several type of clinical trials using the Mediana R package are provided and will be updated in a continuous basis. Find out more [here](CaseStudies.html).

The Mediana package has been successfully used in multiple clinical
trial optimization exercises. See [Dmitrienko et al. (2015)]() and [Dmitrienko et al. (2016)]().