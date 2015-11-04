---
layout: page
title: Case studies
header: Case studies
group: navigation
---
{% include JB/setup %}

## Introduction

Several case studies have been created to facilitate the implementation of simulation-based Clinical Scenario Evaluation (CSE) approaches in multiple settings and help the user understand individual features of the Mediana package. Case studies are arranged in terms of increasing complexity of the underlying clinical trial setting (i.e., trial design and analysis methodology). For example, [Case study 1](CaseStudy01.html) deals with a number of basic settings and increasingly more complex settings are considered in the subsequent case studies.

## Case study 1

This case study serves a good starting point for users who are new to the Mediana package. It focuses on clinical trials with simple designs and analysis strategies where power and sample size calculations can be performed using analytical methods.

1.  [Trial with two treatment arms and single endpoint (normally distributed endpoint).](CaseStudy01.html#Normallydistributedendpoint)
2.  [Trial with two treatment arms and single endpoint (binary endpoint).](CaseStudy01.html#Binaryendpoint)
3.  [Trial with two treatment arms and single endpoint (survival-type endpoint).](CaseStudy01.html#Survival-typeendpoint)
4.  [Trial with two treatment arms and single endpoint (survival-type endpoint with censoring).](CaseStudy01.html#Survival-typeendpoint(withcensoring))
5.  [Trial with two treatment arms and single endpoint (count-type endpoint).](CaseStudy01.html#Count-typeendpoint)

## Case study 2

This case study is based on a **clinical trial with three or more treatment arms**. A multiplicity adjustment is required in this setting and no analytical methods are available to support power calculations.

This example also illustrates a key feature of the Mediana package, namely, a useful option to define custom functions, for example, it shows how the user can define a new criterion in the Evaluation Model.

[Clinical trial in patients with schizophrenia](CaseStudy02.html)

## Case study 3

This case study introduces a **clinical trial with several patient populations** (marker-positive and marker-negative patients). It demonstrates how the user can define independent samples in a data model and then specify statistical tests in an analysis model based on merging several samples, i.e., merging samples of marker-positive and marker-negative patients to carry out a test that evaluated the treatment effect in the overall population.

[Clinical trial in patients with asthma](CaseStudy03.html)

## Case study 4

This case study illustrates CSE simulations in a **clinical trial with several endpoints** and helps showcase the package's ability to model multivariate outcomes in clinical trials.

[Clinical trial in patients with metastatic colorectal cancer](CaseStudy04.html)

## Case study 5

This case study is based on a **clinical trial with several endpoints and multiple treatment arms** and illustrates the process of performing complex multiplicity adjustments in trials with several clinical objectives.

[Clinical trial in patients with rheumatoid arthritis](CaseStudy05.html)

## Case study 6

This case study is an extension of [Case study 2](CaseStudy02.html) and illustrates how the package can be used to assess the performance of several multiplicity adjustments. The case study also walks the reader through the process of defining customized simulation reports.

[Clinical trial in patients with schizophrenia](CaseStudy06.html)
