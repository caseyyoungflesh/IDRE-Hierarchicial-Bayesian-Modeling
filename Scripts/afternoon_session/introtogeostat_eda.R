
rm(list=ls())

##### Code for L1 #####
library(MBA)
library(fields)
library(classInt)
library(geoR)

### dataset 1 ###
data1=read.csv("data/dataset1.csv")

col.br <- colorRampPalette(c("midnightblue", "cyan", "yellow", "red"))
col.pal <- col.br(5)

### function for plotting interpolated surface of a column of a data table
myplot=function(tab,colname){
  
  surf <- mba.surf(tab[,c("sx","sy",colname)], no.X=100, no.Y=100, h=5, m=2, extend=FALSE)$xyz.est
  dev.new()
  image.plot(surf, xaxs = "r", yaxs = "r", xlab="Easting (m)", ylab="Northing (m)", col=col.br(25))
  
}

myplot(data1,"y")
myplot(data1,"x")

lmobj1=lm(y~x,data=data1)
data1$res=lmobj1$residuals

myplot(data1,"res")

### empirical variograms ###
max.dist <- 0.75*max(rdist(data1[,1:2]))
bins <- 20

dev.new()
vario1raw <- variog(coords=data1[,1:2], data=data1$y, uvec=(seq(0, max.dist, length=bins)))
plot(vario1raw,pch=16)

dev.new()
vario1 <- variog(coords=data1[,1:2], data=data1$res, uvec=(seq(0, max.dist, length=bins)))
plot(vario1,pch=16)



###################################################
### WEF data
###################################################
WEF.dat=read.csv("data/WEFsmall.csv")

set.seed(1)
ind=sample(1:nrow(WEF.dat),100,replace=FALSE)

### holdout data to assess RMSPE ###
WEF.out=WEF.dat[ind,]
WEF.in=WEF.dat[-ind,]
rm("WEF.dat")

### diameter at breast height for the trees
DBH <- WEF.in$DBH_cm

coords <- as.matrix(WEF.in[,c("East_m","North_m")])

col.br <- colorRampPalette(c("midnightblue", "cyan", "yellow",  "orange", "red"))
col.pal <- col.br(5)

### DBH quantile based color coding of the locations
quant <- classIntervals(DBH, n=5, style="quantile")

quant.col <- findColours(quant, col.pal)

dev.new()
plot(coords, col=quant.col, pch=19, cex=1.5, main="", xlab="Easting (m)", ylab="Northing (m)")
legend("topleft", fill=attr(quant.col, "palette"), 
       legend=names(attr(quant.col, "table")), bty="n",cex=1.3)

### plot of interpolated surface using mba package ###
surf <- mba.surf(cbind(coords,DBH), no.X=100, no.Y=100, h=5, m=2, extend=FALSE)$xyz.est
dev.new()
image.plot(surf, xaxs = "r", yaxs = "r", xlab="Easting (m)", ylab="Northing (m)", col=col.br(25))

### plot of Species type ###
spnum=as.factor(WEF.in$Species)
col.pal2 <- col.br(length(unique(spnum)))

dev.new()
plot(coords, col=col.pal2[spnum], pch=19, cex=1.5, main="", xlab="Easting (m)", ylab="Northing (m)")
legend("topleft", fill=col.pal2, 
       legend=levels(spnum), bty="n")


### Linear regression ###
lm.DBH <- lm(DBH~Species, data=WEF.in)
summary(lm.DBH)
DBH.resid <- resid(lm.DBH)

surf <- mba.surf(cbind(coords,DBH.resid), no.X=100, no.Y=100, h=5, m=2, extend=FALSE)$xyz.est
dev.new()
image.plot(surf, xaxs = "r", yaxs = "r", xlab="Easting (m)", ylab="Northing (m)", col=col.br(25))


### variogram of raw data and residuals ###
max.dist=0.5*max(rdist(coords))
bins=20

dev.new()
vario.DBH <- variog(coords=coords, data=DBH, uvec=(seq(5, max.dist, length=bins)))
plot(vario.DBH)


dev.new()
vario.DBH.resid <- variog(coords=coords, data=DBH.resid, uvec=(seq(0, max.dist, length=bins)))
plot(vario.DBH.resid)


### spatial mle ###
mle <- likfit(coords=coords, data=DBH, trend = trend.spatial(~Species,WEF.in), ini.cov.pars=c(100,100),
              nugget = 300,cov.model="exponential",nospatial=TRUE)

mle

mle$AIC
mle$BIC

mle$nospatial$AIC
mle$nospatial$BIC

### RMSPE ###
krig_mlefit=krige.conv(coords=coords, data=DBH,
    locations=WEF.out[,c("East_m","North_m")],krige=krige.control(type.krige="OK",obj.model=mle,
    trend.d=trend.spatial(~Species,WEF.in),trend.l=trend.spatial(~Species,WEF.out)))

pred_spatial=krig_mlefit$predict
rmspe_spatial=sqrt(mean((pred_spatial-WEF.out$DBH_cm)^2))

pred_lm=as.vector(as.matrix(trend.spatial(~Species,WEF.out))%*%lm.DBH$coefficients)
rmspe_lm=sqrt(mean((pred_lm-WEF.out$DBH_cm)^2))

rmspe_spatial
rmspe_lm


### CP ###
CI_spatial=pred_spatial+1.96*sqrt(krig_mlefit$krige.var)%*%t(c(-1,1))  ## confidence interval ##
CP_spatial=mean(CI_spatial[,1]<WEF.out$DBH_cm & CI_spatial[,2]>WEF.out$DBH_cm) ## coverage probability ##
CIW_spatial=mean(CI_spatial[,2]-CI_spatial[,1]) ## confidence interval width ##

CP_spatial
CIW_spatial

N=nrow(WEF.out)
CI_lm=pred_lm+1.96*summary(lm.DBH)$sigma*cbind(-rep(1,N),rep(1,N))
CP_lm=mean(CI_lm[,1]<WEF.out$DBH_cm & CI_lm[,2]>WEF.out$DBH_cm)
CIW_lm=mean(CI_lm[,2]-CI_lm[,1])

CP_lm
CIW_lm

### krigged surface 
## prediction locations ###
WEF.pred=read.csv("data/WEFpred.csv")

krigsurf_mlefit=krige.conv(coords=coords, data=DBH,
    locations=WEF.pred[,c("East_m","North_m")],krige=krige.control(type.krige="OK",obj.model=mle,
    trend.d=trend.spatial(~Species,WEF.in),trend.l=trend.spatial(~Species,WEF.pred)))

pred=krigsurf_mlefit$predict
predsd=sqrt(krigsurf_mlefit$krige.var)

predsurf <- mba.surf(cbind(WEF.pred[,c("East_m","North_m")],pred), no.X=100, no.Y=100, h=5, m=2, extend=FALSE)$xyz.est
dev.new()
image.plot(predsurf, xaxs = "r", yaxs = "r", xlab="Easting (m)", ylab="Northing (m)", col=col.br(25))

predsdsurf <- mba.surf(cbind(WEF.pred[,c("East_m","North_m")],predsd), no.X=100, no.Y=100, h=5, m=2, extend=FALSE)$xyz.est
dev.new()
image.plot(predsdsurf, xaxs = "r", yaxs = "r", xlab="Easting (m)", ylab="Northing (m)", col=rev(terrain.colors(25)))
