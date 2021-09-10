.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname, force = TRUE)
}


ngboost <- reticulate::import("ngboost",delay_load = TRUE)
sklearn <- reticulate::import("sklearn",delay_load = TRUE)
scores <- reticulate::import("ngboost.scores",delay_load = TRUE)
