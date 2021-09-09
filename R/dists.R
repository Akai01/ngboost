#' NGBoost distributions
#' @param dist NGBoost distributions
#' \itemize{
#' \item Bernoulli
#' \item k_categorical
#' \item StudentT
#' \item Poisson
#' \item Laplace
#' \item Cauchy
#' \item Exponential
#' \item LogNormal
#' \item MultivariateNormal
#' \item Normal
#' }
#' @import reticulate
#' @param K Used only with k_categorical and MultivariateNormal
#' @export
Dist <- function(dist = c("Bernoulli", "k_categorical", "StudentT", "Poisson",
                          "Laplace", "Cauchy", "Exponential", "LogNormal",
                          "MultivariateNormal", "Normal"), K){

  dist <- match.arg(dist)
  #ngboost <- reticulate::import("ngboost")
  if(dist=="Normal"){
    out <- ngboost$distns$Normal
  }
  if(dist=="MultivariateNormal"){
    out <- ngboost$distns$MultivariateNormal(as.integer(K))
  }
  if(dist=="LogNormal"){
    out <- ngboost$distns$LogNormal
  }
  if(dist=="Exponential"){
    out <- ngboost$distns$Exponential
  }
  if(dist=="Cauchy"){
    out <- ngboost$distns$Cauchy
  }
  if(dist=="Laplace"){
    out <- ngboost$distns$Laplace
  }
  if(dist=="Poisson"){
    out <- ngboost$distns$Poisson
  }
  if(dist=="StudentT"){
    out <- ngboost$distns$T
  }
  if(dist=="k_categorical"){
    out <- ngboost$distns$k_categorical(as.integer(K))
  }
  if(dist=="Bernoulli"){
    out <- ngboost$distns$Bernoulli
  }

  out
}


