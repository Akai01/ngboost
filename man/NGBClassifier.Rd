% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ngbclass.R
\name{NGBClassifier}
\alias{NGBClassifier}
\title{Constructor for NGBoost Classifier models.}
\description{
NGBRegressor is a wrapper for the generic NGBoost class that facilitates
classifier.Use this class if you want to predict an outcome that could take
an infinite number of (ordered) values.
}
\examples{
\dontrun{

data(BreastCancer, package = "mlbench")

dta <- na.omit(BreastCancer)

dta <- rsample::initial_split(dta)

train <- rsample::training(dta)

test <- rsample::testing(dta)

x_train = train[,2:10]
y_train = as.integer(train[,11])

x_test = test[,2:10]
y_test = as.integer(test[,11])


model <- NGBClassifier$new(Dist = Dist("k_categorical", K = 3),
                           Base=DecisionTreeRegressor(
                           criterion='friedman_mse', max_depth=2),
                           Score = Scores("LogScore"),
                           natural_gradient=TRUE,
                           n_estimators=500,
                           learning_rate=0.01,
                           minibatch_frac=1.0,
                           col_sample=0.2,
                           verbose=TRUE,
                           verbose_eval=1,
                           tol=1e-5,
                           random_state = NULL)

model$fit(x_train, y_train, X_val = x_test, Y_val = y_test)

model$feature_importances()

model$plot_feature_importance()

model$predict(x_test)

model$predict_proba(x_test)

}



}
\author{
Resul Akay
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-NGBClassifier-new}{\code{NGBClassifier$new()}}
\item \href{#method-NGBClassifier-fit}{\code{NGBClassifier$fit()}}
\item \href{#method-NGBClassifier-feature_importances}{\code{NGBClassifier$feature_importances()}}
\item \href{#method-NGBClassifier-plot_feature_importance}{\code{NGBClassifier$plot_feature_importance()}}
\item \href{#method-NGBClassifier-predict}{\code{NGBClassifier$predict()}}
\item \href{#method-NGBClassifier-predict_proba}{\code{NGBClassifier$predict_proba()}}
\item \href{#method-NGBClassifier-predict_pred_dist}{\code{NGBClassifier$predict_pred_dist()}}
\item \href{#method-NGBClassifier-staged_pred_dist}{\code{NGBClassifier$staged_pred_dist()}}
\item \href{#method-NGBClassifier-staged_pred}{\code{NGBClassifier$staged_pred()}}
\item \href{#method-NGBClassifier-set_params}{\code{NGBClassifier$set_params()}}
\item \href{#method-NGBClassifier-get_params}{\code{NGBClassifier$get_params()}}
\item \href{#method-NGBClassifier-pred_dist}{\code{NGBClassifier$pred_dist()}}
\item \href{#method-NGBClassifier-clone}{\code{NGBClassifier$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-new"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-new}{}}}
\subsection{Method \code{new()}}{
Initialize NGBoost Classifier model.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$new(
  Dist = NULL,
  Score = NULL,
  Base = NULL,
  natural_gradient = TRUE,
  n_estimators = as.integer(500),
  learning_rate = 0.01,
  minibatch_frac = 1,
  col_sample = 1,
  verbose = TRUE,
  verbose_eval = as.integer(100),
  tol = 1e-04,
  random_state = NULL
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{Dist}}{Assumed distributional form of Y|X=x.}

\item{\code{Score}}{Rule to compare probabilistic predictions to the observed
data.A score from ngboost.scores, e.g. LogScore}

\item{\code{Base}}{Base learner to use in the boosting algorithm.
Any instantiated sklearn regressor, e.g. DecisionTreeRegressor()}

\item{\code{natural_gradient}}{Logical flag indicating whether the natural
gradient should be used}

\item{\code{n_estimators}}{The number of boosting iterations to fit}

\item{\code{learning_rate}}{The learning rate}

\item{\code{minibatch_frac}}{The percent subsample of rows to use in each
boosting iteration}

\item{\code{col_sample}}{The percent subsample of columns to use in each
boosting iteration}

\item{\code{verbose}}{Flag indicating whether output should be printed
during fitting}

\item{\code{verbose_eval}}{Increment (in boosting iterations) at which output
should be printed}

\item{\code{tol}}{Numerical tolerance to be used in optimization}

\item{\code{random_state}}{Seed for reproducibility.}

\item{\code{A}}{Distribution from ngboost.distns, e.g. Normal}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
An NGBRegressor object that can be fit.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-fit"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-fit}{}}}
\subsection{Method \code{fit()}}{
An NGBRegressor object that can be fit.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$fit(
  X,
  Y,
  X_val = NULL,
  Y_val = NULL,
  sample_weight = NULL,
  val_sample_weight = NULL,
  train_loss_monitor = NULL,
  val_loss_monitor = NULL,
  early_stopping_rounds = NULL
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{X}}{DataFrame object or List or numpy array of predictors (n x p)
in Numeric format}

\item{\code{Y}}{DataFrame object or List or numpy array of outcomes (n)
in numeric format. Should be floats for regression and integers from 0
to K-1 for K-class classification}

\item{\code{X_val}}{DataFrame object or List or numpy array of validation-set
predictors in numeric format}

\item{\code{Y_val}}{DataFrame object or List or numpy array of validation-set
outcomes in numeric format}

\item{\code{sample_weight}}{how much to weigh each example in the training set.
numpy array of size (n) (defaults to 1)}

\item{\code{val_sample_weight}}{How much to weigh each example in the validation
set. (defaults to 1)}

\item{\code{train_loss_monitor}}{A custom score or set of scores to track on the
training set during training. Defaults to the score defined in the NGBoost
constructor.}

\item{\code{val_loss_monitor}}{A custom score or set of scores to track on the
validation set during training. Defaults to the score defined in the
NGBoost  constructor}

\item{\code{early_stopping_rounds}}{The number of consecutive boosting
iterations during which the loss has to increase before the algorithm
stops early.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
NULL
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-feature_importances"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-feature_importances}{}}}
\subsection{Method \code{feature_importances()}}{
Return the feature importances for all parameters in the
distribution (the higher, the more important the feature).
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$feature_importances()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
A data frame
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-plot_feature_importance"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-plot_feature_importance}{}}}
\subsection{Method \code{plot_feature_importance()}}{
Plot feature importance
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$plot_feature_importance()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-predict"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-predict}{}}}
\subsection{Method \code{predict()}}{
Point prediction of Y at the points X=x
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$predict(X, max_iter = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{X}}{DataFrame object or List or numpy array of predictors (n x p)
in numeric Format}

\item{\code{max_iter}}{Get the prediction at the specified number of boosting
iterations}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
Numpy array of the estimates of Y
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-predict_proba"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-predict_proba}{}}}
\subsection{Method \code{predict_proba()}}{
Probability prediction of Y at the points X=x
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$predict_proba(X, max_iter = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{X}}{DataFrame object or List or numpy array of predictors (n x p)
in numeric Format}

\item{\code{max_iter}}{Get the prediction at the specified number of boosting
iterations}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
Numpy array of the estimates of Y
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-predict_pred_dist"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-predict_pred_dist}{}}}
\subsection{Method \code{predict_pred_dist()}}{
Predict the conditional distribution of Y at the points X=x
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$predict_pred_dist(X, max_iter = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{X}}{DataFrame object or List or numpy array of predictors (n x p)
in numeric Format}

\item{\code{max_iter}}{Get the prediction at the specified number of boosting
iterations}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
Numpy array of the estimates of Y
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-staged_pred_dist"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-staged_pred_dist}{}}}
\subsection{Method \code{staged_pred_dist()}}{
Predict the conditional distribution of Y at the points X=x
at multiple boosting iterations
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$staged_pred_dist(X, max_iter = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{X}}{DataFrame object or List or numpy array of predictors (n x p)
in numeric Format}

\item{\code{max_iter}}{Get the prediction at the specified number of boosting
iterations}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A list of NGBoost distribution objects, one per boosting stage
up to max_iter.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-staged_pred"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-staged_pred}{}}}
\subsection{Method \code{staged_pred()}}{
Point prediction of Y at the points X=x at multiple boosting
iterations.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$staged_pred(X, max_iter = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{X}}{DataFrame object or List or numpy array of predictors (n x p)
in numeric Format}

\item{\code{max_iter}}{Get the prediction at the specified number of boosting
iterations}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A list of NGBoost distribution objects, one per boosting stage
up to max_iter.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-set_params"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-set_params}{}}}
\subsection{Method \code{set_params()}}{
Set the parameters of this estimator.
The method works on simple estimators as well as on nested objects
(such as :class:\code{~sklearn.pipeline.Pipeline}). The latter have
parameters of the form \verb{<component>__<parameter>} so that it's
possible to update each component of a nested object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$set_params(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{dict (a named R list). Estimator parameters.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
self : estimator instance. Estimator instance.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-get_params"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-get_params}{}}}
\subsection{Method \code{get_params()}}{
Get parameters for this estimator.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$get_params(deep = TRUE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{bool, default = TRUE
If True, will return the parameters for this estimator and
contained subobjects that are estimators.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
params. A dict (R list). Parameter names mapped to their values.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-pred_dist"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-pred_dist}{}}}
\subsection{Method \code{pred_dist()}}{
Predict the conditional distribution of Y at the points X=x
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$pred_dist(X, max_iter = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{X}}{DataFrame object or List or numpy array of predictors (n x p) in
numeric format.}

\item{\code{max_iter}}{get the prediction at the specified number of boosting
iterations.}
}
\if{html}{\out{</div>}}
}
\subsection{Details}{
See for available methods \code{\link{NGBDistClass}}
}

\subsection{Returns}{
A NGBDistClass Class
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-NGBClassifier-clone"></a>}}
\if{latex}{\out{\hypertarget{method-NGBClassifier-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{NGBClassifier$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
