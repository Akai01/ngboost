
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
#> 1      crim 0.142399208
#> 2        zn 0.001203715
#> 3     indus 0.010923345
#> 4      chas 0.001173010
#> 5       nox 0.098952132
#> 6        rm 0.172952519
#> 7       age 0.026715749
#> 8       dis 0.056945422
#> 9       rad 0.003705938
#> 10      tax 0.015719317
#> 11  ptratio 0.019257480
#> 12    black 0.024229980
#> 13    lstat 0.425822185

model$plot_feature_importance()
```

<img src="man/figures/README-example_regression-1.png" width="100%" />

``` r
model$predict(x_test)%>%head()
#> [1] 29.02222 22.10507 33.97874 32.62122 18.23236 20.92843

distt <- model$pred_dist(x_test) # it returns a NGBDist

class(distt)
#> [1] "NGBDist" "R6"

?NGBDist # see the available methods

distt$interval(confidence = .9)
#> [[1]]
#>   [1] 1.4886451 1.1338418 1.7428817 1.6732499 0.9351977 1.0734879 1.1146075
#>   [8] 1.0660200 0.7792490 1.1244381 0.9896841 0.7826185 0.9587932 0.9966620
#>  [15] 1.6276390 1.0043995 1.0907593 1.2089458 1.1099767 1.2179538 1.1420366
#>  [22] 1.0659717 1.1800493 1.5311154 1.2291027 1.1221730 1.5786443 0.9335236
#>  [29] 1.0335640 0.9947969 1.0405290 1.0155754 0.9926447 0.9013738 0.8903351
#>  [36] 0.8536084 1.0183868 0.9095356 0.7505455 0.7336754 0.6623609 0.6884665
#>  [43] 0.7130477 2.1779588 1.0598753 1.1115150 1.3572091 1.5212450 1.5724342
#>  [50] 1.7530230 1.6403755 1.6497670 1.2009328 1.1863139 1.1629569 1.4564060
#>  [57] 1.1411421 2.1676792 1.3310018 1.3449847 1.2438100 0.9626404 1.1815605
#>  [64] 1.2582108 1.6901488 1.0901383 1.6071295 2.2629240 1.3918248 1.1546943
#>  [71] 1.5541043 1.6616953 1.1952458 1.1188410 1.0511425 1.2406214 1.6158877
#>  [78] 1.5271243 1.0315190 1.0325474 1.1148108 1.1637825 1.0238628 1.0008041
#>  [85] 1.3670743 1.1298756 1.5524612 1.0567987 1.1814300 1.0681803 1.0647405
#>  [92] 1.0439024 0.9127987 1.7932182 1.9039662 1.8424804 0.6995121 0.6463180
#>  [99] 0.4126952 0.6219038 0.5375460 0.7906460 0.5685875 0.8643478 0.8680059
#> [106] 1.0969450 0.7924119 0.5366259 0.8427772 0.8403751 0.8373088 0.7899793
#> [113] 0.8468204 0.8046080 0.8669816 1.0586106 0.9645191 0.9808457 0.8393148
#> [120] 1.0084712 1.0625228 1.1055432 0.4954059 0.8176753 0.9866202 1.0232595
#> [127] 1.0725107
#> 
#> [[2]]
#>   [1]  86.94279  66.22087 101.79122  97.72445  54.61926  62.69596  65.09751
#>   [8]  62.25980  45.51124  65.67165  57.80149  45.70803  55.99734  58.20902
#>  [15]  95.06059  58.66092  63.70468  70.60724  64.82705  71.13334  66.69948
#>  [22]  62.25699  68.91957  89.42322  71.78448  65.53936  92.19910  54.52149
#>  [29]  60.36424  58.10009  60.77103  59.31364  57.97440  52.64382  51.99911
#>  [36]  49.85413  59.47784  53.12049  43.83484  42.84956  38.68451  40.20918
#>  [43]  41.64482 127.20145  61.90093  64.91690  79.26641  88.84675  91.83641
#>  [50] 102.38351  95.80445  96.35295  70.13925  69.28545  67.92131  85.05990
#>  [57]  66.64723 126.60108  77.73580  78.55245  72.64345  56.22202  69.00783
#>  [64]  73.48451  98.71141  63.66841  93.86275 132.16376  81.28810  67.43874
#>  [71]  90.76587  97.04961  69.80711  65.34476  61.39090  72.45722  94.37426
#>  [78]  89.19013  60.24481  60.30487  65.10938  67.96952  59.79766  58.45094
#>  [85]  79.84257  65.98922  90.66990  61.72125  69.00021  62.38597  62.18508
#>  [92]  60.96805  53.31107 104.73107 111.19919 107.60818  40.85429  37.74754
#>  [99]  24.10304  36.32165  31.39482  46.17687  33.20777  50.48135  50.69499
#> [106]  64.06595  46.28001  31.34108  49.22154  49.08125  48.90216  46.13793
#> [113]  49.45768  46.99230  50.63517  61.82706  56.33175  57.28528  49.01932
#> [120]  58.89873  62.05555  64.56812  28.93367  47.75549  57.62254  59.76242
#> [127]  62.63889
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
#> 1     Cl.thickness 0.034702613
#> 2        Cell.size 0.033569264
#> 3       Cell.shape 0.737087801
#> 4    Marg.adhesion 0.736255270
#> 5     Epith.c.size 0.085793571
#> 6      Bare.nuclei 0.075757042
#> 7      Bl.cromatin 0.030643950
#> 8  Normal.nucleoli 0.026617579
#> 9          Mitoses 0.009599385
#> 10    Cl.thickness 0.016987457
#> 11       Cell.size 0.061139834
#> 12      Cell.shape 0.061277870
#> 13   Marg.adhesion 0.017239617
#> 14    Epith.c.size 0.022057551
#> 15     Bare.nuclei 0.022361628
#> 16     Bl.cromatin 0.022825271
#> 17 Normal.nucleoli 0.001431600
#> 18         Mitoses 0.004652697

model$plot_feature_importance()
```

<img src="man/figures/README-example_class-1.png" width="100%" />

``` r
model$predict(x_test)
#>   [1] 1 1 2 2 2 1 2 2 2 2 1 1 1 2 2 1 1 2 2 1 1 1 1 1 1 1 1 1 1 2 2 1 2 1 2 1 2
#>  [38] 1 1 1 2 1 2 2 1 2 2 1 1 1 1 2 1 2 2 1 1 2 1 2 2 1 2 2 1 2 2 1 2 1 2 1 1 1
#>  [75] 1 1 2 2 1 2 2 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 2 1 1 1 2 1 1 2 1 1 2 2 1 2
#> [112] 1 2 1 2 2 1 1 1 1 1 1 2 1 1 2 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 1 1 1
#> [149] 1 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2

model$predict_proba(x_test)%>%head()
#>              [,1]         [,2]         [,3]
#> [1,] 2.898729e-11 9.999996e-01 4.363088e-07
#> [2,] 1.035215e-15 1.000000e+00 5.564671e-16
#> [3,] 1.035215e-15 5.564671e-16 1.000000e+00
#> [4,] 1.035215e-15 5.564671e-16 1.000000e+00
#> [5,] 1.035215e-15 5.564671e-16 1.000000e+00
#> [6,] 1.035215e-15 1.000000e+00 5.564671e-16
```
