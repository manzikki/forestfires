# Print the daily value of avg pm2.5 in the Chiang Mai province
# Based on ECMWF examples, tuning by Marko Niinimaki marko.n@chula.ac.th 2024
# Use parameter: an netcdf file containing one day of data, variable pm2p5fire
# install.packages(c("raster"))

library("raster")
#library("ncdf4")
#library("ncdf.tools")
#library("stringr")

args = commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  stop("Parameters needed: dayfile.nc", call.=FALSE)
}

pmfile = args[1]

country <- raster::getData(name = "GADM", country = "Thailand", level = 1)
chiangmai <- country[country$NAME1=="ChiangMai"]


# Load current emissions: PM2.5
current_emissions <- brick(pmfile, varname="pm2p5fire")
#crop to include chiangmai only
chiangmai_em = crop(current_emissions, chiangmai)
#not sure about this. why would we multiply because next we divide
current <- raster::area(chiangmai_em) # * 1000000 # in m2

# Compute mean over the area
current_mean <- cellStats(current, mean) * 86400 * 1E-3
print(current_mean)

#current <- raster::mask(current_emissions * current_area, chiangmai)
#current <- mask(current, chiangmai)
