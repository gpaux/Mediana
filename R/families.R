#' Create list of character strings
#'
#' This function is used mostly for user's convenience. It simply creates a
#' list of character strings.
#'
#'
#' @aliases tests samples statistics parameters families
#' @param \dots defines character strings to be passed into the function.
#' @references \url{http://gpaux.github.io/Mediana/}
#' @export families
families = function(...) {

  args = list(...)

  nargs = length(args)

  if (nargs <= 0) stop("Families function: At least one family must be specified.")

  return(args)
  invisible(args)

}
