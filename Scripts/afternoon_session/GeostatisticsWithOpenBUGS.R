rm(list = ls())

library(R2OpenBUGS)
library(spBayes)

data(BEF.dat)
BEF.dat <- BEF.dat[BEF.dat$ALLBIO02_KGH>0,]
bio <- BEF.dat$ALLBIO02_KGH*0.001;
Y <- log(bio)
## Extract the coordinates
coords <- as.matrix(BEF.dat[,c("XUTM","YUTM")])

n = length(Y)
intercept = rep(1, times=n)
X = cbind(intercept, BEF.dat$ELEV, BEF.dat$SLOPE)
p = ncol(X)

data = list("Y", "X", "coords", "n", "p")
parameters = c("beta", "tausq.inv", "sigmasq.inv", "w")
inits = list(
	     list(beta=rep(0, times=p), tausq.inv=1.0, sigmasq.inv=1.0, w=rep(0, times=n))
)

GeostatModel <- bugs(data, inits, parameters, model.file="GeostatBUGS.txt", n.chains=1, n.burnin=0, n.iter=2, digits=5, OpenBUGS="~/.local/bin/OpenBUGS")

print(GeostatModel)
