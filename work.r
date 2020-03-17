# Creates graphs about forest fires in SEA
# Call by: Rscript work.r frpfile.nc pm25file.nc
# Outputfiles: same name as input but jpg instead of nc
# Based on an example by Claudia Vitolo
# Marko Niinimaki, niinimakim@webster.ac.th 2020
### PACKAGES ###

# Install
#install.packages(c("devtools", "raster", "manipulate", "dplyr", "leaflet", "stringr"))
#devtools::install_github("ecmwf/caliver")

# Check parameters: 1: frpfile.nc 2: pm25file.nc
args = commandArgs(trailingOnly=TRUE)

if (length(args) < 2) {
  stop("Parameters needed 1: frpfile.nc 2: pm25file.nc", call.=FALSE)
}

frpfile = args[1]
pm25file = args[2]

print(frpfile)
print(pm25file)

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
lao <- raster::getData(name = "GADM", country = "LAO", level = 0)
khm <- raster::getData(name = "GADM", country = "KHM", level = 0)
vnm <- raster::getData(name = "GADM", country = "VNM", level = 0)
mmr <- raster::getData(name = "GADM", country = "MMR", level = 0)


# bounding box (find dimensions by boundingbox.klokantech.com)
seabox <- as(raster::extent(89.25,110.38,1.89,28.84), "SpatialPolygons")
proj4string(seabox) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# Load global FRP layer and rotate longitude to be in the range [-180, +180]
frp <- raster::rotate(raster::brick(frpfile))

# Load global PM2.5 layer and rotate longitude to be in the range [-180, +180]
pm2p5 <- raster::rotate(raster::brick(pm25file))

# Crop frp and pm2p5 over SEA
frp_sea <- raster::crop(frp, seabox)
pm2p5_sea <- raster::crop(pm2p5, seabox)

# Calculate the area of each cell of raster, applies a correction for latitude -> m2
area_raster <- raster::area(pm2p5_sea[[1]])*1000000

mydate <- str_replace(frpfile, "frp.nc", "")
mainlabel = paste("FRP in W/m2", mydate)

# Plot the FRP to frp.jpg
jpeg("frp.jpg")

plot(frp_sea, main = mainlabel,
     xlab = "Lon", ylab = "Lat")
plot(tha, add= TRUE)
plot(lao, add=TRUE)
plot(khm, add=TRUE)
plot(vnm, add=TRUE)
plot(mmr, add=TRUE)

dev.off()
mainlabel = paste("PM 2.5", mydate)

oname <- str_replace(frpfile, ".nc", ".jpg")
file.copy("frp.jpg", oname)

# Plot the PM2.5
jpeg("pm25.jpg")
plot(pm2p5_sea, main = mainlabel,
     xlab = "Lon", ylab = "Lat")
plot(tha, add = TRUE)
plot(lao, add = TRUE)
plot(khm, add=TRUE)
plot(vnm, add=TRUE)
plot(mmr, add=TRUE)


dev.off()

oname <- str_replace(pm25file, ".nc", ".jpg")
file.copy("pm25.jpg", oname)
