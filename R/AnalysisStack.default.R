############################################################################################################################

# Function: AnalysisStack
# Argument: ....
# Description: This function generate analysis result according to the data model and analysis model
#' @export
AnalysisStack.default = function(data.model, analysis.model, sim.parameters){

  analysis.stack = PerformAnalysis(data.model, analysis.model, sim.parameters)
  class(analysis.stack) = "AnalysisStack"

  return(analysis.stack)
}
