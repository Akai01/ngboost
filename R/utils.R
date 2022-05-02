#' Scikit-Learn interface
#' @param module scikit-learn module name, default is 'tree'.
#' @param class scikit-learn's module class, default is 'DecisionTreeRegressor'
#' @param ... Other arguments passed to model class
#' @author Resul Akay
#' @examples
#' \dontrun{
#'
#' sklearner(module = "tree", class = "DecisionTreeRegressor",
#' criterion="friedman_mse", min_samples_split=2)
#'
#' }
#'
#' @export
sklearner <- function(module = "tree", class = "DecisionTreeRegressor",
                      ...){
  sklearn[[module]][[class]](...)
}

#' NGBoost distributions
#' @param dist NGBoost distributions
#' \itemize{
#' \item Bernoulli
#' \item k_categorical
#' \item StudentT
#' \item Poisson
#' \item Laplace
#' \item Cauchy
#' \item Exponential
#' \item LogNormal
#' \item MultivariateNormal
#' \item Normal
#' }
#' @import reticulate
#' @param k Used only with k_categorical and MultivariateNormal
#' @export
Dist <- function(dist = c("Normal", "Bernoulli", "k_categorical", "StudentT",
                          "Laplace", "Cauchy", "Exponential", "LogNormal",
                          "MultivariateNormal", "Poisson"), k){
  dist <- match.arg(dist)
  if(dist %in% c("MultivariateNormal", "k_categorical")){
    if(dist == "k_categorical"){
      out <- ngboost[["distns"]][[dist]](K = as.integer(k))
    } else{
      out <- ngboost[["distns"]][[dist]](k = as.integer(k))
    }
  } else {
    out <- ngboost[["distns"]][[dist]]
  }
  out
}

#' Select a rule to compare probabilistic predictions to the observed data.
#' A score from ngboost.scores, e.g. LogScore.
#' @param score A string. can be one of the following:
#' \itemize{
#'
#'  \item LogScore : Generic class for the log scoring rule.
#'  \item CRPS : Generic class for the continuous ranked probability scoring rule.
#'  \item CRPScore : Generic class for the continuous ranked probability scoring rule.
#'  \item MLE : Generic class for the log scoring rule.
#'  }
#' @author Resul Akay
#' @return A score class from ngboost.scores
#' @export
Scores <- function(score = c("LogScore", "CRPS", "CRPScore", "MLE")){
  score <- match.arg(score)
  out <- scores[[score]]
  return(out)
}

#' Is conda installed?
#' @return Logical, true if and only if conda is installed.
#' @export
#' @author Resul Akay
is_exists_conda <- function() {
  clist <- tryCatch({
    reticulate::conda_list()
  }, error = function(e){
    list()
  }
  )
  return(length(clist) > 0)
}

#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

#' Assignment pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%<>\%}} for details.
#'
#' @name %<>%
#' @rdname assignment_pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %<>%
#' @usage lhs \%<>\% rhs
NULL

`%notin%` <- Negate(`%in%`)

