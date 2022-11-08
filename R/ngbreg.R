#' @title Constructor for NGBoost regression models.
#' @description
#' NGBRegressor is a wrapper for the generic NGBoost class that facilitates
#' regression.Use this class if you want to predict an outcome that could take
#' an infinite number of (ordered) values.
#'
#' @examples
#' \dontrun{
#'
#' data(Boston, package = "MASS")
#'
#' dta <- rsample::initial_split(Boston)
#'
#' train <- rsample::training(dta)
#'
#' test <- rsample::testing(dta)
#'
#'
#' x_train = train[,1:13]
#' y_train = train[,14]
#'
#' x_test = test[,1:13]
#' y_test = test[,14]
#'
#'
#' model <- NGBRegression$new(Dist = Dist("Exponential"),
#'                            Base=DecisionTreeRegressor(
#'                              criterion="mae",
#'                              min_samples_split=2,
#'                              min_samples_leaf=1,
#'                              min_weight_fraction_leaf=0.0,
#'                              max_depth=5,
#'                              splitter="best",
#'                              random_state=NULL),
#'                            Score = Scores("MLE"),
#'                            natural_gradient=TRUE,
#'                            n_estimators= 600,
#'                            learning_rate= 0.002,
#'                            minibatch_frac= 0.8,
#'                            col_sample= 0.9,
#'                            verbose=TRUE,
#'                            verbose_eval=100,
#'                            tol=1e-5)
#'
#' model$fit(X = x_train, Y = y_train, X_val = x_test, Y_val = y_test)
#'
#' model$feature_importances()
#'
#' model$plot_feature_importance()
#'
#' model$predict(x_test)
#'
#' }
#'
#'
#' @author Resul Akay
#' @importFrom R6 R6Class
#' @export
NGBRegression <- R6::R6Class(
  classname = "NGBRegression",
  public = list(
    #' @description Initialize NGBoost regression model.
    #' @param Dist Assumed distributional form of Y|X=x.
    #' @param A Distribution from ngboost.distns, e.g. Normal
    #' @param Score Rule to compare probabilistic predictions to the observed
    #' data. A score from ngboost.scores, e.g. LogScore
    #' @param Base Base learner to use in the boosting algorithm.
    #' Any instantiated sklearn regressor, e.g. DecisionTreeRegressor()
    #' @param natural_gradient Logical flag indicating whether the natural
    #' gradient should be used
    #' @param n_estimators The number of boosting iterations to fit
    #' @param learning_rate The learning rate
    #' @param minibatch_frac The percent subsample of rows to use in each
    #' boosting iteration
    #' @param col_sample The percent subsample of columns to use in each
    #'  boosting iteration
    #' @param verbose Flag indicating whether output should be printed during
    #' fitting
    #' @param verbose_eval Increment (in boosting iterations) at which output
    #'  should be printed
    #' @param tol Numerical tolerance to be used in optimization
    #' @param random_state Seed for reproducibility.
    #' @return An NGBRegressor object that can be fit.
    initialize = function(Dist = NULL,
                          Score = NULL,
                          Base = NULL,
                          natural_gradient = TRUE,
                          n_estimators = as.integer(500),
                          learning_rate = 0.01,
                          minibatch_frac = 1.0,
                          col_sample = 1.0,
                          verbose = TRUE,
                          verbose_eval = as.integer(100),
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
      private$model <- ngboost$NGBRegressor(
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
    #' @description An NGBRegressor object that can be fit.
    #' @param X DataFrame object or List or numpy array of predictors (n x p)
    #' in Numeric format
    #' @param Y DataFrame object or List or numpy array of outcomes (n)
    #' in numeric format. Should be floats for regression and integers from 0
    #'  to K-1 for K-class classification
    #' @param X_val DataFrame object or List or numpy array of validation-set
    #' predictors in numeric format
    #' @param Y_val DataFrame object or List or numpy array of validation-set
    #' outcomes in numeric format
    #' @param sample_weight how much to weigh each example in the training set.
    #' numpy array of size (n) (defaults to 1)
    #' @param val_sample_weight How much to weigh each example in the validation
    #' set. (defaults to 1)
    #' @param train_loss_monitor A custom score or set of scores to track on the
    #' training set during training. Defaults to the score defined in the
    #' NGBoost constructor.
    #' @param val_loss_monitor A custom score or set of scores to track on the
    #'  validation set during training. Defaults to the score defined in the
    #'  NGBoost  constructor
    #' @param early_stopping_rounds The number of consecutive boosting
    #'  iterations during which the loss has to increase before the algorithm
    #'  stops early.
    #' @return NULL
    #'
    fit = function(X,
                   Y,
                   X_val=NULL,
                   Y_val=NULL,
                   sample_weight=NULL,
                   val_sample_weight=NULL,
                   train_loss_monitor=NULL,
                   val_loss_monitor=NULL,
                   early_stopping_rounds=NULL){
      private$feature_names <- colnames(X)
      model = private$model
      model$fit(X = X,
                Y = Y,
                X_val = X_val,
                Y_val = Y_val,
                sample_weight = sample_weight,
                val_sample_weight = val_sample_weight,
                train_loss_monitor = train_loss_monitor,
                val_loss_monitor = val_loss_monitor,
                early_stopping_rounds = early_stopping_rounds)
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
    #' @return A NGBDistReg Class
    #'
    #' @details See for available methods \code{\link{NGBDistReg}}
    #'
    pred_dist = function(X, max_iter=NULL){
      model = private$model

      NGBDistReg$new(model$pred_dist(X = X, max_iter=max_iter))

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
