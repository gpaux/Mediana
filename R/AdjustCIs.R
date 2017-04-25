##############################################################################################################################################

# Function: AdjustCIs
# Argument: est (vector) and proc and par (list of parameters).
# Description: This function returns adjusted pvalues according to the multiple testing procedure specified in the multadj argument
#' @export
AdjustCIs = function(est, proc, par=NA){

  # Check if the multiplicity adjustment procedure is specified, check if it exists
  if (!exists(paste0(proc,".CI"))) {
    stop(paste0("AdjustCIs: Simultaneous confidence intervals for '", proc, "' does not exist."))
  } else if (!is.function(get(as.character(paste0(proc,".CI")), mode = "any"))) {
    stop(paste0("AdjustCIs: Simultaneous confidence intervals for '", proc, "' does not exist."))
  }

  result = do.call(paste0(proc,".CI"), list(est, list("Analysis", par)))
  return(result)
}
