---
layout: page
title: Analysis Model
header: Analysis Model
group: navigation
weight: 2
---
{% include JB/setup %}

# About
Analysis models define statistical methods that are applied to the study data in a clinical trial.

# Initialization

An Analysis Model can be initialized using the following command

```R
analysis.model = AnalysisModel()
```

Initialization with this command is higlhy recommended as it will simplify the add of related objects, such as 
`MultAdj`, `MultAdjProc`, `MultAdjStrategy`, `Test`, `Statistic` objects.