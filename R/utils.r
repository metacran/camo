
extract_column <- function(x, col) {
  x[, col]
}

NA_NULL <- function(x) {
  if (length(x) == 1 && is.na(x)) NULL else x
}

`%+%` <- function(lhs, rhs) {
  assert_that(is.string(lhs))
  assert_that(is.string(rhs))
  paste0(lhs, rhs)
}
