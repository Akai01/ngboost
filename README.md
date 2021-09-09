
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ngboost

<!-- badges: start -->
<!-- badges: end -->

The goal of ngboost is to provide an R interface for the Python package
[NGBoost](https://stanfordmlgroup.github.io/ngboost/intro.html).

# What is Natural Gradient Boosting?

“NGBoost is a method for probabilistic prediction with competitive
state-of-the-art performance on a variety of datasets. NGBoost combines
a multiparameter boosting algorithm with the natural gradient to
efficiently estimate how parameters of the presumed outcome distribution
vary with the observed features. NGBoost performs as well as existing
methods for probabilistic regression but retains major advantages:
NGBoost is flexible, scalable, and easy-to-use.” (From the paper, Duan,
et at., 2019, [see here](https://arxiv.org/pdf/1910.03225.pdf))

## Installation

You can install the released version of ngboost from
[CRAN](https://CRAN.R-project.org) with:

``` r
# not yet

install.packages("ngboost")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Akai01/ngboost")
```

## Example

A probabilistic regression example on the Boston housing dataset:

``` r
library(ngboost)
#> Loading required package: reticulate

data(Boston, package = "MASS")

dta <- rsample::initial_split(Boston)

train <- rsample::training(dta)

test <- rsample::testing(dta)


x_train = train[,1:13]
y_train = train[,14]

x_test = test[,1:13]
y_test = test[,14]


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
                           n_estimators= 600,
                           learning_rate= 0.002,
                           minibatch_frac= 0.8,
                           col_sample= 0.9,
                           verbose=TRUE,
                           verbose_eval=100,
                           tol=1e-5)

model$fit(X = x_train, Y = y_train, X_val = x_test, Y_val = y_test)

model$feature_importances()
#>    features  importance
#> 1      crim 0.115444512
#> 2        zn 0.001558982
#> 3     indus 0.016630919
#> 4      chas 0.003251259
#> 5       nox 0.047643536
#> 6        rm 0.220264905
#> 7       age 0.051876137
#> 8       dis 0.077110612
#> 9       rad 0.007851554
#> 10      tax 0.027225091
#> 11  ptratio 0.045092450
#> 12    black 0.035865116
#> 13    lstat 0.350184928

model$plot_feature_importance()
```

<img src="man/figures/README-example_regression-1.png" width="100%" />

``` r
model$predict(x_test)%>%head()
#> [1] 24.53977 17.33471 19.09419 19.21961 16.15626 15.68390
```

Classification example:

``` r
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
                           Base=DecisionTreeRegressor(criterion='friedman_mse', 
                                                      max_depth=2),
                           Score = Scores("LogScore"),
                           natural_gradient=TRUE,
                           n_estimators=500,
                           learning_rate=0.01,
                           minibatch_frac=1.0,
                           col_sample=0.2,
                           verbose=TRUE,
                           verbose_eval=100,
                           tol=1e-5,
                           random_state = NULL)

model$fit(x_train, y_train, X_val = x_test, Y_val = y_test)

model$feature_importances()
#>           features importance
#> 1     Cl.thickness 0.02664848
#> 2        Cell.size 0.02664848
#> 3       Cell.shape 0.17577695
#> 4    Marg.adhesion 0.17577695
#> 5     Epith.c.size 0.47092396
#> 6      Bare.nuclei 0.47092396
#> 7      Bl.cromatin 0.05329669
#> 8  Normal.nucleoli 0.05329669
#> 9          Mitoses 0.07994497
#> 10    Cl.thickness 0.07994497
#> 11       Cell.size 0.06016697
#> 12      Cell.shape 0.06016697
#> 13   Marg.adhesion 0.07994492
#> 14    Epith.c.size 0.07994492
#> 15     Bare.nuclei 0.03997264
#> 16     Bl.cromatin 0.03997264
#> 17 Normal.nucleoli 0.01332443
#> 18         Mitoses 0.01332443

model$plot_feature_importance()
```

<img src="man/figures/README-example_class-1.png" width="100%" />

``` r
model$predict(x_test)
#>   [1] 1 0 1 1 0 0 1 1 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 1 1 0 0 1 0 1 0 1 0 1 0 1 0
#>  [38] 0 1 1 1 0 0 0 1 1 0 1 1 0 0 1 1 1 1 1 0 1 1 1 0 0 0 0 1 1 1 0 0 0 0 0 1 1
#>  [75] 0 0 1 0 0 1 0 1 1 0 1 1 0 0 0 1 1 1 1 1 0 1 1 1 0 1 0 1 1 1 1 1 1 1 1 1 1
#> [112] 1 1 1 1 0 1 0 1 1 0 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 1 1 1 0 0 0 1 1 1 0 0 0
#> [149] 1 1 0 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 0

model$predict_proba(x_test)%>%head()
#>           [,1]      [,2]        [,3]
#> [1,] 0.4176584 0.5778545 0.004487127
#> [2,] 0.4367354 0.3276329 0.235631677
#> [3,] 0.4298751 0.5648983 0.005226627
#> [4,] 0.4116954 0.5841936 0.004110936
#> [5,] 0.4553031 0.4428733 0.101823540
#> [6,] 0.3968299 0.2351165 0.368053608
```
