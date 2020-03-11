# Call by: Rscript work.r
# Based on an example by Claudia Vitolo
# Marko Niinimaki, niinimakim@webster.ac.th 2020
### PACKAGES ###

# Install
#install.packages(c("devtools", "raster", "manipulate", "dplyr", "leaflet"))
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

### Administrative boundary and bounding box for Thailand ###

# Get Thai administrative boundary
tha <- raster::getData(name = "GADM", country = "THA", level = 0)

# or bounding box (http://boundingbox.klokantech.com/)
thaibox <- as(raster::extent(89.25,110.38,1.89,28.84), "SpatialPolygons")
proj4string(thaibox) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# Load global FRP layer and rotate longitude to be in the range [-180, +180]
frp <- raster::rotate(raster::brick(frpfile))

# Load global PM2.5 layer and rotate longitude to be in the range [-180, +180]
pm2p5 <- raster::rotate(raster::brick(pm25file))

# Crop frp and pm2p5 over Thailand
frp_thabbox <- raster::crop(frp, thaibox)
pm2p5_thabbox <- raster::crop(pm2p5, thaibox)

# Calculate the area of each cell of raster, applies a correction for latitude -> m2
area_raster <- raster::area(pm2p5_thabbox[[1]])*1000000

# Plot the FRP to frp.jpg
jpeg("frp.jpg")

plot(frp_thabbox, main = "FRP in W/m2", 
     xlab = "Lon", ylab = "Lat")
plot(tha, add= TRUE)
dev.off()

# Plot the PM2.5
jpeg("pm25.jpg")
plot(pm2p5_thabbox, main = "PM2.5", 
     xlab = "Lon", ylab = "Lat")
plot(tha, add = TRUE)
dev.off()
