// bird weight ~ bird food abundance - varying intercepts

data {
  int<lower=0> N; // number of observations
  int<lower=0> J; // number of groups
  vector[N] y; // bird weight
  vector[N] x; // bird food abundance (standardized)
  int gid[N]; // group ids
}

parameters {
  vector[J] alpha; //intercept
  real mu_alpha; // group mean alpha
  real<lower=0> sigma_alpha; // group sd alpha
  real beta; // slope
  real<lower=0> sigma; // residual error
}

transformed parameters {
  vector[N] mu; // linear predictor
    
    mu = alpha[gid] + beta * x;
}

model {
  // priors
  mu_alpha ~ normal(50, 15);
  sigma_alpha ~ normal(0, 10);
  beta ~ normal(0, 10);
  sigma ~ normal(0, 10); // half-normal
  
  // likelihood
  alpha ~ normal(mu_alpha, sigma_alpha);
  y ~ normal(mu, sigma);
}

generated quantities {
  real yrep[N]; // simulated repsonse generated from posterior samples
  
  yrep = normal_rng(mu, sigma);
}

