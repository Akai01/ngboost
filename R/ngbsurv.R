#' @title Constructor for NGBoost survival models.
#' @description
#' NGBSurvival is a wrapper for the generic NGBoost class that facilitates
#' survival analysis.
#' Use this class if you want to predict an outcome that could take an infinite
#'  number of (ordered) values, but right-censoring is present in the observed data.
#'
#' @author Resul Akay
#' @importFrom R6 R6Class
#' @export
NGBSurvival <- R6::R6Class(
  classname = "NGBSurvival",
  public = list(
    #' @description Initialize NGBoost Survival model.
    #' @param Dist Assumed distributional form of Y|X=x.
    #' @param A Distribution from ngboost.distns, e.g. Normal
    #' @param Score Rule to compare probabilistic predictions to the observed
    #' data. A score from ngboost.scores, e.g. LogScore
    #' @param Base Base learner to use in the boosting algorithm.
    #' Any instantiated sklearn regressor, e.g. DecisionTreeRegressor()
    #' @param natural_gradient Logical flag indicating whether the natural gradient should be used
    #' @param n_estimators The number of boosting iterations to fit
    #' @param learning_rate The learning rate
    #' @param minibatch_frac The percent subsample of rows to use in each boosting iteration
    #' @param col_sample The percent subsample of columns to use in each boosting iteration
    #' @param verbose Flag indicating whether output should be printed during fitting
    #' @param verbose_eval Increment (in boosting iterations) at which output should be printed
    #' @param tol Numerical tolerance to be used in optimization
    #' @param random_state Seed for reproducibility.
    #' @return An NGBRegressor object that can be fit.
    initialize = function(Dist = NULL,
                          Score = NULL,
                          Base = NULL,
                          natural_gradient = TRUE,
                          n_estimators = 500,
                          learning_rate = 0.01,
                          minibatch_frac = 1.0,
                          col_sample = 1.0,
                          verbose = TRUE,
                          verbose_eval = 100,
                          tol = 0.0001,
                          random_state = NULL){
      private$Dist <- Dist
      private$Base <- Base
      private$Score <- Score
      private$natural_gradient <- natural_gradient
      private$n_estimators <- as.integer(n_estimators)
      private$learning_rate <- learning_rate
      private$minibatch_frac <- minibatch_frac
      private$col_sample <- col_sample
      private$verbose <- verbose
      private$verbose_eval <- as.integer(verbose_eval)
      private$tol <- tol
      private$random_state <- random_state

      #ngboost <- reticulate::import("ngboost")
      private$model <- ngboost$NGBSurvival(
        Dist = private$Dist,
        Score = private$Score,
        Base = private$Base,
        natural_gradient = private$natural_gradient,
        n_estimators = private$n_estimators,
        learning_rate = private$learning_rate,
        minibatch_frac = private$minibatch_frac,
        col_sample = private$col_sample,
        verbose = private$verbose,
        verbose_eval = private$verbose_eval,
        tol = private$tol,
        random_state = private$random_state
      )
      return(self)
    },
    #' @description Fits an NGBoost survival model to the data.
    #' For additional parameters see ngboost.NGboost.fit
    #' @param X DataFrame object or List or numpy array of predictors (n x p)
    #' in Numeric format
    #' @param t DataFrame object or List or numpy array of times to event or
    #' censoring (n) (floats).
    #' @param E DataFrame object or List or numpy array of event indicators (n).
    #' E(i) = 1 <=> T(i) is the time of an event, else censoring time
    #' @param X_val DataFrame object or List or numpy array of validation-set
    #' predictors in numeric format
    #' @param T_val DataFrame object or List or validation-set times, in numeric
    #'  format if any
    #' @param E_val DataFrame object or List or validation-set event idicators,
    #' in numeric format if any
    #' @param ... Additonal parameters. For additional parameters see
    #' ngboost.NGboost.fit
    #' @return NULL
    #'
    fit = function(X,
                   t,
                   E,
                   X_val=NULL,
                   T_val=NULL,
                   E_val=NULL, ...){
      private$feature_names <- colnames(X)
      model = private$model
      model$fit(X,
                t,
                E,
                X_val,
                T_val,
                E_val, ...)
      return(invisible(NULL))
    },
    #' @description Return the feature importances for all parameters in the
    #' distribution (the higher, the more important the feature).
    #' @return A data frame
    #'
    feature_importances = function(){
      model = private$model
      out <- model$feature_importances_
      feature_names <- private$feature_names
      out <- data.frame("features" = c(feature_names), "importance" = c(out))
      private$feature_importance_data <- out
      return(out)
    },
    #' @description Plot feature importance
    plot_feature_importance = function(){

      feature_importance_data <- private$feature_importance_data

      if(is.null(feature_importance_data)){
        stop("Please use feature_importances method fist.")
      }

      ggplot2::ggplot(data = feature_importance_data,
                      ggplot2::aes(y = .data$features, x = .data$importance)) +
        ggplot2::geom_col()
    },
    #' @description Point prediction of Y at the points X=x
    #' @param X DataFrame object or List or numpy array of predictors (n x p)
    #' in numeric Format
    #' @param max_iter Get the prediction at the specified number of boosting
    #' iterations
    #' @return Numpy array of the estimates of Y
    #'
    predict = function(X, max_iter = NULL){
      model = private$model
      model$predict(X = X, max_iter = max_iter)
    },
    #' @description Predict the conditional distribution of Y at the points X=x
    #' at multiple boosting iterations
    #' @param X DataFrame object or List or numpy array of predictors (n x p)
    #' in numeric Format
    #' @param max_iter Get the prediction at the specified number of boosting
    #' iterations
    #' @return  A list of NGBoost distribution objects, one per boosting stage
    #' up to max_iter.
    staged_pred_dist = function(X, max_iter = NULL){
      model = private$model
      model$staged_pred_dist(X = as.matrix(X), max_iter = max_iter)
    },

    #' @description Point prediction of Y at the points X=x at multiple boosting
    #' iterations.
    #' @param X DataFrame object or List or numpy array of predictors (n x p)
    #' in numeric Format
    #' @param max_iter Get the prediction at the specified number of boosting
    #' iterations
    #' @return  A list of NGBoost distribution objects, one per boosting stage
    #' up to max_iter.
    staged_pred = function(X, max_iter = NULL){
      model = private$model
      model$staged_pred(X = as.matrix(X), max_iter = max_iter)
    },

    #' @description Set the parameters of this estimator.
    #' The method works on simple estimators as well as on nested objects
    #' (such as :class:`~sklearn.pipeline.Pipeline`). The latter have
    #' parameters of the form ``<component>__<parameter>`` so that it's
    #' possible to update each component of a nested object.
    #' @param ... dict (a named R list). Estimator parameters.
    #' @return self : estimator instance. Estimator instance.
    #'
    set_params = function(...){
      model = private$model
      model$set_params(...)

      return(self)
    },

    #' @description Get parameters for this estimator.
    #' @param deep bool, default = TRUE
    #' If True, will return the parameters for this estimator and
    #' contained subobjects that are estimators.
    #' @return params. A dict (R list). Parameter names mapped to their values.
    get_params = function(deep = TRUE){
      model = private$model
      model$get_params(deep = deep)
    },
    #' @description Predict the conditional distribution of Y at the points X=x
    #' @param X DataFrame object or List or numpy array of predictors (n x p) in
    #' numeric format.
    #' @param max_iter get the prediction at the specified number of boosting
    #'  iterations.
    #' @return A NGBDist Class
    #'
    #' @details See for available methods \code{\link{NGBDist}}
    #'
    pred_dist = function(X, max_iter=NULL){
      model = private$model
      NGBDist$new(model$pred_dist(X = X, max_iter=max_iter))
    }
  ),
  private = list(Dist = NULL,
                 Score = NULL,
                 Base = NULL,
                 natural_gradient = NULL,
                 n_estimators = NULL,
                 learning_rate = NULL,
                 minibatch_frac = NULL,
                 col_sample = NULL,
                 verbose = NULL,
                 verbose_eval = NULL,
                 tol = NULL,
                 random_state = NULL,
                 model = NULL,
                 feature_names = NULL,
                 feature_importance_data = NULL)
)
