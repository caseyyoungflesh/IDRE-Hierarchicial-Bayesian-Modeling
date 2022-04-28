#################
# plot normal PDF
#################

#fixed parameters
mu <- 4
sigma <- 2

#varying data
x <- seq(-5, 15, length.out = 1000)

#calculate density
pd <- dnorm(x, mu, sigma)

#plot
plot(x, pd, type = 'l', lwd = 3,
     xlab = 'x', 
     ylab = 'probability density')
abline(v = mu, lwd = 3, lty = 2, col = 'red')

#check that integrates to 1
# sum(diff(x) * zoo::rollmean(pd,2))
