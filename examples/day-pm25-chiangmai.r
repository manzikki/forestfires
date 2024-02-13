# Print the daily value of sum of pm2.5 in the Chiang Mai province
# Based on ECMWF examples, tuning by Marko Niinimaki marko.n@chula.ac.th 2024
# install.packages(c("raster", "mapview", "ncfd4"))

library("raster")
# library("mapview")
library("ncdf4")
#library("ncdf.tools")
library("stringr")

args = commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  stop("Parameters needed: dayfile.nc", call.=FALSE)
}

woffile = args[1]

country <- raster::getData(name = "GADM", country = "Thailand", level = 1)
chiangmai <- country[country$NAME1=="ChiangMai"]


# Load current emissions: PM2.5
current_emissions <- brick(woffile, varname="pm2p5fire")
#crop to include chiangmai only
chiangmai_em = crop(current_emissions, chiangmai)
#not sure about this. why would we multiply because in the sum we divide
current <- raster::area(chiangmai_em) # * 1000000 # in m2

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-3
print(current_sum)

#current <- raster::mask(current_emissions * current_area, chiangmai)
#current <- mask(current, chiangmai)
