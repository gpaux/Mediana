---
layout: page
title: Case studies
header: Case studies
group: navigation
---
{% include JB/setup %}

## About

Several case studies have been created to help the user understand the feature of the Mediana package. Case studies go from the most simple case ([Case study 1](CaseStudy01.html)) to complex clinical setting ([Case study 6](CaseStudy06.html)).

## Case study 1

This case studies will serve to introduce the implementation of very simple case studies, where in most of the case, a closed-form expression can be used to calculate the sample size. They will help the user to understand the specificity of the Mediana Package with simple examples.

1.  [Trial with two treatment arms and single endpoint (normally distributed endpoint).](CaseStudy01.html#Normallydistributedendpoint)
2.  [Trial with two treatment arms and single endpoint (binary endpoint).](CaseStudy01.html#Binaryendpoint)
3.  [Trial with two treatment arms and single endpoint (survival-type endpoint).](CaseStudy01.html#Survival-typeendpoint)
4.  [Trial with two treatment arms and single endpoint (survival-type endpoint with censoring).](CaseStudy01.html#Survival-typeendpoint(withcensoring))
5.  [Trial with two treatment arms and single endpoint (count-type endpoint).](CaseStudy01.html#Count-typeendpoint)

## Case study 2

This case study will serve to introduce a **clinical trial with three or more treatment arms**. In this settings, a multiplicity adjustment is required and no analytical methods are available to support power calculations.

This example will also illustrate a key feature of the Mediana package, the possibility to define user-specified function, for example, to define a new criterion for the Evaluation Model.

[Clinical trial in patients with schizophrenia](CaseStudy02.html)

## Case study 3

This case study will serve to introduce a **clinical trial with several patient populations** (marker-positive and marker-negative patients). It will help the user to understand how to define independant samples, and perform a test by merging samples, i.e. merging marker-positive and marker-negative  samples to perform a test on the overall population.

[Clinical trial in patients with asthma](CaseStudy03.html)

## Case study 4

This case study will serve to introduce a **clinical trial with several endpoints** and help showcase the package’s ability to model complex design and analysis strategies in trials with multivariate outcomes.

[Clinical trial in patients with metastatic colorectal cancer](CaseStudy04.html)

## Case study 5

This case study will serve to introduce a **clinical trial with several endpoints and multiple treatment arms** and help showcase the package’s ability to model complex design and analysis strategies in trials with multivariate outcomes.

[Clinical trial in patients with rheumatoid arthritis](CaseStudy05.html)

## Case study 6

This case study is an extenston of [Case study 2](CaseStudy02.html) and will serve to illustrate how the package can be used to compare the performance of several MTPs. Customized report generation will also be illustrated in this case study.

[Clinical trial in patients with schizophrenia](CaseStudy06.html)
