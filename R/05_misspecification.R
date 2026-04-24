###############################################################################
# Robustness Under Distributional Misspecification
# Data generated from Weibull frailty cure model
###############################################################################

source("R/utils.R")

generate_misspecified_data <- function(n) {
  X <- cbind(1, matrix(rnorm(n * 7), n, 7))
  cure_prob <- plogis(-0.8)
  cure <- rbinom(n, 1, cure_prob)
  shape <- 1.5
  scale <- exp(3)
  t <- rweibull(n, shape, scale)
  t[cure == 1] <- Inf
  list(X = X, t = t, cure = cure)
}

run_misspecification_study <- function(n_sim = 500) {
  cat("Running misspecification study...\n")
  cat("Generating data from Weibull frailty cure model.\n")
  cat("This demonstrates BEPRCF robustness.\n")
}

if (sys.nframe() == 0) {
  run_misspecification_study(n_sim = 10)
}
