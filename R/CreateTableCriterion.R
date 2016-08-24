############################################################################################################################

# Function: CreateTableCriterion.
# Argument: analysis.strucure and label (optional).
# Description: Generate a summary table of criteria for the report.

CreateTableCriterion = function(evaluation.structure, label = NULL) {

  # Number of criterion
  n.criterion = length(evaluation.structure$criterion)

  criterion.table = matrix(nrow = n.criterion, ncol = 6)
  ntest = unlist(lapply(evaluation.structure$criterion, function(x) length(x$test)))
  nstatistic = unlist(lapply(evaluation.structure$criterion, function(x) length(x$statistics)))
  npar = unlist(lapply(evaluation.structure$criterion, function(x) length(unlist(x$par)[which(!is.na(unlist(x$par)))])))
  
  for (i in 1:n.criterion) {
    criterion.table[i, 1] = evaluation.structure$criterion[[i]]$id
    criterion.table[i, 2] = evaluation.structure$criterion[[i]]$method   
    criterion.table[i, 3] = ifelse(npar[i]>0,
                                   paste0(names(evaluation.structure$criterion[[i]]$par)," = ", lapply(evaluation.structure$criterion[[i]]$par, function(x) round(x,4)), collapse = "\n"),
                                   "")
    criterion.table[i, 4] = ifelse(ntest[i]>0,
                                   #paste0("{",paste0(unlist(evaluation.structure$criterion[[i]]$test), collapse = ", "),"}"),
                                   paste0(unlist(evaluation.structure$criterion[[i]]$test), collapse = "\n"),
                                   "")
    criterion.table[i, 5] = ifelse(nstatistic[i]>0,
                                   #paste0("{",paste0(unlist(evaluation.structure$criterion[[i]]$statistics), collapse = ", "),"}"),
                                   paste0(unlist(evaluation.structure$criterion[[i]]$statistics), collapse = "\n"),
                                   "")
    #criterion.table[i, 6] = paste0("{",paste0(unlist(evaluation.structure$criterion[[i]]$labels), collapse = ", "),"}")
    criterion.table[i, 6] = paste0(unlist(evaluation.structure$criterion[[i]]$labels), collapse = "\n")
  }
  
  criterion.table = as.data.frame(criterion.table)
  colnames(criterion.table) = c("Criterion ID", "Criterion method", "Criterion parameters", "Tests", "Statistics", "Label")
  return(criterion.table[-c(2)])
}
# End of CreateTableCriterion