############################################################################################################################

# Function: GenerateData
# Argument: ....
# Description: This function generate data according to the data model
#' @export
GenerateData = function(data.model, sim.parameters) {
  UseMethod("GenerateData")
}
