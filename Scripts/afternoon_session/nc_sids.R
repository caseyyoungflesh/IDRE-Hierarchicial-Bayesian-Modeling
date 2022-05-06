##Author: Sudipto Banerjee, April, 2021

rm(list=ls())
library(spdep)
library(maptools)
library(RColorBrewer)
library(spatialreg)

nc.sids <- st_read(system.file("shapes/sids.shp", package="spData")[1], quiet=TRUE) 
st_crs(nc.sids) = "+proj=longlat +ellps=clrk66"
row.names(nc.sids) <- as.character(nc.sids$FIPSNO)

#ncCC89.nb <- read.gal(system.file("weights/ncCC89.gal", package="spData")[1], region.id=nc.sids$FIPSNO)
ncCC89.nb = poly2nb(nc.sids)

##plot(nc.sids, border="grey")
##plot(ncCR85.nb, coordinates(nc.sids), add=TRUE, col="blue")
##plot(nc.sids, border="grey")
##plot(ncCC89.nb, coordinates(nc.sids), add=TRUE, col="blue")

nc.county.id = attr(ncCC89.nb, "region.id")
nc.no.neighbors = card(ncCC89.nb)
nc.islands = as.character(nc.sids[card(ncCC89.nb) == 0, ]$NAME)

##Create a map of raw SIDS rates
##First create a vector of rates from counts
nc.sids.rates.raw = probmap(nc.sids$SID79, nc.sids$BIR79)$raw
##Alternatvely, one may want to use Freeman-Tukey transformations
nc.sids.rates.FT = sqrt(1000) * (sqrt(nc.sids$SID79/nc.sids$BIR79) + sqrt((nc.sids$SID79 + 1)/nc.sids$BIR79))
##Append the rates we want to plot to the nc.sids data frame
nc.sids$rates.FT = nc.sids.rates.FT 
brks = c(0, 2.0, 3.0, 3.5, 6.0)

##Compute Moran's I and Geary's C
ncCC89.listw = nb2listw(ncCC89.nb, style="B", zero.policy=TRUE)
##ncCR85.listw = nb2listw(ncCR85.nb, style="W", zero.policy=TRUE)
nc.sids.moran.out = moran.test(nc.sids.rates.FT, listw=ncCC89.listw, zero.policy=TRUE) 
nc.sids.geary.out = geary.test(nc.sids.rates.FT, listw=ncCC89.listw, zero.policy=TRUE) 

##SAR model regressing rates.FT on NWBIR79.FT
##Begin with a Freeman-Tukey transformation on non-white birth rates
nc.sids.nwbir.FT = sqrt(1000) * (sqrt(nc.sids$NWBIR79/nc.sids$BIR79) + sqrt((nc.sids$NWBIR79 + 1)/nc.sids$BIR79))
nc.sids$nwbir.FT = nc.sids.nwbir.FT
## Use errorsarlm and lagsarlm 
##nc.sids.sar.out = errorsarlm(rates.FT~ nwbir.FT, data=nc.sids, listw=ncCC89.listw, zero.policy=TRUE)
nc.sids.sar.out = spautolm(rates.FT~ nwbir.FT, data=nc.sids, family="SAR", listw=ncCC89.listw, zero.policy=TRUE)
nc.sids.lagsar.out = lagsarlm(rates.FT~ nwbir.FT, data=nc.sids, listw=ncCC89.listw, zero.policy=TRUE)
nc.sids.sar.fitted = fitted(nc.sids.sar.out)
nc.sids$fitted.sar = nc.sids.sar.fitted

##CAR model regressing rates.FT on NWBIR79.FT
nc.sids.car.out = spautolm(rates.FT~ nwbir.FT, data=nc.sids, family="CAR", listw=ncCC89.listw, zero.policy=TRUE)
nc.sids.car.fitted = fitted(nc.sids.car.out)
nc.sids$fitted.car = nc.sids.car.fitted


##Draw the maps using the spplot (trellis) graphics function
##postscript(file="nc_sids_sar_actual.eps")
##print(spplot(nc.sids, "rates.FT", at = brks, col.regions = rev(brewer.pal(4,"RdBu")), main="a) Actual SIDS rates"))
##dev.off()
##postscript(file="nc_sids_sar_fitted.eps")
##print(spplot(nc.sids, "fitted.sar", at = brks, col.regions = rev(brewer.pal(4,"RdBu")), main="b) Fitted SIDS rates from SAR model"))
##dev.off()

##Draw the maps using the maps function
library(maps)
library(classInt)
color.pallete = rev(brewer.pal(4,"RdBu"))
class.raw = classIntervals(var=nc.sids$rates.FT, n=4, style="fixed", fixedBreaks=brks, dataPrecision=4)
color.code.raw = findColours(class.raw, color.pallete)
class.fitted = classIntervals(var=nc.sids$fitted.sar, n=4, style="fixed", fixedBreaks=brks, dataPrecision=4)
color.code.fitted = findColours(class.fitted, color.pallete)

leg.txt = c("<2.0", "2.0-3.0", "3.0-3.5",">3.5")

pdf(file="SidsSar.pdf")
par(mfrow=c(2,1), oma = c(0,0,4,0) + 0.1, mar = c(0,0,1,0) + 0.1)
plot(nc.sids[c("geometry","rates.FT")], col=color.code.raw, main = "", key.pos = NULL, reset = FALSE)
title("a) Raw Freeman-Tukey transformed SIDS rates" )
legend("bottomleft", legend=leg.txt, cex=1.25, bty="n", horiz = FALSE, fill = color.pallete)
plot(nc.sids[c("geometry","fitted.sar")], col=color.code.fitted, main = "", key.pos = NULL, reset = FALSE)
title("b) Fitted SIDS rates from SAR model")
dev.off()


     
