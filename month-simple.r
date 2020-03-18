# Creates sevaral barchart visualizations of monthly data. Use month.py to get the data.
# Usage: Rscript month-simple.r monthfile.nc
# Output: jpg files year-month-variable.jpg
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

country <- raster::getData(name = "GADM", country = "Thailand", level = 0)

# Load the climatology
gfas_data_mean <- brick("gfas_0001_cfire_climatology_2003_2018.nc",
                        varname = "gfas_data_mean")

# Load current emissions: Wildfire Overall flux
current_emissions <- brick(woffile, varname="cfire")
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- labels_current

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-9

#open the file to read the time dimension for the first day
ncin <- nc_open(woffile)
time <- ncvar_get(ncin,'time')
times <- convertDateNcdf2R(time, units = "hours", origin = as.POSIXct("1900-01-01",  tz = "UTC"))
times_no <- str_replace(times[20], "UTC", "")
times_no <- str_replace(times_no, "-20", "")

fname = paste(times_no, "-wof.jpg", sep="")
jpeg(fname)
barplot(current_sum, names.arg=idx, main=paste("Wildfire Overall Flux of Burnt Carbon, Thailand", times_no))


# Load current emissions: CO2
current_emissions <- brick(woffile, varname="co2fire")
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- labels_current

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-9

fname = paste(times_no, "-co2.jpg", sep="")
jpeg(fname)
barplot(current_sum, names.arg=idx, main=paste("Wildfire flux of Carbon Dioxide, Thailand", times_no))

# Load current emissions: CO
current_emissions <- brick(woffile, varname="cofire")
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- labels_current

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-9

fname = paste(times_no, "-co.jpg", sep="")
jpeg(fname)
barplot(current_sum, names.arg=idx, main=paste("Wildfire flux of Carbon Monoxide, Thailand", times_no))

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
current_sum <- cellStats(current, sum) * 86400 * 1E-9

fname = paste(times_no, "-pm25.jpg", sep="")
jpeg(fname)
barplot(current_sum, names.arg=idx, main=paste("Wildfire flux of Particulate Matter PM2.5, Thailand", times_no))


# Create a map of emissions for the first day of the month
#Emissions <- current[[1]]
#mapview(Emissions, alpha.regions = 0.3)
