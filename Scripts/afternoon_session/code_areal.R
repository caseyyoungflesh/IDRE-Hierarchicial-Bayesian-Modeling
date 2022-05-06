library(maps)
library(spdep)
library(maptools)
library(classInt)
library(RColorBrewer)

# Get county map for California
ca.county = map("county","california", fill=TRUE, plot=FALSE)
county.ID <- sapply(strsplit(ca.county$names, ","), function(x) x[2])
ca.poly = map2SpatialPolygons(ca.county, IDs=county.ID)
ca.coords = coordinates(ca.poly)

plot(ca.poly)
text(ca.coords, county.ID, cex=0.5, col = "red")

# Plot data on map
# Get data for lung cancer
rate_5y <- read.csv("age_adjusted.csv")
rate_CA = rate_5y[substr(rate_5y$State_county,1,2) == "CA",]
rate_lung = rate_CA[rate_CA$Site_recode_ICD_O_3_WHO_2008=="Lung and Bronchus",]
rate_lung = rate_lung[order(readr::parse_number(as.character(rate_lung$State_county))),]
# Import lung cancer data in map data
ca.poly$rate_lung = rate_lung$Age_Adjusted_Rate

# Plots
brks_fit_lung = c(22, 41, 45, 51, 80)
color.pallete = rev(brewer.pal(4,"RdBu"))
class.rate_lung = classIntervals(var=ca.poly$rate_lung, n=4, style="fixed", 
                                 fixedBreaks=brks_fit_lung, dataPrecision=4)
color.code.rate_lung = findColours(class.rate_lung, color.pallete)

plot(ca.poly, col = color.code.rate_lung)
leg.txt1 = c("22-41", "41-45", "45-51","51-80")
legend("bottomleft", title="Lung cancer", legend=leg.txt1, cex=1.25, bty="n", horiz = FALSE, 
       fill = color.pallete)
