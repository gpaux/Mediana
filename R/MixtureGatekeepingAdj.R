######################################################################################################################

# Function: MixtureGatekeepingAdj
# Argument: rawp, Raw p-value.
#           par, List of procedure parameters: vector of family (1 x m) Vector of component procedure labels ('BonferroniAdj.global' or 'HolmAdj.global' or 'HochbergAdj.global' or 'HommelAdj.global') (1 x nfam) Vector of truncation parameters for component procedures used in individual families (1 x nfam)

# Description: Computation of adjusted p-values for gatekeeping procedures based on the mixture methods (ref Dmitrienko et al. (2011))

MixtureGatekeepingAdj = function(rawp, par) {
  # Determine the function call, either to generate the p-value or to return description
  call = (par[[1]] == "Description")

  if (any(call == FALSE) | any(is.na(call))) {
    # Error check
    if (is.null(par[[2]]$family)) stop("Analysis model: Mixture-based gatekeeping procedure: Hypothesis families must be specified.")
    if (is.null(par[[2]]$proc)) stop("Analysis model: Mixture-based gatekeeping procedure: Procedures must be specified.")
    if (is.null(par[[2]]$gamma)) stop("Analysis model: Mixture-based gatekeeping procedure: Gamma must be specified.")
    if (is.null(par[[2]]$parallel)) stop("Analysis model: Mixture-based gatekeeping procedure: Parallel restriction set must be specified.")
    if (is.null(par[[2]]$serial)) stop("Analysis model: Mixture-based gatekeeping procedure: Serial restriction set must be specified.")

    # Number of p-values
    nhyp = length(rawp)
    # Extract the vector of family (1 x m)
    family = par[[2]]$family
    # Number of families in the multiplicity problem
    nfam = length(family)
    # Extract the list of parallel resriction set (m list containint vectors (1 x m))
    parallel = par[[2]]$parallel
    # Extract the vector of serial resriction set (m list containint vectors (1 x m))
    serial = par[[2]]$serial

    # Number of null hypotheses per family
    nperfam = lapply(family, function(x) length(x))

    # Extract the vector of procedures (1 x m)
    proc = paste(unlist(par[[2]]$proc), ".global", sep = "")
    # Extract the vector of truncation parameters (1 x m)
    gamma = unlist(par[[2]]$gamma)

    # Simple error checks
    if (nhyp != length(unlist(family)))
      stop("Mixture-based gatekeeping adjustment: Length of the p-value vector must be equal to the number of hypothesis.")
    if (length(proc) != nfam)
      stop("Mixture-based gatekeeping adjustment: Length of the procedure vector must be equal to the number of families.") else {
        for (i in 1:nfam) {
          if (proc[i] %in% c("BonferroniAdj.global", "HolmAdj.global", "HochbergAdj.global", "HommelAdj.global") == FALSE)
            stop("Mixture-based gatekeeping adjustment: Only Bonferroni (BonferroniAdj), Holm (HolmAdj), Hochberg (HochbergAdj) and Hommel (HommelAdj) component procedures are supported.")
        }
      }
    if (length(gamma) != nfam)
      stop("Mixture-based gatekeeping adjustment: Length of the gamma vector must be equal to the number of families.") else {
        for (i in 1:nfam) {
          if (gamma[i] < 0 | gamma[i] > 1)
            stop("Mixture-based gatekeeping adjustment: Gamma must be between 0 (included) and 1 (included).") else if (proc[i] == "bonferroni.global" & gamma[i] != 0)
              stop("Mixture-based gatekeeping adjustment: Gamma must be set to 0 for the global Bonferroni procedure.")
        }
      }
    if (nhyp != length(parallel))
      stop("Mixture-based gatekeeping adjustment: Length of the parallel restriction set must be equal to the number of hypothesis.")
    if (any(unlist(lapply(parallel, function(x) length(x)!= nhyp))))
      stop("Mixture-based gatekeeping adjustment: Each lenght's vector of the parallel restriction set must be equal to the number of hypothesis.")
    if (nhyp != length(serial))
      stop("Mixture-based gatekeeping adjustment: Length of the serial restriction set must be equal to the number of hypothesis.")
    if (any(unlist(lapply(serial, function(x) length(x)!= nhyp))))
      stop("Mixture-based gatekeeping adjustment: Each lenght's vector of the serial restriction set must be equal to the number of hypothesis.")

        # Number of intersection hypotheses in the closed family
    nint = 2^nhyp - 1

    # Construct the intersection index sets (int_orig) before the logical restrictions are applied.  Each row is a vector of binary indicators (1 if the hypothesis is
    # included in the original index set and 0 otherwise)
    int_orig = matrix(0, nint, nhyp)
    serial_index = matrix(1, nint, nhyp)
    parallel_index = matrix(1, nint, nhyp)
    testable_index = matrix(1, nint, nhyp)
    int_rest = matrix(0, nint, nhyp)
    fam_rest = matrix(1, nint, nhyp)
    for (i in 1:nhyp) {
      for (j in 0:(nint - 1)) {
        k = floor(j/2^(nhyp - i))
        if (k/2 == floor(k/2))  int_orig[j + 1, i] = 1
      }
      # Serial index indicates for each row if the hypothesis is testebale after having applied the serial restriction
      serial_index[,i] = apply(int_orig, 1, function(x) all((x * serial[[i]])==0))
      # Parallel index indicates for each row if the hypothesis is testebale after having applied the parallel restriction
      parallel_index[,i] = apply(int_orig, 1, function(x) ifelse(any(parallel[[i]]==1), any((x * parallel[[i]])[which(parallel[[i]]==1)]==0),1))
      # Testable index: if serial or parallel indicates that the hypothesis is testable
      testable_index[,i] = mapply(x = serial_index[,i], y = parallel_index[,i], function(x,y) x==TRUE & y == TRUE)
      # Construct the intersection index sets (int_rest) and family index sets (fam_rest) after the logical restrictions are applied.
      # Each row is a vector of binary indicators (1 if the hypothesis is included in the restricted index set and 0 otherwise)
      int_rest[,i] = int_orig[,i] * testable_index[,i]
      fam_rest[,i] = fam_rest[,i] * testable_index[,i]
    }

    # Number of null hypotheses from each family included in each intersection before the logical restrictions are applied
    korig = do.call(cbind, lapply(family, function(x) apply(as.matrix(int_orig[, x]), 1, sum)))

    # Number of null hypotheses from each family included in the current intersection after the logical restrictions are applied
    krest = do.call(cbind, lapply(family, function(x) apply(as.matrix(int_rest[, x]), 1, sum)))

    # Number of null hypotheses from each family after the logical restrictions are applied
    nrest = do.call(cbind, lapply(family, function(x) apply(as.matrix(fam_rest[, x]), 1, sum)))

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
          # Use the following line for modified mixture method
          # tot = nrest[i, j]
          # Use the following line for standard mixture method
          tot = nperfam[[j]]
          pcomp[i, j] = do.call(proc[j], list(pselected, tot, gamma[j]))
        } else if (krest[i, j] == 0)
          pcomp[i, j] = 1
      }

      # Compute family weights
      c[i, 1] = 1
      for (j in 2:nfam) {
        # Use the following line for modified mixture method
        # c[i, j] = c[i, j - 1] * (1 - errorfrac(krest[i, j - 1], nrest[i, j - 1], gamma[j - 1]))
        # Use the following line for standard mixture method
        c[i, j] = c[i, j - 1] * (1 - errorfrac(korig[i, j - 1], nperfam[[j - 1]], gamma[j - 1]))
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
    serial = par[[2]]$serial
    parallel = par[[2]]$parallel
    test.id=unlist(par[[3]])
    proc.par = data.frame(nrow = nfam, ncol = 4)
    for (i in 1:nfam){
      proc.par[i,1] = i
      proc.par[i,2] = paste0("{",paste(test.id[family[[i]]], collapse = ", "),"}")
      proc.par[i,3] = proc[i]
      proc.par[i,4] = gamma[i]
    }
    colnames(proc.par) = c("Family", "Hypotheses set", "Component procedure", "Truncation parameter")

    nhyp = length(test.id)
    hyp.par = data.frame(nrow = nhyp, ncol = 4)
    index = 0
    for (i in 1:nfam){
      for (j in 1:length(family[[i]])){
        index = index + 1
        hyp.par[index,1] = i
        hyp.par[index,2] = test.id[family[[i]][j]]
        hyp.par[index,3] = ifelse(sum(parallel[[family[[i]][j]]])>0,paste0("{",paste(test.id[which(parallel[[family[[i]][j]]]==1)], collapse = ", "),"}"),"")
        hyp.par[index,4] = ifelse(sum(serial[[family[[i]][j]]])>0,paste0("{",paste(test.id[which(serial[[family[[i]][j]]]==1)], collapse = ", "),"}"),"")
      }
    }
    colnames(hyp.par) = c("Family", "Hypothesis", "Parallel rejection set", "Serial rejection set")
    result=list(list("Mixture-based gatekeeping"),list(proc.par, hyp.par))
  }



  return(result)
}
# End of MultipleSequenceGatekeepingAdj
