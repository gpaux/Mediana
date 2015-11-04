---
layout: page
title: Reporting
header: Reporting
group: navigation
---
{% include JB/setup %}


## Summary

The Mediana R package uses the [ReporteRs R package](http://davidgohel.github.io/ReporteRs/) package to generate a Microsoft Word-based report that summarizes the results of Clinical Scenario Evaluation-based simulations. 

The user can easily customize this simulation report by adding a description of the project as well as labels to each scenario, including data scenarios (sample size, outcome distribution parameters, design parameters) and analysis scenarios (multiplicity adjustment). The user can also customize the report's structure, e.g., create sections and subsections within the report and specify how the rows will be sorted within each table.

In order to customize the report, the user has to use a `PresentationModel` object described below.

Once a `PresentationModel` object has been defined, the `GenerateReport` function can be called to generate a Clinical Scenario Evaluation report.

## Initialization

A presentation model can be initialized using the following command
{% highlight R %}
# PresentationModel initialization
presentation.model = PresentationModel()
{% endhighlight %}

Initialization with this command is highly recommended as it will simplify the process of adding related objects, e.g., the `Project`, `Section`, `Subsection`, `Table`, `CustomLabel` objects. 

## Specific objects

Once the `PresentationModel` object has been initialized, specific objects can be added by simply using the '+' operator as in data, analysis and evaluation models.

### `Project` object

#### Description

This object specifies a description of the project. The `Project` object is defined by three optional arguments:

- `username` defines the username to be included in the report (by default, the username is "[Unknown User]").

- `title` defines the project's in the report (the default value is "[Unknown title]").

- `description` defines the project's description (the default value is "[No description]").

This information will be added in the report generated using the `GenerateReport` function. 

A single object of the `Project` class can be added to an object of the `PresentationModel` class.

#### Examples

A simple `Project` object can be created as follows: 

{% highlight R %}
Project(username = "Gautier Paux",
        title = "Case study 1",
        description = "Clinical trial in patients with pulmonary arterial hypertension")
{% endhighlight %}

### `Section` object

#### Description

This object specifies the sections that will be created within the simulation report. A `Section` object is defined by a single argument:

- `by` defines the rules for setting up sections.

The `by` argument can contain several parameters from the following list:

- `sample.size`: a separate section will be created for each sample size.

- `event`: a separate section will be created for each event count.

- `outcome.parameter`: a separate section will be created for each outcome parameter scenario.

- `design.parameter`: a separate section will be created for each design parameter scenario.

- `multiplicity.adjustment`: a separate section will be created for each multiplicity adjustment scenario.
 
Note that, if a parameter is defined in the `by` argument, it must be defined only in this object (i.e., neither in the `Subection` object nor in the `Table` object).

A single object of the `Section` class can be added to an object of the `PresentationModel` class.

#### Examples

A `Section` object can be defined as follows: 

Create a separate section within the report for each outcome parameter scenario:

{% highlight R %}
Section(by = "outcome.parameter") 
{% endhighlight %}

Create a separate section for each unique combination of the sample size and outcome parameter scenarios:

{% highlight R %}
Section(by = c("sample.size", "outcome.parameter"))
{% endhighlight %}

### `Subsection` object

#### Description

This object specifies the rules for creating subsections within the simulation report. A `Subsection` object is defined by a single argument:

- `by` defines the rules for creating subsections.

The `by` argument can contain several parameters from the following list:

- `sample.size`: a separate subsection will be created for each sample size.

- `event`: a separate subsection will be created for each number of events.

- `outcome.parameter`: a separate subsection will be created for each outcome parameter scenario.

- `design.parameter`: a separate subsection will be created for each design parameter scenario.

- `multiplicity.adjustment`: a separate subsection will be created for each multiplicity adjustment scenario.

As before, if a parameter is defined in the `by` argument, it must be defined only in this object (i.e., neither in the `Section` object nor in the `Table` object).

A single object of the `Subsection` class can be added to an object of the `PresentationModel` class. 
#### Examples

`Subsection` objects can be set up as follows: 

Create a separate subsection for each sample size scenario:

{% highlight R %}
Subsection(by = "sample.size") 
{% endhighlight %}

Create a separate subsection for each unique combination of the sample size and outcome parameter scenarios:

{% highlight R %}
Subsection(by = c("sample.size", "outcome.parameter"))
{% endhighlight %}

### `Table` object

#### Description

This object specifies how the summary tables will be sorted within the report. A `Table` object is defined by a single argument:

- `by` defines how the tables of the report will be sorted.

The `by` argument can contain several parameters, the value must be contain in the following list:

- `sample.size`: the tables will be sorted by the sample size.

- `event`: the tables will be sorted by the number of events.

- `outcome.parameter`: the tables will be sorted by the outcome parameter scenario.

- `design.parameter`: the tables will be sorted by the design parameter scenario.

- `multiplicity.adjustment`: the tables will be sorted by the multiplicity adjustment scenario.

If a parameter is defined in the `by` argument it must be defined only in this object (i.e., neither in the `Section` object nor in the `Subsection` object).

A single object of class `Table` can be added to an object of class `PresentationModel`.

#### Examples

Examples of `Table` objects: 

Create a summary table sorted by sample size scenarios:

{% highlight R %}
Table(by = "sample.size") 
{% endhighlight %}

Create a summary table sorted by sample size and outcome parameter scenarios:

{% highlight R %}
Table(by = c("sample.size", "outcome.parameter"))
{% endhighlight %}

### `CustomLabel` object

#### Description

This object specifies the labels that will be assigned to sets of parameter values or simulation scenarios. These labels will be used in the section and subsection titles of the Clinical Scenario Evaluation Report as well as in the summary tables. A `CustomLabel` object is defined by two arguments:

- `param` defines a parameter (scenario) to which the current set of labels will be assigned.

- `label` defines the label(s) to assign to each value of the parameter.

The `param` argument can contain several parameters from the following list:

- `sample.size`:  labels will be applied to sample size values.

- `event`:  labels will be applied to number of events values.

- `outcome.parameter`:  labels will be applied to outcome parameter scenarios.

- `design.parameter`:  labels will be applied to design parameter scenarios.

- `multiplicity.adjustment`:  labels will be applied to multiplicity adjustment scenarios.

Several objects of the `CustomLabel` class can be added to an object of the `PresentationModel` class.

#### Examples

Examples of `CustomLabel` objects: 

Assign a custom label to the sample size values:

{% highlight R %}
CustomLabel(param = "sample.size",
            label= paste0("N = ",c(50, 55, 60, 65, 70)))
{% endhighlight %}

Assign a custom label to the outcome parameter scenarios:

{% highlight R %}
CustomLabel(param = "outcome.parameter", 
            label=c("Pessimistic", "Expected", "Optimistic"))
{% endhighlight %}

## `GenerateReport` function

### Description

The Clinical Scenario Evaluation Report is generated using the `GenerateReport` function. This function has four arguments:

- `presentation.model` defines a `PresentationModel` object.

- `cse.result` defines a `CSE` object returned by the CSE function.

- `report.filename` defines the filename of the Word-based report generated by this function.

- `report.template` defines a Word-based template (it is an optional argument).

The `GenerateReport` function requires the [ReporteRs R package](http://davidgohel.github.io/ReporteRs/) package to generate a Word-based simulation report. Optionally, a custom template can be selected by defining `report.template`, this argument specifies the name of a Word document located in the working directory.

The Word-based simulation report is structured as follows:

1. GENERAL INFORMATION
	1. PROJECT INFORMATION
	2. SIMULATION PARAMETERS 
1. DATA MODEL
	1. DESIGN (if a `Design` object has been defined)
	2. SAMPLE SIZE (or EVENT if an `Event` object has been defined)
	2. OUTCOME DISTRIBUTION
	3. DESIGN
1. ANALYSIS MODEL
	1. TESTS
	2. MULTIPLICITY ADJUSTMENT
1. RESULTS
	1. SECTION (if a `Section` object has been defined)
		1. SUBSECTION (if a `Subsection` object has been defined)
		2. ...
	1. ...

### Examples

This example illustrates the use of the `GenerateReport` function: 

{% highlight R %}
# Define a presentation model
case.study1.presentation.model = PresentationModel() +
  Section(by = "outcome.parameter") +
  Table(by = "sample.size") +
  CustomLabel(param = "sample.size",
              label= paste0("N = ",c(50, 55, 60, 65, 70))) +
  CustomLabel(param = "outcome.parameter",
              label=c("Standard 1", "Standard 2"))

# Report Generation
GenerateReport(presentation.model = case.study1.presentation.model,
               cse.results = case.study1.results,
               report.filename = "Case study 1 (normally distributed endpoint).docx")
{% endhighlight %}

Click on the icon to download an example of the Clinical Scenario Evaluation report:

<center>
  <div class="col-md-12">
    <a href="Case study 1 (normally distributed endpoint).docx" class="img-responsive">
      <img src="Logo_Microsoft_Word.png" class="img-responsive" height="100">
    </a>
  </div>
</center>