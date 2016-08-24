# Mediana

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/Mediana)](http://cran.r-project.org/package=Mediana)

Mediana is an R package which provides a general framework for clinical trial simulations based on the Clinical Scenario Evaluation approach. The package supports a broad class of data models (including clinical trials with continuous, binary, survival-type and count-type endpoints as well as multivariate outcomes that are based on combinations of different endpoints), analysis strategies and commonly used evaluation criteria.

Find out more at [http://gpaux.github.io/Mediana/](http://gpaux.github.io/Mediana/) and check out the case studies.

# Installation

Get the released version from CRAN:

```R
install.packages("Mediana")
```

Or the development version from github:

```R
# install.packages("devtools")
devtools::install_github("gpaux/Mediana")
```

When installing Mediana package, an error could occur if a java version >= 1.6 is not installed. Java is used in the ReporteRs R package which is required in the Mediana R package to [generate Word report](Reporting.html). 

`system("java -version")` should return java version ‘1.6.0’ or greater.

In order to ensure a proper installation, it is highly recommended to install the latest version of Java in the same architecture of R (32-bit or 64-bit). 

The latest version can be found at [https://www.java.com/en/download/manual.jsp](https://www.java.com/en/download/manual.jsp).


# Online Manual

A detailed online manual is accessible at [http://gpaux.github.io/Mediana/](http://gpaux.github.io/Mediana/)

