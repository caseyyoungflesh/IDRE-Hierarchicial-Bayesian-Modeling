rm(list=ls())
library(spNNGP)
library(MBA)
library(fields)

##Simulated data analysis

rmvn <- function(n, mu=0, V = matrix(1)){
  p <- length(mu)
  if(any(is.na(match(dim(V),p))))
    stop("Dimension problem!")
  D <- chol(V)
  t(matrix(rnorm(n*p), ncol=p)%*%D + rep(mu,rep(n,p)))
}

##Make some data
set.seed(1)
n <- 2000
coords <- cbind(runif(n,0,1), runif(n,0,1))

x <- cbind(1, rnorm(n))

B <- as.matrix(c(1,5))

sigma.sq <- 1
tau.sq <- 0.5
phi <- 3/0.5

D <- as.matrix(dist(coords))
R <- exp(-phi*D)
w <- rmvn(1, rep(0,n), sigma.sq*R)
y <- rnorm(n, x%*%B + w, sqrt(tau.sq))


##Fit a Conjugate NNGP model and predict for the holdout
sigma.sq.IG <- c(2, sigma.sq)

cov.model <- "exponential"

theta.alpha <- as.matrix(expand.grid(3/seq(0.1,1,by=0.1), seq(0.1,2,by=0.1)))
dim(theta.alpha)

colnames(theta.alpha) <- c("phi", "alpha")

m.c <- spConjNNGP(y~x-1, coords=coords, n.neighbors = 10,
                  k.fold = 5, score.rule = "crps",
                  n.omp.threads = 2,
                  theta.alpha = theta.alpha, sigma.sq.IG = sigma.sq.IG, cov.model = cov.model)

names(m.c)

head(m.c$k.fold.scores)

par(mfrow=c(1,2))
crps.surf <- mba.surf(m.c$k.fold.scores[,c("phi","alpha","crps")], no.X=100, no.Y=100)$xyz.est
image.plot(crps.surf, xlab="phi", ylab="alpha=tau^2/sigma^2", main="CRPS (lower is better)")
points(phi, tau.sq/sigma.sq, col="white", pch=0)
points(m.c$theta.alpha, col="white", pch=2)
legend("topright", legend=c("True", "CRPS minimum"), col="white", pch=c(0,2), bty="n")

rmspe.surf <- mba.surf(m.c$k.fold.scores[,c("phi","alpha","rmspe")], no.X=100, no.Y=100)$xyz.est
image.plot(rmspe.surf, xlab="phi", ylab="alpha=tau^2/sigma^2",  main="RMSPE (lower is better)")
points(phi, tau.sq/sigma.sq, col="white", pch=0)
legend("topright", legend="True", col="white", pch=0, bty="n")

m.c$beta.hat

m.c$sigma.sq.hat

##Harvard Forest forest canopy analysis
data(CHM)

CHM <- CHM[CHM[,3]>0,]

set.seed(1)
mod <- sample(1:nrow(CHM), 25000)
ho <- sample((1:nrow(CHM))[-mod], 25000)

CHM.mod <- CHM[mod,]
CHM.ho <- CHM[ho,]

##Fit a Conjugate NNGP model and predict for the holdout
sigma.sq.IG <- c(2, 15)

cov.model <- "exponential"

g <- 5
theta.alpha <- as.matrix(expand.grid(seq(3/1000,3/10,length.out=g), seq(0.001,0.5,length.out=g)))

colnames(theta.alpha) <- c("phi", "alpha")

m.c <- spConjNNGP(CHM.mod[,3] ~ 1, coords=CHM.mod[,1:2], n.neighbors = 10,
                  X.0 = as.matrix(rep(1,nrow(CHM.ho))), coords.0 = CHM.ho[,1:2],
                  k.fold = 5, score.rule = "crps",
                  n.omp.threads = 2,
                  theta.alpha = theta.alpha, sigma.sq.IG = sigma.sq.IG, cov.model = cov.model)

names(m.c)

m.c$sigma.sq.hat

m.c$theta.alpha
tau.sq <- m.c$theta.alpha[2]*m.c$sigma.sq.hat
tau.sq

crps.surf <- mba.surf(m.c$k.fold.scores[,c("phi","alpha","crps")], no.X=100, no.Y=100)$xyz.est
image.plot(crps.surf, xlab="phi", ylab="alpha=tau^2/sigma^2", main="CRPS (lower is better)")
points(m.c$theta.alpha, col="white", pch=2)

plot(m.c$y.0.hat, CHM.ho[,3], main="Conjugate NNGP model")

##Now something big-N just for fun
set.seed(1)
mod <- sample(1:nrow(CHM), 500000)

CHM.mod <- CHM[mod,]

theta.alpha <- c(0.07, 0.13)
names(theta.alpha) <- c("phi", "alpha")

m.c.big <- spConjNNGP(CHM.mod[,3] ~ 1, coords=CHM.mod[,1:2], n.neighbors = 10,
                      theta.alpha = theta.alpha,
                      n.omp.threads = 2,
                      sigma.sq.IG = sigma.sq.IG, cov.model = cov.model)
