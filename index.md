---
layout: page
title: Mediana R package 
tagline:
---
{% include JB/setup %}

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/Mediana)](https://cran.r-project.org/package=Mediana) ![cranlogs](http://cranlogs.r-pkg.org./badges/Mediana)

## New FAQ page

A  [Frequently Asked Question](FAQ_index.html) page has been created! Don't hesitate to [contact us](mailto: gautier@paux.fr) if you have questions and we will be happy to guide you in the use of Mediana R package for your case study.

## Clinical trial optimization using R

<center>
  <div class="col-md-3">
    <a href="https://www.crcpress.com/Clinical-Trial-Optimization-using-R/Dmitrienko/p/book/9781498735070" class="img-responsive">
      <img src="book.jpg" class="img-responsive"/>
    </a>
  </div>
</center>

[Clinical Trial Optimization Using R](https://www.crcpress.com/Clinical-Trial-Optimization-using-R/Dmitrienko/p/book/9781498735070) explores a unified and broadly applicable framework for optimizing decision making and strategy selection in clinical development, through a series of examples and case studies.It provides the clinical researcher with a powerful evaluation paradigm, as well as supportive R tools, to evaluate and select among simultaneous competing designs or analysis options. It is applicable broadly to statisticians and other quantitative clinical trialists, who have an interest in optimizing clinical trials, clinical trial programs, or associated analytics and decision making.

This book presents in depth the Clinical Scenario Evaluation (CSE) framework, and discusses optimization strategies, including the quantitative assessment of tradeoffs. A variety of common development challenges are evaluated as case studies, and used to show how this framework both simplifies and optimizes strategy selection. Specific settings include optimizing adaptive designs, multiplicity and subgroup analysis strategies, and overall development decision-making criteria around Go/No-Go. After this book, the reader will be equipped to extend the CSE framework to their particular development challenges as well.

Mediana R package has been widely used to implement the case studies presented in this book. The detailed description and R code of these case studies are available on this website.

## New release ! [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/Mediana)](https://cran.r-project.org/package=Mediana)

The version 1.0.7 of the Mediana R package has been released on 16 July 2018. This latest stable version can be downloaded from the [CRAN website](https://cran.r-project.org/web/packages/Mediana/index.html). As the `ReporteRs` R package is not available on the CRAN anymore, the report generation feature has been revised using the `officer` and `flextable` R packages. These packages are now required to use the `GenerateReport` function.

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

### Suggested packages

When installing Mediana package, it is recommended to install the `officer` and `flextable` R packages to enable the [generation of Word-based report](Reporting.html).

## Clinical Scenario Evaluation Framework

The Mediana R package was developed to provide a general software implementation of the Clinical Scenario Evaluation (CSE) framework. This framework introduced by [Benda et al. (2010)](http://dij.sagepub.com/content/44/3/299.abstract) and [Friede et al. (2010)](http://dij.sagepub.com/content/44/6/713.abstract) recognizes that sample size calculation and power evaluation in clinical trials are high-dimensional statistical problems. This approach helps decompose this complex problem by identifying key elements of the evaluation process. These components are termed models:

- [Data models](DataModel.html) define the process of generating trial data (e.g., sample sizes,  outcome distributions and parameters).
- [Analysis models](AnalysisModel.html) define the statistical methods applied to the trial data (e.g., statistical tests, multiplicity adjustments).
- [Evaluation models](EvaluationModel.html) specify the measures for evaluating the performance of the analysis strategies (e.g., traditional success criteria such as marginal power or composite criteria such as disjunctive power).

Find out more about the role of each model and how to specify the three models to perform Clinical Scenario Evaluation by reviewing the dedicated pages (click on the links above).

## Case studies

Multiple [case studies](CaseStudies.html) are provided on this web site to facilitate the implementation of Clinical Scenario Evaluation in different clinical trial settings using the Mediana package. These case studies will be updated on a regular basis. 

The Mediana package has been successfully used in multiple clinical trials to perform power calculations as well as optimally select trial designs and analysis strategies (clinical trial optimization). For more information on applications of the Mediana package, download the following papers:

- [Dmitrienko, A., Paux, G., Brechenmacher, T. (2016). Power calculations in clinical trials with complex clinical objectives. Journal of the Japanese Society of Computational Statistics. 28, 15-50.](https://www.jstage.jst.go.jp/article/jjscs/28/1/28_1411001_213/_article)
- [Dmitrienko, A., Paux, G., Pulkstenis, E., Zhang, J. (2016). Tradeoff-based optimization criteria in clinical trials with multiple objectives and adaptive designs. Journal of Biopharmaceutical Statistics. 26, 120-140.](http://www.tandfonline.com/doi/abs/10.1080/10543406.2015.1092032?journalCode=lbps20)
- [Paux, G. and Dmitrienko A. (2018). Penalty-based approaches to evaluating multiplicity adjustments in clinical trials: Traditional multiplicity problems. Journal of Biopharmaceutical Statistics. 28, 146-168.](https://doi.org/10.1080/10543406.2017.1397010)
- [Paux, G. and Dmitrienko A. (2018). Penalty-based approaches to evaluating multiplicity adjustments in clinical trials: Advanced multiplicity problems. Journal of Biopharmaceutical Statistics. 28, 169-188.](https://doi.org/10.1080/10543406.2017.1397011)
