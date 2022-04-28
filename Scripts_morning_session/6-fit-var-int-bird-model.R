#################################################
# simulate data for varying intercepts regression
#################################################

# simulate data for multiple groups ------------------------------------------------

#from 5-var-int-simulation.R

#set seed for reproducing results
set.seed(3)
#number of data points per group
N <- 30
#number of groups
J <- 5
#group ids
gid <- rep(1:J, each = 30)
#simulate predictors (standardized)
food_std <- rnorm(N*J, 0, 1)
#generating intercept and slope values
mu_alpha <- 40
sigma_alpha <- 6
beta <- 3
#simulate different alpha params
alpha <- rnorm(J, mu_alpha, sigma_alpha)
#simulate linear predictor
mu <- rep(NA, length = N*J)
counter <- 1
for (i in 1:J)
{
  #i <- 1
  idx <- counter:(counter+N-1)
  mu[idx] <- alpha[i] + beta * food_std[idx]
  counter <- counter + N
}
#process error (wrt relationship between food and bird weight)
sigma <- 3
#simulate y values
bird_weight <- rnorm(N*J, mu, sigma)


# load packages -----------------------------------------------------------

library(rstan)
#library(shinystan)
library(MCMCvis)
library(tidyverse)


# organize data ------------------------------------------------------------

DATA <- list(N = N,
             J = J,
             NJ = N*J,
             y = bird_weight,
             x = food_std,
             gid = gid)


# run Stan model ----------------------------------------------------------

fit <- rstan::stan(file = '~/Google_Drive/Teaching/UCLA_Bayes_Stan_2022/Scripts_morning_session/var-int-bird-model.stan',
                   data = DATA,
                   chains = 4,
                   iter = 2000,
                   warmup = 1000,
                   pars = c('alpha',
                            'beta',
                            'mu_alpha',
                            'sigma_alpha',
                            'sigma',
                            'mu',
                            'yrep'))


# look at the output ------------------------------------------------------

#shinystan - might skip due to time
# shinystan::launch_shinystan(fit)

#posterior chains and densities
MCMCvis::MCMCtrace(fit, 
                   params = c('alpha', 'mu_alpha', 'sigma_alpha', 
                              'beta', 'sigma'),
                   pdf = FALSE,
                   Rhat = TRUE,
                   n.eff = TRUE)


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


# summarize model ---------------------------------------------------------

#MCMCsummary - check for Rhat <= 1.01 and n.eff > 400
MCMCvis::MCMCsummary(fit, 
                     params = c('alpha', 'mu_alpha', 'sigma_alpha', 
                                'beta', 'sigma'), 
                     round = 2)


# caterpillar plots -------------------------------------------------------

MCMCvis::MCMCplot(fit, 
                  params = c('alpha', 'mu_alpha'))


# plot model fit ----------------------------------------------------------

#calculate quantiles of mu
mu_q <- MCMCvis::MCMCpstr(fit, params = 'mu', 
                          func = function(x) quantile(x, 
                                                      probs = c(0.025, 0.5, 0.975)))[[1]]
colnames(mu_q) <- c('LCI', 'LP', 'UCI')

#add group ids to mu quantiles
mu_df <- data.frame(mu_q, gid, food_std, bird_weight) %>%
  dplyr::group_by(gid) %>%
  dplyr::arrange(gid, food_std) %>%
  dplyr::ungroup()

#plot data
ggplot(mu_df) +
  geom_point(aes(food_std, bird_weight, color = factor(gid))) +
  geom_ribbon(aes(food_std, ymin = LCI, ymax = UCI, 
                  fill = factor(gid)), alpha = 0.2) +
  geom_line(aes(food_std, LP, color = factor(gid)),
            size = 2, alpha = 0.6) +
  theme_bw() +
  theme(legend.position = 'none') +
  xlab('Bird food (std)') +
  ylab('Bird weight (g)')
