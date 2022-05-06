rm(list = ls())

library(R2OpenBUGS)

TrainingData <- read.table("TrainingData.txt", header=F)

Y <- as.numeric(TrainingData[,1])
X <- as.matrix(TrainingData[,2:7], ncol=6, byrow=T)
Lat <- as.numeric(TrainingData[,8])
Lon <- as.numeric(TrainingData[,9])

X.tilde <- as.matrix(read.table("PredictionData.txt", header=F), ncol=6, byrow=T)

data = list("Y", "X", "Lat", "Lon", "X.tilde")

inits = list(
	     list(beta=c(0,0,0,0,0,0,0), tausq=1.0, Y.tilde = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
	     list(beta=c(-100,-100,-100,-100,-100,-100,-100), tausq=10.0, Y.tilde = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
	     list(beta=c(100,100,100,100,100,100,100), tausq=0.10, Y.tilde = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
	     )

parameters = c("beta", "tausq", "sigma", "Y.tilde")

LinearModelExample <- bugs(data, inits, parameters, model.file="ModelBUGS.txt", n.chains=3, n.iter=5000, digits=5, OpenBUGS.pgm="~/.local/bin/OpenBUGS")

print(LinearModelExample)

