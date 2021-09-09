#' R interface for NGBoost package
#'
#' The goal of ngboost is to provide an R interface for the Python package \href{https://stanfordmlgroup.github.io}{NGBoost}
#' @rdname ngboost
#' @docType package
#' @name ngboost


#' @export
ngboost <- NULL
sklearn <- NULL
scores <- NULL
.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname)
  ngboost <- reticulate::import("ngboost",delay_load = TRUE)
  sklearn <- reticulate::import("sklearn",delay_load = TRUE)
  scores <-  reticulate::import("ngboost.scores",delay_load = TRUE)
}
