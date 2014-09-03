
#' Load multiple versions of the same package
#'
#' @docType package
#' @name camo-package
#' @rdname camo-package
#' @import magrittr
NULL

#' Load a given version of a package, and return it as an object
#'
#' @param package Package name.
#' @param version Package version.
#'
#' @export
#' @importFrom falsy %||%
#' @importFrom assertthat assert_that is.string

camo <- function(package, version) {

  assert_that(is.string(package))
  missing(version) %||% assert_that(is.string(version))

  ## Search for the given version of the package
  lib_dir <- find_package(package, version) %||%
    stop("Cannot find ", package, "@", version)

  ## Temporary package directory
  t_dir <- tempfile()
  dir.create(t_dir)

  ## New name of the package
  new_name <- package %+% "@" %+% version
  new_dir <- file.path(t_dir, new_name)

  ## Make a copy of the package, under a different name
  file.path(lib_dir, package) %>%
    file.copy(t_dir, overwrite = TRUE, recursive = TRUE)
  file.path(t_dir, package) %>%
    file.rename(new_dir)

  ## Need to edit 'Version' in package.rds file
  package_rds <- file.path(new_dir, "Meta", "package.rds") %>%
    readRDS()
  package_rds$DESCRIPTION["Package"] <- new_name
  file.path(new_dir, "Meta", "package.rds") %>%
    saveRDS(object = package_rds)

  ## Rename files in the R directory
  r_dir <- file.path(new_dir, "R")
  file.path(r_dir, package) %>%
    file.rename(file.path(r_dir, new_name))
  file.path(r_dir, package %+% ".rdb") %>%
    file.rename(file.path(r_dir, new_name %+% ".rdb"))
  file.path(r_dir, package %+% ".rdx") %>%
    file.rename(file.path(r_dir, new_name %+% ".rdx"))

  ## Load it
  loadNamespace(new_name, lib.loc = t_dir)

}

find_package <- function(package, version) {
  versions <- package_versions(package)
  versions$dir[match(version, versions$version)] %>%
    NA_NULL()
}

package_versions <- function(package) {

  dirs <- .libPaths() %>%
    file.path(package) %>%
    Filter(f = file.exists) %>%
    unname()

  versions <- dirs %>%
    file.path("DESCRIPTION") %>%
    lapply(read.dcf) %>%
    vapply(extract_column, FUN.VALUE = "", "Version") %>%
    unname()

  data.frame(
    stringsAsFactors = FALSE,
    dir = dirs %>% dirname(),
    version = versions
  )
}
