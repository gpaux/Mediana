---
layout: page
title: Data Model
header: Data Model
group: navigation
weight: 1
---
{% include JB/setup %}

# About
Data models define the process of generating patient data in clinical trials.

# Initialization

A data model can be initialized using the following command

```R
data.model = DataModel()
```

Initialization with this command is higlhy recommended as it will simplify the add of related objects, such as 
`Sample`, `SampleSize`, `Event`, `Design` objects. 
