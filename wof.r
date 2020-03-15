# Displays Wildfire Overall flux of burnt carbon for a month compared with a climatological average
# Based on ECMWF examples, only small tuning by Marko Niinimaki niinimakim@webster.ac.th 2020
# install.packages(c("raster", "mapview"))

library("raster")
# library("mapview")
library("ncdf4")
library("ncdf.tools")
library("stringr")

args = commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  stop("Parameters needed: woffile.nc", call.=FALSE)
}

woffile = args[1]

country <- raster::getData(name = "GADM", country = "Thailand", level = 0)

# Load the climatology
gfas_data_mean <- brick("gfas_0001_cfire_climatology_2003_2018.nc",
                        varname = "gfas_data_mean")
labels_clima <- substr(names(gfas_data_mean), 7, 11)
clima_area <- raster::area(gfas_data_mean) * 1000000 # in m2
clima <- gfas_data_mean * clima_area
clima <- mask(clima, country)

# Load current emissions
current_emissions <- brick(woffile)
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- which(labels_clima %in% labels_current)

# Compute sum over the area
clima_sum <- cellStats(clima[[idx]], sum) * 86400 * 1E-9
current_sum <- cellStats(current, sum) * 86400 * 1E-9

#open the file to read the time dimension for the first day
ncin <- nc_open(woffile)
time <- ncvar_get(ncin,'time')
times <- convertDateNcdf2R(time, units = "hours", origin = as.POSIXct("1900-01-01",  tz = "UTC"))
times_no <- str_replace(times, " UTC", "")

jpeg("wof.jpg")
# Grouped Bar Plot
df <- t(as.matrix(data.frame(climatology = clima_sum, current = current_sum)))
colnames(df) <- as.character(times_no)

#as.character(as.Date(idx), origin = first))
barplot(df,
        main="Wildfire overall flux of burnt Carbon",
        xlab="", ylab = "Megatones per day", col=c("darkgrey", "darkred"),
        legend = rownames(df),,
        beside=TRUE, las = 2, border = NA)

# Create a map of emissions for the first day of the month
#Emissions <- current[[1]]
#mapview(Emissions, alpha.regions = 0.3)
