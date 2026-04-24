###############################################################################
# BEPRCF OHTS Data Analysis
# Requires OHTS data from dbGaP (phs000240.v1.p1)
###############################################################################

source("R/utils.R")

analyze_ohts_data <- function(data_path = "data/processed/", 
                               n_chains = 4, n_iter = 6000, n_warmup = 2000) {
  
  cat("Loading OHTS data...\n")
  
  # Check if processed data exists
  data_file <- file.path(data_path, "ohts_analysis_ready.csv")
  
  if (!file.exists(data_file)) {
    stop("OHTS data not found. Please run prepare_ohts_data() first.
         See data/README.md for access instructions.")
  }
  
  # Load data
  ohts_data <- read.csv(data_file)
  
  cat("Data loaded:", nrow(ohts_data), "patients\n")
  cat("Fitting BEPRCF model with Stan...\n")
  
  # Prepare Stan data
  stan_data <- list(
    N = nrow(ohts_data),
    P = 8,
    L_left = ohts_data$L_left,
    R_left = ohts_data$R_left,
    L_right = ohts_data$L_right,
    R_right = ohts_data$R_right,
    X = as.matrix(ohts_data[, grep("^X", names(ohts_data))])
  )
  
  # Fit model
  fit <- rstan::stan(
    file = "stan/beprcf_model.stan",
    data = stan_data,
    chains = n_chains,
    iter = n_iter,
    warmup = n_warmup,
    cores = n_chains,
    seed = 2026
  )
  
  cat("Model fitting complete.\n")
  return(fit)
}

if (sys.nframe() == 0) {
  fit <- analyze_ohts_data()
  print(fit, pars = c("a", "b", "eta", "theta", "kendall_tau", "mean_pi"))
}
