
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
#> 1      crim 0.122288415
#> 2        zn 0.001597048
#> 3     indus 0.011390725
#> 4      chas 0.001026770
#> 5       nox 0.072995171
#> 6        rm 0.184250085
#> 7       age 0.031541709
#> 8       dis 0.049929326
#> 9       rad 0.005215137
#> 10      tax 0.020678474
#> 11  ptratio 0.024152711
#> 12    black 0.027510986
#> 13    lstat 0.447423444

model$plot_feature_importance()
```

<img src="man/figures/README-example_regression-1.png" width="100%" />

``` r
model$predict(x_test)%>%head()
#> [1] 33.79651 24.74818 19.67144 19.80951 20.51384 18.36694

distt <- model$pred_dist(x_test) # it returns a NGBDist

class(distt)
#> [1] "NGBDist" "R6"

?NGBDist # see the available methods

distt$interval(confidence = .9)
#> [[1]]
#>   [1] 1.7335342 1.2694158 1.0090132 1.0160950 1.0522224 0.9421009 0.7919649
#>   [8] 1.0937962 0.8705184 0.7697177 1.0695675 1.1612282 1.0741747 1.0954219
#>  [15] 1.0080916 1.0445587 1.0558903 1.1826124 1.1802470 1.2167844 2.1213375
#>  [22] 1.1719697 1.1856366 1.0879803 1.0291072 1.0848495 1.0916226 1.0187155
#>  [29] 1.0244920 0.8334700 0.7970061 0.8435389 0.7997304 0.8398757 0.9216819
#>  [36] 0.8597677 1.2962384 1.2272370 2.3181089 1.1418077 1.1238467 1.1064920
#>  [43] 1.2486544 1.1284879 1.2102655 2.2689474 1.1353566 0.9110310 1.2531363
#>  [50] 1.0593714 0.9512059 1.2508219 2.1508542 1.1430072 1.6242410 1.0585995
#>  [57] 1.0269948 1.6292973 1.1554335 1.0175753 2.0894439 2.2634202 1.1850379
#>  [64] 1.3050076 1.9796766 1.5864826 2.2644639 1.2489179 1.6558654 1.7730200
#>  [71] 1.4621893 1.0273868 1.1422207 1.2222028 1.2156718 1.2232493 1.2199572
#>  [78] 1.0836709 1.0700776 0.9984165 1.1060825 1.2643207 1.3475103 0.8048093
#>  [85] 1.7583148 1.9762707 0.7700735 0.6777197 0.4501729 0.6178796 0.7942079
#>  [92] 0.5972010 0.4913990 0.8248404 0.7902368 0.5411259 0.5673426 0.8138058
#>  [99] 1.0706643 0.8030909 0.7028434 0.8284733 0.5722750 0.5705156 0.5471899
#> [106] 0.6292867 0.7588841 0.8237889 0.9132897 0.8562711 1.0759295 0.8037003
#> [113] 0.9488967 0.9813638 0.8430129 0.8153520 0.7656170 0.8158763 1.0336814
#> [120] 1.0727838 1.0548741 1.1221120 1.0095198 0.6168160 1.0623106 1.1263424
#> [127] 1.0359753
#> 
#> [[2]]
#>   [1] 101.24529  74.13893  58.93038  59.34399  61.45397  55.02244  46.25390
#>   [8]  63.88204  50.84173  44.95458  62.46700  67.82034  62.73607  63.97699
#>  [15]  58.87656  61.00638  61.66819  69.06926  68.93112  71.06505 123.89454
#>  [22]  68.44769  69.24589  63.54238  60.10395  63.35952  63.75510  59.49703
#>  [29]  59.83441  48.67796  46.54832  49.26603  46.70743  49.05208  53.82989
#>  [36]  50.21385  75.70548  71.67552 135.38678  66.68611  65.63711  64.62353
#>  [43]  72.92638  65.90818  70.68432 132.51555  66.30934  53.20783  73.18814
#>  [50]  61.87150  55.55421  73.05297 125.61843  66.75616  94.86213  61.82642
#>  [57]  59.98058  95.15744  67.48191  59.43044 122.03183 132.19273  69.21092
#>  [64]  76.21763 115.62098  92.65689 132.25369  72.94177  96.70912 103.55142
#>  [71]  85.39767  60.00348  66.71023  71.38150  71.00006  71.44262  71.25035
#>  [78]  63.29069  62.49679  58.31149  64.59961  73.84136  78.69996  47.00406
#>  [85] 102.69257 115.42206  44.97535  39.58153  26.29189  36.08663  46.38490
#>  [92]  34.87891  28.69966  48.17396  46.15297  31.60390  33.13506  47.52949
#>  [99]  62.53105  46.90370  41.04885  48.38614  33.42313  33.32038  31.95807
#> [106]  36.75284  44.32185  48.11254  53.33975  50.00963  62.83856  46.93929
#> [113]  55.41934  57.31555  49.23531  47.61980  44.71508  47.65042  60.37110
#> [120]  62.65484  61.60884  65.53580  58.95997  36.02451  62.04316  65.78287
#> [127]  60.50508
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
#>           features   importance
#> 1     Cl.thickness 4.837859e-02
#> 2        Cell.size 4.348554e-02
#> 3       Cell.shape 7.465027e-01
#> 4    Marg.adhesion 7.500175e-01
#> 5     Epith.c.size 3.289445e-03
#> 6      Bare.nuclei 1.382879e-09
#> 7      Bl.cromatin 1.064850e-02
#> 8  Normal.nucleoli 1.291000e-02
#> 9          Mitoses 1.554263e-02
#> 10    Cl.thickness 1.410349e-02
#> 11       Cell.size 1.263905e-01
#> 12      Cell.shape 1.284053e-01
#> 13   Marg.adhesion 5.491140e-03
#> 14    Epith.c.size 4.117195e-03
#> 15     Bare.nuclei 4.217344e-02
#> 16     Bl.cromatin 4.537793e-02
#> 17 Normal.nucleoli 1.583045e-03
#> 18         Mitoses 1.583046e-03

model$plot_feature_importance()
```

<img src="man/figures/README-example_class-1.png" width="100%" />

``` r
model$predict(x_test)
#>   [1] 1 2 1 2 1 2 1 1 1 1 2 1 1 2 1 1 2 2 2 1 2 2 1 1 1 2 1 1 1 1 1 1 1 2 2 1 1
#>  [38] 1 1 1 1 1 2 1 2 2 2 1 1 1 1 2 1 2 1 2 1 2 2 2 1 2 1 1 1 2 1 2 2 1 1 1 2 2
#>  [75] 1 2 1 2 1 2 2 2 1 1 2 1 1 2 1 2 2 2 2 2 2 1 2 2 1 1 1 1 2 1 1 1 1 1 2 1 1
#> [112] 1 1 1 2 1 2 1 1 1 1 1 1 1 1 1 1 1 2 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#> [149] 2 2 1 2 1 2 2 2 2 1 1 1 1 1 1 1 1 1 1 2 1 1 2

model$predict_proba(x_test)%>%head()
#>              [,1]         [,2]         [,3]
#> [1,] 8.925742e-16 1.000000e+00 4.715989e-16
#> [2,] 1.493596e-13 1.320539e-11 1.000000e+00
#> [3,] 8.925742e-16 1.000000e+00 4.715989e-16
#> [4,] 8.925743e-16 4.715991e-16 1.000000e+00
#> [5,] 8.925742e-16 1.000000e+00 4.715989e-16
#> [6,] 8.925742e-16 4.715989e-16 1.000000e+00
```
