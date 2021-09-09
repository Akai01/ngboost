#' Select a rule to compare probabilistic predictions P̂ to the observed data y.
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

  #scores <- reticulate::import("ngboost.scores")
  score <- match.arg(score)
  if(score == "CRPS"){
    out <- scores$CRPS
  }
  if(score == "CRPScore"){
    out <- scores$CRPScore
  }
  if(score == "LogScore"){
    out <- scores$LogScore
  }
  if(score == "MLE"){
    out <- scores$MLE
  }
  return(out)
}
