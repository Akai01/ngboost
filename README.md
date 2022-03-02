
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
                           Base = sklearner(),
                           Score = Scores("MLE"),
                           natural_gradient =TRUE,
                           n_estimators = 600,
                           learning_rate = 0.002,
                           minibatch_frac = 0.8,
                           col_sample = 0.9,
                           verbose = TRUE,
                           verbose_eval = 100,
                           tol = 1e-5)

model$fit(X = x_train, Y = y_train, X_val = x_test, Y_val = y_test)

model$feature_importances()
#>    features  importance
#> 1      crim 0.173127863
#> 2        zn 0.001288576
#> 3     indus 0.007806564
#> 4      chas 0.001329934
#> 5       nox 0.077946992
#> 6        rm 0.154315121
#> 7       age 0.033186137
#> 8       dis 0.058404260
#> 9       rad 0.007249823
#> 10      tax 0.012866860
#> 11  ptratio 0.018787261
#> 12    black 0.025433288
#> 13    lstat 0.428257321
model$plot_feature_importance()
```

<img src="man/figures/README-example_regression-1.png" width="100%" />

``` r
model$predict(x_test)%>%head()
#> [1] 32.59258 24.76969 20.14197 18.13234 21.02914 20.25172
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


model <- NGBClassifier$new(Dist = Dist("k_categorical", k = 3),
                           Base = sklearner(),
                           Score = Scores("LogScore"),
                           natural_gradient = TRUE,
                           n_estimators = 100,
                           tol = 1e-5,
                           random_state = NULL)

model$fit(x_train, y_train, X_val = x_test, Y_val = y_test)

model$feature_importances()
#>           features  importance
#> 1     Cl.thickness 0.060005775
#> 2        Cell.size 0.056244052
#> 3       Cell.shape 0.742055551
#> 4    Marg.adhesion 0.748501956
#> 5     Epith.c.size 0.072877639
#> 6      Bare.nuclei 0.069732522
#> 7      Bl.cromatin 0.010621672
#> 8  Normal.nucleoli 0.011418023
#> 9          Mitoses 0.011649645
#> 10    Cl.thickness 0.017591782
#> 11       Cell.size 0.053283960
#> 12      Cell.shape 0.052676274
#> 13   Marg.adhesion 0.026254546
#> 14    Epith.c.size 0.024599767
#> 15     Bare.nuclei 0.017100762
#> 16     Bl.cromatin 0.015321701
#> 17 Normal.nucleoli 0.006150452
#> 18         Mitoses 0.003913924
model$plot_feature_importance()
```

<img src="man/figures/README-example_class-1.png" width="100%" />

``` r
model$predict(x_test)
#>   [1] 1 1 2 1 1 2 2 1 1 2 2 2 1 2 2 1 1 1 1 1 1 2 2 1 1 1 1 1 1 1 1 1 1 1 2 1 2
#>  [38] 2 1 1 1 2 1 1 2 1 2 1 1 2 2 2 2 2 1 1 2 1 2 2 2 1 2 1 1 2 2 2 1 1 2 1 2 2
#>  [75] 1 1 2 1 1 1 2 2 1 2 1 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 1 1
#> [112] 2 2 1 1 1 1 1 2 2 1 1 1 1 1 2 1 2 1 1 2 1 1 1 1 1 1 2 1 1 1 1 2 1 1 1 2 1
#> [149] 1 1 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
model$predict_proba(x_test)%>%head()
#>             [,1]         [,2]         [,3]
#> [1,] 2.06395e-15 1.000000e+00 1.207698e-15
#> [2,] 2.06395e-15 1.000000e+00 1.207698e-15
#> [3,] 2.06395e-15 1.207698e-15 1.000000e+00
#> [4,] 2.06395e-15 1.000000e+00 1.207698e-15
#> [5,] 2.06395e-15 1.000000e+00 1.207698e-15
#> [6,] 2.06395e-15 1.207698e-15 1.000000e+00
```
