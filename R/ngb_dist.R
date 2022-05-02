#' NGBoost distribution object
#'
#' @export
#' @author Resul Akay
NGBDist <- R6::R6Class(
  classname = "NGBDist",
  public = list(
    #' @description Initialize the NGBoost distribution object.
    #' It is initialize internally.
    #' @param x A python ngboost.distns.distn.Distn.uncensor object
    #' @returns A NGBDist Class
    initialize = function(x){
      private$dist <- x
      return(self)
    },
    #' @description
    #' Random variates of given type.
    #'
    #' @return Random variates
    #'
    rvs = function(){
      private$dist$rvs()
    },
    #' @description Probability density function at x of the given RV.
    #' @param quantiles The quantiles
    #'
    #' @param ... Ignored
    #'
    #' @return Probability density function evaluated at quantiles
    #'
    pdf = function(quantiles, ...){
      private$dist$pdf(quantiles)
    },
    #' @description Log of the probability density function at x of the given RV.
    #' This uses a more numerically accurate calculation if available.
    #' @param quantiles The quantiles
    #'
    #' @return Log of the probability density function evaluated at quantiles
    #'
    logpdf = function(quantiles){
      private$dist$logpdf(quantiles)
    },

    #' @description  Cumulative distribution function of the given RV.
    #'
    #' @param quantiles The quantiles
    #'
    #' @return Cumulative distribution function evaluated at quantiles
    #'
    cdf = function(quantiles){
      private$dist$cdf(quantiles)
    },

    #' @description  Log of the cumulative distribution function at x of the
    #' given RV.
    #'
    #' @param quantiles The quantiles
    #'
    #' @return Log of the cumulative distribution function evaluated at
    #' quantiles.
    #'
    logcdf = function(quantiles){
      private$dist$logcdf(quantiles)
    },

    #' @description Survival function (1 - 'cdf') at x of the given RV.
    #' @param quantiles The quantiles
    #'
    #' @return Survival function evaluated at quantiles
    #'
    sf = function(quantiles){
      private$dist$sf(quantiles)
    },

    #' @description Log of the survival function of the given RV.
    #' @param quantiles The quantiles
    #' @param return Log of the survival function evaluated at quantiles
    logsf = function(quantiles){
      private$dist$logsf(quantiles)
    },

    #' @description Percent point function (inverse of 'cdf') at q of the
    #' given RV.
    #' @param q array, Lower tail probability.
    #' @param ... Other arguments
    #' @return quantile corresponding to the lower tail probability q
    ppf = function(q, ...){
      private$dist$ppf(q, ...)
    },


    #' @description Inverse survival function (inverse of sf) at q of the
    #' given RV.
    #' @param q array, Lower tail probability.
    #'
    #' @return
    #' Quantile corresponding to the upper tail probability, q.
    #'
    isf = function(q){
      private$dist$isf(q)
    },

    #' @description Differential entropy.
    #'
    #' @return Differential entropy
    #'
    entropy = function(){
      private$dist$dist$entropy()
    },

    #' @description Confidence interval with equal areas around the median.
    #' @param confidence Probability that an rv will be drawn from the returned range.
    #' Each value should be in the range \code{0>= confidence <=1}.
    #'
    #' @return nd-points of range that contain \code{100 * confidence} of
    #' the rv's possible values.
    #'
    interval = function(confidence){
      private$dist$interval(confidence)
    },

    #' @description Mean of the distribution.
    #' @return The mean of the distribution
    mean = function(){
      private$dist$mean()
    },
    #' @description Median of the distribution.
    #' @return The median of the distribution
    median = function(){
      private$dist$dist$median()
    },

    #' @description Standard deviation of the distribution
    #' @return The standard deviation of the distribution
    std = function(){
      private$dist$dist$std()
    },

    #' @description Variance of the distribution.
    #' @return The variance of the distribution.
    var = function(){
      private$dist$dist$var()
    }
  ),
  private = list(
    dist = NULL
  )
)
