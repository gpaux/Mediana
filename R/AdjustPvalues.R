##############################################################################################################################################

# Function: AdjustPvalues
# Argument: pval (vector) and proc and par (list of parameters).
# Description: This function returns adjusted pvalues according to the multiple testing procedure specified in the multadj argument
#' @export
AdjustPvalues = function(pval, proc, par=NA){

  # Check if the multiplicity adjustment procedure is specified, check if it exists
  if (!exists(proc)) {
    stop(paste0("AdjustPvalues: Multiplicity adjustment procedure function '", proc, "' does not exist."))
  } else if (!is.function(get(as.character(proc), mode = "any"))) {
    stop(paste0("AdjustPvalues: Multiplicity adjustment procedure function '", proc, "' does not exist."))
  }

  adjustpval = do.call(proc, list(pval, list("Analysis", par)))
  return(adjustpval)
}
