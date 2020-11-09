# Creates a map about forest fire FRP in Thailand
# Call by: Rscript work.r frpfile.nc
# Outputfiles: same name as input but thaifrp.jpg instead of nc
# Based on an example by Claudia Vitolo
# Marko Niinimaki, niinimakim@webster.ac.th 2020
### PACKAGES ###

# Install
#install.packages(c("devtools", "raster", "manipulate", "dplyr", "leaflet", "stringr"))
#devtools::install_github("ecmwf/caliver")

# Check parameters: 1: frpfile.nc
args = commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  stop("Parameters needed: frpfile.nc", call.=FALSE)
}

frpfile = args[1]

print(frpfile)

# Load
library("raster")
library("manipulate")
library("dplyr")
library("leaflet")
library("caliver")
library("stringr")

### Administrative boundary and bounding box for Thailand ###

# Get Thai administrative boundary
tha <- raster::getData(name = "GADM", country = "THA", level = 0)

# bounding box (find dimensions by boundingbox.klokantech.com)
seabox <- as(raster::extent(89.25,110.38,1.89,28.84), "SpatialPolygons")
proj4string(seabox) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# Load global FRP layer and rotate longitude to be in the range [-180, +180]
frp <- raster::rotate(raster::brick(frpfile, varname="frpfire"))

# Crop frp and pm2p5 over SEA
frp_sea <- raster::crop(frp, seabox)

# Calculate the area of each cell of raster, applies a correction for latitude -> m2
area_raster <- raster::area(frp_sea[[1]])*1000000

mydate <- str_replace(frpfile, ".nc", "")
mainlabel = paste("FRP in W/m2", mydate)

# Plot the FRP to frp.jpg
jpeg("frp.jpg")

plot(frp_sea, main = mainlabel,
     xlab = "Lon", ylab = "Lat")
#breaks=c(0.0,0.2,0.4,0.6,0.8,1.0,2.0,3.0))
plot(tha, add = TRUE)

dev.off()

oname <- str_replace(frpfile, ".nc", "thaifrp.jpg")
file.copy("frp.jpg", oname)

