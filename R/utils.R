install_dependencies <- function() {
  pkgs <- c("rstan", "survival", "flexsurv", "copula", 
            "ggplot2", "dplyr", "tidyr", "foreach", "doParallel")
  for (pkg in pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
  }
  cat("Dependencies installed.\n")
}

set_seed <- function(seed = 2026) {
  set.seed(seed)
}
