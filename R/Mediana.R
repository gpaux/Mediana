######################################################################################################################
# FUNCTIONS USED BY THE PACKAGE BUT PRIVATE

######################################################################################################################

# Function: UniformDist.
# Argument: List of parameters (number of observations, maximum value).
# Description: This function is used to generate uniform outcomes.

UniformDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: UniformDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$max))
    stop("Data model: UniformDist distribution: Maximum value must be specified.")

  max.value = parameter[[2]]$max

  if (max.value <= 0)
    stop("Data model: UniformDist distribution: Maximum value must be positive.")

  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    # Error checks
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: UniformDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: UniformDist distribution: Number of observations must be positive.")

    result = stats::runif(n = n, max = max.value)
  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      result = list(list(max = "max"),list("Uniform"))
    }
  }
  return(result)

}
#End of UniformDist

######################################################################################################################

# Function: NormalDist.
# Argument: List of parameters (number of observations, list(mean, standard deviation)).
# Description: This function is used to generate normal outcomes.
NormalDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: NormalDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$mean))
    stop("Data model: NormalDist distribution: Mean must be specified.")

  if (is.null(parameter[[2]]$sd))
    stop("Data model: NormalDist distribution: SD must be specified.")

  mean = parameter[[2]]$mean
  sd = parameter[[2]]$sd

  if (sd <= 0)
    stop("Data model: NormalDist distribution: Standard deviations in the normal distribution must be positive.")

  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    # Error checks
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: NormalDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: NormalDist distribution: Number of observations must be positive.")

    result = stats::rnorm(n = n, mean = mean, sd = sd)

  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      result = list(list(mean = "mean", sd = "SD"),list("Normal"))
    }
  }
  return(result)
}
#End of NormalDist

######################################################################################################################

# Function: BinomDist .
# Argument: List of parameters (number of observations, proportion/probability of success).
# Description: This function is used to generate binomial outcomes (0/1).

BinomDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: BinomDist distribution: List of parameters must be provided.")


  if (is.null(parameter[[2]]$prop))
    stop("Data model: BinomDist distribution: Proportion must be specified.")


  prop = parameter[[2]]$prop


  if (prop < 0 | prop > 1)
    stop("Data model: BinomDist distribution: Proportion must be between 0 and 1.")


  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    # Error checks
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: BinomDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: BinomDist distribution: Number of observations must be positive.")


    result = stats::rbinom(n = n, size = 1, prob = prop)
  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      result = list(list(prop = "prop"),list("Binomial"))
    }
  }
  return(result)

}
#End of BinomDist

######################################################################################################################

# Function: ExpoDist.
# Argument: List of parameters (number of observations, rate).
# Description: This function is used to generate exponential outcomes.

ExpoDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: ExpoDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$rate))
    stop("Data model: ExpoDist distribution: Rate parameter must be specified.")

  rate = parameter[[2]]$rate

  # Parameters check
  if (rate <= 0) stop("Data model: ExpoDist distribution: Rate parameter must be positive")

  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: ExpoDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: ExpoDist distribution: Number of observations must be positive.")

    result = stats::rexp(n = n, rate = rate)
  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      result = list(list(rate = "rate"),list("Exponential"))
    }
  }
  return(result)
}
# End of ExpoDist

######################################################################################################################

# Function: MVNormalDist.
# Argument: List of parameters (number of observations, list(list (mean, SD), correlation matrix)).
# Description: This function is used to generate correlated multivariate normal outcomes.

MVNormalDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: MVNormalDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$par))
    stop("Data model: MVNormalDist distribution: Parameter list (means and SDs) must be specified.")

  if (is.null(parameter[[2]]$corr))
    stop("Data model: MVNormalDist distribution: Correlation matrix must be specified.")

  par = parameter[[2]]$par
  corr = parameter[[2]]$corr

  # Number of endpoints
  m = length(par)

  if (ncol(corr) != m)
    stop("Data model: MVNormalDist distribution: The size of the mean vector is different to the dimension of the correlation matrix.")
  if (sum(dim(corr) == c(m, m)) != 2)
    stop("Data model: MVNormalDist distribution: Correlation matrix is not correctly defined.")
  if (det(corr) <= 0)
    stop("Data model: MVNormalDist distribution: Correlation matrix must be positive definite.")
  if (any(corr < -1 | corr > 1))
    stop("Data model: MVNormalDist distribution: Correlation values must be between -1 and 1.")


  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")


  # Generate random variables
  if (call == FALSE) {
    # Error checks
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: MVNormalDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: MVNormalDist distribution: Number of observations must be positive.")


    # Generate multivariate normal variables
    multnorm = mvtnorm::rmvnorm(n = n, mean = rep(0, m), sigma = corr)
    # Store resulting multivariate variables
    mv = matrix(0, n, m)


    for (i in 1:m) {
      if (is.null(par[[i]]$mean))
        stop("Data model: MVNormalDist distribution: Mean must be specified.")
      if (is.null(par[[i]]$sd))
        stop("Data model: MVNormalDist distribution: SD must be specified.")

      mean = as.numeric(par[[i]]$mean)
      sd = as.numeric(par[[i]]$sd)

      if (sd <= 0)
        stop("Data model: MVNormalDist distribution: Standard deviations must be positive.")

      mv[, i] = mean + sd * multnorm[, i]
    }
    result = mv
  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      par.labels = list()
      for (i in 1:m) {
        par.labels[[i]] = list(mean = "mean", sd = "SD")
      }
      result = list(list(par = par.labels, corr = "corr"),list("Multivariate Normal"))
    }
  }
  return(result)
}
#End of MVNormalDist

######################################################################################################################

# Function: MVBinomDist .
# Argument: List of parameters (number of observations, list(list (prop), correlation matrix)).
# Description: This function is used to generate correlated multivariate binomial (0/1) outcomes.

MVBinomDist = function(parameter) {

  if (missing(parameter))
    stop("Data model: MVBinomDist distribution: List of parameters must be provided.")
  # Error checks
  if (is.null(parameter[[2]]$par))
    stop("Data model: MVBinomDist distribution: Parameter list (prop) must be specified.")
  if (is.null(parameter[[2]]$par))
    stop("Data model: MVBinomDist distribution: Correlation matrix must be specified.")

  par = parameter[[2]]$par
  corr = parameter[[2]]$corr

  # Number of endpoints
  m = length(par)

  if (ncol(corr) != m)
    stop("Data model: MVBinomDist distribution: The size of the proportion vector is different to the dimension of the correlation matrix.")
  if (sum(dim(corr) == c(m, m)) != 2)
    stop("Data model: MVBinomDist distribution: Correlation matrix is not correctly defined.")
  if (det(corr) <= 0)
    stop("Data model: MVBinomDist distribution: Correlation matrix must be positive definite.")
  if (any(corr < -1 | corr > 1))
    stop("Data model: MVBinomDist distribution: Correlation values must be comprised between -1 and 1.")


  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")


  # Generate random variables
  if (call == FALSE) {
    # Error checks
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: MVBinomDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: MVBinomDist distribution: Number of observations must be positive.")

    # Generate multivariate normal variables
    multnorm = mvtnorm::rmvnorm(n = n, mean = rep(0, m), sigma = corr)
    # Store resulting multivariate variables
    mvbinom = matrix(0, n, m)
    # Convert selected components to a uniform distribution and then to binomial distribution
    for (i in 1:m) {
      uniform = stats::pnorm(multnorm[, i])
      # Proportion
      if (is.null(par[[i]]$prop))
        stop("Data model: MVBinomDist distribution: Proportion must be specified.")

      prop = as.numeric(par[[i]]$prop)
      if (prop < 0 | prop > 1)
        stop("Data model: MVBinomDist distribution: proportion in the binomial distribution must be between 0 and 1.")

      mvbinom[, i] = (uniform <= prop)
    }
    result = mvbinom

  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      par.labels = list()
      for (i in 1:m) {
        par.labels[[i]] = list(prop = "prop")
      }
      result = list(list(par = par.labels, corr = "corr"),list("Multivariate Binomial"))
    }
  }
  return(result)
}
#End of MVBinomDist

######################################################################################################################

# Function: MVExpoDist.
# Argument: List of parameters (number of observations, list(list(rate), correlation matrix).
# Description: This function is used to generate correlated exponential outcomes.

MVExpoDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: MVExpoDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$par))
    stop("Data model: MVExpoDist distribution: Parameter list (rate) must be specified.")

  if (is.null(parameter[[2]]$corr))
    stop("Data model: MVExpoDist distribution: Correlation matrix must be specified.")

  par = parameter[[2]]$par
  corr = parameter[[2]]$corr


  # Number of endpoints
  m = length(par)


  if (ncol(corr) != m)
    stop("Data model: MVExpoDist distribution: The size of the hazard rate vector is different to the dimension of the correlation matrix.")
  if (sum(dim(corr) == c(m, m)) != 2)
    stop("Data model: MVExpoDist distribution: Correlation matrix is not correctly defined.")
  if (det(corr) <= 0)
    stop("Data model: MVExpoDist distribution: Correlation matrix must be positive definite.")
  if (any(corr < -1 | corr > 1))
    stop("Data model: MVExpoDist distribution: Correlation values must be comprised between -1 and 1.")


  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")


  # Generate random variables
  if (call == FALSE) {
    # Error checks
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: MVExpoDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: MVExpoDist distribution: Number of observations must be positive.")

    # Generate multivariate normal variables
    multnorm = mvtnorm::rmvnorm(n = n, mean = rep(0, m), sigma = corr)
    # Store resulting multivariate variables
    mvmixed = matrix(0, n, m)
    # Convert selected components to a uniform distribution and then to exponential distribution
    for (i in 1:m) {
      uniform = stats::pnorm(multnorm[, i])

      if (is.null(par[[i]]$rate))
        stop("Data model: MVExpoDist distribution: Hazard rate parameter in the exponential distribution must be specified.")

      # Hazard rate
      hazard = as.numeric(par[[i]]$rate)
      if (hazard <= 0)
        stop("Data model: MVExpoDist distribution: Hazard rate parameter in the exponential distribution must be positive.")
      mvmixed[, i] = -log(uniform)/hazard
    }
    result = mvmixed

  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      par.labels = list()
      for (i in 1:m) {
        par.labels[[i]] = list(rate = "rate")
      }
      result = list(list(par = par.labels, corr = "corr"),list("Multivariate Exponential"))
    }
  }
  return(result)
}
# End of MVExpoDist

######################################################################################################################

# Function: MVExpoPFSOSDist.
# Argument: List of parameters (number of observations, list(list(rate), correlation matrix).
# Description: This function is used to generate correlated exponential outcomes for PFS and OS.
#              Time of PFS cannot be greater than time of OS

MVExpoPFSOSDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: MVExpoPFSOSDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$par))
    stop("Data model: MVExpoPFSOSDist distribution: Parameter list (rate) must be specified.")

  if (is.null(parameter[[2]]$corr))
    stop("Data model: MVExpoPFSOSDist distribution: Correlation matrix must be specified.")

  par = parameter[[2]]$par
  corr = parameter[[2]]$corr


  # Number of endpoints
  m = length(par)
  if (m != 2)
    stop("Data model: MVExpoPFSOSDist distribution: Only PFS and OS must be defined (2 endpoints)")

  if (ncol(corr) != m)
    stop("Data model: MVExpoPFSOSDist distribution: The size of the hazard rate vector is different to the dimension of the correlation matrix.")
  if (sum(dim(corr) == c(m, m)) != 2)
    stop("Data model: MVExpoPFSOSDist distribution: Correlation matrix is not correctly defined.")
  if (det(corr) <= 0)
    stop("Data model: MVExpoPFSOSDist distribution: Correlation matrix must be positive definite.")
  if (any(corr < -1 | corr > 1))
    stop("Data model: MVExpoPFSOSDist distribution: Correlation values must be comprised between -1 and 1.")


  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")


  # Generate random variables
  if (call == FALSE) {
    # Error checks
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: MVExpoPFSOSDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: MVExpoPFSOSDist distribution: Number of observations must be positive.")

    # Generate multivariate normal variables
    multnorm = mvtnorm::rmvnorm(n = n, mean = rep(0, m), sigma = corr)
    # Store resulting multivariate variables
    mvmixed = matrix(0, n, m)
    # Convert selected components to a uniform distribution and then to exponential distribution
    for (i in 1:m) {
      uniform = stats::pnorm(multnorm[, i])

      if (is.null(par[[i]]$rate))
        stop("Data model: MVExpoPFSOSDist distribution: Hazard rate parameter in the exponential distribution must be specified.")

      # Hazard rate
      hazard = as.numeric(par[[i]]$rate)
      if (hazard <= 0)
        stop("Data model: MVExpoPFSOSDist distribution: Hazard rate parameter in the exponential distribution must be positive.")
      mvmixed[, i] = -log(uniform)/hazard
    }

    # if Time of PFS is greater than time of OS, in that case, time of PFS will be replaced by time of OS
    PFSsupOS = mvmixed[,1]>mvmixed[,2]
    mvmixed[PFSsupOS,1]=mvmixed[PFSsupOS,2]

    result = mvmixed

  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      par.labels = list()
      for (i in 1:m) {
        par.labels[[i]] = list(rate = "rate")
      }
      result = list(list(par = par.labels, corr = "corr"),list("Multivariate Exponential for PFS and OS"))
    }
  }
  return(result)
}
# End of MVExpoPFSOSDist


######################################################################################################################

# Function: MVMixedDist .
# Argument: List of parameters (number of observations, list(list (distribution type), list(distribution parameters) correlation matrix)).
# Description: This function is used to generate correlated normal, binary and exponential outcomes.

MVMixedDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: MVMixedDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$type))
    stop("Data model: MVMixedDist distribution: Distribution type must be specified.")

  if (is.null(parameter[[2]]$par))
    stop("Data model: MVMixedDist distribution: Parameters list must be specified.")

  if (is.null(parameter[[2]]$corr))
    stop("Data model: MVMixedDist distribution: Correlation matrix must be specified.")


  type = parameter[[2]]$type
  par = parameter[[2]]$par
  corr = parameter[[2]]$corr


  # Number of endpoints
  m = length(par)


  if (length(type) != m)
    stop("Data model: MVMixedDist distribution: Number of distribution type parameters must be equal to the number of endpoints.")
  for (i in 1:m) {
    if ((type[[i]] %in% c("NormalDist", "BinomDist", "ExpoDist")) == FALSE)
      stop("Data model: MVMixedDist distribution: MVMixedDist accepts only normal, binomial and exponential endpoints.")
  }
  if (ncol(corr) != m)
    stop("Data model: MVMixedDist distribution: The size of the outcome parameter is different to the dimension of the correlation matrix.")
  if (sum(dim(corr) == c(m, m)) != 2)
    stop("Data model: MVMixedDist distribution: Correlation matrix is not correctly defined.")
  if (det(corr) <= 0)
    stop("Data model: MVMixedDist distribution: Correlation matrix must be positive definite.")
  if (any(corr < -1 | corr > 1))
    stop("Data model: MVMixedDist distribution: Correlation values must be comprised between -1 and 1.")


  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")


  # Generate random variables
  if (call == FALSE) {
    # Error checks
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: MVMixedDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: MVMixedDist distribution: Number of observations must be positive.")

    # Generate multivariate normal variables
    multnorm = mvtnorm::rmvnorm(n = n, mean = rep(0, m), sigma = corr)

    # Store resulting multivariate variables
    mvmixed = matrix(0, n, m)

    # Convert selected components to a uniform distribution and then to either binomial or exponential distribution
    for (i in 1:m) {
      if (type[[i]] == "NormalDist") {
        if (is.null(par[[i]]$mean))
          stop("Data model: MVMixedDist distribution: Mean in the normal distribution must be specified.")
        if (is.null(par[[i]]$sd))
          stop("Data model: MVMixedDist distribution: SD in the normal distribution must be specified.")
        mean = as.numeric(par[[i]]$mean)
        sd = as.numeric(par[[i]]$sd)
        if (sd <= 0)
          stop("Data model: MVMixedDist distribution: SD in the normal distribution must be positive.")
        mvmixed[, i] = mean + sd * multnorm[, i]
      } else if (type[[i]] == "BinomDist") {
        uniform = stats::pnorm(multnorm[, i])
        # Proportion
        if (is.null(par[[i]]$prop))
          stop("Data model: MVMixedDist distribution: Proportion in the binomial distribution must be specified.")
        prop = as.numeric(par[[i]]$prop)
        if (prop < 0 | prop > 1)
          stop("Data model: MVMixedDist distribution: Proportion in the binomial distribution must be between 0 and 1.")
        mvmixed[, i] = (uniform <= prop)
      } else if (type[[i]] == "ExpoDist") {
        uniform = stats::pnorm(multnorm[, i])
        # Hazard rate
        if (is.null(par[[i]]$rate))
          stop("Data model: MVMixedDist distribution: Hazard rate in the exponential distribution must be specified.")
        hazard = as.numeric(par[[i]])
        if (hazard <= 0)
          stop("Data model: MVMixedDist distribution: Hazard rate parameter in the exponential distribution must be positive.")
        mvmixed[, i] = -log(uniform)/hazard
      }
    }
    result = mvmixed

  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      par.labels = list()
      outcome.name=""
      for (i in 1:m) {
        if (type[[i]] == "NormalDist")
        {
          par.labels[[i]] = list(mean = "mean", sd = "SD")
          outcome.name=paste0(outcome.name,", ","Normal")
        }
        if (type[[i]] == "BinomDist")
        {
          par.labels[[i]] = list(prop = "prop")
          outcome.name=paste0(outcome.name,", ","Binomial")
        }
        if (type[[i]] == "ExpoDist")
        {
          par.labels[[i]] = list(rate = "rate")
          outcome.name=paste0(outcome.name,", ","Exponential")
        }
      }
      result = list(list(type = "type", par = par.labels, corr = "corr"),list(paste0("Multivariate Mixed (", sub(", ","",outcome.name),")")))
    }
  }
  return(result)
}
# End of MVMixedDist

######################################################################################################################

# Function: PoissonDist .
# Argument: List of parameters (number of observations, mean).
# Description: This function is used to generate Poisson outcomes.

PoissonDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: PoissonDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$lambda))
    stop("Data model: PoissonDist distribution: Lambda must be specified.")

  lambda = parameter[[2]]$lambda

  # Parameters check
  if (lambda <= 0)
    stop("Data model: PoissonDist distribution: Lambda must be non-negative.")

  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: PoissonDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: PoissonDist distribution: Number of observations must be positive.")

    result = stats::rpois(n = n, lambda = lambda)
  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      result = list(list(lambda = "lambda"),list("Poisson"))
    }
  }
  return(result)

}
# End of PoissonDist

######################################################################################################################

# Function: NegBinomDist .
# Argument: List of parameters (number of observations, list(dispersion, mean)).
# Description: This function is used to generate negative-binomial outcomes.

NegBinomDist = function(parameter) {

  # Error checks
  if (missing(parameter))
    stop("Data model: NegBinomDist distribution: List of parameters must be provided.")

  if (is.null(parameter[[2]]$dispersion))
    stop("Data model: NegBinomDist distribution: Dispersion (size) must be specified.")

  if (is.null(parameter[[2]]$mean))
    stop("Data model: NegBinomDist distribution: Mean (mu) must be specified.")

  dispersion = parameter[[2]]$dispersion
  mean = parameter[[2]]$mean

  # Parameters check
  if (dispersion <= 0) {
    stop("Data model: NegBinomDist distribution: Dispersion parameter must be positive.")
  } else if (mean <= 0) {
    stop("Data model: NegBinomDist distribution: Mean must be positive.")
  }

  # Determine the function call, either to generate distribution or to return description
  call = (parameter[[1]] == "description")

  # Generate random variables
  if (call == FALSE) {
    n = parameter[[1]]
    if (n%%1 != 0)
      stop("Data model: NegBinomDist distribution: Number of observations must be an integer.")
    if (n <= 0)
      stop("Data model: NegBinomDist distribution: Number of observations must be positive.")

    result = stats::rnbinom(n = n, size = dispersion, mu = mean)
  } else {
    # Provide information about the distribution function
    if (call == TRUE) {
      # Labels of distributional parameters
      result = list(list(dispersion = "dispersion", mean = "mean"),list("Negative binomial"))
    }
  }
  return(result)
}
#End of NegBinomDist

######################################################################################################################

# Function: argmin.
# Argument: p, Vector of p-values (1 x m)
#           w, Vector of hypothesis weights (1 x m)
#           processed, Vector of binary indicators (1 x m) [1 if processed and 0 otherwise].
# Description: Hidden function used in the Chain function. Find the index of the smallest weighted p-value among the non-processed null hypotheses with a positive weight (index=0 if
# the smallest weighted p-value does not exist) in a chain procedure

argmin = function(p, w, processed) {

  index = 0
  m = length(p)
  for (i in 1:m) {
    if (w[i] > 0 & processed[i] == 0) {
      if (index == 0) {
        pmin = p[i]/w[i]
        index = i
      }
      if (index > 0 & p[i]/w[i] < pmin) {
        pmin = p[i]/w[i]
        index = i
      }
    }
  }
  return(index)
}
# End of argmin

######################################################################################################################

# Function: ChainAdj.
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m) matrix of transition parameters (m x m)
# Description: Chain multiple testing procedure.

ChainAdj = function(p, par) {

  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")

  if (any(call == FALSE) | any(is.na(call))) {
    # Number of p-values
    m = length(p)
    # Extract the vector of hypothesis weights (1 x m) and matrix of transition parameters (m x m)
    if (is.null(par[[2]]$weight)) stop("Analysis model: Chain procedure: Hypothesis weights must be specified.")
    if (is.null(par[[2]]$transition)) stop("Analysis model: Chain procedure: Transition matrix must be specified.")
    w = par[[2]]$weight
    g = par[[2]]$transition

    # Error checks
    if (sum(w)!=1) stop("Analysis model: Chain procedure: Hypothesis weights must add up to 1.")
    if (any(w<0)) stop("Analysis model: Chain procedure: Weights must be greater than 1.")
    if (sum(dim(g) == c(m, m)) != 2)
      stop("Analysis model: Chain procedure: The dimension of the transition matrix is not correct.")
    if (any(rowSums(g)>1))
      stop("Analysis model: Chain procedure: The sum of each row of the transition matrix must be lower than 1.")
    if (any(g < 0))
      stop("Analysis model: Chain procedure: The transition matrix must include only positive values.")

    pmax = 0


    # Index set of processed, eg, rejected, null hypotheses (no processed hypotheses at the beginning of the algorithm)
    processed = rep(0, m)


    # Adjusted p-values
    adjpvalue = rep(0, m)


    # Loop over all null hypotheses
    for (i in 1:m) {
      # Find the index of the smallest weighted p-value among the non-processed null hypotheses
      ind = argmin(p, w, processed)
      if (ind>0){
        adjpvalue[ind] = max(p[ind]/w[ind], pmax)
        adjpvalue[ind] = min(1, adjpvalue[ind])
        pmax = adjpvalue[ind]
        # This null hypothesis has been processed
        processed[ind] = 1


        # Update the hypothesis weights after a null hypothesis has been processed
        temp = w
        for (j in 1:m) {
          if (processed[j] == 0)
            w[j] = temp[j] + temp[ind] * g[ind, j] else w[j] = 0
        }


        # Update the transition parameters (connection weights) after the rejection
        temp = g
        for (j in 1:m) {
          for (k in 1:m) {
            if (processed[j] == 0 & processed[k] == 0 & j != k & temp[j, ind] * temp[ind, j] != 1)
              g[j, k] = (temp[j, k] + temp[j, ind] * temp[ind, k])/(1 - temp[j, ind] * temp[ind, j]) else g[j, k] = 0
          }
        }
      }
      else {
        adjpvalue[which(processed==0)]=1
      }
    }
    result = adjpvalue
  }
  else if (call == TRUE) {
    w = paste0("Weight={",paste(round(par[[2]]$weight, 3), collapse = ","),"}")
    g = paste0("Transition matrix={",paste(as.vector(t(par[[2]]$transition)), collapse = ","),"}")
    result=list(list("Chain procedure"),list(w,g))
  }



  return(result)
}
# End of ChainAdj

######################################################################################################################

# Function: BonferroniAdj.
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m)
# Description: Bonferroni multiple testing procedure.

BonferroniAdj = function(p, par) {

  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")


  # Number of p-values
  m = length(p)

  # Extract the vector of hypothesis weights (1 x m)
  if (!any(is.na(par[[2]]))) {
    if (is.null(par[[2]]$weight)) stop("Analysis model: Bonferroni procedure: Hypothesis weights must be specified.")
    w = par[[2]]$weight
  } else {
    w = rep(1/m, m)
  }

  # Error checks
  if (length(w) != m) stop("Analysis model: Bonferroni procedure: Length of the weight vector must be equal to the number of hypotheses.")
  if (sum(w)!=1) stop("Analysis model: Bonferroni procedure: Hypothesis weights must add up to 1.")
  if (any(w < 0)) stop("Analysis model: Bonferroni procedure: Hypothesis weights must be greater than 0.")

  if (any(call == FALSE) | any(is.na(call))) {
    # Adjusted p-values
    adjpvalue = pmin(1, p/w)
    result = adjpvalue
  }
  else if (call == TRUE) {
    weight = paste0("Weight={",paste(round(w,2), collapse = ","),"}")
    result=list(list("Bonferroni procedure"),list(weight))
  }


  return(result)
}
# End of BonferroniAdj

######################################################################################################################

# Function: BonferroniAdj.global.
# Argument: p, Vector of p-values (1 x m)
#           n, Total number of testable hypotheses (in the case of modified mixture procedure) (1 x 1)
#       gamma, Vector of truncation parameter (1 x 1)
# Description: Compute global p-value for the Bonferroni multiple testing procedure. The function returns the global adjusted pvalue (1 x 1)

BonferroniAdj.global = function(p, n, gamma) {

  # Number of p-values
  k = length(p)
  if (k > 0 & n > 0) {
    adjp = n * min(p)  # Bonferonni procedure
  } else adjp = 1
  return(adjp)
}
# End of BonferroniAdj.global

######################################################################################################################

# Function: HolmAdj.
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m)
# Description: Holm multiple testing procedure.

HolmAdj = function(p, par) {

  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")


  # Number of p-values
  m = length(p)

  # Extract the vector of hypothesis weights (1 x m)
  if (!any(is.na(par[[2]]))) {
    if (is.null(par[[2]]$weight)) stop("Analysis model: Holm procedure: Hypothesis weights must be specified.")
    w = par[[2]]$weight
  } else {
    w = rep(1/m, m)
  }

  if (any(call == FALSE) | any(is.na(call))) {
    # Error checks
    if (length(w) != m) stop("Analysis model: Holm procedure: Length of the weight vector must be equal to the number of hypotheses.")
    if (sum(w)!=1) stop("Analysis model: Holm procedure: Hypothesis weights must add up to 1.")
    if (any(w < 0)) stop("Analysis model: Holm procedure: Hypothesis weights must be greater than 0.")

    # Index of ordered pvalue
    ind <- order(p/w)


    # Adjusted p-values
    adjpvalue <- pmin(1, cummax(c(1 - cumsum(c(0, w[ind])))[1:m] * p[ind]/w[ind]), na.rm=TRUE)[order(ind)]
    result = adjpvalue
  }
  else if (call == TRUE) {
    weight = paste0("Weight={",paste(round(w,2), collapse = ","),"}")
    result=list(list("Holm procedure"),list(weight))
  }

  return(result)
}
# End of HolmAdj

######################################################################################################################

# Function: HolmAdj.global.
# Argument: p, Vector of p-values (1 x m)
#           n, Total number of testable hypotheses (in the case of modified mixture procedure) (1 x 1)
#       gamma, Vector of truncation parameter (1 x 1)
# Description: Compute global p-value for the truncated Holm multiple testing procedure. The function returns the global adjusted pvalue (1 x 1)

HolmAdj.global = function(p, n, gamma) {

  # Number of p-values
  k = length(p)
  if (k > 0 & n > 0) {
    if (gamma == 0)
    {
      adjp = n * min(p)
    }  # Bonferonni procedure
    else if (gamma <= 1) {
      # Truncated Holm procedure Index of ordered pvalue
      ind = order(p)
      # Denominator (1 x m)
      seq = seq_vector(k)
      denom = gamma/(k - seq + 1) + (1 - gamma)/n
      # Adjusted p-values
      sortp = sort(p)
      adjp = min(cummax(sortp/denom)[order(ind)])
    }
  } else adjp = 1

  return(adjp)

}
# End of HolmAdj.global

######################################################################################################################

# Function: HochbergAdj.
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m)
# Description: Hochberg multiple testing procedure.

HochbergAdj = function(p, par) {

  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")

  # Number of p-values
  m = length(p)

  # Extract the vector of hypothesis weights (1 x m)
  if (!any(is.na(par[[2]]))) {
    if (is.null(par[[2]]$weight)) stop("Analysis model: Hochberg procedure: Hypothesis weights must be specified.")
    w = par[[2]]$weight
  } else {
    w = rep(1/m, m)
  }

  if (any(call == FALSE) | any(is.na(call))) {
    # Error checks
    if (length(w) != m) stop("Analysis model: Hochberg procedure: Length of the weight vector must be equal to the number of hypotheses.")
    if (sum(w)!=1) stop("Analysis model: Hochberg procedure: Hypothesis weights must add up to 1.")
    if (any(w < 0)) stop("Analysis model: Hochberg procedure: Hypothesis weights must be greater than 0.")

    if (max(w) == min(w)){
      # Index of ordered pvalue
      ind <- order(p, decreasing = TRUE)

      # Adjusted p-values
      result <- pmin(1, cummin(cumsum(w[ind]) * p[ind]/w[ind]))[order(ind)]
    } else {

      # Compute the weighted incomplete Simes p-value for an intersection hypothesis
      incsimes<-function(p,u) {
        k<-length(u[u!=0 & !is.nan(u)])
        if (k>1) {
          temp=matrix(0,2,k)
          temp[1,]<-p[u!=0]
          temp[2,]<-u[u!=0]
          sort<-temp[,order(temp[1,])]
          modu<-u[u!=0]
          modu[1]<-0
          modu[2:k]<-sort[2,1:k-1]
          incsimes<-min((1-cumsum(modu))*sort[1,]/sort[2,])
        } else if (k==1)  {
          incsimes<-p[u!=0]/u[u!=0]
        } else if (k==0) incsimes<-1
        return(incsimes)
      }
      # End of incsimes

      # number of intersection
      nbint <- 2^m - 1

      # matrix of intersection hypotheses
      int <- matrix(0, nbint, m)
      for (i in 1:m) {
        for (j in 0:(nbint - 1)) {
          k <- floor(j/2^(m - i))
          if (k/2 == floor(k/2))
            int[j + 1, i] <- 1
        }
      }

      # matrix of local p-values
      int.pval <- matrix(0, nbint, m)

      # vector of weights for local test
      w.loc <- rep(0, m)

      # local p-values for intersection hypotheses
      for (i in 1:nbint) {
        w.loc <- w * int[i, ]/sum(w * int[i, ])
        int.pval[i, ] <- int[i, ] * incsimes(p, w.loc)
      }

      result <- apply(int.pval, 2, max)
    }
  }
  else if (call == TRUE) {
    weight = paste0("Weight={",paste(round(w,2), collapse = ","),"}")
    result=list(list("Hochberg procedure"),list(weight))
  }

  return(result)
}
# End of HochbergAdj


######################################################################################################################

# Function: HochbergAdj.global.
# Argument: p, Vector of p-values (1 x m)
#           n, Total number of testable hypotheses (in the case of modified mixture procedure) (1 x 1)
#       gamma, Vector of truncation parameter (1 x 1)
# Description: Compute global p-value for the truncated Hochberg multiple testing procedure. The function returns the global adjusted pvalue (1 x 1)

HochbergAdj.global = function(p, n, gamma) {

  # Number of p-values
  k = length(p)
  if (k > 0 & n > 0) {
    if (gamma == 0)
    {
      adjp = n * min(p)
    }  # Bonferonni procedure
    else if (gamma <= 1) {
      # Truncated Hochberg procedure Index of ordered pvalue
      ind = order(p, decreasing = TRUE)
      # Denominator (1 x m)
      seq = k:1
      denom = gamma/(k - seq + 1) + (1 - gamma)/n
      # Adjusted p-values
      sortp = sort(p, decreasing = TRUE)
      adjp = min(cummin(sortp/denom)[order(ind)])
    }
  } else adjp = 1

  return(adjp)

}
# End of HochbergAdj.global

######################################################################################################################

# Function: HommelAdj.
# Argument: p, Vector of p-values (1 x m)
#           par, List of procedure parameters: vector of hypothesis weights (1 x m)
# Description: Hommel multiple testing procedure (using the closed testing procedure).

HommelAdj = function(p, par) {

  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")


  # Number of p-values
  m = length(p)

  # Extract the vector of hypothesis weights (1 x m)
  if (!any(is.na(par[[2]]))) {
    if (is.null(par[[2]]$weight)) stop("Analysis model: Hommel procedure: Hypothesis weights must be specified.")
    w = par[[2]]$weight
  } else {
    w = rep(1/m, m)
  }

  if (any(call == FALSE) | any(is.na(call))) {
    # Error checks
    if (length(w) != m) stop("Analysis model: Hommel procedure: Length of the weight vector must be equal to the number of hypotheses.")
    if (sum(w)!=1) stop("Analysis model: Hommel procedure: Hypothesis weights must add up to 1.")
    if (any(w < 0)) stop("Analysis model: Hommel procedure: Hypothesis weights must be greater than 0.")

    # Weighted Simes p-value for intersection hypothesis
    simes <- function(p, w) {
      nb <- length(w[w != 0 & !is.nan(w)])
      if (nb > 1) {
        p.sort <- sort(p[w != 0])
        w.sort <- w[w != 0][order(p[w != 0])]
        simes <- min(p.sort/cumsum(w.sort))
      }
      else if (nb == 1)
        simes <- pmin(1, p/w)
      else if (nb == 0)
        simes <- 1
      return(simes)
    }

    # number of intersection
    nbint <- 2^m - 1

    # matrix of intersection hypotheses
    int <- matrix(0, nbint, m)
    for (i in 1:m) {
      for (j in 0:(nbint - 1)) {
        k <- floor(j/2^(m - i))
        if (k/2 == floor(k/2))
          int[j + 1, i] <- 1
      }
    }

    # matrix of local p-values
    int.pval <- matrix(0, nbint, m)

    # vector of weights for local test
    w.loc <- rep(0, m)

    # local p-values for intersection hypotheses
    for (i in 1:nbint) {
      w.loc <- w * int[i, ]/sum(w * int[i, ])
      int.pval[i, ] <- int[i, ] * simes(p, w.loc)
    }

    adjpvalue <- apply(int.pval, 2, max)
    result = adjpvalue
  }
  else if (call == TRUE) {
    weight = paste0("Weight={",paste(round(w,2), collapse = ","),"}")
    result=list(list("Hommel procedure"),list(weight))
  }

  return(result)
}
# End of HommelAdj

######################################################################################################################

# Function: HommelAdj.global.
# Argument: p, Vector of p-values (1 x m)
#           n, Total number of testable hypotheses (in the case of modified mixture procedure) (1 x 1)
#       gamma, Vector of truncation parameter (1 x 1)
# Description: Compute global p-value for the truncated Hommel multiple testing procedure. The function returns the global adjusted pvalue (1 x 1)

HommelAdj.global = function(p, n, gamma) {

  # Number of p-values
  k = length(p)
  if (k > 0 & n > 0) {
    if (gamma == 0)
    {
      adjp = n * min(p)
    }  # Bonferonni procedure
    else if (gamma <= 1) {
      # Truncated Hommel procedure
      seq = 1:k
      denom = seq * gamma/k + (1 - gamma)/n
      sortp = sort(p)
      adjp = min(sortp/denom)
    }
  } else adjp = 1
  return(adjp)
}
# End of HommelAdj.global

######################################################################################################################

# Function: NormalParamDist.
# Argument: c, Common critical value
#       w, Vector of hypothesis weights (1 x m)
#       corr, Correlation matrix (m x m)
# Description: Multivariate normal distribution function used in the parametric multiple testing procedure based on a multivariate normal distribution

NormalParamDist = function(c, w, corr) {

  m = dim(corr)[1]
  prob = mvtnorm::pmvnorm(lower = rep(-Inf, m), upper = c/(w * m), mean=rep(0, m), corr = corr)
  return(1 - prob[1])
}
# End of NormalParamDist

######################################################################################################################

# Function: NormalParamAdj.
# Argument: p, Vector of p-values (1 x m)
#       par, List of procedure parameters: vector of hypothesis weights (1 x m) and correlation matrix (m x m)

# Description: Parametric multiple testing procedure based on a multivariate normal distribution

NormalParamAdj = function(p, par) {

  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")


  if (any(call == FALSE) | any(is.na(call))) {
    # Number of p-values
    p = unlist(p)
    m = length(p)


    # Extract the vector of hypothesis weights (1 x m) and correlation matrix (m x m)
    # If the first parameter is a matrix and no weights are provided, the hypotheses are assumed to be equally weighted
    if (is.null(par[[2]]$weight)) {
      w = rep(1/m, m)
    } else {
      w = unlist(par[[2]]$weight)
      if (is.null(par[[2]]$corr)) stop("Analysis model: Parametric multiple testing procedure: Correlation matrix must be specified.")
      corr = par[[2]]$corr
    }

    # Error checks
    if (length(w) != m) stop("Analysis model: Parametric multiple testing procedure: Length of the weight vector must be equal to the number of hypotheses.")
    if (sum(w) != 1) stop("Analysis model: Parametric multiple testing procedure: Hypothesis weights must add up to 1.")
    if (any(w < 0)) stop("Analysis model: Parametric multiple testing procedure: Hypothesis weights must be greater than 0.")

    if (sum(dim(corr) == c(m, m)) != 2) stop("Analysis model: Parametric multiple testing procedure: Correlation matrix is not correctly defined.")
    if (det(corr) <= 0) stop("Analysis model: Parametric multiple testing procedure: Correlation matrix must be positive definite.")


    # Compute test statistics based on a normal distribution
    stat = stats::qnorm(1 - p)

    # Adjusted p-values computed using a multivariate normal distribution function
    adjpvalue = sapply(stat, NormalParamDist, w, corr)


    result = adjpvalue
  }
  else if (call == TRUE) {
    if (is.null(par[[2]]$weight)) {
      w = rep(1/m, m)
    } else {
      w = unlist(par[[2]]$weight)
      if (is.null(par[[2]]$corr)) stop("Analysis model: Parametric multiple testing procedure: Correlation matrix must be specified.")
      corr = par[[2]]$corr
    }
    weight = paste0("Hypothesis weights={", paste(round(w, 3), collapse = ","),"}")
    corr = paste0("Correlation matrix={", paste(as.vector(t(corr)), collapse = ","),"}")
    result=list(list("Normal parametric multiple testing procedure"), list(weight,corr))
  }


  return(result)
}
# End of NormalParamAdj

######################################################################################################################

# Function: errorfrac.
# Argument: k: Number of null hypotheses included in the intersection within the family.
#           n: Total number of null hypotheses in the family.
#       gamma: Truncation parameter (0<=GAMMA<1).

# Description: Evaluate error fraction function for a family based on Bonferroni, Holm, Hochberg or Hommel procedures

errorfrac = function(k, n, gamma) {
  if (k > 0)
    f = gamma + (1 - gamma) * k/n
  if (k == 0)
    f = 0
  return(f)
}
# End of errorfrac


######################################################################################################################

# Function: ParallelGatekeepingAdj.
# Argument: rawp, Raw p-value.
#           par, List of procedure parameters: vector of family (1 x m) Vector of component procedure labels ('BonferroniAdj.global' or 'HolmAdj.global' or 'HochbergAdj.global' or 'HommelAdj.global') (1 x nfam) Vector of truncation parameters for component procedures used in individual families (1 x nfam)

# Description: Computation of adjusted p-values for mixture parallel gatekeeping (ref Dmitrienko et al. (2011))

ParallelGatekeepingAdj = function(rawp, par) {

  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")

  if (any(call == FALSE) | any(is.na(call))) {
    #Error check
    if (is.null(par[[2]]$family)) stop("Analysis model: Parallel gatekeeping procedure: Hypothesis families must be specified.")
    if (is.null(par[[2]]$proc)) stop("Analysis model: Parallel gatekeeping procedure: Procedures must be specified.")
    if (is.null(par[[2]]$gamma)) stop("Analysis model: Parallel gatekeeping procedure: Gamma must be specified.")

    # Number of p-values
    nhyp = length(rawp)
    # Extract the vector of family (1 x m)
    family = par[[2]]$family
    # Number of families in the multiplicity problem
    nfam = length(family)
    # Number of null hypotheses per family
    nperfam = rep(0, nfam)
    for (j in 1:nfam) {
      nperfam[j] = length(family[[j]])
    }

    # Extract the vector of procedures (1 x m)
    proc = paste(unlist(par[[2]]$proc), ".global", sep = "")
    # Extract the vector of truncation parameters (1 x m)
    gamma = unlist(par[[2]]$gamma)

    # Simple error checks
    if (nhyp != length(unlist(family)))
      stop("Parallel gatekeeping adjustment: Length of the p-value vector must be equal to the number of hypotheses.")
    if (length(proc) != nfam)
      stop("Parallel gatekeeping adjustment: Length of the procedure vector must be equal to the number of families.") else {
        for (i in 1:nfam) {
          if (proc[i] %in% c("BonferroniAdj.global", "HolmAdj.global", "HochbergAdj.global", "HommelAdj.global") == FALSE)
            stop("Parallel gatekeeping adjustment: Only Bonferroni (BonferroniAdj), Holm (HolmAdj), Hochberg (HochbergAdj) and Hommel (HommelAdj) component procedures are supported.")
        }
      }
    if (length(gamma) != nfam)
      stop("Mixture parallel gatekeeping: Length of the gamma vector must be equal to the number of families.") else {
        for (i in 1:nfam) {
          if (gamma[i] < 0 | gamma[i] > 1)
            stop("Parallel gatekeeping adjustment: Gamma must be between 0 (included) and 1 (included).")
          if (proc[i] == "bonferroni.global" & gamma[i] != 0)
            stop("Parallel gatekeeping adjustment: Gamma must be set to 0 for the Bonferroni procedure.")
        }
      }
    # Number of intersection hypotheses in the closed family
    nint = 2^nhyp - 1

    # Construct the intersection index sets (int_orig) before the logical restrictions are applied.  Each row is a vector of binary indicators (1 if the hypothesis is
    # included in the original index set and 0 otherwise)
    int_orig = matrix(0, nint, nhyp)
    for (i in 1:nhyp) {
      for (j in 0:(nint - 1)) {
        k = floor(j/2^(nhyp - i))
        if (k/2 == floor(k/2))
          int_orig[j + 1, i] = 1
      }
    }

    # Number of null hypotheses from each family included in each intersection before the logical restrictions are applied
    korig = matrix(0, nint, nfam)

    # Compute korig
    for (j in 1:nfam) {
      # Index vector in the current family
      # index = which(family == j)
      index = family[[j]]
      korig[, j] = apply(as.matrix(int_orig[, index]), 1, sum)
    }


    # Vector of intersection p-values
    pint = rep(1, nint)

    # Matrix of component p-values within each intersection
    pcomp = matrix(0, nint, nfam)

    # Matrix of family weights within each intersection
    c = matrix(0, nint, nfam)

    # P-value for each hypothesis within each intersection
    p = matrix(0, nint, nhyp)

    # Compute the intersection p-value for each intersection hypothesis
    for (i in 1:nint) {
      # Compute component p-values
      for (j in 1:nfam) {
        # Restricted index set in the current family
        int = int_orig[i, family[[j]]]
        # Set of p-values in the current family
        pv = rawp[family[[j]]]
        # Select raw p-values included in the restricted index set
        pselected = pv[int == 1]
        # Total number of hypotheses used in the computation of the component p-value
        tot = nperfam[j]
        pcomp[i, j] = do.call(proc[j], list(pselected, tot, gamma[j]))
      }

      # Compute family weights
      c[i, 1] = 1
      for (j in 2:nfam) {
        c[i, j] = c[i, j - 1] * (1 - errorfrac(korig[i, j - 1], nperfam[j - 1], gamma[j - 1]))
      }

      # Compute the intersection p-value for the current intersection hypothesis
      pint[i] = pmin(1, min(pcomp[i, ]/c[i, ]))
      # Compute the p-value for each hypothesis within the current intersection
      p[i, ] = int_orig[i, ] * pint[i]

    }
    # Compute adjusted p-values
    adjustedp = apply(p, 2, max)
    result = adjustedp
  }
  else if (call == TRUE) {
    family = par[[2]]$family
    nfam = length(family)
    proc = unlist(par[[2]]$proc)
    gamma = unlist(par[[2]]$gamma)
    test.id = unlist(par[[3]])
    proc.par = data.frame(nrow = nfam, ncol = 4)
    for (i in 1:nfam){
      proc.par[i,1] = i
      proc.par[i,2] = paste0("{",paste(test.id[family[[i]]], collapse = ", "),"}")
      proc.par[i,3] = proc[i]
      proc.par[i,4] = gamma[i]
    }
    colnames(proc.par) = c("Family", "Hypotheses", "Component procedure", "Truncation parameter")
    result=list(list("Parallel gatekeeping"), list(proc.par))
  }

  return(result)
}
# End of ParallelGatekeepingAdj

######################################################################################################################

# Function: MultipleSequenceGatekeepingAdj.
# Argument: rawp, Raw p-value.
#           par, List of procedure parameters: vector of family (1 x m) Vector of component procedure labels ('BonferroniAdj.global' or 'HolmAdj.global' or 'HochbergAdj.global' or 'HommelAdj.global') (1 x nfam) Vector of truncation parameters for component procedures used in individual families (1 x nfam)

# Description: Computation of adjusted p-values for gatekeeping procedures based on the modified mixture methods (ref Dmitrienko et al. (2014))

MultipleSequenceGatekeepingAdj = function(rawp, par) {
  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")

  if (any(call == FALSE) | any(is.na(call))) {
    # Error check
    if (is.null(par[[2]]$family)) stop("Analysis model: Multiple sequence gatekeeping procedure: Hypothesis families must be specified.")
    if (is.null(par[[2]]$proc)) stop("Analysis model: Multiple sequence gatekeeping procedure: Procedures must be specified.")
    if (is.null(par[[2]]$gamma)) stop("Analysis model: Multiple sequence gatekeeping procedure: Gamma must be specified.")

    # Number of p-values
    nhyp = length(rawp)
    # Extract the vector of family (1 x m)
    family = par[[2]]$family
    # Number of families in the multiplicity problem
    nfam = length(family)
    # Number of null hypotheses per family
    nperfam = nhyp/nfam

    # Extract the vector of procedures (1 x m)
    proc = paste(unlist(par[[2]]$proc), ".global", sep = "")
    # Extract the vector of truncation parameters (1 x m)
    gamma = unlist(par[[2]]$gamma)

    # Simple error checks
    if (nhyp != length(unlist(family)))
      stop("Multiple-sequence gatekeeping adjustment: Length of the p-value vector must be equal to the number of hypothesis.")
    if (length(proc) != nfam)
      stop("Multiple-sequence gatekeeping adjustment: Length of the procedure vector must be equal to the number of families.") else {
        for (i in 1:nfam) {
          if (proc[i] %in% c("BonferroniAdj.global", "HolmAdj.global", "HochbergAdj.global", "HommelAdj.global") == FALSE)
            stop("Multiple-sequence gatekeeping adjustment: Only Bonferroni (BonferroniAdj), Holm (HolmAdj), Hochberg (HochbergAdj) and Hommel (HommelAdj) component procedures are supported.")
        }
      }
    if (length(gamma) != nfam)
      stop("Multiple-sequence gatekeeping adjustment: Length of the gamma vector must be equal to the number of families.") else {
        for (i in 1:nfam) {
          if (gamma[i] < 0 | gamma[i] > 1)
            stop("Multiple-sequence gatekeeping adjustment: Gamma must be between 0 (included) and 1 (included).") else if (proc[i] == "bonferroni.global" & gamma[i] != 0)
              stop("Multiple-sequence gatekeeping adjustment: Gamma must be set to 0 for the global Bonferroni procedure.")
        }
      }
    # Number of intersection hypotheses in the closed family
    nint = 2^nhyp - 1

    # Construct the intersection index sets (int_orig) before the logical restrictions are applied.  Each row is a vector of binary indicators (1 if the hypothesis is
    # included in the original index set and 0 otherwise)
    int_orig = matrix(0, nint, nhyp)
    for (i in 1:nhyp) {
      for (j in 0:(nint - 1)) {
        k = floor(j/2^(nhyp - i))
        if (k/2 == floor(k/2))
          int_orig[j + 1, i] = 1
      }
    }

    # Construct the intersection index sets (int_rest) and family index sets (fam_rest) after the logical restrictions are applied.  Each row is a vector of binary
    # indicators (1 if the hypothesis is included in the restricted index set and 0 otherwise)
    int_rest = int_orig
    fam_rest = matrix(1, nint, nhyp)
    for (i in 1:nint) {
      for (j in 1:(nfam - 1)) {
        for (k in 1:nperfam) {
          # Index of the current null hypothesis in Family j
          m = (j - 1) * nperfam + k
          # If this null hypothesis is included in the intersection hypothesis all dependent null hypotheses must be removed from the intersection hypothesis
          if (int_orig[i, m] == 1) {
            for (l in 1:(nfam - j)) {
              int_rest[i, m + l * nperfam] = 0
              fam_rest[i, m + l * nperfam] = 0
            }
          }
        }
      }
    }

    # Number of null hypotheses from each family included in each intersection before the logical restrictions are applied
    korig = matrix(0, nint, nfam)

    # Number of null hypotheses from each family included in the current intersection after the logical restrictions are applied
    krest = matrix(0, nint, nfam)

    # Number of null hypotheses from each family after the logical restrictions are applied
    nrest = matrix(0, nint, nfam)

    # Compute korig, krest and nrest
    for (j in 1:nfam) {
      # Index vector in the current family
      # index = which(family == j)
      index = family[[j]]
      korig[, j] = apply(as.matrix(int_orig[, index]), 1, sum)
      krest[, j] = apply(as.matrix(int_rest[, index]), 1, sum)
      nrest[, j] = apply(as.matrix(fam_rest[, index]), 1, sum)
    }

    # Vector of intersection p-values
    pint = rep(1, nint)

    # Matrix of component p-values within each intersection
    pcomp = matrix(0, nint, nfam)

    # Matrix of family weights within each intersection
    c = matrix(0, nint, nfam)

    # P-value for each hypothesis within each intersection
    p = matrix(0, nint, nhyp)

    # Compute the intersection p-value for each intersection hypothesis
    for (i in 1:nint) {

      # Compute component p-values
      for (j in 1:nfam) {
        # Consider non-empty restricted index sets
        if (krest[i, j] > 0) {
          # Restricted index set in the current family
          int = int_rest[i, family[[j]]]
          # Set of p-values in the current family
          pv = rawp[family[[j]]]
          # Select raw p-values included in the restricted index set
          pselected = pv[int == 1]
          # Total number of hypotheses used in the computation of the component p-value
          tot = nrest[i, j]
          pcomp[i, j] = do.call(proc[j], list(pselected, tot, gamma[j]))
        } else if (krest[i, j] == 0)
          pcomp[i, j] = 1
      }

      # Compute family weights
      c[i, 1] = 1
      for (j in 2:nfam) {
        c[i, j] = c[i, j - 1] * (1 - errorfrac(krest[i, j - 1], nrest[i, j - 1], gamma[j - 1]))
      }

      # Compute the intersection p-value for the current intersection hypothesis
      pint[i] = pmin(1, min(pcomp[i, ]/c[i, ]))
      # Compute the p-value for each hypothesis within the current intersection
      p[i, ] = int_orig[i, ] * pint[i]

    }

    # Compute adjusted p-values
    adjustedp = apply(p, 2, max)
    result = adjustedp
  }
  else if (call == TRUE) {
    family = par[[2]]$family
    nfam = length(family)
    proc = unlist(par[[2]]$proc)
    gamma = unlist(par[[2]]$gamma)
    test.id=unlist(par[[3]])
    proc.par = data.frame(nrow = nfam, ncol = 4)
    for (i in 1:nfam){
      proc.par[i,1] = i
      proc.par[i,2] = paste0("{",paste(test.id[family[[i]]], collapse = ", "),"}")
      proc.par[i,3] = proc[i]
      proc.par[i,4] = gamma[i]
    }
    colnames(proc.par) = c("Family", "Hypotheses", "Component procedure", "Truncation parameter")
    result=list(list("Multiple-sequence gatekeeping"),list(proc.par))
  }



  return(result)
}
# End of MultipleSequenceGatekeepingAdj

# Function: samples
# Argument: Multiple character strings.
# Description: This function is used mostly for user's convenience. It simply creates a list of character strings and
# can be used in cases where multiple samples need to be specified.
#' @export
samples = function(...) {

  args = list(...)

  nargs = length(args)

  if (nargs <= 0) stop("Samples function: At least one sample must be specified.")

  return(args)
  invisible(args)

}

# Function: tests
# Argument: Multiple character strings.
# Description: This function is used mostly for the user's convenience. It simply creates a list of character strings and
# can be used in cases where multiple tests need to be specified.
#' @export
tests = function(...) {

  args = list(...)

  nargs = length(args)

  if (nargs <= 0) stop("Tests function: At least one test must be specified.")

  return(args)
  invisible(args)

}

# Function: statistics
# Argument: Multiple character strings.
# Description: This function is used mostly for the user's convenience. It simply creates a list of character strings and
# can be used in cases where multiple statistics need to be specified.
#' @export
statistics = function(...) {

  args = list(...)

  nargs = length(args)

  if (nargs <= 0) stop("Statistics function: At least one test must be specified.")

  return(args)
  invisible(args)

}

# Function: parameters
# Argument: Multiple character strings.
# Description: This function is used mostly for the user's convenience. It simply creates a list of character strings and
# can be used in cases where multiple parameters need to be specified.
#' @export
parameters = function(...) {

  args = list(...)

  nargs = length(args)

  if (nargs <= 0) stop("Parameters function: At least one parameter must be specified.")

  return(args)
  invisible(args)

}

# Function: families
# Argument: Multiple character strings.
# Description: This function is used mostly for the user's convenience. It simply creates a list of character strings and
# can be used in the specification of parameters for gatekeeping procedures.
#' @export
families = function(...) {

  args = list(...)

  nargs = length(args)

  if (nargs <= 0) stop("Families function: At least one family must be specified.")

  return(args)
  invisible(args)

}

######################################################################################################################

# Function: CreateDataStructure.
# Argument: Data model.
# Description: This function is based on the old data_model_extract function. It performs error checks in the data model
# and creates a "data structure", which is an internal representation of the original data model used by all other Mediana functions.

CreateDataStructure = function(data.model) {

  # Check the general set
  if (is.null(data.model$samples))
    stop("Data model: At least one sample must be specified.")

  # Number of samples in the data model
  n.samples = length(data.model$samples)

  if (is.null(data.model$general))
    stop("Data model: General set of parameters must be specified.")

  # General set of parameters

  # List of outcome distribution parameters
  outcome = list()

  # Outcome distribution is required in the general set of data model parameters
  if (is.null(data.model$general$outcome.dist))
    stop("Data model: Outcome distribution must be specified in the general set of parameters.")
  outcome.dist = data.model$general$outcome.dist
  if (!exists(outcome.dist)) {
    stop(paste0("Data model: Outcome distribution function '", outcome.dist, "' does not exist."))
  } else {
    if (!is.function(get(as.character(outcome.dist), mode = "any")))
      stop(paste0("Data model: Outcome distribution function '", outcome.dist, "' does not exist."))
  }

  # Extract sample-specific parameters

  # List of outcome parameter sets
  outcome.parameter.set = list()
  # List of design parameter sets
  design.parameter.set = list()
  # List of sample IDs
  id = list()

  # Determine if the data model is expanded or compact (compact if the sample size sets are
  # specified in the general set of parameters, extended if the sample size sets
  # are specified for each sample)
  compact.size = FALSE
  expanded.size = FALSE

  sample.size = FALSE
  event = FALSE

  if (is.null(data.model$general$sample.size) & is.null(data.model$general$event)) {
    if (is.null(data.model$samples[[1]]$sample.size) & is.null(data.model$samples[[1]]$event))
      stop("Data model: Sample sizes or events must be specified either in the general set or in the sample-specific set of parameters.")
  }
  if (!is.null(data.model$general$sample.size)) {
    if (!is.null(data.model$samples[[1]]$sample.size))
      stop("Data model: Sample sizes must be specified either in the general set or in the sample-specific set of parameters but not both.")
  }
  if (!is.null(data.model$general$event)) {
    if (!is.null(data.model$samples[[1]]$event))
      stop("Data model: Events must be specified either in the general set or in the sample-specific set of parameters but not both.")
  }

  if (!is.null(data.model$general$event) & !is.null(data.model$general$sample.size)) {
    stop("Data model: Sample sizes or Events must be specified but not both.")
  }

  if (!is.null(data.model$samples[[1]]$event) & !is.null(data.model$samples[[1]]$sample.size)) {
    stop("Data model: Sample sizes or Events must be specified but not both.")
  }

  if (!is.null(data.model$samples[[1]]$event) & !is.null(data.model$general$sample.size)) {
    stop("Data model: Sample sizes or Events must be specified but not both.")
  }

  if (!is.null(data.model$general$event) & !is.null(data.model$samples[[1]]$sample.size)) {
    stop("Data model: Sample sizes or Events must be specified but not both.")
  }


  # Compute the number of sample size sets
  if (!is.null(data.model$general$sample.size) | !is.null(data.model$samples[[1]]$sample.size)){
    sample.size = TRUE
    if (!is.null(data.model$general$sample.size)) {
      compact.size = TRUE
      n.sample.size.sets = length(data.model$general$sample.size)
    } else {
      expanded.size = TRUE
      n.sample.size.sets = length(data.model$samples[[1]]$sample.size)
      for (i in 1:n.samples) {
        if (is.null(data.model$samples[[i]]$sample.size))
          stop("Data model: Sample sizes must be specified for all samples.")
        if (n.sample.size.sets != length(data.model$samples[[i]]$sample.size))
          stop("Data model: The same number of sample sizes must be specified across the samples.")
      }
    }

    # Data frame of sample size sets
    sample.size.set = matrix(0, n.sample.size.sets, n.samples)

    # Create a list of sample size sets
    for (i in 1:n.sample.size.sets) {
      if (expanded.size) {
        for (j in 1:n.samples) {
          sample.size.set[i, j] = data.model$samples[[j]]$sample.size[[i]]
        }
      }
      if (compact.size) {
        for (j in 1:n.samples) {
          sample.size.set[i, j] = data.model$general$sample.size[[i]]
        }
      }
    }
    sample.size.set = as.data.frame(sample.size.set)

    # Error check
    if (any(sample.size.set<=0)) stop("Data model : Sample size must be strictly positive")

  } else  {
    sample.size.set = NA
  }

  # Compute the number of event sets
  if (!is.null(data.model$general$event)){
    event = TRUE
    compact.size = TRUE
    event.set = data.frame(event.total = data.model$general$event$n.events)
    rando.ratio = data.model$general$event$rando.ratio
    if (is.null(rando.ratio)) rando.ratio = rep(1,n.samples)

    # Error check
    if (any(event.set<=0)) stop("Data model : Number of events must be strictly positive")
    if (length(rando.ratio) != n.samples) stop("Data model: the randomization ratio of each sample must be specified")
    if (any(rando.ratio<=0)) stop("Data model: the randomization ratio of each sample must be positive")
    if (any(rando.ratio %%1 != 0)) stop("Data model: the randomization ratio of each sample must be an integer")

  } else  {
    event.set = NA
    rando.ratio = NA
  }

  # Compute the number of outcome parameter sets
  for (i in 1:n.samples) {
    if (is.null(data.model$samples[[i]]$outcome.par))
      stop("Data model: Outcome parameters must be specified for all samples.")

    outcome.par = data.model$samples[[i]]$outcome.par

    if (i == 1) {
      n.outcome.parameter.sets = length(outcome.par)
    } else {
      if (n.outcome.parameter.sets != length(outcome.par))
        stop("Data model: The same number of outcome parameter sets must be specified across the samples.")
    }
  }

  # Create a list of outcome parameter sets
  for (i in 1:n.outcome.parameter.sets) {
    temp = list()
    for (j in 1:n.samples) {
      temp[[j]] = data.model$samples[[j]]$outcome.par[[i]]
      # Check if the outcome parameters are correctly specified and determine the dimensionality of the outcome distribution
      dummy.function.call = list(1, data.model$samples[[j]]$outcome.par[[i]])
      outcome.dist.dim = length(do.call(outcome.dist, list(dummy.function.call)))
    }
    outcome.parameter.set[[i]] = temp
  }

  if (is.null(data.model$general$outcome.type) & sample.size == TRUE) {
    outcome.type = rep("standard", outcome.dist.dim)
  } else if (is.null(data.model$general$outcome.type) & event == TRUE) {
    outcome.type = rep("event", outcome.dist.dim)
  } else {
    outcome.type = data.model$general$outcome.type
    if (length(outcome.type) != outcome.dist.dim)
      stop("Data model: Number of outcome types must be equal to the number of dimensions in the outcome distribution.")
  }

  # Create a list of sample IDs
  for (i in 1:n.samples) {
    if (is.null(data.model$samples[[i]]$id))
      stop("Data model: Sample IDs must be specified for all samples.")
    if (outcome.dist.dim != length(data.model$samples[[i]]$id))
      stop("Data model: The same number of sample IDs in each sample must be equal to the number of dimensions in the outcome distribution.")
    id[[i]] = data.model$samples[[i]]$id
  }

  # Compute the number of design parameter sets
  if (is.null(data.model$general$design)) {
    n.design.parameter.sets = NA
    design.parameter.set = NULL
  } else {
    n.design.parameter.sets = length(data.model$general$design)
  }

  # Create a list of design parameter sets
  if (!is.null(design.parameter.set)) {
    for (i in 1:n.design.parameter.sets) {
      if (!is.null(data.model$general$design[[i]]$followup.period) & !is.null(data.model$general$design[[i]]$study.duration))
        stop("Data model: Either the length of the follow-up period or total study duration can be specified but not both.")

      if (is.null(data.model$general$design[[i]]$enroll.dist) & !is.null(data.model$general$design[[i]]$dropout.dist))
        stop("Data model: Dropout parameters may not be specified without enrollment parameters.")

      if (is.null(data.model$general$design[[i]]$enroll.period)) {
        enroll.period = NA
      } else {
        enroll.period = data.model$general$design[[i]]$enroll.period
      }

      if (is.null(data.model$general$design[[i]]$enroll.dist)) {
        enroll.dist = NA
      } else {
        enroll.dist = data.model$general$design[[i]]$enroll.dist
        if (!exists(enroll.dist)) {
          stop(paste0("Data model: Enrollment distribution function '", enroll.dist, "' does not exist."))
        } else {
          if (!is.function(get(as.character(enroll.dist), mode = "any")))
            stop(paste0("Data model: Enrollment distribution function '", enroll.dist, "' does not exist."))
        }
      }

      if (enroll.dist == "UniformDist") {
        enroll.dist.par = NA
      } else {
        if (is.null(data.model$general$design[[i]]$enroll.dist.par)) {
          stop("Data model: Enrollment distribution parameters must be specified for non-uniform distributions.")
        } else {
          enroll.dist.par = data.model$general$design[[i]]$enroll.dist.par
        }
      }

      if (is.null(data.model$general$design[[i]]$followup.period)) {
        followup.period = NA
      } else {
        followup.period = data.model$general$design[[i]]$followup.period
      }

      if (is.null(data.model$general$design[[i]]$study.duration)) {
        study.duration = NA
      } else {
        study.duration = data.model$general$design[[i]]$study.duration
      }

      if (is.null(data.model$general$design[[i]]$dropout.dist)) {
        dropout.dist = NA
      } else {
        dropout.dist = data.model$general$design[[i]]$dropout.dist
        if (!exists(dropout.dist)) {
          stop(paste0("Data model: Dropout distribution function '", dropout.dist, "' does not exist."))
        } else {
          if (!is.function(get(as.character(dropout.dist), mode = "any")))
            stop(paste0("Data model: Dropout distribution function '", dropout.dist, "' does not exist."))
        }
      }

      if (is.null(data.model$general$design[[i]]$dropout.dist.par)) {
        dropout.dist.par = NA
      } else {
        dropout.dist.par = data.model$general$design[[i]]$dropout.dist.par
      }

      design.parameter.set[[i]] = list(enroll.period = enroll.period,
                                       enroll.dist = enroll.dist,
                                       enroll.dist.par = enroll.dist.par,
                                       followup.period = followup.period,
                                       study.duration = study.duration,
                                       dropout.dist = dropout.dist,
                                       dropout.dist.par = dropout.dist.par)
    }
  }

  # Create the data structure
  outcome = list(outcome.dist = outcome.dist, outcome.type = outcome.type, outcome.dist.dim = outcome.dist.dim)
  data.structure = list(description = "data.structure",
                        id = id,
                        outcome = outcome,
                        sample.size.set = sample.size.set,
                        event.set = event.set,
                        rando.ratio = rando.ratio,
                        outcome.parameter.set = outcome.parameter.set,
                        design.parameter.set = design.parameter.set)
  return(data.structure)
}
# End of CreateDataStructure


#######################################################################################################################

# Function: GeneratePatients.
# Argument: Design parameter, outcome parameter, sample id and number of patients or events to generate.
# Description: Generates data frames of simulated patients. This function is used in the CreateDataStack function.

GeneratePatients = function(current.design.parameter, current.outcome, current.sample.id, number){

  # Generate a set of outcome variables
  current.outcome.call = list(number, current.outcome$par)
  current.outcome.variables = as.matrix(do.call(current.outcome$dist, list(current.outcome.call)))
  colnames(current.outcome.variables) = paste0("outcome",1:ncol(current.outcome.variables))

  # Generate a set of design variables
  if (!is.null(current.design.parameter)){

    # Compute patient start times
    # Uniform patient start times
    if (current.design.parameter$enroll.dist == "UniformDist") {
      # Uniform distribution over [0, 1]
      enroll.par = list(number, list(max = 1))
      # Uniform distribution is expanded over the enrollment period
      patient.start.time = current.design.parameter$enroll.period * sort(unlist(lapply(list(enroll.par), "UniformDist")))
    } else {
      # Non-uniform patient start times
      # List of enrollment parameters
      enroll.par = list(number, current.design.parameter$enroll.dist.par)
      patient.start.time = sort(unlist(lapply(list(enroll.par), current.design.parameter$enroll.dist)))
    }
    # Patient start times are truncated at the end of the enrollment period
    patient.start.time = pmin(patient.start.time, current.design.parameter$enroll.period)

    # Compute patient end times
    # Patient end times
    if (!is.na(current.design.parameter$followup.period)) {
      # In a design with a fixed follow-up (followup.period is specified), the patient end time
      # is equal to the patient start time plus the fixed follow-up time
      patient.end.time = patient.start.time + current.design.parameter$followup.period
    }
    if (!is.na(current.design.parameter$study.duration)) {
      # In a design with a variable follow-up (study.duration is specified), the patient end time
      # is equal to the end of the trial
      patient.end.time = rep(current.design.parameter$study.duration, number)
    }

    # Compute patient dropout times (if the dropout distribution is specified) for the maximum sample size
    if (!is.na(current.design.parameter$dropout.dist)) {
      # Uniform patient dropout times
      if (current.design.parameter$dropout.dist == "UniformDist") {
        # Uniform distribution over [0, 1]
        dropout.par = list(number, 1/current.design.parameter$dropout.dist.par)
        # Uniform distribution is expanded over the patient-specific periods
        patient.dropout.time = patient.start.time + (patient.end.time - patient.start.time) *
          unlist(lapply(list(dropout.par), "UniformDist"))
      } else {
        # Non-uniform patient dropout times
        # List of dropout parameters
        dropout.par = list(number, current.design.parameter$dropout.dist.par)
        patient.dropout.time = patient.start.time +
          unlist(lapply(list(dropout.par), current.design.parameter$dropout.dist))
      }
      # If the patient end time is greater than the patient dropout time, the patient end time
      # is truncated, the patient dropout indicator is set to TRUE.
      patient.dropout.indicator = (patient.end.time >= patient.dropout.time)
      patient.end.time = pmin(patient.end.time, patient.dropout.time)
    } else {
      # No dropout distribution is specified
      patient.dropout.time = rep(NA, number)
      patient.dropout.indicator = rep(FALSE, number)
    }

    # Patient censore will be get later on in the function according to the outcome variable
    patient.censor.indicator = rep(FALSE, number)

    # Create a data frame and save it
    current.design.variables = t(rbind(patient.start.time,
                                       patient.end.time,
                                       patient.dropout.time,
                                       patient.dropout.indicator,
                                       patient.censor.indicator))

  } else if (is.null(current.design.parameter)){
    # No design parameters are specified in the data model
    patient.start.time = rep(NA, number)
    patient.end.time = rep(NA, number)
    patient.dropout.time = rep(NA, number)
    patient.dropout.indicator = rep(FALSE, number)
    patient.censor.indicator = rep(FALSE, number)

    # Create a data frame and save it
    current.design.variables = t(rbind(patient.start.time,
                                       patient.end.time,
                                       patient.dropout.time,
                                       patient.dropout.indicator,
                                       patient.censor.indicator))

  }

  colnames(current.design.variables) = c("patient.start.time",
                                         "patient.end.time",
                                         "patient.dropout.time",
                                         "patient.dropout.indicator",
                                         "patient.censor.indicator")

  # Create the list with the data frame for the current design and outcome parameter and for each outcome
  current.design.outcome.variables = list()

  # Create the censor indicator for each outcome
  for (outcome.index in 1:length(current.outcome$type)){

    current.outcome.type = current.outcome$type[outcome.index]
    patient.end.time = current.design.variables[,"patient.end.time"]
    patient.start.time = current.design.variables[,"patient.start.time"]
    patient.dropout.time = current.design.variables[,"patient.dropout.time"]
    patient.censor.indicator = current.design.variables[,"patient.censor.indicator"]
    outcome = current.outcome.variables[,paste0("outcome",outcome.index)]

    # Compute patient censor times for the analysis data sample if the current outcome type is "event"
    if (current.outcome.type == "event") {

      # Dropout distribution is specified
      if (!all(is.na(patient.dropout.time))) {

        # Outcome variable is truncated and the patient censor indicator is set to TRUE
        # if the outcome variable is greater than the patient dropout time (relative to the patient start time)
        outcome = pmin(outcome, patient.dropout.time - patient.start.time)

      }

      # Enrollment distribution is specified
      if (!all(is.na(patient.start.time))) {

        patient.censor.indicator = patient.dropout.indicator

        # Outcome variable is truncated and the patient censor indicator is set to TRUE
        # if the outcome variable is greater than the patient end time (relative to the patient start time)
        patient.censor.indicator = patient.censor.indicator | (outcome >= patient.end.time - patient.start.time)
        outcome = pmin(outcome, patient.end.time - patient.start.time)

        # Patient end time (relative to the patient start time) is set to the outcome variable if the
        # patient experience the event (that is, the patient censor indicator is FALSE)
        patient.end.time = (!patient.censor.indicator) * (patient.start.time + outcome) +
          (patient.censor.indicator) * patient.end.time
      }

    } else {
      # Current outcome type is "standard"

      # Dropout distribution is specified
      if (!all(is.na(patient.dropout.time))) {

        # Outcome variable is set to NA if the patient dropout indicator is TRUE
        outcome[patient.dropout.indicator] = NA
      }

      patient.censor.indicator = rep(FALSE, length(patient.censor.indicator))
    }

    # Create a data frame for the current sample and outcome
    df = t(rbind(outcome,
                 patient.start.time,
                 patient.end.time,
                 patient.dropout.time,
                 patient.censor.indicator))

    colnames(df) = c("outcome",
                     "patient.start.time",
                     "patient.end.time",
                     "patient.dropout.time",
                     "patient.censor.indicator")

    current.design.outcome.variables[[outcome.index]] = list(id = current.sample.id[outcome.index],
                                                             outcome.type = current.outcome.type,
                                                             data = df)

  }

  return(current.design.outcome.variables)
} # End of GeneratePatients function


#######################################################################################################################

# Function: CreateDataScenarioSampleSize .
# Argument: Data frame of patients and sample size.
# Description: Create data stack for the current sample size. This function is used in the CreateDataStack function when the user uses the SampleSize.

CreateDataScenarioSampleSize = function(current.design.outcome.variables, current.sample.size) {

  # List of current data scenario
  current.data.scenario = list()
  current.data.scenario.index = 0

  # Get the number of samples
  n.samples = length(current.design.outcome.variables)

  # Get the number of outcome
  n.outcomes = length(current.design.outcome.variables[[1]])

  # For each sample, generate the data for each outcome for the current sample size
  for (sample.index in 1:n.samples){

    for (outcome.index in 1:n.outcomes){

      # Increment the index
      current.data.scenario.index = current.data.scenario.index + 1

      # Get the current sample.size for the current sample
      current.sample.size.sample = as.numeric(current.sample.size[sample.index])

      # Get the data for the current sample.size
      current.data = current.design.outcome.variables[[sample.index]][[outcome.index]]$data[(1:current.sample.size.sample),]

      # Get the sample id
      current.id = current.design.outcome.variables[[sample.index]][[outcome.index]]$id

      # Get the outcome type
      current.outcome.type = current.design.outcome.variables[[sample.index]][[outcome.index]]$outcome.type

      # Add the current sample in the list
      current.data.scenario[[current.data.scenario.index]] = list(id = current.id,
                                                                  outcome.type = current.outcome.type,
                                                                  data = current.data
      )
    }

  }

  # Return the object
  return(current.data.scenario)

} # End of CreateDataScenarioSampleSize

#######################################################################################################################

# Function: CreateDataScenarioEvent.
# Argument: Data frame of patients and number of events.
# Description: Create data stack for the current number of events. This function is used in the CreateDataStack function when the user uses the Event.

CreateDataScenarioEvent = function(current.design.outcome.variables, current.events, rando.ratio) {

  # List of current data scenario
  current.data.scenario = list()
  current.data.scenario.index = 0

  # Get the number of samples
  n.samples = length(current.design.outcome.variables)

  # Get the number of outcome
  n.outcomes = length(current.design.outcome.variables[[1]])

  # Get the patient indicator censor of the primary outcome from all samples
  current.design.outcome.variables.primary = lapply(current.design.outcome.variables, function(x) !x[[1]]$data[,"patient.censor.indicator"])

  # Add rows in case of unbalance randomization to bind by column
  maxrow = max(unlist(lapply(current.design.outcome.variables.primary, length)))
  current.design.outcome.variables.primary.complete = mapply(cbind,lapply(current.design.outcome.variables.primary, function(x) 	{ length(x) = maxrow
  return(x)
  }))

  # Calculate the cumulative number of events for each sample according to the randomization ratio
  n.events.cum = mapply(function(x,y) cumsum(x)[seq(y,length(x), y)], current.design.outcome.variables.primary, as.list(rando.ratio))
  index.patient = which(rowSums(n.events.cum)>=current.events)[1]

  # Get the number of patients required to get the current number of events in each sample
  index.patient = rando.ratio*index.patient

  # For each sample, generate the data for each outcome for the current sample size
  for (sample.index in 1:n.samples){

    for (outcome.index in 1:n.outcomes){

      # Increment the index
      current.data.scenario.index = current.data.scenario.index + 1

      # Get the data for the current sample.size
      current.data = current.design.outcome.variables[[sample.index]][[outcome.index]]$data[(1:index.patient[[sample.index]]),]

      # Get the sample id
      current.id = current.design.outcome.variables[[sample.index]][[outcome.index]]$id

      # Get the outcome type
      current.outcome.type = current.design.outcome.variables[[sample.index]][[outcome.index]]$outcome.type

      # Add the current sample in the list
      current.data.scenario[[current.data.scenario.index]] = list(id = current.id,
                                                                  outcome.type = current.outcome.type,
                                                                  data = current.data
      )
    }

  }

  # Return the object
  return(current.data.scenario)

} # End of CreateDataScenarioEvent

#######################################################################################################################

# Function: CreateDataStack.
# Argument: Data model and number of simulations.
# Description: Generates a data stack, which is a collection of individual data sets (one data set per simulation run).

CreateDataStack = function(data.model, n.sims, seed=NULL) {

  # Perform error checks for the data model and create an internal data structure
  data.structure = CreateDataStructure(data.model)

  # Check the seed if defined (the seed should be defined only when the user generate the data stack)
  if (!is.null(seed)){
    if (!is.numeric(seed))
      stop("Seed must be an integer.")
    if (length(seed) > 1)
      stop("Seed: Only one value must be specified.")
    if (nchar(as.character(seed)) > 10)
      stop("Length of seed must be inferior to 10.")
  }

  # Create short names for data model parameters
  outcome.dist = data.structure$outcome$outcome.dist
  outcome.type = data.structure$outcome$outcome.type
  outcome.dist.dim = data.structure$outcome$outcome.dist.dim
  data.sample.id = data.structure$id
  data.size = data.structure$sample.size.set
  data.event = data.structure$event.set
  rando.ratio = data.structure$rando.ratio
  data.design = data.structure$design.parameter.set
  data.outcome = data.structure$outcome.parameter.set

  # Number of outcome parameter sets, sample size sets and design parameter sets
  n.outcome.parameter.sets = length(data.structure$outcome.parameter.set)
  if (!is.null(data.structure$design.parameter.set)) {
    n.design.parameter.sets = length(data.structure$design.parameter.set)
  } else {
    n.design.parameter.sets = 1
  }

  # Determine if sample size or event were used
  # Determine which sample size set corresponds to the maximum of events or sample size for each data sample
  sample.size = any(!is.na(data.size))
  event = any(!is.na(data.event))
  if (sample.size) {
    n.sample.size.event.sets = dim(data.structure$sample.size.set)[1]
    max.sample.size = apply(data.size,2,max)
  } else if (event){
    n.sample.size.event.sets = dim(data.structure$event.set)[1]
    max.event = apply(data.event,2,max)
  }

  # Number of data samples specified in the data model
  n.data.samples = length(data.sample.id)

  # Create the data stack which is represented by a list of data sets (one data set for each simulation run)
  data.set = list()

  # Create a grid of the data scenario factors (outcome parameter, sample size and design parameter)
  data.scenario.grid = expand.grid(design.parameter.set = 1:n.design.parameter.sets,
                                   outcome.parameter.set = 1:n.outcome.parameter.sets,
                                   sample.size.set = 1:n.sample.size.event.sets)

  colnames(data.scenario.grid) = c("design.parameter", "outcome.parameter", "sample.size")

  # Number of data scenarios (number of unique combinations of the data scenario factors)
  n.data.scenarios = dim(data.scenario.grid)[1]

  # Create a grid of the ouctcome and design scenario factors (outcome parameter and design parameter)
  data.design.outcome.grid = expand.grid(design.parameter.set = 1:n.design.parameter.sets,
                                         outcome.parameter.set = 1:n.outcome.parameter.sets)

  colnames(data.design.outcome.grid) = c("design.parameter", "outcome.parameter")

  # Number of design and outcome scenarios (number of unique combinations of the design and outcome scenario factors)
  n.design.outcome.scenarios = dim(data.design.outcome.grid)[1]

  # Set the seed
  if (!is.null(seed)) set.seed(seed)

  # Loop over the simulations
  for (sim.index in 1:n.sims) {

    # If sample size is used (fixed number of sample size)
    if (sample.size) {

      design.outcome.variables = vector(n.design.outcome.scenarios, mode = "list")

      # Loop over the design and outcome grid
      for (design.outcome.index in 1:n.design.outcome.scenarios) {

        # Get the current design index and parameters
        current.design.index = data.design.outcome.grid[design.outcome.index, "design.parameter"]
        current.design.parameter = data.design[[current.design.index]]

        # Get the outcome index and parameters
        current.outcome.index = data.design.outcome.grid[design.outcome.index, "outcome.parameter"]
        current.outcome.parameter = data.outcome[[current.outcome.index]]

        # Initialized the data frame list
        df = vector(n.data.samples, mode = "list")

        # Loop over the data samples
        for (data.sample.index in 1:n.data.samples) {

          # Maximum sample size across the sample size sets for the current data sample
          current.max.sample.size = max.sample.size[data.sample.index]

          # Outcome parameter for the current data sample
          current.outcome = list(dist = outcome.dist, par = current.outcome.parameter[[data.sample.index]], type = outcome.type)

          # Get the current sample id
          current.sample.id = unlist(data.sample.id[[data.sample.index]])

          # Generate the data for the current design and outcome parameters
          df[[data.sample.index]] = GeneratePatients(current.design.parameter, current.outcome, current.sample.id, current.max.sample.size)

        } # Loop over the data samples

        design.outcome.variables[[design.outcome.index]] = list(design.parameter = current.design.index, outcome.parameter = current.outcome.index, sample = df)

      } # Loop over the design and outcome grid

      # Create the data scenario list (one element for each unique combination of the data scenario factors)
      data.scenario = list()

      # Loop over the data scenarios
      for (data.scenario.index in 1:n.data.scenarios) {

        design.index = data.scenario.grid[data.scenario.index, 1]
        outcome.index = data.scenario.grid[data.scenario.index, 2]
        sample.size.index = data.scenario.grid[data.scenario.index, 3]

        # Get the design.outcome variables corresponding to the current data scenario
        current.design.outcome.index = sapply(design.outcome.variables, function(x) x$design.parameter == design.index & x$outcome.parameter == outcome.index)
        current.design.outcome.variables = design.outcome.variables[current.design.outcome.index][[1]]$sample

        # Get the sample size
        current.sample.size = data.size[sample.size.index,]

        # Generate the data for the current data scenario
        data.scenario[[data.scenario.index]] = list(sample = CreateDataScenarioSampleSize(current.design.outcome.variables, current.sample.size))
      }

    } else if (event) {
      # If event is used (generate data until the number of event required for the first outcome is reached)

      design.outcome.variables = vector(n.design.outcome.scenarios, mode = "list")

      # Loop over the design and outcome grid
      for (design.outcome.index in 1:n.design.outcome.scenarios) {

        # Get the current design index and parameters
        current.design.index = data.design.outcome.grid[design.outcome.index, "design.parameter"]
        current.design.parameter = data.design[[current.design.index]]

        # Get the outcome index and parameters
        current.outcome.index = data.design.outcome.grid[design.outcome.index, "outcome.parameter"]
        current.outcome.parameter = data.outcome[[current.outcome.index]]

        # Initialized the data frame list
        df = vector(n.data.samples, mode = "list")

        # Initialized the temporary data frame list
        df.temp = vector(n.data.samples, mode = "list")

        # Set the Number of events
        n.observed.events = 0

        # Loop over the data samples to generate a first set of data corresponding to the maximum number of events required divided by randomization ratio
        for (data.sample.index in 1:n.data.samples) {

          # Outcome parameter for the current data sample
          current.outcome = list(dist = outcome.dist, par = current.outcome.parameter[[data.sample.index]], type = outcome.type)

          # Get the current sample id
          current.sample.id = unlist(data.sample.id[[data.sample.index]])

          # Generate the data for the current design and outcome parameters
          df.temp[[data.sample.index]] = GeneratePatients(current.design.parameter, current.outcome, current.sample.id, rando.ratio[data.sample.index] * ceiling(max.event / sum(rando.ratio)))

          # Merge the previous generated data with the temporary data
          if (!is.null(df[[data.sample.index]])) {
            data.temp = as.data.frame(mapply(rbind, lapply(df[[data.sample.index]], function(x) as.data.frame(x$data)), lapply(df.temp[[data.sample.index]], function(x) as.data.frame(x$data)), SIMPLIFY=FALSE))
            row.names(data.temp) = NULL
            df[[data.sample.index]] = lapply(df[[data.sample.index]], function(x) {return(list(id = x$id, outcome.type = x$outcome.type, data = as.matrix(data.temp)))})
          } else {
            df[[data.sample.index]] = df.temp[[data.sample.index]]
          }

        } # Loop over the data samples

        # Get the number of events observed accross all samples for the primary endpoint
        n.observed.events = sum(unlist(lapply(df, function(x) {return(!x[[1]]$data[,"patient.censor.indicator"])})))

        # Loop until the maximum number of events required is observed
        while(n.observed.events < max.event){

          # Loop over the data samples
          for (data.sample.index in 1:n.data.samples) {

            # Outcome parameter for the current data sample
            current.outcome = list(dist = outcome.dist, par = current.outcome.parameter[[data.sample.index]], type = outcome.type)

            # Get the current sample id
            current.sample.id = unlist(data.sample.id[[data.sample.index]])

            # Generate the data for the current design and outcome parameters
            df.temp[[data.sample.index]] = GeneratePatients(current.design.parameter, current.outcome, current.sample.id, rando.ratio[data.sample.index])

            # Merge the previous generated data with the temporary data
            if (!is.null(df[[data.sample.index]])) {
              data.temp = lapply(mapply(rbind, lapply(df[[data.sample.index]], function(x) as.data.frame(x$data)), lapply(df.temp[[data.sample.index]], function(x) as.data.frame(x$data)), SIMPLIFY=FALSE), function(x) as.matrix(x))
              df[[data.sample.index]] = mapply(function(x,y) {return(list(id=x$id, outcome.type = x$outcome.type, data = as.matrix(y, row.names = NULL)))}, x=df[[data.sample.index]], y=data.temp, SIMPLIFY=FALSE)
            } else {
              df[[data.sample.index]] = df.temp[[data.sample.index]]
            }

          } # Loop over the data samples

          # Get the number of events observed accross all samples for the primary endpoint
          n.observed.events = sum(unlist(lapply(df, function(x) {return(!x[[1]]$data[,"patient.censor.indicator"])})))

        } # Loop until the maximum number of events required is observed

        design.outcome.variables[[design.outcome.index]] = list(design.parameter = current.design.index, outcome.parameter = current.outcome.index, sample = df)

      } # Loop over the design and outcome grid

      # Create the data scenario list (one element for each unique combination of the data scenario factors)
      data.scenario = list()

      # Loop over the data scenarios
      for (data.scenario.index in 1:n.data.scenarios) {

        design.index = data.scenario.grid[data.scenario.index, 1]
        outcome.index = data.scenario.grid[data.scenario.index, 2]
        event.index = data.scenario.grid[data.scenario.index, 3]

        # Get the design.outcome variables corresponding to the current data scenario
        current.design.outcome.index = sapply(design.outcome.variables, function(x) x$design.parameter == design.index & x$outcome.parameter == outcome.index)
        current.design.outcome.variables = design.outcome.variables[current.design.outcome.index][[1]]$sample

        # Get the number of events
        current.events = data.event[event.index,]

        # Generate the data for the current data scenario
        data.scenario[[data.scenario.index]] = list(sample = CreateDataScenarioEvent(current.design.outcome.variables, current.events, rando.ratio))

      } # Loop over the data scenarios

    } # If event

    data.set[[sim.index]] = list(data.scenario = data.scenario)

  } # Loop over the simulations

  # Create the data stack
  data.stack = list(description = "data.stack",
                    data.set = data.set,
                    data.scenario.grid = data.scenario.grid,
                    data.structure = data.structure,
                    n.sims = n.sims,
                    seed = seed)

  class(data.stack) = "DataStack"
  return(data.stack)

}
# End of CreateDataStack

#######################################################################################################################

# Function: CreateDataSlice.
# Argument: Data scenario (results of a single simulation run for a single combination of data scenario factores),
# list of analysis samples for defining a data slice, slice criterion and slice value.
# Description: Creates a subset of the original data set (known as a slice) based on the specified parameter. This function is useful for
# implementing interim looks and requires that the enrollment parameters should be specified in the data model.
# If parameter = "sample.size", the time point for defining the slice is determined by computing the time when X patients
# in the combined samples from the sample list complete the trial (patients who dropped out of the trial or who are censored
# are not counted as completers).
# If parameter = "event", the time point for defining the slice is determined by computing the time when X events occurs
# in the combined samples specified in the sample list.
# If parameter = "time", the data slice includes the patients who complete the trial by the specified time cutoff
# (patients who dropped out of the trial or who are censored are not counted as completers).
# After the time cutoff is determined, the data slice is then created by keeping only the
# patients who complete the trial prior to the time cutoff. The patients not included in the data slice are
# assumed to have dropped out of the trial (if the outcome type if "standard") or have been censored (if the outcome type if "event").

# X is specified by the value argument.

CreateDataSlice = function(data.scenario, sample.list, parameter, value) {

  # Number of analysis samples within the data scenario
  n.analysis.samples = length(data.scenario$sample)

  # Create the data slice
  data.slice = data.scenario

  # Select the samples from the sample list within the current data scenario
  selected.samples = list()

  index = 1
  for (i in 1:n.analysis.samples) {
    if (data.scenario$sample[[i]]$id %in% sample.list) {
      selected.samples[[index]] = data.scenario$sample[[i]]$data
      index = index + 1
    }
  }

  # Merge the selected analysis samples
  selected.analysis.sample = do.call(rbind, selected.samples)

  # Determine the time cutoff depending on the parameter specified
  if (parameter == "sample.size") {

    # Remove patients who dropped out of the trial or who are censored (they are not counted as completers)
    non.missing.outcome = !(is.na(selected.analysis.sample[, "outcome"]))
    completers = selected.analysis.sample[non.missing.outcome, ]

    # Check if there are any completers
    if (dim(completers)[1] > 0) {

      # Sort by the patient end time
      completers = completers[order(completers[, "patient.end.time"]), ]

      # Total number of completers
      total.sample.size = dim(completers)[1]

      # Find the time cutoff corresponding to the specified sample size in the selected sample
      # Truncate the VALUE argument if greater than the total number of completers
      time.cutoff = completers[min(value, total.sample.size), "patient.end.time"]

    } else {

      # No completers
      time.cutoff = 0
    }

  }

  if (parameter == "event") {

    # Remove patients who dropped out of the trial or who are censored (they are not counted as events)
    non.missing.outcome = !(is.na(selected.analysis.sample[, "outcome"])) & (selected.analysis.sample[, "patient.censor.indicator"] == 0)
    events = selected.analysis.sample[non.missing.outcome, ]

    # Check if there are any events
    if (dim(events)[1] > 0) {

      # Sort by the patient end time (this is when the events occurred)
      events = events[order(events[, "patient.end.time"]), ]

      # Total number of events
      total.event.count = dim(events)[1]

      # Find the time cutoff corresponding to the specified event count in the selected sample
      # Truncate the VALUE argument if greater than the total event count
      time.cutoff = events[min(value, total.event.count), "patient.end.time"]

    } else {

      # No events
      time.cutoff = 0
    }

  }

  if (parameter == "time") {

    # Time cutoff is directly specified
    time.cutoff = value

  }

  # Create the data slice by applying the time cutoff to all analysis samples

  # Loop over the analysis samples
  for (i in 1:n.analysis.samples) {

    sliced.analysis.sample = data.scenario$sample[[i]]$data

    if (data.scenario$sample[[i]]$outcome.type == "event") {

      # Apply slicing rules for event-type outcomes

      # If the patient end time is greater than the time cutoff, the patient censor indicator is set to TRUE
      sliced.analysis.sample[, "patient.censor.indicator"] = (sliced.analysis.sample[, "patient.end.time"] > time.cutoff)

      # If the patient end time or dropout time is greater than the time cutoff, the patient end time is set to the time cutoff
      sliced.analysis.sample[, "patient.end.time"] = pmin(time.cutoff, sliced.analysis.sample[, "patient.end.time"])
      sliced.analysis.sample[, "patient.dropout.time"] = pmin(time.cutoff, sliced.analysis.sample[, "patient.dropout.time"])

      # Outcome is truncated at the time cutoff for censored observations
      sliced.analysis.sample[, "outcome"] = (time.cutoff - sliced.analysis.sample[, "patient.start.time"]) * sliced.analysis.sample[, "patient.censor.indicator"] +
        sliced.analysis.sample[, "outcome"] * (1 - sliced.analysis.sample[, "patient.censor.indicator"])

      # If the patient outcome is negative, the outcome is set to NA (patient is enrolled after the time cutoff)
      sliced.analysis.sample[sliced.analysis.sample[, "outcome"] < 0, "outcome"] = NA

    } else {

      # Apply slicing rules for standard outcomes (binary and continuous outcome variables)

      # If the patient end time is greater than the time cutoff, the patient is considered a dropout and the outcome is set to NA
      sliced.analysis.sample[sliced.analysis.sample[, "patient.end.time"] > time.cutoff, "outcome"] = NA

      # If the patient end time or dropout time is greater than the time cutoff, the patient end time is set to the time cutoff
      sliced.analysis.sample[, "patient.end.time"] = pmin(time.cutoff, sliced.analysis.sample[, "patient.end.time"])
      sliced.analysis.sample[, "patient.dropout.time"] = pmin(time.cutoff, sliced.analysis.sample[, "patient.dropout.time"])

    }

    # Put the sliced data sample in the data slice
    data.slice$sample[[i]]$data = sliced.analysis.sample

  } # Loop over the analysis samples

  return(data.slice)
}
# End of CreateDataSlice

######################################################################################################################

# Function: CreateAnalysisStructure.
# Argument: Analysis model.
# Description: This function is based on the old analysis_model_extract function. It performs error checks in the analysis model
# and creates an "analysis structure", which is an internal representation of the original analysis model used by all other Mediana functions.

CreateAnalysisStructure = function(analysis.model) {

  # Check the general set
  if (is.null(analysis.model$tests) & is.null(analysis.model$statistics))
    stop("Analysis model: At least one test or statistic must be specified.")

  # General set of analysis model parameters

  # Extract interim analysis parameters
  if (!is.null(analysis.model$general$interim.analysis)) {

    interim.looks = analysis.model$general$interim.analysis$interim.looks
    if (!(interim.looks$parameter %in% c("sample.size", "event", "time")))
      stop("Analysis model: Parameter in the interim analysis specifications must be sample.size, event or time.")
    interim.analysis = list(interim.looks = interim.looks)

  } else {
    interim.analysis = NULL
  }

  # Extract test-specific parameters

  if (!is.null(analysis.model$tests)) {

    # Number of tests in the analysis model
    n.tests = length(analysis.model$tests)

    # List of tests (id, statistical method, sample list, parameters)
    test = list()

    for (i in 1:n.tests) {
      # Test IDs
      if (is.null(analysis.model$tests[[i]]$id))
        stop("Analysis model: IDs must be specified for all tests.") else id = analysis.model$tests[[i]]$id
        # List of samples
        if (is.null(analysis.model$tests[[i]]$samples))
          stop("Analysis model: Samples must be specified for all tests.") else samples = analysis.model$tests[[i]]$samples
          # Statistical method
          method = analysis.model$test[[i]]$method

          if (!exists(method)) {
            stop(paste0("Analysis model: Statistical method function '", method, "' does not exist."))
          } else if (!is.function(get(as.character(method), mode = "any"))) {
            stop(paste0("Analysis model: Statistical method function '", method, "' does not exist."))
          }

          # Test parameters (optional)
          if (is.null(analysis.model$tests[[i]]$par)) par = NA else par = analysis.model$tests[[i]]$par

          test[[i]] = list(id = id, method = method, samples = samples, par = par)
    }

    # Check if id is uniquely defined
    if (any(table(unlist(lapply(test,function(list) list$id)))>1))
      stop("Analysis model: Tests IDs must be uniquely defined.")

  } else {
    # No tests are specified
    test = NULL

  }

  # Extract statistic-specific parameters

  if (!is.null(analysis.model$statistics)) {

    # Number of statistics in the analysis model
    n.statistics = length(analysis.model$statistics)

    # List of statistics (id, statistical method, sample list, parameters)
    statistic = list()

    for (i in 1:n.statistics) {
      # Statistic IDs
      if (is.null(analysis.model$statistic[[i]]$id))
        stop("Analysis model: IDs must be specified for all statistics.") else id = analysis.model$statistic[[i]]$id
        # List of samples
        if (is.null(analysis.model$statistic[[i]]$samples))
          stop("Analysis model: Samples must be specified for all statistics.") else samples = analysis.model$statistic[[i]]$samples
          # Statistical method
          method = analysis.model$statistic[[i]]$method

          if (!exists(method)) {
            stop(paste0("Analysis model: Statistical method function '", method, "' does not exist."))
          } else if (!is.function(get(as.character(method), mode = "any"))) {
            stop(paste0("Analysis model: Statistical method function '", method, "' does not exist."))
          }

          if (is.null(analysis.model$statistic[[i]]$par)) par = NA else par = analysis.model$statistic[[i]]$par

          statistic[[i]] = list(id = id, method = method, samples = samples, par = par)
    }

  } else {
    # No statistics are specified
    statistic = NULL

  }

  # Extract parameters of multiplicity adjustment methods

  # List of multiplicity adjustments (procedure, parameters, tests)
  mult.adjust = list(list())

  # Number of multiplicity adjustment methods
  if (is.null(analysis.model$general$mult.adjust)) {
    # No multiplicity adjustment is specified
    mult.adjust = NULL
  } else {
    n.mult.adjust = length(analysis.model$general$mult.adjust)
    for (i in 1:n.mult.adjust) {
      mult.adjust.temp = list()
      # Number of multiplicity adjustments within each mult.adj scenario
      n.mult.adj.sc=length(analysis.model$general$mult.adjust[[i]])
      for (j in 1:n.mult.adj.sc){
        proc = analysis.model$general$mult.adjust[[i]][[j]]$proc
        if (is.na(proc) | is.null(analysis.model$general$mult.adjust[[i]][[j]]$par)) par = NA else par = analysis.model$general$mult.adjust[[i]][[j]]$par
        if (is.null(analysis.model$general$mult.adjust[[i]][[j]]$tests)) {
          tests = lapply(test, function(list) list$id)
        } else {
          tests = analysis.model$general$mult.adjust[[i]][[j]]$tests
        }

        # If the multiplicity adjustment procedure is specified, check if it exists
        if (!is.na(proc)) {
          if (!exists(proc)) {
            stop(paste0("Analysis model: Multiplicity adjustment procedure function '", proc, "' does not exist."))
          } else if (!is.function(get(as.character(proc), mode = "any"))) {
            stop(paste0("Analysis model: Multiplicity adjustment procedure function '", proc, "' does not exist."))
          }
        }

        # Check if tests defined in the multiplicity adjustment exist (defined in the test list)
        temp_list = lapply(lapply(tests,function(l1,l2) l1 %in% l2, lapply(test, function(list) list$id)), function(l) any(l == FALSE))

        if (!is.na(proc) & any(temp_list == TRUE))
          stop(paste0("Analysis model: Multiplicity adjustment procedure test has not been specified in the test-specific model."))

        mult.adjust.temp[[j]] = list(proc = proc, par = par, tests = tests)
      }

      mult.adjust[[i]] = mult.adjust.temp
      # Check if tests defined in multiplicity adjustment is defined in one and only one multiplicity adjustment
      if (any(table(unlist(lapply(mult.adjust[[i]],function(list) list$tests)))>1))
        stop(paste0("Analysis model: Multiplicity adjustment procedure test has been specified in more than one multiplicity adjustment."))

    }
  }

  # Create the analysis structure
  analysis.structure = list(description = "analysis.structure",
                            test = test,
                            statistic = statistic,
                            mult.adjust = mult.adjust,
                            interim.analysis = interim.analysis)
  return(analysis.structure)

}
# End of CreateAnalysisStructure


##############################################################################################################################################

# Function: PerformAnalysis.
# Argument: Data model (or data stack) and analysis model.
# Description: This function carries out the statistical tests and computes the descriptive statistics specified in
# the analysis model using the specified data model (or data stack generated by the user).
# The number of simulations (n.sims) is used only if a data model is specified. If a data stack is specified,
# the number of simulations is obtained from this data stack.
#' @import doRNG
#' @import doParallel
#' @import foreach
PerformAnalysis = function(data, analysis.model, sim.parameters) {

  # Check if a data stack was specified and, if a data model is specified, call the CreateDataStructure function
  if (class(data) == "DataStack") {
    if (data$description == "data.stack") {
      call.CreateDataStructure  = FALSE
      data.stack = data
      n.sims = data.stack$n.sims
      seed = data.stack$seed
      data.structure = data.stack$data.structure
    } else {
      stop("The data object is not recognized.")
    }
  } else {
    call.CreateDataStructure  = TRUE
    data.model = data
    # Create a dummy data.stack
    data.stack = CreateDataStack(data.model, 1)
    data.structure = CreateDataStructure(data.model)
  }

  # Simulation parameters
  # Number of simulation runs
  if (is.null(sim.parameters$n.sims))
    stop("The number of simulation runs must be provided (n.sims)")

  if (call.CreateDataStructure == TRUE){
    n.sims = sim.parameters$n.sims
  }
  else {
    # Get the number of simulations with the data stack
    n.sims = n.sims
    warning("The number of simulation runs from the sim.parameter was ignored as a data stack was defined.")
  }
  if (!is.numeric(n.sims))
    stop("Number of simulation runs must be an integer.")
  if (length(n.sims) > 1)
    stop("Number of simulations runs: Only one value must be specified.")
  if (n.sims%%1 != 0)
    stop("Number of simulations runs must be an integer.")
  if (n.sims <= 0)
    stop("Number of simulations runs must be positive.")

  # Seed
  if (is.null(sim.parameters$seed))
    stop("The seed must be provided (seed)")

  if (call.CreateDataStructure == TRUE){
    seed = sim.parameters$seed
  } else {
    # Get the number of simulations with the data stack
    seed = seed
    warning("The seed from the sim.parameter was ignored as a data stack was defined.")
  }

  if (!is.numeric(seed))
    stop("Seed must be an integer.")
  if (length(seed) > 1)
    stop("Seed: Only one value must be specified.")
  if (nchar(as.character(seed)) > 10)
    stop("Length of seed must be inferior to 10.")

  if (!is.null(sim.parameters$proc.load)){
    proc.load = sim.parameters$proc.load
    if (is.numeric(proc.load)){
      if (length(proc.load) > 1)
        stop("Number of cores: Only one value must be specified.")
      if (proc.load %%1 != 0)
        stop("Number of cores must be an integer.")
      if (proc.load <= 0)
        stop("Number of cores must be positive.")
      n.cores = proc.load
    }
    else if (is.character(proc.load)){
      n.cores=switch(proc.load,
                     low={1},
                     med={parallel::detectCores()/2},
                     high={parallel::detectCores()-1},
                     full={parallel::detectCores()},
                     {stop("Processor load not valid")})
    }
  } else n.cores = 1

  sim.parameters = list(n.sims = n.sims, seed = seed, proc.load = n.cores)

  # Perform error checks for the data model and create an internal analysis structure
  analysis.structure = CreateAnalysisStructure(analysis.model)

  # Check if the samples referenced in the analysis model are actually specified in the data model

  # List of sample IDs
  sample.id = unlist(data.structure$id)

  # Number of tests specified in the analysis model
  n.tests = length(analysis.structure$test)

  if (n.tests > 0) {

    # Test IDs
    test.id = rep(" ", n.tests)

    for (test.index in 1:n.tests) {

      test.id[test.index] = analysis.structure$test[[test.index]]$id

      # Number of samples in the current test
      n.test.samples = length(analysis.structure$test[[test.index]]$samples)

      # When processing samples specified for individual tests, it is important to remember that
      # a hierarchical structure can be used, i.e., samples can first be merged and then passed to a specific test

      for (i in 1:n.test.samples) {

        # Number of subsamples in the current sample
        n.subsamples = length(analysis.structure$test[[test.index]]$samples[[i]])
        if (n.subsamples == 1) {
          if (!(analysis.structure$test[[test.index]]$samples[[i]] %in% sample.id))
            stop(paste0("Analysis model: Sample '", analysis.structure$test[[test.index]]$samples[[i]], "' is not defined in the data model."))
        } else {
          # Multiple subsamples
          for (j in 1:n.subsamples) {
            if (!(analysis.structure$test[[test.index]]$samples[[i]][[j]] %in% sample.id))
              stop(paste0("Analysis model: Sample '", analysis.structure$test[[test.index]]$samples[[i]][[j]], "' is not defined in the data model."))
          }
        }
      }
    }
  }

  # Number of statistics specified in the analysis model
  n.statistics = length(analysis.structure$statistic)

  # Statistic IDs
  statistic.id = rep(" ", n.statistics)

  if (n.statistics > 0) {

    for (statistic.index in 1:n.statistics) {

      statistic.id[statistic.index] = analysis.structure$statistic[[statistic.index]]$id

      # Number of samples in the current statistic
      n.statistic.samples = length(analysis.structure$statistic[[statistic.index]]$samples)

      for (i in 1:n.statistic.samples) {
        # Number of subsamples in the current sample
        n.subsamples = length(analysis.structure$statistic[[statistic.index]]$samples[[i]])
        if (n.subsamples == 1) {
          if (!(analysis.structure$statistic[[statistic.index]]$samples[[i]] %in% sample.id))
            stop(paste0("Analysis model: Sample '", analysis.structure$statistic[[statistic.index]]$samples[[i]], "' is not defined in the data model."))
        } else {
          # Multiple subsamples
          for (j in 1:n.subsamples) {
            if (!(analysis.structure$statistic[[statistic.index]]$samples[[i]][[j]] %in% sample.id))
              stop(paste0("Analysis model: Sample '", analysis.structure$statistic[[statistic.index]]$samples[[i]][[j]], "' is not defined in the data model."))
          }
        }
      }
    }
  }

  # Information on the analysis scenario factors

  # Number of multiplicity adjustment sets
  if (!is.null(analysis.structure$mult.adjust)) {
    n.mult.adjust = length(analysis.structure$mult.adjust)
  } else {
    n.mult.adjust = 1
  }

  # Number of analysis points (total number of interim and final analyses)
  if (!is.null(analysis.structure$interim.analysis)) {
    n.analysis.points = length(analysis.structure$interim.analysis$interim.looks$fraction)
  } else {
    # No interim analyses
    n.analysis.points = 1
  }


  # Create the analysis stack (list of the analysis sets produced by the test and statistic functions,
  # each element in this list contains the results generated in a single simulation run)
  analysis.set = list()

  # Number of data scenarios
  n.data.scenarios = dim(data.stack$data.scenario.grid)[1]
  data.scenario.grid = data.stack$data.scenario.grid

  # Create a grid of the data and analysis scenario factors (outcome parameter, sample size,
  # design parameter, multiplicity adjustment)
  scenario.grid = matrix(0, n.data.scenarios * n.mult.adjust, 2)

  index = 1
  for (i in 1:n.data.scenarios) {
    for (j in 1:n.mult.adjust) {
      scenario.grid[index, 1] = i
      scenario.grid[index, 2] = j
      index = index + 1
    }
  }

  # Number of data and analysis scenarios
  n.scenarios = dim(scenario.grid)[1]

  # Number of analysis samples in each data scenario
  n.analysis.samples = length(data.stack$data.set[[1]]$data.scenario[[1]]$sample)

  # Simulation parameters
  # Use proc.load to generate the clusters
  cluster.mediana = parallel::makeCluster(getOption("cluster.mediana.cores", sim.parameters$proc.load))

  # To make this reproducible I used the same number as the seed
  set.seed(seed)
  parallel::clusterSetRNGStream(cluster.mediana, seed)

  #Export all functions in the global environment to each node
  parallel::clusterExport(cluster.mediana,ls(envir=.GlobalEnv))
  doParallel::registerDoParallel(cluster.mediana)

  # Simulation index initialisation
  sim.index=0

  # Loop over simulation runs
  result.analysis.scenario=foreach::foreach(sim.index=1:sim.parameters$n.sims, .packages=(.packages())) %dorng% {
    # Select the current data set within the data stack
    if (!call.CreateDataStructure){
      current.data.set = data.stack$data.set[[sim.index]]
    } else {
      current.data.stack = CreateDataStack(data.model, 1)
      current.data.set = current.data.stack$data.set[[1]]
    }

    # Matrix of results (p-values) produced by the tests
    test.results = matrix(0, n.tests, n.analysis.points)

    # Matrix of results produced by the statistics
    statistic.results = matrix(0, n.statistics, n.analysis.points)

    # Create the analysis scenario list (one element for each unique combination of the data scenario factors)
    result.data.scenario = list()

    # Loop over the data scenario factors (outcome parameter, sample size, and design parameter)
    for (scenario.index in 1:n.data.scenarios) {

      # Current data scenario
      current.data.scenario = current.data.set$data.scenario[[scenario.index]]

      # Current sample size set
      current.sample.size.set = data.stack$data.scenario.grid[scenario.index, "sample.size"]

      # Vector of sample sizes across the data samples in the current sample size set
      if (!any(is.na(data.stack$data.structure$sample.size.set))) current.sample.sizes = data.stack$data.structure$sample.size.set[current.sample.size.set, ]

      # Loop over interim analyses
      for (analysis.point.index in 1:n.analysis.points) {

        # Create a data slice for the current interim look if interim analyses are specified in the analysis model
        if (!is.null(analysis.structure$interim.analysis)) {

          sample.list = analysis.structure$interim.analysis$interim.looks$sample
          parameter = analysis.structure$interim.analysis$interim.looks$parameter
          fraction = analysis.structure$interim.analysis$interim.looks$fraction[[analysis.point.index]]

          # Compute the total sample size in the sample list
          n.sample.list = length(sample.list)
          total.sample.size = 0
          # Number of samples
          n.samples = length(sample.id)

          for (k in 1:n.samples) {
            for (l in 1:n.sample.list) {
              if(sample.list[[l]] == sample.id[k]) total.sample.size = total.sample.size + current.sample.sizes[k]
            }
          }

          data.slice = CreateDataSlice(current.data.scenario, sample.list, parameter, round(total.sample.size * fraction))

        } else {

          # No interim analyses are specified in the analysis model -- simply use the current data scenario
          data.slice = current.data.scenario

        }

        # Loop over the tests specified in the analysis model to compute statistic results
        # if tests are specified in the analysis model
        if (n.tests > 0) {

          # Loop over the tests specified in the analysis model to compute test results (p-values)
          for (test.index in 1:n.tests) {

            # Current test
            current.test = analysis.structure$test[[test.index]]

            # Number of analysis samples specified in the current test
            n.samples = length(current.test$samples)

            # Extract the data frames for the analysis samples specified in the current test
            sample.list = list()

            # Extract the data frames for the analysis samples specified in the current test
            for (sample.index in 1:n.samples) {

              # Number of subsamples within the current analysis sample
              n.subsamples = length(current.test$samples[[sample.index]])

              if (n.subsamples == 1) {

                # If there is only one subsamples, no merging is required, simply select the right analysis sample
                sample.flag.num = match(current.test$samples[[sample.index]],sample.id)
                sample.list[[sample.index]] = data.slice$sample[[sample.flag.num]]$data


              } else {

                # If there are two or more subsamples, these subsamples must be merged first to create analysis samples
                # that are passed to the statistic function

                subsample.flag.num = match(current.test$samples[[sample.index]],sample.id)
                selected.subsamples = lapply(as.list(subsample.flag.num), function(x) data.slice$sample[[x]]$data)

                # Merge the subsamples
                sample.list[[sample.index]] = do.call(rbind, selected.subsamples)

              }

            }

            # Compute the test results (p-values) by calling the function for the current test with the test parameters
            test.results[test.index, analysis.point.index] = do.call(current.test$method,
                                                                     list(sample.list, list("PerformAnalysis",current.test$par)))

          } # End of the loop over the tests

        } # End of the if n.tests>0

        # Loop over the statistics specified in the analysis model to compute statistic results
        # if statistics are specified in the analysis model
        if (n.statistics > 0) {

          for (statistic.index in 1:n.statistics) {

            # Current statistic
            current.statistic = analysis.structure$statistic[[statistic.index]]

            # Number of analysis samples specified in the current statistic
            n.samples = length(current.statistic$samples)

            # Extract the data frames for the analysis samples specified in the current statistic
            sample.list = list()

            for (sample.index in 1:n.samples) {

              # Number of subsamples within the current analysis sample
              n.subsamples = length(current.statistic$samples[[sample.index]])

              if (n.subsamples == 1) {

                # If there is only one subsamples, no merging is required, simply select the right analysis sample
                sample.flag.num = match(current.statistic$samples[[sample.index]],sample.id)
                sample.list[[sample.index]] = data.slice$sample[[sample.flag.num]]$data


              } else {

                # If there are two or more subsamples, these subsamples must be merged first to create analysis samples
                # that are passed to the statistic function

                subsample.flag.num = match(current.statistic$samples[[sample.index]],sample.id)
                selected.subsamples = lapply(as.list(subsample.flag.num), function(x) data.slice$sample[[x]]$data)

                # Merge the subsamples
                sample.list[[sample.index]] = do.call(rbind, selected.subsamples)

              }

            }


            # Compute the statistic results by calling the function for the current statistic with the statistic parameters
            statistic.results[statistic.index, analysis.point.index] = do.call(current.statistic$method,
                                                                               list(sample.list, current.statistic$par))

          } # End of the loop over the statistics

        }    # End of the if n.statistics>0

      } # Loop over interim analyses

      # Assign test names
      if (n.tests > 0) {

        test.results = as.data.frame(test.results)
        rownames(test.results) = test.id

        if (n.analysis.points == 1) {
          colnames(test.results) = "Analysis"
        } else {
          names = rep("", n.analysis.points)
          for (j in 1:n.analysis.points) names[j] = paste0("Analysis ", j)
          colnames(test.results) = names
        }
      } else {

        # No tests are specified in the analysis model
        test.results = NA
      }


      # Assign statistic names
      if (n.statistics > 0) {

        statistic.results = as.data.frame(statistic.results)
        rownames(statistic.results) = statistic.id

        if (n.analysis.points == 1) {
          colnames(statistic.results) = "Analysis"
        } else {
          names = rep("", n.analysis.points)
          for (j in 1:n.analysis.points) names[j] = paste0("Analysis ", j)
          colnames(statistic.results) = names
        }
      } else {
        # No statistics are specified in the analysis model
        statistic.results = NA
      }


      result = list(tests = test.results,
                    statistic = statistic.results)

      result.data.scenario[[scenario.index]] = list(result = result)

    } # Loop over the data scenario factors

    # Loop for each data scenario
    for (data.scenario.index in 1:n.data.scenarios) {

      # If at least one multiplicity adjustment has been specified loop over the analysis scenario factors (multiplicity adjustment)
      if (!is.null(analysis.structure$mult.adjust)) {

        # Create the analysis scenario list (one element for each unique combination of the data and analysis scenario factors)
        result.data.scenario[[data.scenario.index]]$result$tests.adjust = list()

        # Loop for each analysis.scenarios
        for (scenario.index in 1:n.mult.adjust) {

          # Matrix of results (p-values) produced by the tests
          test.results.adj = matrix(0, n.tests, n.analysis.points)

          # Get the current multiplicity adjustment procedure
          current.mult.adjust = analysis.structure$mult.adjust[[scenario.index]]

          # Get the unadjusted pvalues for the current data scenarios
          current.pvalues = result.data.scenario[[data.scenario.index]]$result$tests

          # Loop for each analysis point
          for (analysis.point.index in 1:n.analysis.points) {

            # Number of multiplicity adjustment procedure within the multiplicity adjustment scenarios
            n.mult.adjust.sc = length(current.mult.adjust)

            # Loop for each multiplicity adjustment procedure within the multiplicity adjustment scenarios
            for (mult.adjust.sc in 1:n.mult.adjust.sc) {
              # Apply the multiple testing procedure specified in the current multiplicity adjustment set
              # to the tests specified in this set

              # Extract the p-values for the tests specified in the current multiplicity adjustment set
              pvalues.flag.num = match(current.mult.adjust[[mult.adjust.sc]]$tests, test.id)
              selected.pvalues = current.pvalues[pvalues.flag.num, analysis.point.index]

              if (!is.na(current.mult.adjust[[mult.adjust.sc]]$proc)) {
                test.results.adj[pvalues.flag.num, analysis.point.index] = do.call(current.mult.adjust[[mult.adjust.sc]]$proc, list(selected.pvalues, list("Analysis", current.mult.adjust[[mult.adjust.sc]]$par)))
              }   else {
                # If no multiplicity procedure is defined, there is no adjustment
                test.results.adj[pvalues.flag.num, analysis.point.index] = selected.pvalues
              }
            } # End Loop for each multiplicity adjustment procedure within the multiplicity adjustment scenario
          } # End Loop for each analysis point

          # Assign test names
          if (n.tests > 0) {
            test.results.adj = as.data.frame(test.results.adj)
            rownames(test.results.adj) = test.id
            if (n.analysis.points == 1) {
              colnames(test.results.adj) = "Analysis"
            } else {
              names = rep("", n.analysis.points)
              for (j in 1:n.analysis.points) names[j] = paste0("Analysis ", j)
              colnames(test.results.adj) = names
            }
          } else {
            # No tests are specified in the analysis model
            test.results.adj = NA
          }

          result.data.scenario[[data.scenario.index]]$result$tests.adjust$analysis.scenario[[scenario.index]] = test.results.adj

        } # End Loop for each analysis.scenarios

      } # End if analysis.structure
      else {
        result.data.scenario[[data.scenario.index]]$result$tests.adjust$analysis.scenario[[1]] = result.data.scenario[[data.scenario.index]]$result$tests
      }

    } # End loop for each data scenario

    result.analysis.scenario = result.data.scenario

    return(result.analysis.scenario)
  } # End of the loop over the simulations

  # Stop the cluster
  parallel::stopCluster(cluster.mediana)
  closeAllConnections()

  # Define the analysis scenario grid (unique combinations of the data and analysis scenario factors)
  analysis.scenario.grid = as.data.frame(matrix(0, n.data.scenarios * n.mult.adjust, 4))
  d = data.stack$data.scenario.grid
  analysis.scenario.grid[, 1:3] = d[scenario.grid[,1], ]
  analysis.scenario.grid[, 4] = scenario.grid[,2]

  colnames(analysis.scenario.grid) = c("design.parameter", "outcome.parameter",
                                       "sample.size", "multiplicity.adjustment")

  # Create the analysis stack
  analysis.stack = list(description = "analysis.stack",
                        analysis.set = result.analysis.scenario,
                        analysis.scenario.grid = analysis.scenario.grid,
                        data.structure = data.structure,
                        analysis.structure = analysis.structure,
                        sim.parameters = sim.parameters)

  class(analysis.stack) = "AnalysisStack"
  return(analysis.stack)

}
# End of PerformAnalysis

######################################################################################################################

# Function: LogrankTest .
# Argument: Data set and parameter.
# Description: Computes one-sided p-value based on log-rank test.

LogrankTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]
    # Observed events in Sample 1 (negation of censoring indicators)
    event1 = !sample.list[[1]][, "patient.censor.indicator"]
    event1.complete = event1[stats::complete.cases(outcome1)]
    # Sample size in Sample 1
    n1 = length(outcome1.complete)

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]
    # Observed events in Sample 2 (negation of censoring indicators)
    event2 = !sample.list[[2]][, "patient.censor.indicator"]
    event2.complete = event2[stats::complete.cases(outcome2)]
    # Sample size in Sample 2
    n2 = length(outcome2.complete)

    # Create combined samples of outcomes, censoring indicators (all events are observed) and treatment indicators
    outcome = c(outcome1.complete, outcome2.complete)
    event = c(event1.complete, event2.complete)
    treatment = c(rep(0, n1), rep(1, n2))

    # Apply log-rank test
    surv.test = survival::survdiff(survival::Surv(outcome, event) ~ treatment)

    # Compute one-sided p-value
    result = stats::pchisq(surv.test$chisq, df = 1, lower.tail = FALSE)/2

  }

  else if (call == TRUE) {
    result = list("Log-rank test")
  }

  return(result)
}
# End of LogrankTest

######################################################################################################################

# Function: TTest .
# Argument: Data set and parameter (call type).
# Description: Computes one-sided p-value based on two-sample t-test.

TTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    # One-sided p-value (treatment effect in sample 2 is expected to be greater than in sample 1)
    result = stats::t.test(outcome2.complete, outcome1.complete, alternative = "greater")$p.value
  }
  else if (call == TRUE) {
    result=list("Student's t-test")
  }

  return(result)
}
# End of TTest

######################################################################################################################

# Function: TTestNI .
# Argument: Data set and parameter (call type and non-inferiority margin).
# Description: Computes one-sided p-value based on two-sample t-test with a non-inferiority margin.

TTestNI = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    if (is.na(parameter[[2]]))
      stop("Analysis model: TTestNI test: Non-inferiority margin must be specified.")

    margin = as.numeric(parameter[[2]])


    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    # One-sided p-value (treatment effect in sample 2 is expected to be greater than in sample 1)
    result = stats::t.test(outcome2.complete  + margin, outcome1.complete, alternative = "greater")$p.value
  }
  else if (call == TRUE) {
    result=list("Student's t-test", "Non-inferiority margin = ")
  }

  return(result)
}
# End of TTestNI

######################################################################################################################

# Function: WilcoxTest .
# Argument: Data set and parameter (call type).
# Description: Computes one-sided p-value based on two-sample non-parametric Wilcoxon Mann-Withney test.

WilcoxTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    # One-sided p-value (treatment effect in sample 2 is expected to be greater than in sample 1)
    result = stats::wilcox.test(outcome2.complete, outcome1.complete, alternative = "greater")$p.value
  }
  else if (call == TRUE) {
    result=list("Wilcoxon-Mann-Withney test")
  }

  return(result)
}
# End of WilcoxTest

######################################################################################################################

# Function: PropTest .
# Argument: Data set and parameter (call type and Yates' correction).
# Description: Computes one-sided p-value based on two-sample proportion test.

PropTest = function(sample.list, parameter) {
  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Yates' correction is set up by default to FALSE
    if (is.na(parameter[[2]])) yates = FALSE
    else yates = parameter[[2]]$yates

    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    # One-sided p-value (treatment effect in sample 2 is expected to be greater than in sample 1)
    result = stats::prop.test(c(sum(outcome2.complete), sum(outcome1.complete)),
                       n = c(length(outcome2.complete), length(outcome1.complete)), alternative = "greater", correct = yates)$p.value
  }
  else if (call == TRUE) {

    result=list("Test for proportions")
  }

  return(result)
}
# End of PropTest

######################################################################################################################

# Function: FisherTest .
# Argument: Data set and parameter (call type).
# Description: Computes one-sided p-value based on two-sample Fisher exact test.

FisherTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    # Contingency table
    contingency.data = rbind(cbind(2, outcome2.complete), cbind(1, outcome1.complete))
    contingency.table = table(utils::data[, 1], utils::data[, 2])


    # One-sided p-value (treatment effect in sample 2 is expected to be greater than in sample 1)
    result = stats::fisher.test(contingency.table, alternative = "greater")$p.value
  }
  else if (call == TRUE) {

    result=list("Fisher exact test")
  }

  return(result)
}
# End of FisherTest

######################################################################################################################

# Function: GLMPoissonTest .
# Argument: Data set and parameter (call type).
# Description: Computes one-sided p-value based on Poisson regression.
#' @importFrom stats poisson
GLMPoissonTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    # Data frame
    data.complete = data.frame(rbind(cbind(2, outcome2.complete), cbind(1, outcome1.complete)))
    colnames(data.complete) = c("TRT", "RESPONSE")
    data.complete$TRT=as.factor(data.complete$TRT)

    # One-sided p-value
    result = summary(stats::glm(RESPONSE ~ TRT, data = data.complete, family = poisson))$coefficients["TRT2", "Pr(>|z|)"]/2
  }
  else if (call == TRUE) {

    result=list("Poisson regression test")
  }

  return(result)
}
# End of GLMPoissonTest

######################################################################################################################

# Function: GLMNegBinomTest.
# Argument: Data set and parameter (call type).
# Description: Computes one-sided p-value based on Negative-Binomial regression.

GLMNegBinomTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Sample list is assumed to include two data frames that represent two analysis samples

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]

    # Data frame
    data.complete = data.frame(rbind(cbind(2, outcome2.complete), cbind(1, outcome1.complete)))
    colnames(data.complete) = c("TRT", "RESPONSE")
    data.complete$TRT=as.factor(data.complete$TRT)

    # One-sided p-value
    result = summary(MASS::glm.nb(RESPONSE ~ TRT, data = data.complete))$coefficients["TRT2", "Pr(>|z|)"]/2
  }
  else if (call == TRUE) {

    result=list("Negative-binomial regression test")
  }

  return(result)
}
# End of stats::glmNegBinomTest



######################################################################################################################

# Compute the median based on non-missing values in the combined sample

MedianStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=1)
      stop("Analysis model: Only one sample must be specified in the MedianStat statistic.")

    sample = sample.list[[1]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome = sample[, "outcome"]
    result = stats::median(stats::na.omit(outcome))

  }

  else if (call == TRUE) {
    result = list("Median")
  }

  return(result)
}
# End of MedianStat

######################################################################################################################

# Compute the mean based on non-missing values in the combined sample

MeanStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=1)
      stop("Analysis model : Only one sample must be specified in the MeanStat statistic.")

    sample = sample.list[[1]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome = sample[, "outcome"]
    result = mean(stats::na.omit(outcome))

  }

  else if (call == TRUE) {
    result = list("Mean")
  }

  return(result)
}
# End of MeanStat

######################################################################################################################

# Compute the sd based on non-missing values in the combined sample

SdStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=1)
      stop("Analysis model : Only one sample must be specified in the SdStat statistic.")

    sample = sample.list[[1]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome = sample[, "outcome"]
    result = stats::sd(stats::na.omit(outcome))

  }

  else if (call == TRUE) {
    result = list("SD")
  }

  return(result)
}
# End of SdStat

######################################################################################################################

# Compute the min based on non-missing values in the combined sample

MinStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=1)
      stop("Analysis model : Only one sample must be specified in the MinStat statistic.")

    sample = sample.list[[1]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome = sample[, "outcome"]
    result = min(stats::na.omit(outcome))

  }

  else if (call == TRUE) {
    result = list("Minimum")
  }

  return(result)
}
# End of MinStat

######################################################################################################################

# Compute the min based on non-missing values in the combined sample

MaxStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=1)
      stop("Analysis model : Only one sample must be specified in the MaxStat statistic.")

    sample = sample.list[[1]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome = sample[, "outcome"]
    result = max(stats::na.omit(outcome))

  }

  else if (call == TRUE) {
    result = list("Maximum")
  }

  return(result)
}
# End of MaxStat

######################################################################################################################

# Compute the hazard ratio based on non-missing values in the combined sample

HazardRatioStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=2)
      stop("Analysis model: Two samples must be specified in the HazardRatioStat statistic.")

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]
    # Observed events in Sample 1 (negation of censoring indicators)
    event1 = !sample.list[[1]][, "patient.censor.indicator"]
    event1.complete = event1[stats::complete.cases(outcome1)]
    # Sample size in Sample 1
    n1 = length(outcome1.complete)

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]
    # Observed events in Sample 2 (negation of censoring indicators)
    event2 = !sample.list[[2]][, "patient.censor.indicator"]
    event2.complete = event2[stats::complete.cases(outcome2)]
    # Sample size in Sample 2
    n2 = length(outcome2.complete)

    # Create combined samples of outcomes, censoring indicators (all events are observed) and treatment indicators
    outcome = c(outcome1.complete, outcome2.complete)
    event = c(event1.complete, event2.complete)
    treatment = c(rep(0, n1), rep(1, n2))

    # Get the HR from the Cox-test
    result = 1 / summary(survival::coxph(survival::Surv(outcome, event) ~ treatment))$coef[,"exp(coef)"]

  }

  else if (call == TRUE) {
    result = list("Hazard Ratio")
  }

  return(result)
}
# End of HazardRatioStat

######################################################################################################################

# Compute the log hazard ratio based on non-missing values in the combined sample

EffectSizeEventStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=2)
      stop("Analysis model: Two samples must be specified in the EffectSizeEventStat statistic.")

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]
    # Observed events in Sample 1 (negation of censoring indicators)
    event1 = !sample.list[[1]][, "patient.censor.indicator"]
    event1.complete = event1[stats::complete.cases(outcome1)]
    # Sample size in Sample 1
    n1 = length(outcome1.complete)

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]
    # Observed events in Sample 2 (negation of censoring indicators)
    event2 = !sample.list[[2]][, "patient.censor.indicator"]
    event2.complete = event2[stats::complete.cases(outcome2)]
    # Sample size in Sample 2
    n2 = length(outcome2.complete)

    # Create combined samples of outcomes, censoring indicators (all events are observed) and treatment indicators
    outcome = c(outcome1.complete, outcome2.complete)
    event = c(event1.complete, event2.complete)
    treatment = c(rep(0, n1), rep(1, n2))

    # Get the HR from the Cox-test
    result = log(1 / summary(survival::coxph(survival::Surv(outcome, event) ~ treatment))$coef[,"exp(coef)"])

  }

  else if (call == TRUE) {
    result = list("Effect size")
  }

  return(result)
}
# End of EffectSizeEventStat

######################################################################################################################

# Compute the ratio of effect sizes for continuous based on non-missing values in the combined sample

RatioEffectSizeEventStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=4)
      stop("Analysis model: Four samples must be specified in the RatioEffectSizeEventStat statistic.")

    # Outcomes in Sample 1
    outcome1 = sample.list[[1]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]
    # Observed events in Sample 1 (negation of censoring indicators)
    event1 = !sample.list[[1]][, "patient.censor.indicator"]
    event1.complete = event1[stats::complete.cases(outcome1)]
    # Sample size in Sample 1
    n1 = length(outcome1.complete)

    # Outcomes in Sample 2
    outcome2 = sample.list[[2]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome2.complete = outcome2[stats::complete.cases(outcome2)]
    # Observed events in Sample 2 (negation of censoring indicators)
    event2 = !sample.list[[2]][, "patient.censor.indicator"]
    event2.complete = event2[stats::complete.cases(outcome2)]
    # Sample size in Sample 2
    n2 = length(outcome2.complete)

    # Create combined samples of outcomes, censoring indicators (all events are observed) and treatment indicators
    outcome = c(outcome1.complete, outcome2.complete)
    event = c(event1.complete, event2.complete)
    treatment = c(rep(0, n1), rep(1, n2))

    # Get the HR from the Cox-test
    result1 = log(1 / summary(survival::coxph(survival::Surv(outcome, event) ~ treatment))$coef[,"exp(coef)"])

    # Outcomes in Sample 3
    outcome3 = sample.list[[3]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome3.complete = outcome3[stats::complete.cases(outcome3)]
    # Observed events in Sample 3 (negation of censoring indicators)
    event3 = !sample.list[[3]][, "patient.censor.indicator"]
    event3.complete = event3[stats::complete.cases(outcome3)]
    # Sample size in Sample 3
    n3 = length(outcome3.complete)

    # Outcomes in Sample 4
    outcome4 = sample.list[[4]][, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome4.complete = outcome4[stats::complete.cases(outcome4)]
    # Observed events in Sample 4 (negation of censoring indicators)
    event4 = !sample.list[[4]][, "patient.censor.indicator"]
    event4.complete = event4[stats::complete.cases(outcome4)]
    # Sample size in Sample 4
    n4 = length(outcome4.complete)

    # Create combined samples of outcomes, censoring indicators (all events are observed) and treatment indicators
    outcome = c(outcome3.complete, outcome4.complete)
    event = c(event3.complete, event4.complete)
    treatment = c(rep(0, n3), rep(1, n4))

    # Get the HR from the Cox-test
    result2 = log(1 / summary(survival::coxph(survival::Surv(outcome, event) ~ treatment))$coef[,"exp(coef)"])

    # Caculate the ratio of effect size
    result = result1 / result2

  }

  else if (call == TRUE) {
    result = list("Ratio of effect size")
  }

  return(result)
}
# End of RatioEffectSizeEventStat

######################################################################################################################

# Compute the number of events based on non-missing values in the combined sample

EventCountStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list) == 0)
      stop("Analysis model: One sample must be specified in the EventCountStat statistic.")

    # Merge the samples in the sample list
    sample1 = do.call(rbind, sample.list)

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome1 = sample1[, "outcome"]
    # Remove the missing values due to dropouts/incomplete observations
    outcome1.complete = outcome1[stats::complete.cases(outcome1)]
    # Observed events in Sample 1 (negation of censoring indicators)
    event1 = !sample1[, "patient.censor.indicator"]
    event1.complete = event1[stats::complete.cases(outcome1)]
    # Number of events in Sample 1
    result = sum(event1.complete)

  }

  else if (call == TRUE) {
    result = list("Number of Events")
  }

  return(result)
}
# End of EventCountStat

######################################################################################################################

# Compute the number of patients generated based on non-missing values in the combined sample

PatientCountStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)==0)
      stop("Analysis model: One sample must be specified in the PatientCountStat statistic.")

    # Merge the samples in the sample list
    sample1 = do.call(rbind, sample.list)

    result = nrow(sample1)

  }

  else if (call == TRUE) {
    result = list("Number of Patients")
  }

  return(result)
}
# End of PatientCountStat

######################################################################################################################

# Compute the difference of means between two samples for continuous based on non-missing values in the combined sample

DiffMeanStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=2)
      stop("Analysis model: Two samples must be specified in the DiffMeanStat statistic.")

    # Merge the samples in the sample list
    sample1 = sample.list[[1]]

    # Merge the samples in the sample list
    sample2 = sample.list[[2]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome1 = sample1[, "outcome"]
    outcome2 = sample2[, "outcome"]
    mean1 = mean(stats::na.omit(outcome1))
    mean2 = mean(stats::na.omit(outcome2))
    result = (mean1 - mean2)

  }

  else if (call == TRUE) {
    result = list("Difference of means")
  }

  return(result)
}
# End of DiffMeanStat

######################################################################################################################

# Compute the effect size for continuous based on non-missing values in the combined sample

EffectSizeContStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=2)
      stop("Analysis model: Two samples must be specified in the EffectSizeContStat statistic.")

    # Merge the samples in the sample list
    sample1 = sample.list[[1]]

    # Merge the samples in the sample list
    sample2 = sample.list[[2]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome1 = sample1[, "outcome"]
    outcome2 = sample2[, "outcome"]
    mean1 = mean(stats::na.omit(outcome1))
    mean2 = mean(stats::na.omit(outcome2))
    sdcom = stats::sd(c(stats::na.omit(outcome1),stats::na.omit(outcome2)))
    result = (mean2 - mean1) / sdcom

  }

  else if (call == TRUE) {
    result = list("Effect size")
  }

  return(result)
}
# End of EffectSizeContStat

######################################################################################################################

# Compute the ratio of effect sizes for continuous based on non-missing values in the combined sample

RatioEffectSizeContStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=4)
      stop("Analysis model: Four samples must be specified in the RatioEffectSizeContStat statistic.")

    # Merge the samples in the sample list
    sample1 = sample.list[[1]]

    # Merge the samples in the sample list
    sample2 = sample.list[[2]]

    # Merge the samples in the sample list
    sample3 = sample.list[[3]]

    # Merge the samples in the sample list
    sample4 = sample.list[[4]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome1 = sample1[, "outcome"]
    outcome2 = sample2[, "outcome"]
    mean1 = mean(stats::na.omit(outcome1))
    mean2 = mean(stats::na.omit(outcome2))
    sdcom1 = stats::sd(c(stats::na.omit(outcome1),stats::na.omit(outcome2)))
    result1 = (mean2 - mean1) / sdcom1

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome3 = sample3[, "outcome"]
    outcome4 = sample4[, "outcome"]
    mean3 = mean(stats::na.omit(outcome3))
    mean4 = mean(stats::na.omit(outcome4))
    sdcom2 = stats::sd(c(stats::na.omit(outcome3),stats::na.omit(outcome4)))
    result2 = (mean4 - mean3) / sdcom2

    # Caculate the ratio of effect size
    result = result1 / result2

  }

  else if (call == TRUE) {
    result = list("Ratio of effect size")
  }

  return(result)
}
# End of RatioEffectSizeContStat

######################################################################################################################

# Compute the difference of proportions between two samples for continuous based on non-missing values in the combined sample

DiffPropStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=2)
      stop("Analysis model: Two samples must be specified in the DiffMeanStat statistic.")

    # Merge the samples in the sample list
    sample1 = sample.list[[1]]

    # Merge the samples in the sample list
    sample2 = sample.list[[2]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome1 = sample1[, "outcome"]
    outcome2 = sample2[, "outcome"]
    prop1 = mean(stats::na.omit(outcome1))
    prop2 = mean(stats::na.omit(outcome2))
    result = (prop2 - prop1)
  }

  else if (call == TRUE) {
    result = list("Difference of proportions")
  }

  return(result)
}
# End of DiffMeanStat

######################################################################################################################

# Compute the effect size for binary data based on non-missing values in the combined sample

EffectSizePropStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=2)
      stop("Analysis model: Two samples must be specified in the EffectSizeContStat statistic.")

    # Merge the samples in the sample list
    sample1 = sample.list[[1]]

    # Merge the samples in the sample list
    sample2 = sample.list[[2]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome1 = sample1[, "outcome"]
    outcome2 = sample2[, "outcome"]
    prop1 = mean(stats::na.omit(outcome1))
    prop2 = mean(stats::na.omit(outcome2))
    prop = (prop2 + prop1) / 2
    result = (prop2 - prop1) / sqrt(prop * (1-prop))

  }

  else if (call == TRUE) {
    result = list("Effect size")
  }

  return(result)
}
# End of EffectSizePropStat

# Compute the ratio of effect sizes for proportions based on non-missing values in the combined sample

RatioEffectSizePropStat = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")

  if (call == FALSE | is.na(call)) {

    # Error checks
    if (length(sample.list)!=4)
      stop("Analysis model: Four samples must be specified in the RatioEffectSizePropStat statistic.")

    # Merge the samples in the sample list
    sample1 = sample.list[[1]]

    # Merge the samples in the sample list
    sample2 = sample.list[[2]]

    # Merge the samples in the sample list
    sample3 = sample.list[[3]]

    # Merge the samples in the sample list
    sample4 = sample.list[[4]]

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome1 = sample1[, "outcome"]
    outcome2 = sample2[, "outcome"]
    prop1 = mean(stats::na.omit(outcome1))
    prop2 = mean(stats::na.omit(outcome2))
    prop = (prop2 + prop1) / 2
    result1 = (prop2 - prop1) / sqrt(prop * (1-prop))

    # Select the outcome column and remove the missing values due to dropouts/incomplete observations
    outcome3 = sample3[, "outcome"]
    outcome4 = sample4[, "outcome"]
    prop3 = mean(stats::na.omit(outcome3))
    prop4 = mean(stats::na.omit(outcome4))
    prop = (prop3 + prop4) / 2
    result2 = (prop4 - prop3) / sqrt(prop * (1-prop))

    # Caculate the ratio of effect size
    result = result1 / result2

  }

  else if (call == TRUE) {
    result = list("Ratio of effect size")
  }

  return(result)
}
# End of RatioEffectSizePropStat


######################################################################################################################

# Function: CreateEvaluationStructure.
# Argument: Evaluation model.
# Description: This function is based on the old evaluation_model_extract function. It performs error checks in the evaluation model
# and creates an "evaluation structure", which is an internal representation of the original evaluation model used by all other Mediana functions.

CreateEvaluationStructure = function(evaluation.model) {

  # TO DO Make sure that all criteria IDs are different

  # General set of evaluation model parameters
  general = evaluation.model$general

  if (is.null(evaluation.model$criteria))
    stop("Evaluation model: At least one criterion must be specified.")

  # Extract criterion-specific parameters

  # Number of criteria
  n.criteria = length(evaluation.model$criteria)

  # List of criteria (id, method, test list, statistic list, parameters, result label list)
  criterion = list()

  for (i in 1:n.criteria) {
    # Metric IDs
    if (is.null(evaluation.model$criteria[[i]]$id))
      stop("Evaluation model: IDs must be specified for all criteria.") else id = evaluation.model$criteria[[i]]$id
      # Criteria
      if (is.null(evaluation.model$criteria[[i]]$method)) {
        stop("Evaluation model: Criterion method must be specified for all criteria.")
      } else if (!exists(evaluation.model$criteria[[i]]$method)) {
        stop(paste0("Evaluation model: Criterion function '", evaluation.model$criteria[[i]]$method, "' does not exist."))
      } else if (!is.function(get(as.character(evaluation.model$criteria[[i]]$method), mode = "any"))) {
        stop(paste0("Evaluation model: Criterion function '", evaluation.model$criteria[[i]]$method, "' does not exist."))
      } else {
        method = evaluation.model$criteria[[i]]$method
      }

      # Tests and statistics
      if (is.null(evaluation.model$criteria[[i]]$tests) & is.null(evaluation.model$criteria[[i]]$statistics))
        stop("Evaluation model: Tests or statistics must be specified for all criteria.")

      if (!is.null(evaluation.model$criteria[[i]]$tests)) {
        tests = evaluation.model$criteria[[i]]$tests
      } else {
        tests = NULL
      }

      if (!is.null(evaluation.model$criteria[[i]]$statistics)) {
        statistics = evaluation.model$criteria[[i]]$statistics
      } else {
        statistics = NULL
      }

      # Parameters (optional)
      if (is.null(evaluation.model$criteria[[i]]$par)) {
        par = NA
      } else {
        par = evaluation.model$criteria[[i]]$par
      }

      # Result labels
      if (is.null(evaluation.model$criteria[[i]]$labels)) {
        stop(paste0("Evaluation model: Label must be specified for the criterion ",evaluation.model$criteria[[i]]$id,"."))
      } else {
        labels = evaluation.model$criteria[[i]]$labels
      }

      criterion[[i]] = list(id = id, method = method, tests = tests, statistics = statistics, par = par, labels = labels)
  }

  # Create the evaluation structure
  evaluation.structure = list(description = "evaluation.structure",
                              criterion = criterion,
                              general = general)
  return(evaluation.structure)

}
# End of CreateEvaluationStructure

############################################################################################################################

# Function: MarginalPower.
# Argument: Test results (p-values) across multiple simulation runs (vector or matrix), statistic results (not used in this function),
#       criterion parameter (Type I error rate).
# Description: Compute marginal power for the vector of test results (vector of p-values or each column of the p-value matrix).

MarginalPower = function(test.result, statistic.result, parameter) {

  # Error check
  if (is.null(parameter$alpha)) stop("Evaluation model: MarginalPower: alpha parameter must be specified.")

  alpha = parameter$alpha
  significant = (test.result <= alpha)
  if (is.numeric(test.result)) power = mean(significant, na.rm = TRUE)
  if (is.matrix(test.result)) power = colMeans(significant, na.rm = TRUE)

  return(power)

}
# End of MarginalPower

############################################################################################################################

# Function: DisjunctivePower
# Argument: Test results (p-values) across multiple simulation runs (vector or matrix), statistic results (not used in this function),
#       criterion parameter (Type I error rate).
# Description: Compute disjunctive power for the test results (vector of p-values or each column of the p-value matrix).

DisjunctivePower = function(test.result, statistic.result, parameter) {

  # Error check
  if (is.null(parameter$alpha)) stop("Evaluation model: DisjunctivePower: alpha parameter must be specified.")

  alpha = parameter$alpha

  if (is.numeric(test.result))
    significant = (test.result <= alpha)
  if (is.matrix(test.result))
    significant = (rowSums(test.result <= alpha) > 0)

  power = mean(significant, na.rm = TRUE)
  return(power)
}
# End of DisjunctivePower

############################################################################################################################

# Function: ConjunctivePower
# Argument: Test results (p-values) across multiple simulation runs (vector or matrix), statistic results (not used in this function),
#       criterion parameter (Type I error rate).
# Description: Compute conjunctive power for the test results (vector of p-values or each column of the p-value matrix).

ConjunctivePower = function(test.result, statistic.result, parameter) {

  # Error check
  if (is.null(parameter$alpha)) stop("Evaluation model: ConjunctivePower: alpha parameter must be specified.")

  alpha = parameter$alpha

  if (is.numeric(test.result))
    significant = (test.result <= alpha)
  if (is.matrix(test.result))
    significant = (rowSums(test.result <= alpha) == ncol(test.result))

  power = mean(significant, na.rm = TRUE)
  return(power)
}
# End of ConjunctivePower


############################################################################################################################

# Function: WeightedPower
# Argument: Test results (p-values) across multiple simulation runs (vector or matrix), statistic results (not used in this function),
#       criterion parameter (Type I error rate and weigth).
# Description: Compute weighted power for the test results (vector of p-values or each column of the p-value matrix).

WeightedPower = function(test.result, statistic.result, parameter) {

  # Error check
  if (is.null(parameter$alpha)) stop("Evaluation model: WeightedPower: alpha parameter must be specified.")
  if (is.null(parameter$weight)) stop("Evaluation model: WeightedPower: weight parameter must be specified.")
  if (length(parameter$weight) != ncol(test.result)) stop("Evaluation model: WeightedPower: The number of test weights must be equal to the number of tests.")
  if (sum(parameter$weight) != 1) stop("Evaluation model: WeightedPower: sum of weights must be equal to 1.")

  # Get the parameter
  alpha = parameter$alpha
  weight = parameter$weight

  significant = (test.result <= alpha)
  if (is.numeric(test.result))
    # Only one test is specified and no weight is applied
    power = mean(significant, na.rm = TRUE)
  if (is.matrix(test.result)) {
    # Weights are applied when two or more tests are specified
    # Check if the number of tests equals the number of weights
    marginal.power = colMeans(significant)

    power = sum(marginal.power * weight, na.rm = TRUE)
  }
  return(power)
}

############################################################################################################################

# Function: ExpectedRejPower
# Argument: Test results (p-values) across multiple simulation runs (vector or matrix), statistic results (not used in this function),
#       criterion parameter (Type I error rate and weigth).
# Description: Compute expected number of rejected hypothesis for the test results (vector of p-values or each column of the p-value matrix).

ExpectedRejPower = function(test.result, statistic.result, parameter) {

  # Error check
  if (is.null(parameter$alpha)) stop("Evaluation model: WeightedPower: alpha parameter must be specified.")

  # Get the parameter
  alpha = parameter$alpha
  ntests = ncol(test.result)
  weight = rep(1/ntests,ntests)

  significant = (test.result <= alpha)
  if (is.numeric(test.result))
    # Only one test is specified and no weight is applied
    power = mean(significant, na.rm = TRUE)
  if (is.matrix(test.result)) {
    # Weights are applied when two or more tests are specified
    # Check if the number of tests equals the number of weights
    marginal.power = colMeans(significant)
    power = ntests * sum(marginal.power * weight, na.rm = TRUE)
  }
  return(power)
}


############################################################################################################################

# Function: InfluencePower
# Argument: Test results (p-values) across multiple simulation runs (vector or matrix), statistic results,
#       criterion parameter (Influence cutoff).
# Description: Compute probability that the influence condition is met.

InfluencePower = function(test.result, statistic.result, parameter) {

  # Error check
  if (is.null(parameter$alpha)) stop("Evaluation model: InfluencePower: alpha parameter must be specified.")
  if (is.null(parameter$cutoff)) stop("Evaluation model: InfluencePower: cutoff parameter must be specified.")

  alpha = parameter$alpha
  cutoff_influence  = parameter$cutoff

  significant = ((test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] >= cutoff_influence) | (test.result[,1] <= alpha & test.result[,2] > alpha))


  power = mean(significant)
  return(power)
}
# End of InfluencePower

############################################################################################################################

# Function: InteractionPower
# Argument: Test results (p-values) across multiple simulation runs (vector or matrix), statistic results,
#       criterion parameter (Influence cutoff).
# Description: Compute probability that the interaction condition is met.

InteractionPower = function(test.result, statistic.result, parameter) {

  # Error check
  if (is.null(parameter$alpha)) stop("Evaluation model: InteractionPower: alpha parameter must be specified.")
  if (is.null(parameter$cutoff_influence)) stop("Evaluation model: InteractionPower: cutoff_influence parameter must be specified.")
  if (is.null(parameter$cutoff_interaction)) stop("Evaluation model: InteractionPower: cutoff_interaction parameter must be specified.")

  alpha = parameter$alpha
  cutoff_influence  = parameter$cutoff_influence
  cutoff_interaction  = parameter$cutoff_interaction

  significant = (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] >= cutoff_influence & statistic.result[,2] >= cutoff_interaction)

  power = mean(significant)
  return(power)
}
# End of InteractionPower

############################################################################################################################

# Function: RestrictedClaimPower
# Argument: Test results (p-values) across multiple simulation runs (vector or matrix), statistic results,
#       criterion parameter (Type I error rate and Influence cutoff).
# Description: Compute probability of restricted claim (new treatment is effective in the target population only)

RestrictedClaimPower = function(test.result, statistic.result, parameter) {

  # Error check
  if (is.null(parameter$alpha)) stop("Evaluation model: RestrictedClaimPower: alpha parameter must be specified.")
  if (is.null(parameter$cutoff_influence)) stop("Evaluation model: RestrictedClaimPower: cutoff parameter must be specified.")

  alpha = parameter$alpha
  cutoff_influence  = parameter$cutoff_influence

  significant = ((test.result[,1] > alpha & test.result[,2] <= alpha) | (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] < cutoff_influence))

  power = mean(significant)
  return(power)
}
# End of RestrictedClaimPower

############################################################################################################################

# Function: BroadClaimPower
# Argument: Test results (p-values) across multiple simulation runs (vector or matrix), statistic results,
#       criterion parameter (Type I error rate and Influence cutoff).
# Description: Compute probability of broad claim (new treatment is effective in the overall population without substantial effect in the subgroup of interest)

BroadClaimPower = function(test.result, statistic.result, parameter) {

  # Error check
  if (is.null(parameter$alpha)) stop("Evaluation model: BroadClaimPower: alpha parameter must be specified.")
  if (is.null(parameter$cutoff_influence)) stop("Evaluation model: BroadClaimPower: cutoff_influence parameter must be specified.")
  if (is.null(parameter$cutoff_interaction)) stop("Evaluation model: BroadClaimPower: cutoff_interaction parameter must be specified.")

  alpha = parameter$alpha
  cutoff_influence  = parameter$cutoff_influence
  cutoff_interaction  = parameter$cutoff_interaction

  significant = ((test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] >= cutoff_influence & statistic.result[,2] < cutoff_interaction) | (test.result[,1] <= alpha & test.result[,2] > alpha))

  power = mean(significant)
  return(power)
}
# End of BroadClaimPower


############################################################################################################################

# Function: EnhancedClaimPower
# Argument: Test results (p-values) across multiple simulation runs (vector or matrix), statistic results,
#       criterion parameter (Type I error rate and Influence cutoff).
# Description: Compute probability of enhanced claim (new treatment is effective in the overall population with substantial effect in the subgroup of interest)

EnhancedClaimPower = function(test.result, statistic.result, parameter) {

  # Error check
  if (is.null(parameter$alpha)) stop("Evaluation model: EnhancedClaimPower: alpha parameter must be specified.")
  if (is.null(parameter$cutoff_influence)) stop("Evaluation model: EnhancedClaimPower: cutoff_influence parameter must be specified.")
  if (is.null(parameter$cutoff_interaction)) stop("Evaluation model: EnhancedClaimPower: cutoff_interaction parameter must be specified.")

  alpha = parameter$alpha
  cutoff_influence  = parameter$cutoff_influence
  cutoff_interaction  = parameter$cutoff_interaction

  significant = (test.result[,1] <= alpha & test.result[,2] <= alpha & statistic.result[,1] >= cutoff_influence & statistic.result[,2] >= cutoff_interaction)

  power = mean(significant)
  return(power)
}
# End of EnhancedClaimPower


############################################################################################################################

# Function: MedianSumm.
# Argument: Descriptive statistics across multiple simulation runs (vector or matrix), method parameters (not used in this function).
# Description: Compute median for the vector of statistics or in each column of the matrix.

MedianSumm = function(test.result, statistic.result, parameter) {

  result = apply(statistic.result, 2, stats::median)
  return(result)
}
# End of MedianSumm

############################################################################################################################

# Function: MeanSumm.
# Argument: Descriptive statistics across multiple simulation runs (vector or matrix), method parameters (not used in this function).
# Description: Compute mean for the vector of statistics or in each column of the matrix.

MeanSumm = function(test.result, statistic.result, parameter) {

  result = apply(statistic.result, 2, mean)
  return(result)
}
# End of MeanSumm

############################################################################################################################

# Function: seq_vector.
# Argument: Number.
# Description: Generate simple number sequence.

seq_vector = function(n) {
  1:n
}

############################################################################################################################

# Function: CreateTableSampleSize .
# Argument: data.strucure and label (optional).
# Description: Generate a summary table of sample size for the report.

CreateTableSampleSize = function(data.structure, label = NULL) {

  # Number of sample ID
  n.id <- length(data.structure$id)
  id.label = c(unlist(lapply(lapply(data.structure$id, unlist), paste0, collapse = ", ")))

  if (!any(is.na(data.structure$sample.size.set))){
    # Number of sample size
    n.sample.size = nrow(data.structure$sample.size.set)

    # Label
    if (is.null(label)) label = paste0("Sample size ", 1:n.sample.size)
    else label = unlist(label)
    if (length(label) != n.sample.size)
      stop("Summary: Number of the sample size labels must be equal to the number of sample size sets.")

    # Summary table
    sample.size.table <- matrix(nrow = n.id*n.sample.size, ncol = 4)
    ind <-1
    for (i in 1:n.sample.size) {
      for (j in 1:n.id) {
        sample.size.table[ind, 1] = i
        sample.size.table[ind, 2] = label[i]
        sample.size.table[ind, 3] = id.label[j]
        sample.size.table[ind, 4] = data.structure$sample.size.set[i,j]
        ind <- ind+1
      }
    }

    sample.size.table = as.data.frame(sample.size.table)
    colnames(sample.size.table) = c("sample.size","Sample size set", "Sample", "Size")
  }
  else if (!any(is.na(data.structure$event.set))){
    # Number of sample size
    n.events = nrow(data.structure$event.set)

    # Label
    if (is.null(label)) label = paste0("Event ", 1:n.events)
    else label = unlist(label)
    if (length(label) != n.events)
      stop("Summary: Number of the events labels must be equal to the number of events sets.")

    # Summary table
    sample.size.table <- matrix(nrow = n.events, ncol = 3)
    ind <-1
    for (i in 1:n.events) {
      sample.size.table[i, 1] = i
      sample.size.table[i, 2] = label[i]
      sample.size.table[i, 3] = data.structure$event[i,1]
    }

    sample.size.table = as.data.frame(sample.size.table)
    colnames(sample.size.table) = c("sample.size","Event set", "Total number of events")
  }


  return(sample.size.table)
}
# End of CreateTableSampleSize

############################################################################################################################

# Function: CreateTableOutcome.
# Argument: data.strucure and label (optional).
# Description: Generate a summary table of outcome parameters for the report.

CreateTableOutcome = function(data.structure, label = NULL) {

  # Number of sample ID
  n.id <- length(data.structure$id)
  id.label = c(unlist(lapply(lapply(data.structure$id, unlist), paste0, collapse = ", ")))

  # Number of outcome
  n.outcome = length(data.structure$outcome.parameter.set)

  # Dummy call of the function to get the description
  dummy.function.call = list("description", data.structure$outcome.parameter.set[[1]][[1]])
  outcome.dist.desc = do.call(data.structure$outcome$outcome.dist, list(dummy.function.call))
  parameter.labels = outcome.dist.desc[[1]]
  outcome.dist.name = outcome.dist.desc[[2]]

  # Label
  if (is.null(label)) label = paste0("Outcome ", 1:n.outcome)
  else label = unlist(label)
  if (length(label) != n.outcome)
    stop("Summary: Number of the outcome parameters labels must be equal to the number of outcome parameters sets.")

  # Summary table
  outcome.table <- matrix(nrow = n.id*n.outcome, ncol = 4)
  ind <-1

  if (data.structure$outcome$outcome.dist.dim == 1) {
    for (i in 1:n.outcome) {
      for (j in 1:n.id) {
        outcome.table[ind, 1] = i
        outcome.table[ind, 2] = label[i]
        outcome.table[ind, 3] = id.label[j]
        outcome.table[ind, 4] = mergeOutcomeParameter(parameter.labels,  data.structure$outcome.parameter.set[[i]][[j]])
        ind<-ind+1
      }
    }
  }
  if (data.structure$outcome$outcome.dist.dim > 1) {
    for (i in 1:n.outcome) {
      for (j in 1:n.id) {
        par = paste0(mapply(mergeOutcomeParameter, parameter.labels$par, data.structure$outcome.parameter.set[[i]][[j]]$par), collapse = ", ")
        corr = paste0("corr = {", paste(t(data.structure$outcome.parameter.set[[i]][[j]]$corr), collapse = ","),"}", collapse = "")
        outcome.table[ind, 1] = i
        outcome.table[ind, 2] = label[i]
        outcome.table[ind, 3] = id.label[j]
        outcome.table[ind, 4] = paste0(par, ", ",corr)
        ind<-ind+1
      }
    }
  }

  outcome.table= as.data.frame(outcome.table)
  colnames(outcome.table) = c("outcome.parameter","Outcome parameter set", "Sample", "Parameter")

  return(list(outcome.dist.name,outcome.table))
}
# End of CreateTableOutcome


############################################################################################################################

# Function: CreateTableDesign.
# Argument: data.strucure and label (optional).
# Description: Generate a summary table of design parameters for the report.

CreateTableDesign = function(data.structure, label = NULL) {

  # Number of design
  n.design = length(data.structure$design.parameter.set)

  # Label
  if (is.null(label)) label = paste0("Design ", 1:n.design)
  else label = unlist(label)
  if (length(label) != n.design)
    stop("Summary: Number of the design parameters labels must be equal to the number of design parameters sets.")

  # Summary table
  design.table <- matrix(nrow = n.design, ncol = 9)

  design.parameter.set = data.structure$design.parameter.set

  for (i in 1:n.design) {
    design.table[i, 1] = i
    design.table[i, 2] = label[i]
    design.table[i, 3] = design.parameter.set[[i]]$enroll.period
    if (design.parameter.set[[i]]$enroll.dist=="UniformDist") enroll.dist.par.dummy = list(max = design.parameter.set[[i]]$enroll.period)
    else enroll.dist.par.dummy = design.parameter.set[[i]]$enroll.dist.par
    enroll.dist.desc = do.call(design.parameter.set[[i]]$enroll.dist,list(list("description",enroll.dist.par.dummy)))
    design.table[i, 4] = unlist(enroll.dist.desc[[2]])
    if (!is.na(design.parameter.set[[i]]$enroll.dist.par)){
      enroll.dist.npar = length(enroll.dist.desc[[1]][[1]])
      enroll.dist.par = ""
      for (j in 1: enroll.dist.npar){
        enroll.dist.par = paste0(", ",enroll.dist.desc[[1]][[1]][j],"=",design.parameter.set[[i]]$enroll.dist.par[j])
      }
      enroll.dist.par = sub(", ","",enroll.dist.par)
      design.table[i, 5] = enroll.dist.par
    }
    else design.table[i, 5] = design.parameter.set[[i]]$enroll.dist.par
    design.table[i, 6] = design.parameter.set[[i]]$followup.period
    design.table[i, 7] = design.parameter.set[[i]]$study.duration
    dropout.dist.desc = do.call(design.parameter.set[[i]]$dropout.dist,list(list("description",design.parameter.set[[i]]$dropout.dist.par)))
    design.table[i, 8] = unlist(dropout.dist.desc[[2]])
    dropout.dist.npar = length(dropout.dist.desc[[1]][[1]])
    dropout.dist.par = ""
    for (j in 1: dropout.dist.npar){
      dropout.dist.par = paste0(", ",dropout.dist.desc[[1]][[1]][j],"=",design.parameter.set[[i]]$dropout.dist.par[j])
    }
    dropout.dist.par = sub(", ","",dropout.dist.par)
    design.table[i, 9] = dropout.dist.par
  }
  design.table = as.data.frame(design.table)
  colnames(design.table) = c("design.parameter", "Design parameter set", "Enrollment period", "Enrollment distribution", "Enrollment distribution parameter", "Follow-up period", "Study duration", "Dropout distribution", "Dropout distribution parameter")
  return(design.table)
}
# End of CreateTableDesign

############################################################################################################################

# Function: CreateTableTest.
# Argument: analysis.strucure and label (optional).
# Description: Generate a summary table of test for the report.

CreateTableTest = function(analysis.structure, label = NULL) {

  # Number of test
  n.test = length(analysis.structure$test)

  test.table = matrix(nrow = n.test, ncol = 4)
  nsample = rep(0,n.test)
  for (i in 1:n.test) {
    test.table[i, 1] = analysis.structure$test[[i]]$id
    test.desc = do.call(analysis.structure$test[[i]]$method,list(c(),list("Description",analysis.structure$test[[i]]$par)))
    test.table[i, 2] = test.desc[[1]]
    if (length(test.desc)>1) {
      test.table[i, 3] = paste0(test.desc[[2]],analysis.structure$test[[i]]$par)
    } else {
      test.table[i, 3] = analysis.structure$test[[i]]$par
    }
    nsample[i]=length(analysis.structure$test[[i]]$samples)
    npersample=rep(0,nsample[i])
    sample.id=rep("",nsample[i])
    text=""
    for (j in 1:nsample[i]) {
      npersample[j]=length(analysis.structure$test[[i]]$samples[[j]])
      for (k in 1:npersample[j]) {
        sample.id[j]=paste0(sample.id[j],", ", analysis.structure$test[[i]]$samples[[j]][[k]])
      }
      sample.id[j]=paste0("{",sub(", ","",sample.id[j]),"}")
      text=paste0(text,", ",sample.id[j])
    }
    test.table[i, 4] = sub(", ","",text)
  }

  test.table = as.data.frame(test.table)
  colnames(test.table) = c("Test ID", "Test type", "Test parameters", "Samples")
  return(test.table)
}
# End of CreateTableTest


############################################################################################################################

# Function: CreateTableStatistic.
# Argument: analysis.strucure and label (optional).
# Description: Generate a summary table of statistic for the report.

CreateTableStatistic = function(analysis.structure, label = NULL) {

  # Number of statistic
  n.statistic = length(analysis.structure$statistic)

  statistic.table = matrix(nrow = n.statistic, ncol = 4)
  nsample = rep(0,n.statistic)
  for (i in 1:n.statistic) {
    statistic.table[i, 1] = analysis.structure$statistic[[i]]$id
    statistic.desc = do.call(analysis.structure$statistic[[i]]$method,list(c(),list("Description",analysis.structure$statistic[[i]]$par)))
    statistic.table[i, 2] = statistic.desc[[1]]
    if (length(statistic.desc)>1) {
      statistic.table[i, 3] = paste0(statistic.desc[[2]],analysis.structure$statistic[[i]]$par)
    } else {
      statistic.table[i, 3] = analysis.structure$statistic[[i]]$par
    }
    nsample[i]=length(analysis.structure$statistic[[i]]$samples)
    npersample=rep(0,nsample[i])
    sample.id=rep("",nsample[i])
    text=""
    for (j in 1:nsample[i]) {
      npersample[j]=length(analysis.structure$statistic[[i]]$samples[[j]])
      for (k in 1:npersample[j]) {
        sample.id[j]=paste0(sample.id[j],", ", analysis.structure$statistic[[i]]$samples[[j]][[k]])
      }
      sample.id[j]=paste0("{",sub(", ","",sample.id[j]),"}")
      text=paste0(text,", ",sample.id[j])
    }
    statistic.table[i, 4] = sub(", ","",text)
  }

  statistic.table = as.data.frame(statistic.table)
  colnames(statistic.table) = c("Statistic ID", "Statistic type", "Statistic parameters", "Samples")
  return(statistic.table)
}
# End of CreateTableStatistic

######################################################################################################################

# Function: CreateTableStructure.
# Argument: Results returned by the CSE function and presentation model.
# Description: This function is used to create the tables for each section/subsection

CreateTableStructure = function(results = NULL, presentation.model = NULL, custom.label.sample.size = NULL, custom.label.design.parameter = NULL, custom.label.outcome.parameter = NULL, custom.label.multiplicity.adjustment = NULL){

  # TO DO: Add checks on parameters

  # Get analysis scenario grid and add a scenario number to the dataframe
  analysis.scenario.grid = results$analysis.scenario.grid
  analysis.scenario.grid$scenario = as.numeric(rownames(results$analysis.scenario.grid))
  analysis.scenario.grid$all = 1

  # Apply the label on the scenario grid
  analysis.scenario.grid.label = analysis.scenario.grid
  analysis.scenario.grid.label$design.parameter.label = as.factor(analysis.scenario.grid.label$design.parameter)
  analysis.scenario.grid.label$outcome.parameter.label = as.factor(analysis.scenario.grid.label$outcome.parameter)
  analysis.scenario.grid.label$sample.size.label = as.factor(analysis.scenario.grid.label$sample.size)
  analysis.scenario.grid.label$multiplicity.adjustment.label = as.factor(analysis.scenario.grid.label$multiplicity.adjustment)
  levels(analysis.scenario.grid.label$design.parameter.label) = custom.label.design.parameter$label
  levels(analysis.scenario.grid.label$outcome.parameter.label) = custom.label.outcome.parameter$label
  levels(analysis.scenario.grid.label$sample.size.label) = custom.label.sample.size$label
  levels(analysis.scenario.grid.label$multiplicity.adjustment.label) = custom.label.multiplicity.adjustment$label
  analysis.scenario.grid.label$all.label = as.factor(analysis.scenario.grid.label$all)

  # Create the summary table with all results
  #summary.table = CreateSummaryTable(results$evaluation.set$analysis.scenario)
  summary.table = merge(results$simulation.results,analysis.scenario.grid.label, by = c("sample.size", "outcome.parameter", "design.parameter", "multiplicity.adjustment"))
  summary.table$result = format(round(summary.table$result, digits = 4), digits = 4, nsmall = 4)

  # Check if Sample Size or event has been used to set the column names
  sample.size = (!any(is.na(results$data.structure$sample.size.set)))
  event = (!any(is.na(results$data.structure$event.set)))

  # Get the "by"
  section.by = presentation.model$section.by$by
  if (is.null(section.by)) {
    section.by = "all"
    custom.label.all = list(label = "Results", custom = FALSE)
  }
  subsection.by = presentation.model$subsection.by$by
  table.by = presentation.model$table.by$by

  # If the user used event, the "by" "event" need to be changed by "sample.size" as the
  if (event) {
    if (!is.null(section.by)) section.by = gsub("event","sample.size",section.by)
    if (!is.null(subsection.by)) subsection.by = gsub("event","sample.size",subsection.by)
    if (!is.null(table.by)) table.by = gsub("event","sample.size",table.by)
  }

  # Create a list with scenario number for all sections
  # This list will get the number of scenarios defined by the user for each parameters
  section.par = list()
  if (!is.null(section.by)){
    for (i in 1:length(section.by)){
      section.par[[i]] = levels(analysis.scenario.grid.label[,paste0(section.by[i],".label")])
    }
  } else section.par = NULL


  # Create the combination of scenario for each section
  section.create = rev(expand.grid(rev(section.par)))
  colnames(section.create) = section.by
  section.create$section = 1:nrow(section.create)
  # Create the title for the section
  section.by.label = sapply(gsub("."," ",section.by,fixed = TRUE),capwords)
  if(get(paste0("custom.label.",section.by)[1])$custom) {
    title = paste0(section.by.label[1]," (",section.create[,1],")")
  } else {
    title = paste0(section.by.label[1]," ",1:max(analysis.scenario.grid[,section.by[[1]][1]]))
  }
  if (length(section.by)>1) {
    for (i in 2:length(section.by)){
      if(get(paste0("custom.label.",section.by)[i])$custom) {
        title = paste0(title," and ",section.by.label[i]," (",section.create[,i],")")
      } else {
        title = paste0(title," and ",section.by.label[i]," ",1:max(analysis.scenario.grid[,section.by[[i]][1]]))
      }
    }
  }
  section.create$title.section = title
  if (any(section.by == "all"))  section.create$title.section = "Results"


    # Create a list with scenario number for all subsections
    subsection.create = NULL
    if (!is.null(subsection.by)){
      # This list will get the number of scenarios defined by the user for each parameters
      subsection.par = list()
      for (i in 1:length(subsection.by)){
        subsection.par[[i]] = levels(analysis.scenario.grid.label[,paste0(subsection.by[i],".label")])
      }

      # Create the combination of scenario for each subsection
      subsection.create = rev(expand.grid(rev(subsection.par)))
      colnames(subsection.create) = subsection.by
      subsection.create$subsection = 1:nrow(subsection.create)
      # Create the title for the subsection
      subsection.by.label = sapply(gsub("."," ",subsection.by,fixed = TRUE),capwords)
      if(get(paste0("custom.label.",subsection.by)[1])$custom) {
        title = paste0(subsection.by.label[1]," (",subsection.create[,1],")")
      } else {
        title = paste0(subsection.by.label[1]," ",1:max(analysis.scenario.grid[,subsection.by[[1]][1]]))
      }
      if (length(subsection.by)>1) {
        for (i in 2:length(subsection.by)){
          if(get(paste0("custom.label.",subsection.by)[i])$custom) {
            title = paste0(title," and ",subsection.by.label[i]," (",subsection.create[,i],")")
          } else {
            title = paste0(title," and ",subsection.by.label[i]," ",1:max(analysis.scenario.grid[,subsection.by[[i]][1]]))
          }
        }
      }
      subsection.create$title.subsection = title
    }

  # Create a list with order tables
  # If the user did not define any parameter to sort the table, the parameters not defined in the section or subsection will be used to sort the table by default
  table.by=c(table.by, colnames(analysis.scenario.grid.label[which(!(colnames(analysis.scenario.grid) %in% c(section.by, subsection.by, table.by, "scenario")))]))
  # If no design or no multiplicity adjustment have been defined, we can delete them from the table.by
  if (is.null(results$analysis.structure$mult.adjust)) table.by=table.by[which(table.by!="multiplicity.adjustment")]
  if (is.null(results$data.structure$design.parameter.set)) table.by=table.by[which(table.by!="design.parameter")]
  if (any(section.by != "all")) table.by=table.by[which(table.by!="all")]

  table.create = NULL
  if (length(table.by)>0){
    # This list will get the number of scenarios defined by the user for each parameters
    table.par = list()
    for (i in 1:length(table.by)){
      table.par[[i]] = as.numeric(levels(as.factor(analysis.scenario.grid.label[,table.by[i]])))
    }
    # Create the combination of scenario for each table
    table.create = rev(expand.grid(rev(table.par)))
    colnames(table.create) = table.by
  }


  # Create report structure
  if(!is.null(subsection.create)){
    report.structure = rev(merge(subsection.create,section.create,by=NULL,suffixes = c(".subsection",".section")))
  } else report.structure = section.create

  # Get the scenario number for each section/subsection
  report.structure.scenario = list()
  for (i in 1:nrow(report.structure)){
    report.structure.temp = as.data.frame(report.structure[i,])
    colnames(report.structure.temp) = paste0(colnames(report.structure),".label")
    report.structure.scenario[[i]] = as.vector(merge(analysis.scenario.grid.label,report.structure.temp)$scenario)
  }

  # Create a list containing the table to report under each section/subsection
  report.structure.scenario.summary.table = list()
  for (i in 1:nrow(report.structure)){
    report.structure.scenario.summary.table[[i]] = summary.table[which(summary.table$scenario %in% report.structure.scenario[[i]]),c(table.by,"criterion","test.statistic","result")]
    colnames(report.structure.scenario.summary.table[[i]])=c(sapply(gsub("."," ",table.by,fixed = TRUE),capwords),"Criterion","Test/Statistic","Result")
    rownames(report.structure.scenario.summary.table[[i]])=NULL
  }

  # Order the table as requested by the user
  if (length(table.by)>0){
    table.by.label = sapply(gsub("."," ",table.by,fixed = TRUE),capwords)
    data.order = as.data.frame(report.structure.scenario.summary.table[[1]][,table.by.label])
    colnames(data.order) = table.by
    order.table = order(apply(data.order, 1, paste, collapse = ""))
    report.structure.scenario.summary.table.order = lapply(report.structure.scenario.summary.table,function(x) x[order.table,])
  } else report.structure.scenario.summary.table.order = report.structure.scenario.summary.table

  # Add the labels
  report.structure.scenario.summary.table.order = lapply(report.structure.scenario.summary.table.order, function(x) {
    if ("Design Parameter" %in% colnames(x)) {
      x[,"Design Parameter"] = as.factor(x[,"Design Parameter"])
      levels(x[,"Design Parameter"]) = custom.label.design.parameter$label
    }
    if ("Outcome Parameter" %in% colnames(x)) {
      x[,"Outcome Parameter"] = as.factor(x[,"Outcome Parameter"])
      levels(x[,"Outcome Parameter"]) = custom.label.outcome.parameter$label
    }
    if ("Sample Size" %in% colnames(x)) {
      x[,"Sample Size"] = as.factor(x[,"Sample Size"])
      levels(x[,"Sample Size"]) = custom.label.sample.size$label
    }
    if ("Multiplicity Adjustment" %in% colnames(x)) {
      x[,"Multiplicity Adjustment"] = as.factor(x[,"Multiplicity Adjustment"])
      levels(x[,"Multiplicity Adjustment"]) = custom.label.multiplicity.adjustment$label
    }

    return(x) })


  # Change the Sample Size column name if Event has been used
  ChangeColNames = function(x) {
    colnames(x)[colnames(x)=="Sample Size"] <- "Event Set"
    x
  }
  if (event) report.structure.scenario.summary.table.order = lapply(report.structure.scenario.summary.table.order, ChangeColNames)

  # Create the object to return, i.e. a list with the parameter of the section/subsection and the table
  res = list()
  for (i in 1:nrow(report.structure)){
    report.structure.temp = as.data.frame(report.structure[i,])
    colnames(report.structure.temp) = colnames(report.structure)
    res[[i]] = list(section = list(number = report.structure.temp$section, title = report.structure.temp$title.section),
                    subsection = list(number = report.structure.temp$subsection, title = report.structure.temp$title.subsection),
                    parameter = as.character(report.structure.temp[,c(section.by, subsection.by)]),
                    results = report.structure.scenario.summary.table.order[[i]])
  }

  # Return the list of results
  return(list(section = section.create, subsection = subsection.create, table.structure = res))
}
# End of CreateTableStructure



######################################################################################################################

# Function: CreateSummaryTable.
# Argument: Results returned by the CSE function.
# Description: This function is used to create a summary table with all results

CreateSummaryTable = function(evaluation.result){
  nscenario = length(evaluation.result)
  table.evaluation.result = list()
  for (i in 1:nscenario){
    ncriterion = length(evaluation.result[[i]]$criterion)
    table.list = list()
    for (j in 1:ncriterion){
      scenario = i
      id = evaluation.result[[i]]$criterion[[j]]$id
      res = format(round(evaluation.result[[i]]$criterion[[j]]$result, digits = 4), digits = 4, nsmall = 4)
      rownames(res) = colnames(res) = NULL
      test = rownames(evaluation.result[[i]]$criterion[[j]]$result)
      table.list[[j]] = data.frame(scenario = scenario, id=rep(id,nrow(res)), test=test, result=res)
    }
    table.evaluation.result[[i]] = do.call(rbind, table.list)
  }
  return(do.call(rbind, table.evaluation.result))
}
# End of CreateSummaryTable

######################################################################################################################



######################################################################################################################
# FUNCTIONS USED BY THE USER (TO BE EXPORTED)

######################################################################################################################

############################################################################################################################

# Function: CSE
# Argument: ....
# Description: This function applies the metrics specified in the evaluation model to the test results (p-values) and
# summaries to the statistic results.
#' @export
CSE = function(data, analysis, evaluation, simulation) {
  UseMethod("CSE")
}

############################################################################################################################

# Function: summary.CSE
# Argument: x, a CSE object.
#' @export
summary.CSE = function(object,...) {
  print(object$simulation.results)
}

############################################################################################################################

# Function: CSE.default
# Argument: Data model (or data stack), analysis model (or analysis stack) and evaluation model.
# Description: This function applies the metrics specified in the evaluation model to the test results (p-values) and
# summaries to the statistic results.
#' @export
CSE.default = function(data, analysis, evaluation, simulation) {

  # Error check
  if (!(class(data) %in% c("DataModel", "DataStack"))) stop("CSE: a DataModel object must be specified in the data parameter")
  if (!(class(analysis) %in% c("AnalysisModel", "AnalysisStack"))) stop("CSE: an AnalysisModel object must be specified in the analysis parameter")
  if (!(class(evaluation) %in% c("EvaluationModel"))) stop("CSE: an EvaluationModel object must be specified in the evaluation parameter")
  if (!(class(simulation) %in% c("SimParameters"))) stop("CSE: a SimParameters object must be specified in the simulation parameter")

  # Start time
  start.time = Sys.time()


  # Perform error checks for the evaluation model and create an internal evaluation structure
  #	(in the first position in order to be sure that if any error is made, the simulation won't run)
  evaluation.structure = CreateEvaluationStructure(evaluation)

  # Case 1: Data model and Analysis model
  if (class(data) == "DataModel" & class(analysis) == "AnalysisModel"){
    data.model = data
    analysis.model = analysis

    # Data structure
    data.structure = CreateDataStructure(data.model)

    # Create the analysis stack from the specified data and analysis models
    analysis.stack = PerformAnalysis(data.model, analysis.model, sim.parameters = simulation)

    # Analysis structure
    analysis.structure = analysis.stack$analysis.structure

    # Simulation parameters
    sim.parameters = analysis.stack$sim.parameters
  }

  # Case 2: Data stack and Analysis model
  if (class(data) == "DataStack" & class(analysis) == "AnalysisModel"){
    data.stack = data
    analysis.model = analysis

    # Data structure
    data.structure = data.stack$data.structure

    # Create the analysis stack from the specified data and analysis models
    analysis.stack = PerformAnalysis(data.stack, analysis.model, sim.parameters = simulation)

    # Analysis structure
    analysis.structure = analysis.stack$analysis.structure

    # Simulation parameters
    sim.parameters = analysis.stack$sim.parameters
  }

  # Case 3: Data stack and Analysis stack
  if (class(data) == "DataStack" & class(analysis) == "AnalysisStack"){
    data.stack = data
    analysis.stack = analysis

    # Data structure
    data.structure = data.stack$data.structure

    # Analysis structure
    analysis.structure = analysis.stack$analysis.structure

    # Simulation parameters
    if (!is.null(simulation))
      warning("The simulation parameters (simulation) defined in the CSE function will be ignored as an analysis stack has been defined.")
    sim.parameters = analysis.stack$sim.parameters
  }

  # Get the number of simulation runs
  n.sims = sim.parameters$n.sims


  # Extract the analysis scenario grid and compute the number of analysis scenarios in this analysis stack
  analysis.scenario.grid = analysis.stack$analysis.scenario.grid
  n.analysis.scenarios = dim(analysis.scenario.grid)[1]

  # Number of outcome parameter sets, sample size sets and design parameter sets
  n.outcome.parameter.sets = length(levels(as.factor(analysis.scenario.grid$outcome.parameter)))
  n.design.parameter.sets = length(levels(as.factor(analysis.scenario.grid$design.parameter)))
  n.sample.size.sets = length(levels(as.factor(analysis.scenario.grid$sample.size)))

  # Number of data scenario
  n.data.scenarios =  n.outcome.parameter.sets*n.sample.size.sets*n.design.parameter.sets

  # Number of multiplicity adjustment procedure
  n.mult.adj = length(levels(as.factor(analysis.scenario.grid$multiplicity.adjustment)))

  # Number of criteria specified in the evaluation model
  n.criteria = length(evaluation.structure$criterion)

  # Criterion IDs
  criterion.id = rep(" ", n.criteria)

  # Check if the tests and statistics referenced in the evaluation model are actually defined in the analysis model

  # Number of tests specified in the analysis model
  n.tests = length(analysis.structure$test)

  # Number of statistics specified in the analysis model
  n.statistics = length(analysis.structure$statistic)

  if(is.null(analysis.structure$test)) {

    # Test IDs
    test.id = " "

  } else {

    # Test IDs
    test.id = rep(" ", n.tests)

    for (test.index in 1:n.tests) {
      test.id[test.index] = analysis.structure$test[[test.index]]$id
    }

  }

  if(is.null(analysis.structure$statistic)) {

    # Statistic IDs
    statistic.id = " "

  } else {

    # Statistic IDs
    statistic.id = rep(" ", n.statistics)

    for (statistic.index in 1:n.statistics) {
      statistic.id[statistic.index] = analysis.structure$statistic[[statistic.index]]$id
    }

  }

  for (criterion.index in 1:n.criteria) {

    current.criterion = evaluation.structure$criterion[[criterion.index]]

    criterion.id[criterion.index] = current.criterion$id

    # Number of tests specified within the current criterion
    n.criterion.tests = length(current.criterion$tests)

    # Number of statistics specified within the current criterion
    n.criterion.statistics = length(current.criterion$statistics)

    if (n.criterion.tests > 0) {
      for (i in 1:n.criterion.tests) {
        if (!(current.criterion$tests[[i]] %in% test.id))
          stop(paste0("Evaluation model: Test '", current.criterion$tests[[i]], "' is not defined in the analysis model."))
      }
    }

    if (n.criterion.statistics > 0) {
      for (i in 1:n.criterion.statistics) {
        if (!(current.criterion$statistics[[i]] %in% statistic.id))
          stop(paste0("Evaluation model: Statistic '", current.criterion$statistics[[i]], "' is not defined in the analysis model."))
      }
    }

  }

  # Number of analysis points (total number of interim and final analyses)
  if (!is.null(analysis.structure$interim.analysis)) {
    n.analysis.points = length(analysis.structure$interim.analysis$interim.looks$fraction)
  } else {
    # No interim analyses
    n.analysis.points = 1
  }

  # Create the evaluation stack (list of evaluation results for each analysis scenario in the analysis stack)
  #evaluation.set = list()

  # List of analysis scenarios
  analysis.scenario = list()

  analysis.scenario.index = 0

  # Loop over the data scenarios
  for (data.scenario.index in 1:n.data.scenarios) {

    # Loop over the multiplicity adjustment
    for (mult.adj.index in 1:n.mult.adj) {

      analysis.scenario.index =  analysis.scenario.index +1

      # List of criteria
      criterion = list()


      # Loop over the criteria
      for (criterion.index in 1:n.criteria) {


        # Current metric
        current.criterion = evaluation.structure$criterion[[criterion.index]]

        # Number of tests specified in the current criterion
        n.criterion.tests = length(current.criterion$tests)

        # Number of statistics specified in the current criterion
        n.criterion.statistics = length(current.criterion$statistics)

        # Create a matrix of test results (p-values) across the simulation runs for the current criterion and analysis scenario
        if (n.criterion.tests > 0) {

          test.result.matrix = matrix(0, n.sims, n.criterion.tests)

          # Create a template for selecting the test results (p-values)
          test.result.flag = lapply(analysis.structure$test, function(x) any(current.criterion$tests == x$id))
          test.result.flag.num = match(current.criterion$tests,test.id)


        } else {
          test.result.matrix = NA
          test.result.flag = NA
          test.result.flag.num = NA
        }

        # Create a matrix of statistic results across the simulation runs for the current criterion and analysis scenario
        if (n.criterion.statistics > 0) {

          statistic.result.matrix = matrix(0, n.sims, n.criterion.statistics)

          # Create a template for selecting the statistic results
          statistic.result.flag = lapply(analysis.structure$statistic, function(x) any(current.criterion$statistics == x$id))
          statistic.result.flag.num = match(current.criterion$statistics ,statistic.id)

        } else {
          statistic.result.matrix = NA
          statistic.result.flag = NA
          statistic.result.flag.num = NA
        }

        # Loop over the analysis points
        for(analysis.point.index in 1:n.analysis.points){

          # Loop over the simulation runs
          for (sim.index in 1:n.sims) {

            # Current analysis scenario
            current.analysis.scenario = analysis.stack$analysis.set[[sim.index]][[data.scenario.index]]$result$tests.adjust$analysis.scenario[[mult.adj.index]]

            # Extract the tests specified in the current criterion
            if (n.criterion.tests > 0) {
              #test.result.matrix[sim.index, ] = current.analysis.scenario[test.result.flag, analysis.point.index]
              test.result.matrix[sim.index, ] = current.analysis.scenario[test.result.flag.num, analysis.point.index]
            }

            # Extract the statistics specified in the current criterion
            if (n.criterion.statistics > 0) {
              #statistic.result.matrix[sim.index, ] = analysis.stack$analysis.set[[sim.index]][[data.scenario.index]]$result$statistic[statistic.result.flag, analysis.point.index]
              statistic.result.matrix[sim.index, ] = analysis.stack$analysis.set[[sim.index]][[data.scenario.index]]$result$statistic[statistic.result.flag.num, analysis.point.index]
            }

          } # Loop over the simulation runs

          # Apply the method specified in the current metric with metric parameters
          single.result = as.matrix(do.call(current.criterion$method,
                                            list(test.result.matrix, statistic.result.matrix, current.criterion$par)))

          if (n.analysis.points == 1) {
            # Only one analysis point (final analysis) is specified
            evaluation.results = single.result
          } else {
            # Two or more analysis points (interim and final analyses) are specified
            if (analysis.point.index == 1) {
              evaluation.results = single.result
            } else {
              evaluation.results = cbind(evaluation.results, single.result)
            }
          }

        } # Loop over the analysis points

        evaluation.results = as.data.frame(evaluation.results)

        # Assign labels
        rownames(evaluation.results) = unlist(current.criterion$labels)

        if (n.analysis.points == 1) {
          colnames(evaluation.results) = "Analysis"
        } else {
          names = rep("", n.analysis.points)
          for (j in 1:n.analysis.points) names[j] = paste0("Analysis ", j)
          colnames(evaluation.results) = names
        }

        criterion[[criterion.index]] = list(id = criterion.id[[criterion.index]],
                                            result = evaluation.results)

      } # Loop over the criteria

      analysis.scenario[[analysis.scenario.index]] = list(criterion = criterion)

    } # Loop over the multiplicity adjustment

  } # Loop over the data scenarios

  #evaluation.set = list(analysis.scenario = analysis.scenario)

  # Create a single data frame with simulation results
  simulation.results = data.frame(sample.size = numeric(),
                                  outcome.parameter = numeric(),
                                  design.parameter = numeric(),
                                  multiplicity.adjustment = numeric(),
                                  criterion = character(),
                                  test.statistic = character(),
                                  result = numeric(),
                                  stringsAsFactors = FALSE)

  row.index = 1

  n.analysis.scenarios = length(analysis.scenario)

  for (scenario.index in 1:(n.data.scenarios*n.mult.adj)) {

    current.analysis.scenario = analysis.scenario[[scenario.index]]
    n.criteria = length(current.analysis.scenario$criterion)
    current.analysis.scenario.grid = analysis.scenario.grid[scenario.index, ]

    for (j in 1:n.criteria) {
      n.rows = dim(current.analysis.scenario$criterion[[j]]$result)[1]
      for (k in 1:n.rows) {
        simulation.results[row.index, 1] = current.analysis.scenario.grid[1, 3]
        simulation.results[row.index, 2] = current.analysis.scenario.grid[1, 2]
        simulation.results[row.index, 3] = current.analysis.scenario.grid[1, 1]
        simulation.results[row.index, 4] = current.analysis.scenario.grid[1, 4]
        simulation.results[row.index, 5] = current.analysis.scenario$criterion[[j]]$id
        simulation.results[row.index, 6] = rownames(current.analysis.scenario$criterion[[j]]$result)[k]
        simulation.results[row.index, 7] = current.analysis.scenario$criterion[[j]]$result[k, 1]
        row.index = row.index + 1
      }
    }


  }

  end.time = Sys.time()
  timestamp  = list(start.time = start.time,
                    end.time = end.time,
                    duration = difftime(end.time,start.time, units = "mins"))

  # Create the evaluation stack
  evaluation.stack = list(#description = "CSE",
                          simulation.results = simulation.results,
                          #evaluation.set = evaluation.set,
                          analysis.scenario.grid = analysis.scenario.grid,
                          data.structure = data.structure,
                          analysis.structure = analysis.structure,
                          evaluation.structure = evaluation.structure,
                          sim.parameters = sim.parameters,
                          #env.information = env.information,
                          timestamp = timestamp )

  class(evaluation.stack) = "CSE"
  return(evaluation.stack)

}
# End of CSE

######################################################################################################################

# Functions to create the Data Model (user interface)

######################################################################################################################


######################################################################################################################

# Function: DataModel.
# Argument: ....
# Description: This function is used to call the corresponding function according to the class of the argument.
#' @export
DataModel = function(...) {
  UseMethod("DataModel")
}


######################################################################################################################

# Function: is.DataModel.
# Argument: an object.
# Description: Return if the object is of class DataModel

is.DataModel = function(arg){
  return(any(class(arg)=="DataModel"))
}

######################################################################################################################

# Function: DataModel.default
# Argument: Multiple character strings.
# Description: This function is called by default if the class of the argument is neither an Outcome,
#              nor a SampleSize object.
#' @export
DataModel.default = function(...) {
  args = list(...)
  if (length(args) > 0) {
    stop("Data Model doesn't know how to deal with the parameters")
  }
  else {
    datamodel = structure(list(general = list(outcome.dist = NULL,
                                              outcome.type = NULL,
                                              sample.size = NULL,
                                              event = NULL,
                                              rando.ratio = NULL,
                                              design = NULL),
                               samples = NULL),
                          class = "DataModel")
  }
  return(datamodel)
}

######################################################################################################################

# Function: DataModel.OutcomeDist
# Argument: OutcomeDist object.
# Description: This function is called by default if the class of the argument is an OutcomeDist object.
#' @export
DataModel.OutcomeDist = function(outcome, ...) {
  datamodel = DataModel()
  datamodel = datamodel + outcome

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      datamodel = datamodel + args[[i]]
    }
  }
  return(datamodel)
}

######################################################################################################################

# Function: DataModel.SampleSize
# Argument: SampleSize object.
# Description: This function is called by default if the class of the argument is an SampleSize object.
#' @export
DataModel.SampleSize = function(sample.size, ...) {
  datamodel = DataModel()
  datamodel = datamodel + sample.size

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      datamodel = datamodel + args[[i]]
    }
  }
  return(datamodel)
}

######################################################################################################################

# Function: DataModel.Event
# Argument: Event object.
# Description: This function is called by default if the class of the argument is an Event object.
#' @export
DataModel.Event = function(event, ...) {
  datamodel = DataModel()
  datamodel = datamodel + event

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      datamodel = datamodel + args[[i]]
    }
  }
  return(datamodel)

}

######################################################################################################################

# Function: DataModel.Design
# Argument: Design object.
# Description: This function is called by default if the class of the argument is a Design object.
#' @export
DataModel.Design = function(design, ...) {
  datamodel = DataModel()
  datamodel = datamodel + design

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      datamodel = datamodel + args[[i]]
    }
  }
  return(datamodel)

}


######################################################################################################################

# Function: SampleSize.
# Argument: A list or vector of numeric.
# Description: This function is used to create an object of class SampleSize.
#' @export
SampleSize = function(sample.size) {

  # Error checks
  if (any(!is.numeric(unlist(sample.size)))) stop("SampleSize: sample size must be numeric.")
  if (any(unlist(sample.size) %% 1 !=0)) stop("SampleSize: sample size must be integer.")
  if (any(unlist(sample.size) <=0)) stop("SampleSize: sample size must be strictly positive.")

  class(sample.size) = "SampleSize"
  return(unlist(sample.size))
  invisible(sample.size)

}

######################################################################################################################

# Function: Event.
# Argument: A list or vector of numeric.
# Description: This function is used to create an object of class Event.
#' @export
Event = function(n.events, rando.ratio=NULL) {

  # Error checks
  if (any(!is.numeric(unlist(n.events)))) stop("Event: number of events must be numeric.")
  if (any(unlist(n.events) %% 1 !=0)) stop("Event: number of events must be integer.")
  if (any(unlist(n.events) <=0)) stop("Event: number of events must be strictly positive.")

  if (!is.null(rando.ratio)){
    if (any(!is.numeric(unlist(rando.ratio)))) stop("Event: randomization ratio must be numeric.")
    if (any(unlist(rando.ratio) %% 1 !=0)) stop("Event: randomization ratio must be integer.")
    if (any(unlist(rando.ratio) <=0)) stop("Event: randomization ratio must be strictly positive.")
  }

  event = list(n.events = unlist(n.events), rando.ratio = unlist(rando.ratio))

  class(event) = "Event"
  return(event)
  invisible(event)

}


######################################################################################################################

# Function: Sample.
# Argument: Sample ID, Outcome Parameters, Sample Size.
# Description: This function is used to create an object of class Sample.
#' @export
Sample = function(id, outcome.par,  sample.size = NULL) {

  # Error checks
  if (!is.character(unlist(id))) stop("Sample: sample ID must be character.")
  if (!is.list(outcome.par)) stop("Sample: outcome parameters must be provided in a list.")

  if (!is.null(sample.size)){
    # Error checks
    if (any(!is.numeric(unlist(sample.size)))) stop("Sample: sample size must be numeric.")
    if (any(unlist(sample.size) %% 1 !=0)) stop("Sample: sample size must be integer.")
    if (any(unlist(sample.size) <=0)) stop("Sample: sample size must be strictly positive.")

  }

  sample = list(id = id,
                outcome.par = outcome.par,
                sample.size = sample.size)

  class(sample) = "Sample"
  return(sample)
  invisible(sample)
}

######################################################################################################################

# Function: Design.
# Argument: enroll.period,  enroll.dist, enroll.dist.par, followup.period, study.duration, dropout.dist,
#           dropout.dist.par
# Description: This function is used to create an object of class Design.
#' @export
Design = function(enroll.period = NULL,  enroll.dist = NULL, enroll.dist.par = NULL, followup.period = NULL, study.duration = NULL, dropout.dist = NULL, dropout.dist.par = NULL) {

  # Error checks
  if (!is.null(enroll.period) & !is.numeric(enroll.period)) stop("Design: enrollment period must be numeric.")
  if (!is.null(enroll.dist) & !is.character(enroll.dist)) stop("Design: enrollment distribution must be character.")
  if (!is.null(enroll.dist.par) & !is.list(enroll.dist.par)) stop("Design: enrollment distribution parameters must be provided in a list.")
  if (!is.null(followup.period) & !is.numeric(followup.period)) stop("Design: follow-up period must be provided in a list.")
  if (!is.null(study.duration) & !is.numeric(study.duration)) stop("Design: study duration must be provided in a list.")
  if (!is.null(dropout.dist) & !is.character(dropout.dist)) stop("Design: dropout distribution must be character.")
  if (!is.null(dropout.dist.par) & !is.list(dropout.dist.par)) stop("Design: enrollment distribution parameters must be provided in a list.")
  if (is.null(followup.period) & is.null(study.duration)) stop("Design: follow-up period or study duration must be defined")
  if (!is.null(followup.period) & !is.null(study.duration)) stop("Design: either follow-up period or study duration must be defined")
  if (is.null(enroll.dist) & !is.null(dropout.dist)) stop("Design: Dropout parameters cannot be specified without enrollment parameters.")

    design = list(enroll.period = enroll.period,
                enroll.dist = enroll.dist,
                enroll.dist.par = enroll.dist.par,
                followup.period = followup.period,
                study.duration = study.duration,
                dropout.dist = dropout.dist,
                dropout.dist.par = dropout.dist.par)


  class(design) = "Design"
  return(design)
  invisible(design)

}

######################################################################################################################

# Function: OutcomeDist.
# Argument: Outcome Distribution and Outcome Type
# Description: This function is used to create an object of class Outcome.
#' @export
OutcomeDist = function(outcome.dist, outcome.type = NULL) {

  # Error checks
  if (!is.character(outcome.dist)) stop("Outcome: outcome distribution must be character.")
  if (!is.null(outcome.type) & !is.character(outcome.type)) stop("Outcome: outcome type must be character.")
  if (!is.null(outcome.type) & !(outcome.type %in% c("event","standard"))) stop("Outcome: outcome type must be event or standard")

  outcome = list(outcome.dist = outcome.dist,
                 outcome.type = outcome.type)

  class(outcome) = "OutcomeDist"
  return(outcome)
  invisible(outcome)

}

######################################################################################################################

# Function: +.DataModel.
# Argument: Two objects (DataModel and another object).
# Description: This function is used to add objects to the DataModel object
#' @export
"+.DataModel" = function(datamodel, object) {

  if (is.null(object))
    return(datamodel)

  if (class(object) == "SampleSize"){
    datamodel$general$sample.size = unclass(unlist(object))
  }
  else if (class(object) == "Event"){
    datamodel$general$event$n.events = unclass(unlist(object$n.events))
    datamodel$general$event$rando.ratio = unclass(object$rando.ratio)
  }
  else if (class(object) == "OutcomeDist"){
    datamodel$general$outcome.dist = unclass(object$outcome.dist)
    datamodel$general$outcome.type = unclass(object$outcome.type)
  }
  else if (class(object) == "Sample"){
    nsample = length(datamodel$samples)
    datamodel$samples[[nsample+1]] = unclass(object)
  }
  else if (class(object) == "Design"){
    ndesign = length(datamodel$general$design)
    datamodel$general$design[[ndesign+1]] = unclass(object)
  }
  else stop(paste0("Data Model: Impossible to add the object of class",class(object)," to the Data Model"))

  return(datamodel)

}

######################################################################################################################

# Functions to create the Analysis Model (user interface)

######################################################################################################################


######################################################################################################################

# Function: AnalysisModel.
# Argument: ....
# Description: This function is used to call the corresponding function according to the class of the argument.
#' @export
AnalysisModel = function(...) {
  UseMethod("AnalysisModel")
}


######################################################################################################################

# Function: is.AnalysisModel.
# Argument: an object.
# Description: Return if the object is of class AnalysisModel

is.AnalysisModel = function(arg){
  return(any(class(arg)=="AnalysisModel"))
}

######################################################################################################################

# Function: AnalysisModel.default
# Argument: arguments.
# Description: This function is called by default if the class of the argument is neither a MultAdjust,
#              nor a Interim object.
#' @export
AnalysisModel.default = function(...) {
  args = list(...)
  if (length(args) > 0) {
    stop("Analysis Model doesn't know how to deal with the parameters")
  }
  else {
    analysismodel = structure(list(general = list(interim.analysis = NULL,
                                                  mult.adjust = NULL),
                                   tests = NULL,
                                   statistics = NULL),
                              class = "AnalysisModel")
  }
  return(analysismodel)
}

######################################################################################################################

# Function: AnalysisModel.MultAdj
# Argument: MultAdj object.
# Description: This function is called by default if the class of the argument is a MultAdj object.
#' @export
AnalysisModel.MultAdj = function(multadj, ...) {

  analysismodel = AnalysisModel()
  analysismodel = analysismodel + multadj

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      analysismodel = analysismodel + args[[i]]
    }
  }
  return(analysismodel)

}

######################################################################################################################

# Function: AnalysisModel.MultAdjProc
# Argument: MultAdjProc object.
# Description: This function is called by default if the class of the argument is a MultAdjProc object.
#' @export
AnalysisModel.MultAdjProc = function(multadjproc, ...) {

  analysismodel = AnalysisModel()
  analysismodel = analysismodel + multadjproc

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      analysismodel = analysismodel + args[[i]]
    }
  }
  return(analysismodel)

}

######################################################################################################################

# Function: AnalysisModel.MultAdjStrategy
# Argument: MultAdjStrategy object.
# Description: This function is called by default if the class of the argument is a MultAdjStrategy object.
#' @export
AnalysisModel.MultAdjStrategy = function(multadjstrategy, ...) {

  analysismodel = AnalysisModel()
  analysismodel = analysismodel + multadjstrategy

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      analysismodel = analysismodel + args[[i]]
    }
  }
  return(analysismodel)

}

######################################################################################################################

# Function: AnalysisModel.Interim
# Argument: Interim object.
# Description: This function is called by default if the class of the argument is a Interim object.

AnalysisModel.Interim = function(interim, ...) {

  analysismodel = AnalysisModel()
  analysismodel = analysismodel + interim

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      analysismodel = analysismodel + args[[i]]
    }
  }
  return(analysismodel)

}

######################################################################################################################

# Function: AnalysisModel.Test
# Argument: Test object.
# Description: This function is called by default if the class of the argument is a Test object.
#' @export
AnalysisModel.Test = function(test, ...) {

  analysismodel = AnalysisModel()
  analysismodel = analysismodel + test

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      analysismodel = analysismodel + args[[i]]
    }
  }
  return(analysismodel)

}

######################################################################################################################

# Function: AnalysisModel.Statistic
# Argument: Statistic object.
# Description: This function is called by default if the class of the argument is a Statistic object.
#' @export
AnalysisModel.Statistic = function(statistic, ...) {

  analysismodel = AnalysisModel()
  analysismodel = analysismodel + statistic

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      analysismodel = analysismodel + args[[i]]
    }
  }
  return(analysismodel)

}




######################################################################################################################

# Function: Test.
# Argument: Test ID, Statistical method, Samples and Parameters.
# Description: This function is used to create an object of class Test.
#' @export
Test = function(id, method, samples, par = NULL) {

  # Error checks
  if (!is.character(id)) stop("Test: ID must be character.")
  if (!is.character(method)) stop("Test: statistical method must be character.")
  if (!is.list(samples)) stop("Test: samples must be wrapped in a list.")
  if (all(lapply(samples, is.list) == FALSE) & any(lapply(samples, is.character) == FALSE)) stop("Test: samples must be character.")
  if (all(lapply(samples, is.list) == TRUE) & (!is.character(unlist(samples)))) stop("Test: samples must be character.")
  if (!is.null(par) & !is.list(par)) stop("Test: par must be wrapped in a list.")

  test = list(id = id, method = method, samples = samples, par = par)

  class(test) = "Test"
  return(test)
  invisible(test)
}

######################################################################################################################

# Function: Statistic.
# Argument: Statistic ID, Statistical method, Samples and Parameters.
# Description: This function is used to create an object of class Statistic.
#' @export
Statistic = function(id, method, samples, par = NULL) {

  # Error checks
  if (!is.character(id)) stop("Statistic: ID must be character.")
  if (!is.character(method)) stop("Statistic: statistical method must be character.")
  if (!is.list(samples)) stop("Statistic: samples must be wrapped in a list.")
  if (any(lapply(samples, is.character) == FALSE)) stop("Statistic: samples must be character.")
  if (!is.null(par) & !is.list(par)) stop("MultAdj: par must be wrapped in a list.")

  statistic = list(id = id, method = method, samples = samples, par = par)

  class(statistic) = "Statistic"
  return(statistic)
  invisible(statistic)
}

######################################################################################################################

# Function: MultAdjProc.
# Argument: ....
# Description: This function is used to call the corresponding function according to the class of the argument.
#' @export
MultAdjProc = function(proc, par = NULL, tests = NULL) {

  # Error checks
  if (!is.na(proc) & !is.character(proc)) stop("MultAdj: multiplicity adjustment procedure must be character.")
  if (!is.null(par) & !is.list(par)) stop("MultAdj: par must be wrapped in a list.")
  if (!is.null(tests) & !is.list(tests)) stop("MultAdj: tests must be wrapped in a list.")
  if (any(lapply(tests, is.character) == FALSE)) stop("MultAdj: tests must be character.")


  mult.adjust = list(proc = proc, par = par, tests = tests)

  class(mult.adjust) = "MultAdjProc"
  return(mult.adjust)
  invisible(mult.adjust)
}


######################################################################################################################

# Function: MultAdjStrategy.
# Argument: ....
# Description: This function is used to call the corresponding function according to the class of the argument.
#' @export
MultAdjStrategy = function(...) {
  UseMethod("MultAdjStrategy")
}

######################################################################################################################

# Function: MultAdjStrategy.default.
# Argument: MultAdjProc object
# Description: This function is used to create an object of class MultAdjStrategy.
#' @export
MultAdjStrategy.default= function(...) {

  stop("MultAdjStrategy: this function only accepts object of class MultAdjProc")

}

######################################################################################################################

# Function: MultAdjStrategy.MultAdjProc.
# Argument: MultAdjProc object
# Description: This function is used to create an object of class MultAdjStrategy.
#' @export
MultAdjStrategy.MultAdjProc = function(...) {

  multadjstrat = lapply(list(...),unclass)

  class(multadjstrat) = "MultAdjStrategy"
  return(multadjstrat)
  invisible(multadjstrat)

}

######################################################################################################################

# Function: MultAdj.
# Argument: ....
# Description: This function is used to call the corresponding function according to the class of the argument.
#' @export
MultAdj = function(...) {
  UseMethod("MultAdj")
}

######################################################################################################################

# Function: MultAdj.MultAdjProc.
# Argument: MultAdjProc object
# Description: This function is used to create an object of class MultAdj.
#' @export
MultAdj.default = function(...) {

  stop("MultAdj: this function only accepts object of class MultAdjProc or MultAdjStrategy")

}

######################################################################################################################

# Function: MultAdj.MultAdjStrategy.
# Argument: MultAdjStrategy object
# Description: This function is used to create an object of class MultAdjStrategy.
#' @export
MultAdj.MultAdjStrategy = function(...) {

  multadj = lapply(list(...),function(x) {if(class(x)=="MultAdjProc") list(unclass(x)) else unclass(x)} )

  class(multadj) = "MultAdj"
  return(multadj)
  invisible(multadj)

}

######################################################################################################################

# Function: MultAdj.MultAdjProc.
# Argument: MultAdjProc object
# Description: This function is used to create an object of class MultAdjProc.
#' @export
MultAdj.MultAdjProc = function(...) {


  multadj = lapply(list(...),function(x) {if(class(x)=="MultAdjProc") list(unclass(x)) else unclass(x)} )

  class(multadj) = "MultAdj"
  return(multadj)
  invisible(multadj)

}

######################################################################################################################

# Function: Interim.
# Argument: Sample (sample), Criterion (criterion) and Fraction (fraction).
# Description: This function is used to create an object of class MultAdj.

Interim = function(sample = NULL, criterion = NULL, fraction = NULL) {

  if (is.null(sample))
    stop("Interim: a sample must be defined")
  if (is.null(criterion))
    stop("Interim: a criterion must be defined")
  if (is.null(fraction))
    stop("Interim: a fraction must be defined")

  interim = list(sample = sample, criterion = criterion ,fraction = fraction )

  class(interim) = "Interim"
  return(interim)
  invisible(interim)

}

######################################################################################################################

# Function: +.AnalysisModel.
# Argument: Two objects (AnalysisModel and another object).
# Description: This function is used to add objects to the AnalysisModel object
#' @export
"+.AnalysisModel" = function(analysismodel, object) {

  if (is.null(object))
    return(analysismodel)
  else if (class(object) == "Test"){
    ntest = length(analysismodel$tests)
    analysismodel$tests[[ntest+1]] = unclass(object)
  }
  else if (class(object) == "Statistic"){
    nstatistic = length(analysismodel$statistics)
    analysismodel$statistics[[nstatistic+1]] = unclass(object)
  }
  else if (class(object) == "Interim"){
    analysismodel$general$interim$interim.analysis = unclass(object)
  }
  else if (class(object) == "MultAdjProc"){
    nmultadj = length(analysismodel$general$mult.adjust)
    analysismodel$general$mult.adjust[[nmultadj + 1]] = list(unclass(object))
  }
  else if (class(object) == "MultAdjStrategy"){
    nmultadj = length(analysismodel$general$mult.adjust)
    analysismodel$general$mult.adjust[[nmultadj + 1]] = list(unclass(object))
  }
  else if (class(object) == "MultAdj"){
    nmultadj = length(analysismodel$general$mult.adjust)
    if (length(object)>1) analysismodel$general$mult.adjust = c(analysismodel$general$mult.adjust, unclass(object))
    else analysismodel$general$mult.adjust[[nmultadj + 1]] = unclass(object)
  }
  else stop(paste0("Analysis Model: Impossible to add the object of class ",class(object)," to the Analysis Model"))

  return(analysismodel)

}



######################################################################################################################

# Functions to create the Evaluation Model (user interface)

######################################################################################################################


######################################################################################################################

# Function: EvaluationModel.
# Argument: ....
# Description: This function is used to call the corresponding function according to the class of the argument.
#' @export
EvaluationModel = function(...) {
  UseMethod("EvaluationModel")
}


######################################################################################################################

# Function: is.EvaluationModel.
# Argument: an object.
# Description: Return if the object is of class EvaluationModel

is.EvaluationModel= function(arg){
  return(any(class(arg)=="EvaluationModel"))
}

######################################################################################################################

# Function: EvaluationModel.default
# Argument: Multiple objects.
# Description: This function is called by default if the class of the argument is not a Criterion object.
#' @export
EvaluationModel.default = function(...) {
  args = list(...)
  if (length(args) > 0) {
    stop("Evaluation Model doesn't know how to deal with the parameters")
  }
  else {
    evaluationmodel = structure(list(general = NULL, criteria = NULL),
                                class = "EvaluationModel")
  }
  return(evaluationmodel)
}

######################################################################################################################

# Function: EvaluationModel.Criterion
# Argument: Criterion object.
# Description: This function is called by default if the class of the argument is an Criterion object.
#' @export
EvaluationModel.Criterion = function(criterion, ...) {
  evaluationmodel = EvaluationModel()
  evaluationmodel = evaluationmodel + criterion

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      evaluationmodel = evaluationmodel + args[[i]]
    }
  }
  return(evaluationmodel)
}

######################################################################################################################

# Function: Criterion.
# Argument: Criterion ID, method, tests, statistics, parameters, labels.
# Description: This function is used to create an object of class Criterion
#' @export
Criterion = function(id, method, tests = NULL, statistics = NULL, par = NULL, labels) {

  # Error checks
  if (!is.character(id)) stop("Criterion: ID must be character.")
  if (!is.character(method)) stop("Criterion: method must be character.")
  if (!is.null(tests) & !is.list(tests)) stop("Criterion: tests must be wrapped in a list.")
  if (any(lapply(tests, is.character) == FALSE)) stop("Criterion: tests must be character.")
  if (!is.null(statistics) & !is.list(statistics)) stop("Criterion: statistics must be wrapped in a list.")
  if (any(lapply(statistics, is.character) == FALSE)) stop("Criterion: statistics must be character.")
  if (is.null(tests) & is.null(statistics )) stop("Criterion: tests and/or statistics must be provided")

  criterion = list(id = id ,
                   method = method ,
                   tests = tests ,
                   statistics = statistics ,
                   par = par ,
                   labels = labels)

  class(criterion) = "Criterion"
  return(criterion)
  invisible(criterion)
}

######################################################################################################################

# Function: +.EvaluationModel.
# Argument: Two objects (EvaluationModel and another object).
# Description: This function is used to add objects to the EvaluationModel object
#' @export
"+.EvaluationModel" = function(evaluationmodel, object) {

  if (is.null(object))
    return(evaluationmodel)
  else if (class(object) == "Criterion"){
    ncriteria = length(evaluationmodel$criteria)
    evaluationmodel$criteria[[ncriteria+1]] = unclass(object)
  }

  else stop(paste0("Evaluation Model: Impossible to add the object of class ",class(object)," to the Evaluation Model"))

  return(evaluationmodel)

}


######################################################################################################################

# Function: SimParameters
# Argument: Multiple character strings.
# Description: This function is called by default.
#' @export
SimParameters = function(n.sims, seed, proc.load = 1) {

  # Error checks
  if (!is.numeric(n.sims)) stop("SimParameters: Number of simulation runs must be an integer.")
  if (length(n.sims) > 1) stop("SimParameters: Number of simulations runs: Only one value must be specified.")
  if (n.sims%%1 != 0) stop("SimParameters: Number of simulations runs must be an integer.")
  if (n.sims <= 0) stop("SimParameters: Number of simulations runs must be positive.")

  if (!is.numeric(seed)) stop("Seed must be an integer.")
  if (length(seed) > 1) stop("Seed: Only one value must be specified.")
  if (nchar(as.character(seed)) > 10) stop("Length of seed must be inferior to 10.")

  if (is.numeric(proc.load)){
    if (length(proc.load) > 1) stop("SimParameters: Processor load only one value must be specified.")
    if (proc.load %%1 != 0) stop("SimParameters: Processor load must be an integer.")
    if (proc.load <= 0) stop("SimParameters: Processor load must be positive.")
  }
  else if (is.character(proc.load)){
    if (!(proc.load %in% c("low", "med", "high", "full"))) stop("SimParameters: Processor load not valid")
  }

  sim.parameters = list(n.sims = n.sims,
                        seed = seed,
                        proc.load = proc.load)

  class(sim.parameters) = "SimParameters"
  return(sim.parameters)
  invisible(sim.parameters)
}
######################################################################################################################

# Functions to create the Presentation Model (user interface)

######################################################################################################################


######################################################################################################################

# Function: PresentationModel.
# Argument: ....
# Description: This function is used to call the corresponding function according to the class of the argument.
#' @export
PresentationModel = function(...) {
  UseMethod("PresentationModel")
}


######################################################################################################################

# Function: is.PresentationModel.
# Argument: an object.
# Description: Return if the object is of class PresentationModel

is.PresentationModel = function(arg){
  return(any(class(arg)=="PresentationModel"))
}

######################################################################################################################

# Function: PresentationModel.default
# Argument: Multiple objects.
# Description: This function is called by default.
#' @export
PresentationModel.default = function(...) {
  args = list(...)
  if (length(args) > 0) {
    stop("Presentation Model doesn't know how to deal with the parameters")
  }
  else {

    presentationmodel = structure(
      list(project = list(username = "[Unknown User]", title = "[Unknown title]", description = "[No description]"),
           section.by = NULL,
           subsection.by = NULL,
           table.by = NULL,
           custom.label = NULL),
      class = "PresentationModel")
  }
  return(presentationmodel)
}

######################################################################################################################

# Function: PresentationModel.Project
# Argument: Projet object.
# Description: This function is called by default if the class of the argument is a Project object.
#' @export
PresentationModel.Project = function(project, ...) {
  presentationmodel = PresentationModel()
  presentationmodel = presentationmodel + project

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      presentationmodel = presentationmodel + args[[i]]
    }
  }
  return(presentationmodel)
}

######################################################################################################################

# Function: PresentationModel.Section
# Argument: Section object.
# Description: This function is called by default if the class of the argument is a Section object.
#' @export
PresentationModel.Section = function(section, ...) {
  presentationmodel = PresentationModel()
  presentationmodel = presentationmodel + section

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      presentationmodel = presentationmodel + args[[i]]
    }
  }
  return(presentationmodel)
}

######################################################################################################################

# Function: PresentationModel.Subsection
# Argument: Subsection object.
# Description: This function is called by default if the class of the argument is a Subsection object.
#' @export
PresentationModel.Subsection = function(subsection, ...) {
  presentationmodel = PresentationModel()
  presentationmodel = presentationmodel + subsection

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      presentationmodel = presentationmodel + args[[i]]
    }
  }
  return(presentationmodel)
}

######################################################################################################################

# Function: PresentationModel.Table
# Argument: Table object.
# Description: This function is called by default if the class of the argument is a Table object.
#' @export
PresentationModel.Table = function(table, ...) {
  presentationmodel = PresentationModel()
  presentationmodel = presentationmodel + table

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      presentationmodel = presentationmodel + args[[i]]
    }
  }
  return(presentationmodel)
}

######################################################################################################################

# Function: PresentationModel.CustomLabel
# Argument: CustomLabel object.
# Description: This function is called by default if the class of the argument is a CustomLabel object.
#' @export
PresentationModel.CustomLabel = function(customlabel, ...) {
  presentationmodel = PresentationModel()
  presentationmodel = presentationmodel + customlabel

  args = list(...)
  if (length(args)>0) {
    for (i in 1:length(args)){
      presentationmodel = presentationmodel + args[[i]]
    }
  }
  return(presentationmodel)
}

######################################################################################################################

# Function: Project.
# Argument: username, title, project.
# Description: This function is used to create an object of class Project.
#' @export
Project = function(username = "[Unknown User]", title = "[Unknown title]", description = "[No description]") {

  # Error checks
  if (!is.character(username)) stop("Project: username must be character.")
  if (!is.character(title)) stop("Project: title must be character.")
  if (!is.character(description)) stop("Project: description must be character.")

  project = list(username = username, title = title, description = description)

  class(project) = "Project"
  return(project)
  invisible(project)
}

######################################################################################################################

# Function: Section.
# Argument: by.
# Description: This function is used to create an object of class Section.
#' @export
Section = function(by) {

  # Error checks
  if (!is.character(by)) stop("Section: by must be character.")
  if (!any(by %in% c("sample.size", "event", "outcome.parameter", "design.parameter", "multiplicity.adjustment"))) stop("Section: the variables included in by are invalid.")

  section.report = list(by = by)

  class(section.report) = "Section"
  return(section.report)
  invisible(section.report)
}

######################################################################################################################

# Function: SubSection.
# Argument: by.
# Description: This function is used to create an object of class SubSection.
#' @export
Subsection = function(by) {

  # Error checks
  if (!is.character(by)) stop("Subsection: by must be character.")
  if (!any(by %in% c("sample.size", "event", "outcome.parameter", "design.parameter", "multiplicity.adjustment"))) stop("Subsection: the variables included in by are invalid.")


  subsection.report = list(by = by)

  class(subsection.report) = "SubSection"
  return(subsection.report)
  invisible(subsection.report)
}

######################################################################################################################

# Function: Table.
# Argument: by.
# Description: This function is used to create an object of class Table.
#' @export
Table = function(by) {

  # Error checks
  if (!is.character(by)) stop("Table: by must be character.")
  if (!any(by %in% c("sample.size", "event", "outcome.parameter", "design.parameter", "multiplicity.adjustment"))) stop("Table: the variables included in by are invalid.")

  table.report = list(by = by)

  class(table.report) = "Table"
  return(table.report)
  invisible(table.report)
}

######################################################################################################################

# Function: CustomLabel.
# Argument: by.
# Description: This function is used to create an object of class CustomLabel.
#' @export
CustomLabel = function(param, label) {

  # Error checks
  if (!is.character(param)) stop("CustomLabel: param must be character.")
  if (!(param %in% c("sample.size", "event", "outcome.parameter", "design.parameter", "multiplicity.adjustment"))) stop("CustomLabel: param is invalid.")
  if (!is.character(label)) stop("CustomLabel: label must be character.")

  custom.label = list(param = param, label = label)

  class(custom.label) = "CustomLabel"
  return(custom.label)
  invisible(custom.label)
}

######################################################################################################################

# Function: +.PresentationModel.
# Argument: Two objects (PresentationModel and another object).
# Description: This function is used to add objects to the PresentationModel object
#' @export
"+.PresentationModel" = function(presentationmodel, object) {

  if (is.null(object))
    return(presentationmodel)
  else if (class(object) == "Project"){
    presentationmodel$project$username = object$username
    presentationmodel$project$title = object$title
    presentationmodel$project$description = object$description
  }
  else if (class(object) == "Section"){
    presentationmodel$section.by = unclass(object)
  }
  else if (class(object) == "SubSection"){
    presentationmodel$subsection.by = unclass(object)
  }
  else if (class(object) == "Table"){
    presentationmodel$table.by = unclass(object)
  }
  else if (class(object) == "CustomLabel"){
    ncustomlabel = length(presentationmodel$custom.label)
    presentationmodel$custom.label[[ncustomlabel+1]] = unclass(object)
  }
  else stop(paste0("Presentation Model: Impossible to add the object of class ",class(object)," to the Presentation Model"))

  return(presentationmodel)

}

######################################################################################################################

# Function: GenerateReport.
# Argument: Results returned by the CSE function and presentation model and Word-document title and Word-template.
# Description: This function is used to create a summary table with all results
#' @export
GenerateReport = function(presentation.model = NULL, cse.results, report.filename, report.template = NULL){
 UseMethod("GenerateReport")
}

######################################################################################################################

# Function: GenerateReport.
# Argument: ResultDes returned by the CSE function and presentation model and Word-document title and Word-template.
# Description: This function is used to create a summary table with all results
#' @export
#' @import ReporteRs

GenerateReport.default = function(presentation.model = NULL, cse.results, report.filename, report.template = NULL){
  # Add error checks
  if (!is.null(presentation.model) & class(presentation.model) != "PresentationModel") stop("GenerateReport: the presentation.model parameter must be a PresentationModel object.")
  if (class(cse.results) != "CSE") stop("GenerateReport: the cse.results parameter must be a CSE object.")
  if (!is.character(report.filename)) stop("GenerateReport: the report.filename parameter must be character.")

  # Create the structure of the report
  # If no presentation model, initialize a presentation model object
  if (is.null(presentation.model)) presentation.model = PresentationModel()
  report = CreateReportStructure(cse.results, presentation.model)
  report.results = report$result.structure
  report.structure = report$report.structure

  # Delete an older version of the report
  if (!is.null(report.filename)){
    if (file.exists(report.filename)) file.remove(report.filename)
  }

  # Create a DOCX object
  if (!missing(report.template)) {
    doc = docx(title = report.structure$title, template = report.template)
  } else {
    # Use standard template
    doc = docx(title = report.structure$title)
  }

  # Report's title
  doc = addParagraph(doc, value = report.structure$title, stylename = "TitleDoc")

  # Text formatting
  my.text.format = parProperties(text.align = "left")

  # Table formatting
  header.cellProperties = cellProperties(border.left.width = 0, border.right.width = 0, border.bottom.width = 2, border.top.width = 2, padding = 5, background.color = "#eeeeee")
  data.cellProperties = cellProperties(border.left.width = 0, border.right.width = 0, border.bottom.width = 1, border.top.width = 0, padding = 3)

  header.textProperties = textProperties(font.size = 10, font.weight = "bold")
  data.textProperties = textProperties(font.size = 10)

  leftPar = parProperties(text.align = "left")
  rightPar = parProperties(text.align = "right")
  centerPar = parProperties(text.align = "center")

  # Number of sections in the report (the report's title is not counted)
  n.sections = length(report.structure$section)

  # Loop over the sections in the report
  for(section.index in 1:n.sections) {

    # Section's title (if non-empty)
    if (!is.na(report.structure$section[[section.index]]$title)) doc = addTitle(doc, value = report.structure$section[[section.index]]$title, 1)

    # Number of subsections in the current section
    n.subsections = length(report.structure$section[[section.index]]$subsection)

    # Loop over the subsections in the current section
    for(subsection.index in 1:n.subsections) {

      # Subsection's title (if non-empty)
      if (!is.na(report.structure$section[[section.index]]$subsection[[subsection.index]]$title)) doc = addTitle(doc, value = report.structure$section[[section.index]]$subsection[[subsection.index]]$title, 2)

      # Number of subsubsections in the current section
      n.subsubsections = length(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection)

      if (n.subsubsections>0){
        # Loop over the subsubsection in the current section
        for(subsubsection.index in 1:n.subsubsections) {

          # Subsubsection's title (if non-empty)
          if (!is.na(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$title)) doc = addTitle(doc, value = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$title, 3)

          # Number of subsubsubsections in the current section
          n.subsubsubsection = length(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection)

          if (n.subsubsubsection>0){
            # Loop over the subsubsubsection in the current section
            for(subsubsubsection.index in 1:n.subsubsubsection) {

              # Subsubsubsection's title (if non-empty)
              if (!is.na(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$title)) doc = addTitle(doc, value = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$title, 4)

              # Number of items in the current subsubsection
              n.items = length(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$item)

              # Loop over the items in the current subsection
              for(item.index in 1:n.items) {

                # Create paragraphs for each item

                # Determine the item's type (text by default)
                type = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$item[[item.index]]$type
                if (is.null(type)) type = "text"

                label = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$item[[item.index]]$label
                value = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$item[[item.index]]$value
                param = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$item[[item.index]]$param

                if (type == "table" & is.null(param)) param = list(span.columns = NULL, groupedheader.row = NULL)

                switch( type,
                        text = {
                          if (label != "") doc = addParagraph(doc, value = paste(label, value), stylename = "Normal", par.properties = my.text.format)
                          else  doc = addParagraph(doc, value = value, stylename = "Normal", par.properties = my.text.format)
                        },
                        table = {
                          header.columns = (is.null(param$groupedheader.row))
                          summary_table = FlexTable(data = value, body.cell.props = data.cellProperties, header.cell.props = header.cellProperties, header.columns = header.columns )
                          if (!is.null(param$span.columns)) {
                            for (ind.span in 1:length(param$span.columns)){
                              summary_table = spanFlexTableRows(summary_table, j = param$span.columns[ind.span], runs = as.character(value[,ind.span]) )
                            }
                          }
                          summary_table = setFlexTableBorders(summary_table, inner.vertical = borderNone(),
                                                              outer.vertical = borderNone())
                          if (!is.null(param$groupedheader.row)) {
                            summary_table = addHeaderRow(summary_table, value = param$groupedheader.row$values, colspan = param$groupedheader.row$colspan)
                            summary_table = addHeaderRow(summary_table, value = colnames( value ))
                          }
                          doc = addParagraph(doc, value = label, stylename = "rTableLegend", par.properties = my.text.format)
                          doc = addFlexTable(doc, summary_table)
                        },
                        plot =  {
                          doc = addPlot(doc, fun = print, x = value, width = 6, height = 5, main = label)
                          doc = addParagraph(doc, value = label, stylename = "rPlotLegend", par.properties = my.text.format)
                        }
                )
              }
            }
          }
          else {
            # Number of items in the current subsubsection
            n.items = length(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$item)

            # Loop over the items in the current subsection
            for(item.index in 1:n.items) {

              # Create paragraphs for each item

              # Determine the item's type (text by default)
              type = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$item[[item.index]]$type
              if (is.null(type)) type = "text"

              label = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$item[[item.index]]$label
              value = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$item[[item.index]]$value
              param = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$item[[item.index]]$param

              if (type == "table" & is.null(param)) param = list(span.columns = NULL, groupedheader.row = NULL)

              switch( type,
                      text = {
                        if (label != "") doc = addParagraph(doc, value = paste(label, value), stylename = "Normal", par.properties = my.text.format)
                        else  doc = addParagraph(doc, value = value, stylename = "Normal", par.properties = my.text.format)
                      },
                      table = {
                        header.columns = (is.null(param$groupedheader.row))
                        summary_table = FlexTable(data = value, body.cell.props = data.cellProperties, header.cell.props = header.cellProperties, header.columns = header.columns )
                        if (!is.null(param$span.columns)) {
                          for (ind.span in 1:length(param$span.columns)){
                            summary_table = spanFlexTableRows(summary_table, j = param$span.columns[ind.span], runs = as.character(value[,ind.span]) )
                          }
                        }
                        summary_table = setFlexTableBorders(summary_table, inner.vertical = borderNone(),
                                                            outer.vertical = borderNone())
                        if (!is.null(param$groupedheader.row)) {
                          summary_table = addHeaderRow(summary_table, value = param$groupedheader.row$values, colspan = param$groupedheader.row$colspan)
                          summary_table = addHeaderRow(summary_table, value = colnames( value ))
                        }
                        doc = addParagraph(doc, value = label, stylename = "rTableLegend", par.properties = my.text.format)
                        doc = addFlexTable(doc, summary_table)
                      },
                      plot =  {
                        doc = addPlot(doc, fun = print, x = value, width = 6, height = 5, main = label)
                        doc = addParagraph(doc, value = label, stylename = "rPlotLegend", par.properties = my.text.format)
                      }
              )
            }
          }
        }
      }
      else {

        # Number of items in the current subsection
        n.items = length(report.structure$section[[section.index]]$subsection[[subsection.index]]$item)

        # Loop over the items in the current subsection
        for(item.index in 1:n.items) {

          # Create paragraphs for each item

          # Determine the item's type (text by default)
          type = report.structure$section[[section.index]]$subsection[[subsection.index]]$item[[item.index]]$type
          if (is.null(type)) type = "text"

          label = report.structure$section[[section.index]]$subsection[[subsection.index]]$item[[item.index]]$label
          value = report.structure$section[[section.index]]$subsection[[subsection.index]]$item[[item.index]]$value
          param = report.structure$section[[section.index]]$subsection[[subsection.index]]$item[[item.index]]$param

          if (type == "table" & is.null(param)) param = list(span.columns = NULL, groupedheader.row = NULL)

          switch( type,
                  text = {
                    if (label != "") doc = addParagraph(doc, value = paste(label, value), stylename = "Normal", par.properties = my.text.format)
                    else  doc = addParagraph(doc, value = value, stylename = "Normal", par.properties = my.text.format)
                  },
                  table = {
                    header.columns = (is.null(param$groupedheader.row))
                    summary_table = FlexTable(data = value, body.cell.props = data.cellProperties, header.cell.props = header.cellProperties, header.columns = header.columns )
                    if (!is.null(param$span.columns)) {
                      for (ind.span in 1:length(param$span.columns)){
                        summary_table = spanFlexTableRows(summary_table, j = param$span.columns[ind.span], runs = as.character(value[,ind.span]) )
                      }
                    }
                    summary_table = setFlexTableBorders(summary_table, inner.vertical = borderNone(),
                                                        outer.vertical = borderNone())
                    if (!is.null(param$groupedheader.row)) {
                      summary_table = addHeaderRow(summary_table, value = param$groupedheader.row$values, colspan = param$groupedheader.row$colspan)
                      summary_table = addHeaderRow(summary_table, value = colnames( value ))
                    }
                    doc = addParagraph(doc, value = label, stylename = "rTableLegend", par.properties = my.text.format)
                    doc = addFlexTable(doc, summary_table)
                  },
                  plot =  {
                    doc = addPlot(doc, fun = print, x = value, width = 6, height = 5, main = label)
                    doc = addParagraph(doc, value = label, stylename = "rPlotLegend", par.properties = my.text.format)
                  }
          )
        }

      }

    }
  }

  # Save the report
  writeDoc(doc, report.filename)

  # Return
  return(invisible(report.results))

}
# End of GenerateReport


######################################################################################################################

# Function: CreateReportStructure.
# Argument: Results returned by the CSE function and tables produced by the CreateTableStructure function.
# Description: This function is used to create a report

CreateReportStructure = function(evaluation, presentation.model){

  # Number of scenario
  n.scenario = nrow(evaluation$analysis.scenario.grid)

  # Number of design parameter
  n.design = max(evaluation$analysis.scenario.grid$design.parameter)

  # Number of outcome parameter
  n.outcome = max(evaluation$analysis.scenario.grid$outcome.parameter)

  # Number of sample size or event set
  n.sample.size = max(evaluation$analysis.scenario.grid$sample.size)

  # Number of multiplicity adjustment
  n.multiplicity.adjustment = max(evaluation$analysis.scenario.grid$multiplicity.adjustment)

  # Empty report object
  report = list()

  # Empty section list
  section = list()

  # Empty subsection list
  subsection = list()

  # Empty subsubsection list
  subsubsection = list()

  # Empty subsubsubsection list
  subusbsubsection = list()

  # Get the label
  custom.label = presentation.model$custom.label

  # Sample size label
  custom.label.sample.size = list()
  if (any(unlist(lapply(custom.label, function(x) (x$param %in% c("sample.size","event")))))) {
    custom.label.sample.size$label = custom.label[[which(unlist(lapply(custom.label, function(x) (x$param %in% c("sample.size","event")))))]]$label
    custom.label.sample.size$custom = TRUE

  } else {
    if (any(!is.na(evaluation$data.structure$sample.size.set))) custom.label.sample.size$label = paste("Sample size", 1:n.sample.size)
    else if (any(!is.na(evaluation$data.structure$event.set))) custom.label.sample.size$label = paste("Event", 1:n.sample.size)
    custom.label.sample.size$custom = FALSE
  }

  # Outcome parameter label
  custom.label.outcome.parameter = list()
  if (any(unlist(lapply(custom.label, function(x) (x$param == "outcome.parameter"))))) {
    custom.label.outcome.parameter$label = custom.label[[which(unlist(lapply(custom.label, function(x) (x$param == "outcome.parameter"))))]]$label
    custom.label.outcome.parameter$custom = TRUE
  } else {
    custom.label.outcome.parameter$label = paste("Outcome", 1:n.outcome)
    custom.label.outcome.parameter$custom = FALSE
  }

  # Multiplicity adjustment label
  custom.label.multiplicity.adjustment = list()
  if (any(unlist(lapply(custom.label, function(x) (x$param == "multiplicity.adjustment"))))) {
    custom.label.multiplicity.adjustment$label = custom.label[[which(unlist(lapply(custom.label, function(x) (x$param == "multiplicity.adjustment"))))]]$label
    custom.label.multiplicity.adjustment$custom = TRUE
  } else {
    custom.label.multiplicity.adjustment$label = paste("Multiplicity adjustment scenario", 1:n.multiplicity.adjustment)
    custom.label.multiplicity.adjustment$custom = FALSE
  }

  # Design parameter label
  custom.label.design.parameter = list()
  if (any(unlist(lapply(custom.label, function(x) (x$param == "design.parameter"))))) {
    custom.label.design.parameter$label = custom.label[[which(unlist(lapply(custom.label, function(x) (x$param == "design.parameter"))))]]$label
    custom.label.design.parameter$custom = TRUE
  } else {
    custom.label.design.parameter$label = paste("Design", 1:n.design)
    custom.label.design.parameter$custom = FALSE
  }

  # Create a summary table for the design
  if (!is.null(evaluation$data.structure$design.parameter.set)) table.design = CreateTableDesign(evaluation$data.structure, custom.label.design.parameter$label)

  # Create a summary table for the sample size
  table.sample.size = CreateTableSampleSize(evaluation$data.structure, custom.label.sample.size$label)

  # Create a summary table for the outcome parameters
  outcome.information = CreateTableOutcome(evaluation$data.structure, custom.label.outcome.parameter$label)
  outcome.dist.name = outcome.information[[1]]
  table.outcome =  outcome.information[[2]]

  # Create a summary table for the tests
  table.test = CreateTableTest(evaluation$analysis.structure)

  # Create a summary table for the statistics
  if (!is.null(evaluation$analysis.structure$statistic)) table.statistic = CreateTableStatistic(evaluation$analysis.structure)

  # Create a summary table for the results, according to the section/subsection requested by the user
  result.structure = CreateTableStructure(evaluation, presentation.model, custom.label.sample.size, custom.label.design.parameter, custom.label.outcome.parameter, custom.label.multiplicity.adjustment)

  # Get information on the multiplicity adjustment
  mult.adj.desc = list()
  if (!is.null(evaluation$analysis.structure$mult.adjust)){
    for (mult in 1:n.multiplicity.adjustment) {
      mult.adjust.temp = list()
      # Number of multiplicity adjustment within each mult.adj scenario
      n.mult.adj.sc = length(evaluation$analysis.structure$mult.adjust[[mult]])
      for (j in 1:n.mult.adj.sc){
        if (!is.na(evaluation$analysis.structure$mult.adjust[[mult]][[j]]$proc)){
          dummy.function.call = list("Description", evaluation$analysis.structure$mult.adjust[[mult]][[j]]$par, unlist(evaluation$analysis.structure$mult.adjust[[mult]][[j]]$tests))
          analysis.mult.desc = do.call(evaluation$analysis.structure$mult.adjust[[mult]][[j]]$proc, list(rep(0,length(unlist(evaluation$analysis.structure$mult.adjust[[mult]][[j]]$tests))),dummy.function.call))
          mult.adjust.temp[[j]] = list(desc = analysis.mult.desc[[1]], tests = paste0("{",paste0(unlist(evaluation$analysis.structure$mult.adjust[[mult]][[j]]$tests),collapse=", "),"}"),par = analysis.mult.desc[[2]])
        }
        else {
          mult.adjust.temp[[j]] = list(desc = "No adjustment", tests=NULL, par=NULL)
        }
      }
      mult.adj.desc[[mult]] = mult.adjust.temp
    }
  } else {
    mult.adj.desc = NA
  }

  # Section 1: General information
  ##################################

  # Items included in Section 1, Subsection 1
  # Item's type is text by default
  item1 = list(label = "", value = paste0("This report was generated by ", presentation.model$project$username, " using the Mediana package. For more information about the Mediana package, see http://biopharmnet.com/mediana."))
  item2 = list(label = "Project title:", value = presentation.model$project$title)
  item3 = list(label = "Description:", value = presentation.model$project$description)
  item4 = list(label = "Random seed:", value = evaluation$sim.parameters$seed)
  item5 = list(label = "Number of simulations:", value = evaluation$sim.parameters$n.sims)
  item6 = list(label = "Number of cores:", value = evaluation$sim.parameters$proc.load)
  item7 = list(label = "Start time:", value = evaluation$timestamp$start.time)
  item8 = list(label = "End time:", value = evaluation$timestamp$end.time)
  item9 = list(label = "Duration (mins):", value = format(round(evaluation$timestamp$duration, digits = 2), digits = 2, nsmall = 2))

  # Create a subsection (set the title to NA to suppress the title)
  subsection[[1]] = list(title = "Project information", item = list(item1, item2, item3))
  # Create a subsection (set the title to NA to suppress the title)
  subsection[[2]] = list(title = "Simulation parameters", item = list(item4, item5, item6, item7, item8, item9))

  # Create the header section (set the title to NA to suppress the title)
  section[[1]] = list(title = "General information", subsection = subsection)

  # Section 2: Data model #
  #########################
  n.subsection = 0

  # Empty subsection list
  subsection = list()

  # Empty subsubsection list
  subsubsection = list()

  # Empty subsubsubsection list
  subusbsubsection = list()

  #Design parameters
  if (!is.null(evaluation$data.structure$design.parameter.set)){
    n.subsection = n.subsection + 1
    item1 = list(label = "Number of design parameter sets: ",
                 value = n.design
    )
    item2 = list(label = "Design",
                 value =  table.design[,2:length(table.design)],
                 param = list(groupedheader.row = list(values = c("", "Enrollment", "", "", "Dropout"), colspan = c(1, 3, 1, 1, 2))),
                 type = "table"
    )

    # Create a subsection
    subsection[[n.subsection]] = list(title = "Design", item = list(item1, item2))
  }

  #Sample size
  if (any(!is.na(evaluation$data.structure$sample.size.set))) {
    item1 = list(label = "Number of samples:",
                 value = length(evaluation$data.structure$id),
                 type = "text"
    )
    item2 = list(label = "Number of sample size sets:",
                 value = n.sample.size,
                 type = "text"
    )
    item3 = list(label = "Sample size",
                 value = table.sample.size[,2:ncol(table.sample.size)],
                 param = list(span.columns = "Sample size set"),
                 type = "table"
    )
    # Create a subsection
    subsection[[n.subsection+1]] = list(title = "Sample size", item = list(item1, item2, item3))
  }
  #Event
  if (any(!is.na(evaluation$data.structure$event.set))) {
    item1 = list(label = "Number of samples:",
                 value = length(evaluation$data.structure$id),
                 type = "text"
    )
    item2 = list(label = "Randomization ratio:",
                 value = paste0("(",paste0(evaluation$data.structure$rando.ratio, collapse = ":"),")"),
                 type = "text"
    )
    item3 = list(label = "Number of event sets:",
                 value = n.sample.size,
                 type = "text"
    )
    item4 = list(label = "Event",
                 value = table.sample.size[,2:ncol(table.sample.size)],
                 type = "table"
    )
    # Create a subsection
    subsection[[n.subsection+1]] = list(title = "Number of events", item = list(item1, item2, item3, item4))
  }

  # Outcome distribution
  item1 = list(label = "Number of outcome parameter sets:",
               value = n.outcome,
               type = "text"
  )
  item2 = list(label = "Outcome distribution:",
               value = outcome.dist.name,
               type = "text"
  )
  item3 = list(label = "Outcome parameter",
               value = table.outcome[,2:length(table.outcome)],
               param = list(span.columns = "Outcome parameter set"),
               type = "table"
  )
  # Create a subsection
  subsection[[n.subsection+2]] = list(title = "Outcome distribution", item = list(item1, item2, item3))

  section[[2]] = list(title = "Data model", subsection = subsection)

  # Section 3: Analysis model
  ###########################
  n.subsection = 0

  # Empty subsection list
  subsection = list()

  # Empty subsection list
  subsection = list()

  # Empty subsubsection list
  subsubsection = list()

  # Empty subsubsubsection list
  subusbsubsection = list()

  # Test
  if (!is.null(evaluation$analysis.structure$test)){
    n.subsection = n.subsection + 1
    item1 = list(label = "Number of tests/null hypotheses: ",
                 value = length(evaluation$analysis.structure$test)
    )
    item2 = list(label = "Tests",
                 value =  table.test,
                 type = "table"
    )

    # Create a subsection
    subsection[[n.subsection]] = list(title = "Tests", item = list(item1, item2))

  }

  # Statistic
  if (!is.null(evaluation$analysis.structure$statistic)){
    n.subsection = n.subsection + 1
    item1 = list(label = "Number of descriptive statistics: ",
                 value = length(evaluation$analysis.structure$statistic)
    )
    item2 = list(label = "Statistics",
                 value =  table.statistic,
                 type = "table"
    )

    # Create a subsection
    subsection[[n.subsection]] = list(title = "Statistics", item = list(item1, item2))

  }

  # Multiplicity adjustment
  if (!is.null(evaluation$analysis.structure$mult.adjust)){
    n.subsection = n.subsection + 1
    subsubsection = list()
    for (mult in 1:n.multiplicity.adjustment) {
      # Number of multiplicity adjustment within each mult.adj scenario
      n.mult.adj.sc = length(mult.adj.desc[[mult]])
      subsubsubsection = list()
      for (j in 1:n.mult.adj.sc){
        item = list()
        ind.item = 1
        item[[ind.item]] = list(label = "Procedure:",
                                value = mult.adj.desc[[mult]][[j]]$desc[[1]]
        )
        if (!is.null(mult.adj.desc[[mult]][[j]]$tests)){
          ind.item = ind.item + 1
          item[[ind.item]] = list(label = "Tests:",
                                  value =  mult.adj.desc[[mult]][[j]]$tests
          )
        }
        if (!is.null(mult.adj.desc[[mult]][[j]]$par)){
          ind.item = ind.item + 1
          if (length(mult.adj.desc[[mult]][[j]]$par)>1) {
            item[[ind.item]] = list(label = "Parameters:",
                                    value =  ""
            )
            for (k in 1:length(mult.adj.desc[[mult]][[j]]$par)){
              ind.item = ind.item + 1
              if (!is.data.frame(mult.adj.desc[[mult]][[j]]$par[[k]])) {
                item[[ind.item]] = list(label = "",
                                        value = mult.adj.desc[[mult]][[j]]$par[[k]],
                                        type = "text"
                )
              }
              else if (is.data.frame(mult.adj.desc[[mult]][[j]]$par[[k]])) {
                item[[ind.item]] = list(label = "Parameters",
                                        value = mult.adj.desc[[mult]][[j]]$par[[k]],
                                        type = "table"
                )
              }
            }
          }
          else {
            if (!is.data.frame(mult.adj.desc[[mult]][[j]]$par[[1]])) {
              item[[ind.item]] = list(label = "Parameters:",
                                      value = mult.adj.desc[[mult]][[j]]$par[[1]],
                                      type = "text"
              )
            }
            else if (is.data.frame(mult.adj.desc[[mult]][[j]]$par[[1]])) {
              item[[ind.item]] = list(label = "Parameters:",
                                      value = mult.adj.desc[[mult]][[j]]$par[[1]],
                                      type = "table"
              )
            }
          }
        }
        if (n.mult.adj.sc>1) {
          subsubsubsection[[j]] = list(title = paste0("Multiplicity adjustment procedure ",j), item = item)
        }
      }
      if (n.mult.adj.sc>1) {
        subsubsection[[mult]] = list(title = custom.label.multiplicity.adjustment$label[mult], subsubsubsection = subsubsubsection)
      }
      else if (!is.null(evaluation$analysis.structure$mult.adjust) & n.multiplicity.adjustment>1){
        subsubsection[[mult]] = list(title = custom.label.multiplicity.adjustment$label[mult], item = item)
      }
    }
    if (n.mult.adj.sc>1) {
      subsection[[n.subsection]] = list(title = "Multiplicity adjustment", subsubsection = subsubsection )
    }
    else if (!is.null(evaluation$analysis.structure$mult.adjust) & n.multiplicity.adjustment>1){
      subsection[[n.subsection]] = list(title = "Multiplicity adjustment", subsubsection = subsubsection )
    }
    else if (!is.null(evaluation$analysis.structure$mult.adjust) & n.multiplicity.adjustment==1){
      subsection[[n.subsection]] = list(title = "Multiplicity adjustment", item = item)
    }
  }

  section[[3]] = list(title = "Analysis model", subsection = subsection)

  # Section : Simulation results
  ##############################

  # Empty subsection list
  subsection = list()

  # Empty subsubsection list
  subsubsection = list()

  # Empty subsubsubsection list
  subusbsubsection = list()

  n.section = nrow(result.structure$section)
  if (!is.null(result.structure$subsection)) n.subsection = nrow(result.structure$subsection)
  else n.subsection = 0

  # Get the names of the columns to span
  span = colnames(result.structure$table.structure[[1]]$results)[which(!(colnames(result.structure$table.structure[[1]]$results) %in% c("Criterion","Test/Statistic","Result")))]

  # Create each section
  for (section.ind in 1:n.section){
    table.result.section = result.structure$table.structure[unlist(lapply(result.structure$table.structure, function(x,ind.section=section.ind) {(x$section$number == ind.section) } ))]
    # Empty subsection list
    subsection = list()
    if (n.subsection >0) {
      for (subsection.ind in 1:n.subsection){
        # Result
        item1 = list(label = "Results summary",
                     value =  table.result.section[[subsection.ind]]$results,
                     type = "table",
                     param = list(span.columns = span)
        )

        # Create a subsection
        subsection[[subsection.ind]] = list(title = table.result.section[[subsection.ind]]$subsection$title, item = list(item1))
      }
      section[[3+section.ind]] = list(title = table.result.section[[subsection.ind]]$section$title, subsection = subsection)
    }
    else {
      # Result
      item1 = list(label = "Results summary",
                   value =  table.result.section[[1]]$results,
                   type = "table",
                   param = list(span.columns = span)
      )
      subsection[[1]] = list(title = NA, item = list(item1))
      section[[3+section.ind]] = list(title = table.result.section[[1]]$section$title, subsection = subsection)
    }
  }

  # Include all sections in the report -- the report object is finalized
  report = list(title = "Clinical scenario evaluation", section = section)

  return(list(result.structure = result.structure, report.structure = report ))

}
# End of CreateReportStructure

######################################################################################################################

# Function: capwords.
# Argument: String.
# Description: This function is used to capitalize every first letter of a word

capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
                           {s <- substring(s, 2); if(strict) tolower(s) else s},
                           sep = "", collapse = " " )
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

######################################################################################################################

# Function: mergeOutcomeParameter .
# Argument: two lists.
# Description: This function is used to merge two lists

mergeOutcomeParameter <- function (first, second)
{
  stopifnot(is.list(first), is.list(second))
  firstnames <- names(first)
  for (v in names(second)) {
    first[[v]] <- if (v %in% firstnames && is.list(first[[v]]) && is.list(second[[v]]))
      appendList(first[[v]], second[[v]])
    else paste0(first[[v]],' = ', lapply(second[[v]], function(x) round(x,3)))
  }
  paste0(first, collapse = ", ")
}

######################################################################################################################

# Function: appendList .
# Argument: two lists.
# Description: This function is used to merge two lists

appendList <- function (x, val)
{
  stopifnot(is.list(x), is.list(val))
  xnames <- names(x)
  for (v in names(val)) {
    x[[v]] <- if (v %in% xnames && is.list(x[[v]]) && is.list(val[[v]]))
      appendList(x[[v]], val[[v]])
    else c(x[[v]], val[[v]])
  }
  x
}



# ######################################################################################################################
#
# # Function: getOutcomeDist
# # Argument: no parameter.
# # Description: This function is used to print in the console the OutcomeDist available in the package.
# #' @export
# getOutcomeDist = function(){
#
#   result = matrix(nrow=100, ncol=2)
#   result[1,] = c("UniformDist", c("max"))
#   result[2,] = c("NormalDist", c("mean, sd"))
#   result[3,] = c("BinomDist", c("prop"))
#   result[4,] = c("ExpoDist", c("rate"))
#   result[5,] = c("MVNormalDist", c("par, corr"))
#   result[6,] = c("MVBinomDist", c("par, corr"))
#   result[7,] = c("MVExpoDist", c("par, corr"))
#   result[8,] = c("MVExpoPFSOSDist", c("par, corr"))
#   result[9,] = c("MVMixedDist", c("type, par, corr"))
#   result[10,] = c("PoissonDist", c("lambda"))
#   result[11,] = c("NegBinomDist", c("dispersion, mean"))
#
#   result = as.data.frame(result, row.names = NULL)
#   colnames(result) = c("outcome.dist", "outcome.par")
#
#   return(subset(result,!is.na(outcome.dist)))
# }

