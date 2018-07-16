######################################################################################################################

# Function: GenerateReport.
# Argument: Results returned by the CSE function and presentation model and Word-document title and Word-template.
# Description: This function is used to create a summary table with all results
#' @export

GenerateReport = function(presentation.model = NULL, cse.results, report.filename, report.template = NULL){
  if (!requireNamespace("officer", quietly = TRUE)) {
   stop("officer R package is needed for to generate the report. Please install it.",
         call. = FALSE)
  }
  if (!requireNamespace("flextable", quietly = TRUE)) {
    stop("flextable R package is needed for to generate the report. Please install it.",
         call. = FALSE)
  }
  UseMethod("GenerateReport")

}
