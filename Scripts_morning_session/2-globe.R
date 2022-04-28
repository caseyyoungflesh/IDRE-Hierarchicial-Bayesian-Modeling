##################################
# grid approximation - globe model
##################################

#observed quantities
W <- 6
N <- 9

#possible values for p
pp <- seq(0, 1, length.out = 10000)

#calculate likelihood (data constant, vary param)
PrW <- dbinom(W,N,pp)

#calculate prior (prob density across all possible value of p)
Prp <- dunif(pp,0,1)
#Prp <- dbeta(pp,5,1)

#calculate the posterior (unstandardized)
posterior_us <- PrW * Prp

#standardize posterior (to compare to likelihood)
posterior <- posterior_us / (diff(pp)[1] * sum(posterior_us))

plot(pp, PrW, type = 'l', lwd = 3,
     xlab = 'p', 
     ylab = '',
     main = 'Observed likelihood')

plot(pp, Prp, type = 'l', lwd = 3,
     xlab = 'p', 
     ylab = '',
     main = 'Prior PDF')

plot(pp, posterior, type = 'l', lwd = 3,
     xlab = 'p',
     ylab = '',
     main = 'Posterior')

#check that area under posterior is equal to 1
# sum(diff(pp) * zoo::rollmean(posterior,2))
