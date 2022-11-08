#' NGBoost classifier distribution object
#'
#' @export
#' @author Resul Akay
NGBDistClass <- R6::R6Class(
  classname = "NGBDistClass",
  public = list(
    #' @description Initialize the NGBoost distribution object.
    #' It is initialize internally.
    #' @param x A python ngboost.distns.distn.Distn.uncensor object
    #' @returns A NGBDist Class
    initialize = function(x){
      private$dist <- x
      return(self)
    },
    #' @description Class Probabilities
    class_probs = function(){
      private$dist$class_probs()
    }
  ),
  private = list(
    dist = NULL
  ),
  )
