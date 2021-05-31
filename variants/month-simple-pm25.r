# Creates barchart visualizations of monthly data for upper SEA. Use month.py to get the data.
# Usage: Rscript month-simple.r monthfile.nc
# Output: year-month-pm25.jpg
# Example: Rscript month-simple.r 2021-05.nc
# produces: 2021-05-pm25.jpg
# Based on ECMWF examples, only small tuning by Marko Niinimaki niinimakim@webster.ac.th 2020
# install.packages(c("raster", "mapview"))

library("raster")
# library("mapview")
library("ncdf4")
library("ncdf.tools")
library("stringr")

args = commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  stop("Parameters needed: monthfile.nc", call.=FALSE)
}

woffile = args[1]


thai <- raster::getData(name = "GADM", country = "Thailand", level = 0)
laos <- raster::getData(name = "GADM", country = "Laos", level = 0)
viet <- raster::getData(name = "GADM", country = "Vietnam", level = 0)
myan <- raster::getData(name = "GADM", country = "Myanmar", level = 0)
camb <- raster::getData(name = "GADM", country = "Cambodia", level = 0)


country <- bind(thai, laos, viet, myan, camb)

# Load the climatology
gfas_data_mean <- brick("gfas_0001_cfire_climatology_2003_2018.nc",
                        varname = "gfas_data_mean")

# Load current emissions: PM2.5
current_emissions <- brick(woffile, varname="pm2p5fire")
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- labels_current

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-3

fname = paste(times_no, "-pm25.jpg", sep="")
jpeg(fname)
meanc = mean(current_sum)
meanc = round(meanc)
maxc  = max(current_sum)
maxc = round(maxc)

tmptext = paste("Average fire PM2.5 emissions per day:", meanc, "max:", maxc)
print(paste(times_no, tmptext))
barplot(current_sum, names.arg=idx, ylim=c(0, 2000), main=paste("Wildfire flux of Particulate Matter PM2.5", times_no), ylab=ylabt,
        sub=tmptext)

