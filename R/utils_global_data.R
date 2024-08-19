#' global_data
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
.onLoad <- function(libname, pkgname) {
  assign("earthquake_data", read.csv(system.file("data", "eq_mag5plus_2014_2024.csv", package = pkgname)), envir = globalenv())
}
