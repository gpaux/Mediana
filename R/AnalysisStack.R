############################################################################################################################

# Function: AnalysisStack
# Argument: ....
# Description: This function generate analysis result according to the data model and analysis model
#' @export
AnalysisStack = function(data.model, analysis.model, sim.parameters) {
  UseMethod("AnalysisStack")
}
