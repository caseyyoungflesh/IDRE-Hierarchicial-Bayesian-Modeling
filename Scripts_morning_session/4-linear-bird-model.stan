// bird weight ~ bird food abundance

data {
  int<lower=0> N; // number of observations
  vector[N] y; // bird weight
  vector[N] x; // bird food abundance (standardized)
}

parameters {
  real alpha; //intercept
  real beta; // slope
  real<lower=0> sigma; // residual error
}

transformed parameters {
  vector[N] mu; // linear predictor
  
    mu = alpha + beta * x;
}

model {
  // priors
  alpha ~ normal(50, 15);
  beta ~ normal(0, 10);
  sigma ~ normal(0, 10); // half-normal
  
  // likelihood
  y ~ normal(mu, sigma);
}

generated quantities {
  real yrep[N]; // simulated repsonse generated from posterior samples
  
  yrep = normal_rng(mu, sigma);
}

