---
layout: page
title: Adjusted p-values and one-sided simultaneous confidence limits 
header: Adjusted p-values
group: navigation
---
{% include JB/setup %}

## `AdjustPvalues` function

The `AdjustPvalues` function can be used to get adjusted *p*-values for commonly used multiple testing procedures based on univariate p-values (Bonferroni, Holm, Hommel, Hochberg, fixed-sequence procedures), commonly used parametric multiple testing procedures (single-step and step-down Dunnett procedures) and multistage gatepeeking procedure.

### Description

#### Inputs

The `AdjustPvalues` function requires the input of two pre-specified objects defined in the following two arguments:

- `pval` defines the raw *p*-values.

- `proc` defines the multiple testing procedure. Several procedures are already implemented in the Mediana package (listed below, along with the required or optional parameters to specify in the par argument):
	- `BonferroniAdj`: Bonferroni procedure. Optional parameter: `weight`.
	- `HolmAdj`: Holm procedure. Optional parameter: `weight`.
	- `HochbergAdj`: Hochberg procedure. Optional parameter: `weight`.
	- `HommelAdj`: Hommel procedure. Optional parameter: `weight`.
	- `FixedSeqAdj`: Fixed-sequence procedure.
	- `FallbackAdj`: **Fallback** procedure. Required parameters: `weight`.
	- `DunnettAdj`: Single-step Dunnett procedure. Required parameters: `n`.
	- `StepDownDunnettAdj`: Step-down Dunnett procedure. Required parameters: `n`.
	- `ChainAdj`: Family of chain procedures. Required parameters: `weight` and `transition`.
	- `NormalParamAdj`: Parametric multiple testing procedure derived from a multivariate normal distribution. Required parameter: `corr`. Optional parameter: `weight`.
	- `ParallelGatekeepingAdj`: Family of parallel gatekeeping procedures. Required parameters: `family`, `proc`, `gamma`.
	- `MultipleSequenceGatekeepingAdj`: Family of multiple-sequence gatekeeping procedures. Required parameters: `family`, `proc`, `gamma`.
	- `MixtureGatekeepingAdj`: Family of mixture-based gatekeeping procedures. Required parameters: `family`, `proc`, `gamma`, `serial`, `parallel`.

- `par` defines the parameters associated to the multiple testing procedure.

#### Outputs

The `AdjustPvalues` function returns a vector of adjusted *p*-values.

### Example

The following example illustrates the use of the `AdjustedPvalues` function to get adjusted *p*-values for traditional nonparametric, semi-parametric and parametric procedures, as well as more complex multiple testing procedures.

#### Traditional nonparametric and semiparametric procedures

For the illustration of adjustedment of raw *p*-values with the traditional nonparametric and semiparametric procedures, we will consider the following three raw *p*-values:

{% highlight R %}
rawp = c(0.012, 0.009, 0.023)                    
{% endhighlight %}

These *p*-values will be adjusted with several multiple testing procedures as specified below:

{% highlight R %}
# Bonferroni, Holm, Hochberg, Hommel and Fixed-sequence procedure
proc = c("BonferroniAdj", "HolmAdj", "HochbergAdj", "HommelAdj", "FixedSeqAdj")
{% endhighlight %}

In order to obtain the adjusted *p*-values for all these procedures, the `sapply` function can be used as follows. Note that as no `weight` parameter is defined, the equally weighted procedures are used to adjust the *p*-values. Finally, for the fixed-sequence procedure (`FixedSeqAdj`), the order of the testing sequence is based on the order of the *p*-values in the vector.

{% highlight R %}
# Equally weighted
sapply(proc, function(x) {AdjustPvalues(rawp,
                                        proc = x)})
{% endhighlight %}

The output is as follows:
{% highlight R %}
     BonferroniAdj HolmAdj HochbergAdj HommelAdj FixedSeqAdj
[1,]         0.036   0.027       0.023     0.023       0.012
[2,]         0.027   0.027       0.023     0.018       0.012
[3,]         0.069   0.027       0.023     0.023       0.023
{% endhighlight %}

In order to specify unequal weights for the three raw *p*-values, the `weight` parameter can be defined as follows. Note that this parameter has no effect on the adjustment with the fixed-sequence procedure.

{% highlight R %}
# Unequally weighted (no effect on the fixed-sequence procedure)
sapply(proc, function(x) {AdjustPvalues(rawp,
                                        proc = x,
                                        par = parameters(weight = c(1/2, 1/4, 1/4)))})
{% endhighlight %}

The output is as follows:
{% highlight R %}
     BonferroniAdj HolmAdj HochbergAdj HommelAdj FixedSeqAdj
[1,]         0.024   0.024       0.018     0.018       0.012
[2,]         0.036   0.024       0.018     0.018       0.012
[3,]         0.092   0.024       0.023     0.023       0.023
{% endhighlight %}

#### Traditional parametric procedures

Consider a clinical trials comparing three doses with a Placebo based on a normally distributed endpoints. Let H1, H2 and H3 be the three null hypotheses of no effect tested in the trial: 

- H1: No difference between Dose 1 and Placebo

- H2: No difference between Dose 2 and Placebo

- H3: No difference between Dose 3 and Placebo

The treatment effect estimates, corresponding to the mean dose-placebo difference are specified below, as well as the pooled standard deviation, the sample size, the standard errors and the *T*-statistics associated with the three dose-placebo tests
{% highlight R %}
# Treatment effect estimates (mean  dose-placebo differences)
est = c(2.3,2.5,1.9)

# Pooled standard deviation
sd = 9.5

# Study design is balanced with 180 patients per treatment arm
n = 180

# Standard errors
stderror = rep(sd*sqrt(2/n),3)

# T-statistics associated with the three dose-placebo tests
stat = est/stderror
{% endhighlight %}

Based on the *T*-statistics, the raw *p*-values can be easily obtained:
{% highlight R %}
# One-sided pvalue
rawp = 1-pt(stat,2*(n-1))
{% endhighlight %}

The adjusted *p*-values based on the single step Dunnett and step-down Dunnett procedures are obtained as follows.
{% highlight R %}
# Adjusted p-values based on the Dunnett procedures
# (assuming that each test statistic follows a t distribution)
AdjustPvalues(rawp,proc = "DunnettAdj", par = parameters(n = n))
AdjustPvalues(rawp,proc = "StepDownDunnettAdj", par = parameters(n = n))
{% endhighlight %}

The outputs are presented below.
{% highlight R %}
> AdjustPvalues(rawp,proc = "DunnettAdj",par = parameters(n = n))
[1] 0.02887019 0.01722656 0.07213393
> AdjustPvalues(rawp,proc = "StepDownDunnettAdj",par = parameters(n = n))
[1] 0.02043820 0.01722544 0.02909082
{% endhighlight %}

#### Gatekeeping procedures

For illustration, we will consider a clinical trial with two families of null hypotheses. The first family contains the null hypotheses associated with the Endpoints 1 and 2, that are considered as primary endpoints, and the second family the null hypotheses associated with the Endpoints 3 and 4 (key secondary endpoints). The null hypotheses of the secondary family will be tested if and only if at least one null hypothesis from the first family is rejected. Let H1, H2, H3 and H4 be the four null hypotheses of no effect on Endpoint 1, 2, 3 and 4 respectively tested in the trial: 

- H1: No difference between Drug and Placebo on Endpoint 1 (Family 1)

- H2: No difference between Drug and Placebo on Endpoint 2 (Family 1)

- H3: No difference between Drug and Placebo on Endpoint 3 (Family 2)

- H4: No difference between Drug and Placebo on Endpoint 4 (Family 2)

The raw *p*-values are specified below:
{% highlight R %}
# One-sided raw p-values (associated respectively with H1, H2, H3 and H4)
rawp<-c(0.0082, 0.0174, 0.0042, 0.0180)
{% endhighlight %}

The parameters of the parallel gatekeeping procedure are specified using the three arguments `family` which specifies the hypotheses included in each family, `proc` which specifies the component procedure associated with each family and `gamma` which specifies the truncation parameter of each family.

{% highlight R %}
# Define hypothesis included in each family (index of the raw p-value vector)
family = families(family1 = c(1, 2),
                  family2 = c(3, 4))

# Define component procedure of each family
component.procedure = families(family1 ="HolmAdj",
                               family2 = "HolmAdj")

# Truncation parameter of each family
gamma = families(family1 = 0.5,
                 family2 = 1)
{% endhighlight %}

The adjusted *p*-values are obtained using the `AdjustedPvalues` function as specified below:
{% highlight R %}
AdjustPvalues(rawp,
                        proc = "ParallelGatekeepingAdj",
                        par = parameters(family = family,
                                         proc = component.procedure,
                                         gamma = gamma))

[1] 0.0164 0.0232 0.0232 0.0232
{% endhighlight %}

## `AdjustCIs` function

The `AdjustCIs` function can be used to get simultaneous confidence intervals for selected multiple testing procedures based on univariate p-values (Bonferroni, Holm and fixed-sequence procedures) and commonly used parametric multiple testing procedures (single-step and step-down Dunnett procedures).

### Description

#### Inputs

The `AdjustPvalues` function requires the input of two pre-specified objects defined in the following two arguments:

- `est` defines the point estimates.

- `proc` defines the multiple testing procedure. Several procedures are already implemented in the Mediana package (listed below, along with the required or optional parameters to specify in the par argument):
	- `BonferroniAdj`: Bonferroni procedure. Required parameters: `n`, `sd` and `covprob`. Optional parameter: `weight`.
	- `HolmAdj`: Holm procedure. Required parameters: `n`, `sd` and `covprob`. Optional parameter: `weight`.
	- `FixedSeqAdj`: Fixed-sequence procedure. Required parameters: `n`, `sd` and `covprob`.
	- `DunnettAdj`: Single-step Dunnett procedure. Required parameters: `n`, `sd` and `covprob`.
	- `StepDownDunnettAdj`: Step-down Dunnett procedure. Required parameters: `n`, `sd` and `covprob`.

- `par` defines the parameters associated to the multiple testing procedure.

#### Outputs

The `AdjustCIs` function returns a vector lower simultaneous confidence limits.

### Example

Consider a clinical trials comparing three doses with a Placebo based on a normally distributed endpoints. Let H1, H2 and H3 be the three null hypotheses of no effect tested in the trial: 

- H1: No difference between Dose 1 and Placebo

- H2: No difference between Dose 2 and Placebo

- H3: No difference between Dose 3 and Placebo

The treatment effect estimates, corresponding to the mean dose-placebo difference are specified below, as well as the pooled standard deviation, the sample size.
{% highlight R %}
# Null hypotheses of no treatment effect are equally weighted
weight<-c(1/3,1/3,1/3)

# Treatment effect estimates (mean  dose-placebo differences)
est = c(2.3,2.5,1.9)

# Pooled standard deviation
sd = 9.5

# Study design is balanced with 180 patients per treatment arm
n = 180
{% endhighlight %}

The one-sided simultaneous confidence limits for several multiple testing procedures are obtained using the `AdjustCIs` function wrapped in a `sapply` function.

{% highlight R %}
# Bonferroni, Holm, Hochberg, Hommel and Fixed-sequence procedure
proc = c("BonferroniAdj", "HolmAdj", "FixedSeqAdj", "DunnettAdj", "StepDownDunnettAdj")

# Equally weighted
sapply(proc, function(x) {AdjustCIs(est,
                                    proc = x,
                                    par = parameters(sd = sd,
                                                     n = n,
                                                     covprob = 0.975,
                                                     weight = weight))})
{% endhighlight %}

The output obtained is presented below:
{% highlight R %}
     BonferroniAdj     HolmAdj FixedSeqAdj  DunnettAdj StepDownDunnettAdj
[1,]   -0.09730247  0.00000000  0.00000000 -0.05714354         0.00000000
[2,]    0.10269753  0.00000000  0.00000000  0.14285646         0.00000000
[3,]   -0.49730247 -0.06268427 -0.06268427 -0.45714354        -0.06934203
{% endhighlight %}