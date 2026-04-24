// BEPRCF: Bivariate ExOW-POLO Regression with Cure Fraction
// Main Stan Model - Clayton Copula

functions {
  // ExOW-POLO CDF
  real exowpolo_cdf(real y, real a, real b, real alpha, real beta, real eta) {
    if (y <= 0) return 0.0;
    real y_eta_alpha = 1.0 + (y^eta) / alpha;
    real y_term = y_eta_alpha^beta - 1.0;
    real inner = 1.0 + b * y_term^a;
    if (inner <= 0) return 0.0;
    real cdf = 1.0 - inner^(-1.0 / b);
    return fmin(1.0, fmax(0.0, cdf));
  }
  
  // ExOW-POLO survival
  real exowpolo_surv(real y, real a, real b, real alpha, real beta, real eta) {
    return 1.0 - exowpolo_cdf(y, a, b, alpha, beta, eta);
  }
  
  // ExOW-POLO log-PDF
  real exowpolo_lpdf(real y, real a, real b, real alpha, real beta, real eta) {
    if (y <= 0) return negative_infinity();
    real y_eta_alpha = 1.0 + y^eta / alpha;
    real y_term = fmax(1e-10, y_eta_alpha^beta - 1.0);
    real inner = 1.0 + b * y_term^a;
    return log(a) + log(eta) + log(beta) - log(alpha)
           + (eta - 1.0) * log(y)
           + (beta - 1.0) * log(y_eta_alpha)
           + (a - 1.0) * log(y_term)
           + (-1.0 / b - 1.0) * log(inner);
  }
  
  // Clayton copula survival
  real clayton_surv(real u, real v, real theta) {
    if (theta <= 0) return u * v;
    return (u^(-theta) + v^(-theta) - 1.0)^(-1.0 / theta);
  }
  
  // Patient log-likelihood
  real patient_loglik(real L1, real R1, real L2, real R2,
                       real a, real b, real alpha, real beta,
                       real eta, real theta,
                       real pi_11, real pi_10, real pi_01, real pi_00) {
    real ll_11 = log(pi_11);
    real ll_10 = log(pi_10) + log(exowpolo_surv(L2, a, b, alpha, beta, eta));
    real ll_01 = log(pi_01) + log(exowpolo_surv(L1, a, b, alpha, beta, eta));
    
    real S1_L1 = exowpolo_surv(L1, a, b, alpha, beta, eta);
    real S2_L2 = exowpolo_surv(L2, a, b, alpha, beta, eta);
    real S_joint = clayton_surv(S1_L1, S2_L2, theta);
    real ll_00 = log(pi_00) + log(S_joint);
    
    real max_ll = max({ll_11, ll_10, ll_01, ll_00});
    return max_ll + log(exp(ll_11 - max_ll) + exp(ll_10 - max_ll)
                      + exp(ll_01 - max_ll) + exp(ll_00 - max_ll));
  }
}

data {
  int<lower=1> N;
  int<lower=1> P;
  vector<lower=0>[N] L_left;
  vector<lower=0>[N] R_left;
  vector<lower=0>[N] L_right;
  vector<lower=0>[N] R_right;
  matrix[N, P] X;
}

parameters {
  real<lower=0.1, upper=3.0> a;
  real<lower=0.1, upper=2.0> b;
  real<lower=0.5, upper=3.0> eta;
  vector[P] gamma_alpha;
  vector[P] gamma_beta;
  vector[P] gamma_pi;
  vector[P] delta_11;
  vector[P] delta_10;
  vector[P] delta_01;
  real<lower=0> theta;
  vector<lower=0>[P] tau_alpha;
  vector<lower=0>[P] tau_beta;
  vector<lower=0>[P] tau_pi;
  vector<lower=0>[P] tau_delta_11;
  vector<lower=0>[P] tau_delta_10;
  vector<lower=0>[P] tau_delta_01;
  real<lower=0> lambda2;
}

transformed parameters {
  vector[N] alpha_i = exp(X * gamma_alpha);
  vector[N] beta_i = exp(X * gamma_beta);
  vector[N] pi_i = inv_logit(X * gamma_pi);
  
  matrix[N, 4] pi_rs;
  vector[N] exp_11 = exp(X * delta_11);
  vector[N] exp_10 = exp(X * delta_10);
  vector[N] exp_01 = exp(X * delta_01);
  vector[N] denom = 1.0 + exp_11 + exp_10 + exp_01;
  
  for (i in 1:N) {
    pi_rs[i, 1] = exp_11[i] / denom[i];
    pi_rs[i, 2] = exp_10[i] / denom[i];
    pi_rs[i, 3] = exp_01[i] / denom[i];
    pi_rs[i, 4] = 1.0 / denom[i];
  }
}

model {
  a ~ gamma(2, 1);
  b ~ gamma(2, 1);
  eta ~ gamma(2, 1);
  theta ~ gamma(2, 1);
  lambda2 ~ gamma(1, 1);
  
  for (p in 1:P) {
    tau_alpha[p] ~ exponential(lambda2 / 2);
    tau_beta[p] ~ exponential(lambda2 / 2);
    tau_pi[p] ~ exponential(lambda2 / 2);
    tau_delta_11[p] ~ exponential(lambda2 / 2);
    tau_delta_10[p] ~ exponential(lambda2 / 2);
    tau_delta_01[p] ~ exponential(lambda2 / 2);
    
    gamma_alpha[p] ~ normal(0, tau_alpha[p]);
    gamma_beta[p] ~ normal(0, tau_beta[p]);
    gamma_pi[p] ~ normal(0, tau_pi[p]);
    delta_11[p] ~ normal(0, tau_delta_11[p]);
    delta_10[p] ~ normal(0, tau_delta_10[p]);
    delta_01[p] ~ normal(0, tau_delta_01[p]);
  }
  
  for (i in 1:N) {
    target += patient_loglik(L_left[i], R_left[i], L_right[i], R_right[i],
               a, b, alpha_i[i], beta_i[i], eta, theta,
               pi_rs[i, 1], pi_rs[i, 2], pi_rs[i, 3], pi_rs[i, 4]);
  }
}

generated quantities {
  real kendall_tau = theta / (theta + 2);
  real lambda_L = 2^(-1.0 / theta);
  real mean_pi = mean(pi_i);
  vector[N] log_lik;
  for (i in 1:N) {
    log_lik[i] = patient_loglik(L_left[i], R_left[i], L_right[i], R_right[i],
                   a, b, alpha_i[i], beta_i[i], eta, theta,
                   pi_rs[i, 1], pi_rs[i, 2], pi_rs[i, 3], pi_rs[i, 4]);
  }
}
