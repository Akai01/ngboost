test_that("NGBRegression", {
  library(ngboost)

  set.seed(42)

  y_train = rnorm(100, 10, 1)

  x_train <- data.frame(x1 = rnorm(100, 15, 1),
                        x2 = rnorm(100, 14, 1),
                        x3 = rnorm(100, 13, 1))

  x_val <- data.frame(x1 = rnorm(20, 15, 1),
                      x2 = rnorm(20, 14, 1),
                      x3 = rnorm(20, 13, 1))
  y_val = rnorm(20, 10, 1)


  model <- NGBRegression$new(Dist = Dist("Exponential"),
                             Base=DecisionTreeRegressor(
                               criterion="mae",
                               min_samples_split=2,
                               min_samples_leaf=1,
                               min_weight_fraction_leaf=0.0,
                               max_depth=5,
                               splitter="best",
                               random_state=NULL),
                             Score = Scores("MLE"),
                             natural_gradient=TRUE,
                             n_estimators= 100,
                             learning_rate= 0.002,
                             minibatch_frac= 0.8,
                             col_sample= 0.9,
                             verbose=FALSE,
                             verbose_eval=100,
                             tol=1e-5, random_state = 42L)

  model$fit(X = x_train, Y = y_train, X_val = x_val, Y_val = y_val)

  model$predict(x_val)[1]

  expect_equal(model$predict(x_val)[1], 10.05477, tolerance = 0.5)
})
