#' Decision tree regressor
#'
#' @param criterion c("mse", "friedman_mse", "mae", "poisson"), default="mse"
#' The function to measure the quality of a split. Supported criteria
#' are "mse" for the mean squared error, which is equal to variance
#' reduction as feature selection criterion and minimizes the L2 loss
#' using the mean of each terminal node, "friedman_mse", which uses mean
#' squared error with Friedman's improvement score for potential splits,
#' "mae" for the mean absolute error, which minimizes the L1 loss using
#' the median of each terminal node, and "poisson" which uses reduction in
#' Poisson deviance to find splits.
#' @param splitter c("best", "random"), default="best".
#' The strategy used to choose the split at each node. Supported strategies are
#' "best" to choose the best split and "random" to choose the best random split.
#' @param max_depth An integer, default=None. The maximum depth of the tree.
#' If None, then nodes are expanded until all leaves are pure or until all
#' leaves contain less than min_samples_split samples.
#'
#' @param min_samples_split int or float, default=2.
#' The minimum number of samples required to split an internal node:
#'
#' * If int, then consider `min_samples_split` as the minimum number.
#' * If float, then `min_samples_split` is a fraction and
#'
#' `ceil(min_samples_split * n_samples)` are the minimum number of samples for
#' each split..
#' @param min_samples_leaf int or float, default=2.
#' The minimum number of samples required to split an internal node:
#' - If int, then consider `min_samples_split` as the minimum number.
#' - If float, then `min_samples_split` is a fraction and
#' `ceil(min_samples_split * n_samples)` are the minimum
#' number of samples for each split.
#'
#' @param random_state int, RandomState instance or None, default=None.
#' Controls the randomness of the estimator. The features are always
#' randomly permuted at each split, even if ``splitter`` is set to ``"best"``.
#' When ``max_features < n_features``, the algorithm will select ``max_features``
#'  at random at each split before finding the best split among them.
#'  But the best found split may vary across different runs, even if
#'   ``max_features=n_features``. That is the case, if the improvement of the
#' criterion is identical for several splits and one split has to be selected
#' at random. To obtain a deterministic behaviour during fitting,
#' ``random_state`` has to be fixed to an integer.
#'
#' @param min_weight_fraction_leaf Float, default=0.0.
#' The minimum weighted fraction of the sum total of weights (of all
#' the input samples) required to be at a leaf node.
#' Samples have equal weight when sample_weight is not provided.
#'
#' @return sklearn.tree._classes.DecisionTreeRegressor object
#' @author Resul Akay
#' @export
DecisionTreeRegressor <- function(
  criterion="friedman_mse",
  min_samples_split=2,
  min_samples_leaf=1,
  min_weight_fraction_leaf=0.0,
  max_depth=3,
  splitter="best",
  random_state=NULL){

  sklearn <- reticulate::import("sklearn")
  sklearn$tree$DecisionTreeRegressor(criterion=criterion,
                min_samples_split=as.integer(min_samples_split),
                min_samples_leaf=as.integer(min_samples_leaf),
                min_weight_fraction_leaf=min_weight_fraction_leaf,
                max_depth=max_depth,
                splitter=splitter,
                random_state=random_state)
}




#' Linear least squares with l2 regularization.
#'
#' @param alpha Float, ndarray of shape (n_targets,).
#' Regularization strength; must be a positive float. Regularization improves
#' the conditioning of the problem and reduces the variance of the estimates.
#' Larger values specify stronger regularization.
#' @param random_state sklearn.linear_model._ridge.Ridge
#' @return sklearn.linear_model._ridge.Ridge object
#' @author Resul Akay
#' @export
Ridge <- function(
  alpha=0.0,
  random_state=NULL
){

  sklearn <- reticulate::import("sklearn")
  sklearn$linear_model$Ridge(alpha=alpha,
                       random_state=random_state)
}

