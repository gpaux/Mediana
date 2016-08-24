---
layout: page
title: Mediana R package
tagline:
---
{% include JB/setup %}

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/Mediana)](http://cran.r-project.org/package=Mediana)

## New release !

The version 1.0.3 of the Mediana R package has been released on 24 August 2016. This latest stable version can be dowloade from the [CRAN website](https://cran.r-project.org/web/packages/Mediana/index.html). The principal revisions compared to the previous version include the following features:

- Addition of the Beta distribution (`BetaDist`, see [Data model](DataModel.html#OutcomeDistobject)).

- Addition of the Truncated exponential distribution, which could be used as enrollment distribution (`TruncatedExpoDist`, see [Data model](DataModel.html#OutcomeDistobject)).

- Addition of the Non-inferiority test for proportion (`PropTestNI`, see [Analysis model](AnalysisModel.html#Testobject)).

- Addition of a function to get the data generated in the CSE using the `DataStack` function (see [Data stack](DataStack.html)).

- Addition of a function to extract a specific set of data in a `DataStack` object (see [Data stack](DataStack.html#ExtractDataStack)).

- Addition of the "Evaluation Model" section in the generated report describing the criteria and their parameters (see [Simulation report](Reporting.html#Description18)).

- Some bug fixes.

## About

Mediana is an R package which provides a general framework for clinical trial simulations based on the Clinical Scenario Evaluation approach. The package supports a broad class of data models (including clinical trials with continuous, binary, survival-type and count-type endpoints as well as multivariate outcomes that are based on combinations of different endpoints), analysis strategies and commonly used evaluation criteria.

## Expert and development teams

**Package design**: [Alex Dmitrienko (Mediana Inc.)](http://www.medianainc.com/).

**Core development team**: [Gautier Paux (Servier)](http://www.linkedin.com/in/pauxgautier), [Alex Dmitrienko (Mediana Inc.)](http://www.medianainc.com/).

**Extended development team**: Thomas Brechenmacher (Novartis), Fei Chen (Johnson and Johnson), Ilya Lipkovich (Quintiles), Ming-Dauh Wang (Lilly), Jay Zhang (MedImmune), Haiyan Zheng (Osaka University).

**Expert team**: Keaven Anderson (Merck), Frank Harrell (Vanderbilt University), Mani Lakshminarayanan (Pfizer), Brian Millen (Lilly), Jose Pinheiro (Johnson and Johnson), Thomas Schmelter (Bayer).

## Installation

### Latest release

Install the latest version of the Mediana package from CRAN using the *install.packages* command in R:

{% highlight R %}
install.packages("Mediana")
{% endhighlight %}

Alternatively, you can download the package from the [CRAN website](https://cran.r-project.org/web/packages/Mediana/index.html).

### Development version

The up-to-date development version can be found and installed directly from the GitHub web site. You need to install the *devtools* package and then call the *install_github* function in R:

{% highlight R %}
# install.packages("devtools")
devtools::install_github("gpaux/Mediana")
{% endhighlight %}

### Potential installation's issue

When installing Mediana package, an error could occur if a java version >= 1.6 is not installed. Java is used in the ReporteRs R package which is required in the Mediana R package to [generate Word report](Reporting.html). 

`system("java -version")` should return java version ‘1.6.0’ or greater.

In order to ensure a proper installation, it is highly recommended to install the latest version of Java in the same architecture of R (32-bit or 64-bit). 

The latest version can be found at [https://www.java.com/en/download/manual.jsp](https://www.java.com/en/download/manual.jsp).

## Clinical Scenario Evaluation Framework

The Mediana R package was developed to provide a general software implementation of the Clinical Scenario Evaluation (CSE) framework. This framework introduced by [Benda et al. (2010)](http://dij.sagepub.com/content/44/3/299.abstract) and [Friede et al. (2010)](http://dij.sagepub.com/content/44/6/713.abstract) recognizes that sample size calculation and power evaluation in clinical trials are high-dimensional statistical problems. This approach helps decompose this complex problem by identifying key elements of the evaluation process. These components are termed models:

- [Data models](DataModel.html) define the process of generating trial data (e.g., sample sizes,  outcome distributions and parameters).
- [Analysis models](AnalysisModel.html) define the statistical methods applied to the trial data (e.g., statistical tests, multiplicity adjustments).
- [Evaluation models](EvaluationModel.html) specify the measures for evaluating the performance of the analysis strategies (e.g., traditional success criteria such as marginal power or composite criteria such as disjunctive power).

Find out more about the role of each model and how to specify the three models to perform Clinical Scenario Evaluation by reviewing the dedicated pages (click on the links above).

## Case studies

Multiple [case studies](CaseStudies.html) are provided on this web site to facilitate the implementation of Clinical Scenario Evaluation in different clinical trial settings using the Mediana package. These case studies will be updated on a regular basis. 

The Mediana package has been successfully used in multiple clinical trials to perform power calculations as well as optimally select trial designs and analysis strategies (clinical trial optimization). For more information on applications of the Mediana package, download the following papers:

- Dmitrienko, A., Paux, G., Brechenmacher, T. (2016). Power calculations in clinical trials with complex clinical objectives. Journal of the Japanese Society of Computational Statistics. 28, 15-50.
- [Dmitrienko, A., Paux, G., Pulkstenis, E., Zhang, J. (2016). Tradeoff-based optimization criteria in clinical trials with multiple objectives and adaptive designs. Journal of Biopharmaceutical Statistics. 26, 120-140.](http://www.tandfonline.com/doi/abs/10.1080/10543406.2015.1092032?journalCode=lbps20)

