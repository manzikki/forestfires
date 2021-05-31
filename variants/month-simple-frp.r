# Creates barchart visualizations of monthly data for upper SEA. Use month.py to get the data.
# Usage: Rscript month-simple-frp.r monthfile.nc
# Output: year-month-frp.jpg
# Example: Rscript month-simple.r 2021-05.nc
# produces: 2021-05-frp.jpg
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

#open the file to read the time dimension for the first day
ncin <- nc_open(woffile)
time <- ncvar_get(ncin,'time')
times <- convertDateNcdf2R(time, units = "hours", origin = as.POSIXct("1900-01-01",  tz = "UTC"))
times_no <- str_replace(times[1], "UTC", "")
#print(times_no) 2020-08-01
times_no <- str_replace(times_no, "-01", "")
#print(times_no) 2020-08

thai <- raster::getData(name = "GADM", country = "Thailand", level = 0)
laos <- raster::getData(name = "GADM", country = "Laos", level = 0)
viet <- raster::getData(name = "GADM", country = "Vietnam", level = 0)
myan <- raster::getData(name = "GADM", country = "Myanmar", level = 0)
camb <- raster::getData(name = "GADM", country = "Cambodia", level = 0)

ylabt <- expression(paste("Tonnes per day per m"^"2"))

country <- bind(thai, laos, viet, myan, camb)

# Load the climatology
gfas_data_mean <- brick("gfas_0001_cfire_climatology_2003_2018.nc",
                        varname = "gfas_data_mean")

# Load current emissions: FRP
current_emissions <- brick(woffile, varname="frpfire")
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- labels_current

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-3

fname = paste(times_no, "-frp.jpg", sep="")
jpeg(fname)
#scaling: use MW instead of W
summillionth <- current_sum %/% 1000000
meanc = mean(current_sum)
meanc = round(meanc)
maxc  = max(current_sum)
maxc = round(maxc)
tmptext = paste("Average FRP per day:", meanc, "max:", maxc)
dtext = paste(times_no, "Average FRP per day:", round(mean(summillionth)), "max:", max(summillionth))
print(paste(times_no, tmptext))
#print(debugtext)
options(scipen=5)
barplot(summillionth, names.arg=idx, main=paste("Fire Radiative Power", times_no), ylab="FRP in MW/m2",
        sub=dtext, ylim=c(0, 1000000))

