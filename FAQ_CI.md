---
layout: page
title: How to compute confidence interval around power?
header: How to compute confidence interval around power?
group: navigation
---
{% include JB/setup %}


## Summary

The Mediana R package use simulation-based method to estimate statistical power. It is then possible to compute a confidence interval around the estimated power. 

A simple example will be used to illustrate how to compute the confidence interval. We will consider the case study used in the [FAQ page](FAQ_CI.html) presenting how to calculate the required sample size. Please refer to the case study before reading what follows.

## Simulation results

To facilitate the review of the simulation results produced by the `CSE` function in this case study, the estimated power are presented in the following table.

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>Sample size scenario</th>
                <th>Sample size per arm</th>
                <th>Marginal power (%)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>55</td>
                <td>84.7</td>
            </tr>
    
            <tr>
                <td>2</td>
                <td>60</td>
                <td>87.7</td>
            </tr>
            <tr>
                <td>3</td>
                <td>65</td>
                <td>90.0</td>
            </tr>
            <tr>
                <td>4</td>
                <td>70</td>
                <td>92.1</td>
            </tr>
            <tr>
                <td>5</td>
                <td>75</td>
                <td>93.7</td>
            </tr>
        </tbody>
    </table>
</div>

## Confidence interval
The results presented above have been generated using 10,000 simulation runs. The estimated power is simply the result of estimating a proportion, therefore, the confidence interval can be approximate using the normal distribution as follows:

$$ \hat{p} \pm z_{\alpha} \sqrt{\frac{\hat{p}(1-\hat{p})}{n}}$$

where $\hat{p}$ is the estimated power, $z_{\alpha}$ the $1-\alpha/2$ quantile from the normal distribution and $n$ the number of simulation runs. 

The following function can be used to compute confidence interval associated with the simulation results returned by the `CSE` function.

{% highlight R %}
# Function: PowerConfidenceInterval
# Argument: CSE (object returned by the CSE function) and ci (level of the ci)
# Description: Compute binomial confidence interval based on normal approximation.
PowerConfidenceInterval = function(CSE, ci) {

  # Error check
  if (class(CSE) != "CSE") stop("PowerConfidenceInterval: a CSE object must be used in the CSE argument.")
  results = CSE$simulation.results
  n.sims = CSE$sim.parameters$n.sims

  if (ci <= 0 | ci >=1) stop("PowerConfidenceInterval: ci parameter must lies between 0 and 1.")

  q = qnorm(1-(1-ci)/2)
  power = results$result


  ci_l = pmax(0, round(power - q * sqrt(power* (1 - power) / n.sims), nchar(n.sims)))
  ci_u = pmin(1, round(power + q * sqrt(power* (1 - power) / n.sims), nchar(n.sims)))

  CSE$simulation.results = cbind(results,
                                 ci_l = ci_l,
                                 ci_u = ci_u)
  return(CSE)

}
# End of PowerConfidenceInterval

{% endhighlight %}

This function requires two arguments, the first one (`CSE`) is the object by the CSE function and the second one (`ci`) is the level of the confidence interval which must lies between 0 and 1.

The use of this function in the case study is presented below.

{% highlight R %}
# Compute 95% confidence interval
case.study1.results = PowerConfidenceInterval(CSE = case.study1.results,
                                              ci = 0.95)
summary(case.study1.results)
{% endhighlight %}

The summary results are presented below.

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>Sample size scenario</th>
                <th>Sample size per arm</th>
                <th>Marginal power (%)</th>
                <th>95% confidence interval (%)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>55</td>
                <td>84.7</td>
                <td>[83.95;85.37]</td>
            </tr>
    
            <tr>
                <td>2</td>
                <td>60</td>
                <td>87.7</td>
                <td>[87.09;88.37]</td>
            </tr>
            <tr>
                <td>3</td>
                <td>65</td>
                <td>90.0</td>
                <td>[89.47;90.65]</td>
                
            </tr>
            <tr>
                <td>4</td>
                <td>70</td>
                <td>92.1</td>
                <td>[91.52;92.58]</td>
            </tr>
            <tr>
                <td>5</td>
                <td>75</td>
                <td>93.7</td>
                <td>[93.18;94.14]</td>
            </tr>
        </tbody>
    </table>
</div>
## Download

Click on the icons below to download the R code used in this case study:

<center>
  <div class="col-md-6">
    <a href="FAQ_Case study CI.R" class="img-responsive">
      <img src="Logo_R.png" class="img-responsive" height="100">
    </a>
  </div>
</center>