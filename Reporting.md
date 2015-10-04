---
layout: page
title: Reporting
header: Reporting
group: navigation
---
{% include JB/setup %}


## About

The Mediana R package uses the [ReporteRs R package](http://davidgohel.github.io/ReporteRs/) to generate a Word-based report of the Clinical Scenario Evaluation. 

The user has the possibility to custom his report, by adding a description of the project as well as labels to each scenario, i.e. data scenarios (sample size, outcome distribution parameters, design parameters) and analysis scenarios (multipliticy adjustment). The user can also customize how the report will create sections, subsections and how the table are sorted out.

In order to customize the report, the user have to use a `PresentationModel` object described below.

Once a `PresentationModel` object has been defined, the function `GenerateReport` can be used to generate the Clinical Scenario Evaluation Report.

## Initialization

A presentation model can be initialized using the following command
{% highlight R %}
# PresentationModel initialization
presentation.model = PresentationModel()
{% endhighlight %}

Initialization with this command is higlhy recommended as it will simplify the add of related objects, such as 
`Project`, `Section`, `Subsection`, `Table`, `CustomLabel` objects. 


## Specific objects

Once a `PresentationModel` object has been initialized, specific objects can be added by using the '+' operator to add objects to it.

### Project

#### Description

Specify a description of the project. A `Project` object is defined by three optional arguments:

- `username`, which defines the username to be printed in the report (by default "[Unknown User]").

- `title`, which defines the title of the project to be printed in the report (by default "[Unknown title]").

- `description`, which defines the description of the project to be printed in the report (by default "[No description]").

This information will be added in the report generated using the `GenerateReport` function. 

A single object of class `Project` can be added to an object of class `PresentationModel`.

#### Examples
Example of `Project` object: 

{% highlight R %}
Project(username = "Gautier Paux",
        title = "Case study 1",
        description = "Clinical trial in patients with pulmonary arterial hypertension")
{% endhighlight %}

### Section

#### Description

Specify how the sections of the report will be created. A `Section` object is defined by a single argument:

- `by`, which defines how the sections of the report will be created.

The `by` argument can contain several parameters, the value must be contained in the following list:

- `sample.size`: a section will be created for each sample size.

- `event`: a section will be created for each number of events.

- `outcome.parameter`: a section will be created for each outcome parameter scenario.

- `design.parameter`: a section will be created for each design parameter scenario.

- `multiplicity.adjustment`: a section will be created for multiplicity adjustment scenario.
- 
If a parameter is defined in the `by` argument it must be defined only in this object (i.e. neither in the `Subection` object nor in the `Table` object).

A single object of class `Section` can be added to an object of class `PresentationModel`.

#### Examples
Example of `Section` object: 

- Section by outcome parameter scenario

{% highlight R %}
Section(by = "outcome.parameter") 
{% endhighlight %}

- Section by sample size and outcome parameter scenario

{% highlight R %}
Section(by = c("sample.size", "outcome.parameter"))
{% endhighlight %}

### Subsection

#### Description

Specify how the subsections of the report will be created. A `Subsection` object is defined by a single argument:

- `by`, which defines how the subsections of the report will be created.

The `by` argument can contain several parameters, the value must be contain in the following list:

- `sample.size`: a subsection will be created for each sample size.

- `event`: a subsection will be created for each number of events.

- `outcome.parameter`: a subsection will be created for each outcome parameter scenario.

- `design.parameter`: a subsection will be created for each design parameter scenario.

- `multiplicity.adjustment`: a subsection will be created for multiplicity adjustment scenario.

If a parameter is defined in the `by` argument it must be defined only in this object (i.e. neither in the `Section` object nor in the `Table` object).

A single object of class `Subsection` can be added to an object of class `PresentationModel`.

#### Examples
Example of `Subsection` object: 

- Subsection by sample size

{% highlight R %}
Subsection(by = "sample.size") 
{% endhighlight %}

- Subsection by sample size and outcome parameter scenario

{% highlight R %}
Subsection(by = c("sample.size", "outcome.parameter"))
{% endhighlight %}

### Table

#### Description

Specify how the summary of results tables of the report will be sorted. A `Table` object is defined by a single argument:

- `by`, which defines how the tables of the report will be sorted.

The `by` argument can contain several parameters, the value must be contain in the following list:

- `sample.size`: the tables will be sorted by sample size.

- `event`: the tables will be sorted by number of events.

- `outcome.parameter`: the tables will be sorted by outcome parameter scenario.

- `design.parameter`: the tables will be sorted by design parameter scenario.

- `multiplicity.adjustment`: the tables will be sorted by multiplicity adjustment scenario.

If a parameter is defined in the `by` argument it must be defined only in this object (i.e. neither in the `Section` object nor in the `Subsection` object).

A single object of class `Table` can be added to an object of class `PresentationModel`.

#### Examples
Example of `Table` object: 

- Table sorted by sample size

{% highlight R %}
Table(by = "sample.size") 
{% endhighlight %}

- Table by sample size and outcome parameter scenario

{% highlight R %}
Table(by = c("sample.size", "outcome.parameter"))
{% endhighlight %}
### CustomLabel

#### Description
Specify the labels that will be assigned to the parameter. These labels will be used in the section and subsection title of the Clinical Scenario Evaluation Report, as well as in the summary of results tables. A `CustomLabel` object is defined by two arguments:

- `param`, which defines  a parameter for which the labels will be assigned.

- `label`, which defines the label(s) to assign to each value of the parameter.

The `param` argument can contain several parameters, the value must be contain in the following list:

- `sample.size`: the labels will be applied to the sample size values.

- `event`: the labels will be applied to the number of events values.

- `outcome.parameter`: the labels will be applied to the outcome parameter scenario.

- `design.parameter`: the labels will be applied to the design parameter scenario.

- `multiplicity.adjustment`: the labels will be applied to the multiplicity adjustment scenario.

Several objects of class `CustomLabel` can be added to an object of class `PresentationModel`.

#### Examples
Example of `CustomLabel` object: 

- Custom label for the sample size parameter

{% highlight R %}
CustomLabel(param = "sample.size",
            label= paste0("N = ",c(50, 55, 60, 65, 70)))
{% endhighlight %}

- Custom label for the outcome parameter scenario

{% highlight R %}
CustomLabel(param = "outcome.parameter", 
            label=c("Pessimiste", "Expected", "Optimist"))
{% endhighlight %}

## GenerateReport function

### Description

The Clinical Scenario Evaluation Report is generated using the `GenerateReport`function. This function has four arguments:

- `presentation.model`, which defines a `PresentationModel` object.

- `cse.result`, which defines a `CSE` object returned by the CSE function..

- `report.filename`, which defines the output filename of the word-based document generated.

- `report.template`, defines a word-based template (optional).

This function requires the package [ReporteRs R package](http://davidgohel.github.io/ReporteRs/) to generate the Word-based report of the Clinical Scenario Evaluation. A customized template can be specified in the argument `report.template` (optional), which consists in a Word document to place in the working directory folder.

The Word-based report of the Clinical Scenario Evaluation is structured as follows:

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
Example of `GenerateReport` function: 

{% highlight R %}
# Reporting
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

An example of Clinical Scenario Evaluation Report can be dowloaded [here](Case study 1 (normally distributed endpoint).docx).