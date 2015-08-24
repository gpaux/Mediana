---
layout: page
title: Evaluation Model
header: Evaluation Model
group: navigation
---
{% include JB/setup %}

# About
Evaluation models are used within the Mediana package to specify the measures (metrics) for evaluating the performance of the selected clinical scenario (combination of data and analysis models).

# Initialization

An evaluation model can be initialized using the following command

{% highlight R %}
evaluation.model = EvaluationModel()
{% endhighlight %}

Initialization with this command is higlhy recommended as it will simplify the add of related objects, such as `Criterion` objects.