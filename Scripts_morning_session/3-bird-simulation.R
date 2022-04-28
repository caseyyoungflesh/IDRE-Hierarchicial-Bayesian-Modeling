##########################################
# simulate bird data for linear regression
##########################################

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

#plot
plot(food_std, bird_weight,
     pch = 19,
     xlab = 'Bird food (std)',
     ylab = 'Bird weight (g)')