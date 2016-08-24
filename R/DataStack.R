############################################################################################################################

# Function: DataStack
# Argument: ....
# Description: This function generate data according to the data model
#' @export
DataStack = function(data.model, sim.parameters) {
  UseMethod("DataStack")
}
