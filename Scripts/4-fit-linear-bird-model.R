#################################################
# Simluate data then fit/assess linear regression
#################################################

# simulate data -----------------------------------------------------------

#from 3-bird-simulation.R

#set seed for reproducing results
set.seed(1)
#number of data points
N <- 30
#simulate predictors (standardized)
food_std <- rnorm(N, 0, 1)
#generating intercept and slope values
alpha <- 40
beta <- 3
#simulate linear predictor
mu <- alpha + beta * food_std
#process error (wrt relationship between food and bird weight)
sigma <- 3
#simulate y values
bird_weight <- rnorm(N, mu, sigma)


# load packages -----------------------------------------------------------

library(rstan)
library(MCMCvis)
library(shinystan)


# organize data ------------------------------------------------------------

DATA <- list(N = N,
             y = bird_weight,
             x = food_std)


# run Stan model ----------------------------------------------------------

fit <- rstan::stan(file = '~/Google_Drive/Teaching/UCLA_Bayes_Stan_2022/Scripts/linear-bird-model.stan',
                  data = DATA,
                  chains = 4,
                  iter = 2000,
                  warmup = 1000,
                  pars = c('alpha',
                           'beta',
                           'mu',
                           'sigma',
                           'yrep'))


# look at the output ------------------------------------------------------

#shinystan
shinystan::launch_shinystan(fit)


# summarize model ---------------------------------------------------------

#MCMCsummary - check for Rhat <= 1.01 and n.eff > 400
MCMCvis::MCMCsummary(fit, 
                     params = c('alpha', 'beta', 'sigma'), 
                     round = 2)


# examine posterior -------------------------------------------------------

#extract posterior chains for alpha
alpha_ch <- MCMCvis::MCMCchains(fit, params = 'alpha')

#summary of posterior chains - matches summary output
mean(alpha_ch)
quantile(alpha_ch, probs = c(0.025, 0.5, 0.975))


# posterior predictive check ----------------------------------------------

#extract posterior for yrep (data simulated from posterior)
yrep_ch <- MCMCvis::MCMCchains(fit, params = 'yrep')

#make sure that data generated from posterior samples looks similar to observed data
plot(density(bird_weight), lwd = 2, 
     ylim = c(0, 0.18),
     xlab = 'y',
     main = 'Posterior predictive check')
for (i in 1:150)
{
  lines(density(yrep_ch[i,]), col = rgb(1,0,0,0.1))
}


# check prior overlap with posterior ----------------------------------------

#check to make sure prior is not having an outsized effect on posterior
MCMCvis::MCMCtrace(fit, 
                   params = 'alpha',
                   priors = rnorm(4000, 50, 15),
                   type = 'density',
                   pdf = FALSE,
                   Rhat = TRUE,
                   n.eff = TRUE,
                   post_zm = FALSE)

MCMCvis::MCMCtrace(fit, 
                   params = 'beta',
                   priors = rnorm(4000, 0, 10),
                   type = 'density',
                   pdf = FALSE,
                   Rhat = TRUE,
                   n.eff = TRUE,
                   post_zm = FALSE)

PP <- rnorm(4000, 0, 10)
MCMCvis::MCMCtrace(fit, 
                   params = 'sigma',
                   priors = PP[which(PP > 0)],
                   type = 'density',
                   pdf = FALSE,
                   Rhat = TRUE,
                   n.eff = TRUE,
                   post_zm = FALSE)


# plot model fit ----------------------------------------------------------

#extract posterior chain for mu
mu_ch <- MCMCvis::MCMCchains(fit, params = 'mu')

#calculate quantiles of mu
mu_q <- MCMCvis::MCMCpstr(fit, params = 'mu', 
                          func = function(x) quantile(x, 
                                                      probs = c(0.025, 0.5, 0.975)))[[1]]

#order of food_std for plotting (to make sure line goes from smallest to largest)
idx <- order(food_std)

#plot data
plot(food_std, bird_weight, 
     pch = 19,
     col = 'grey60', 
     xlab = 'Bird food (std)',
     ylab = 'Bird weight (g)')
#plot model fit and 95% CI - NOTHING SPECIAL ABOUT 95% CI!
lines(food_std[idx], mu_q[idx,1], 
      lty = 2, lwd = 3)
lines(food_std[idx], mu_q[idx,2], 
      col = 'red', lwd = 3)
lines(food_std[idx], mu_q[idx,3],
      lty = 2, lwd = 3)
