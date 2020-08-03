# Creates graphs/maps about forest fires in SEA
# Call by: Rscript day.r dayfile.nc
# Use day.py to produce the dayfile.
# Outputfiles: dayfrp.jpg, daypm25.jpg, oc.jpg
# Based on an example by Claudia Vitolo
# Marko Niinimaki, niinimakim@webster.ac.th 2020
# Sinjan Pokharel
### PACKAGES ###

# Install
#install.packages(c("devtools", "raster", "manipulate", "dplyr", "leaflet", "stringr"))
#devtools::install_github("ecmwf/caliver")

makefilename <- function(ncfilename, extension)
{
### makes a filename for plot based on ncfile ###
oname <- str_replace(ncfilename, ".nc", extension)
oname
}

plotmap <- function()
{
### Administrative boundaries for SEA ###
tha <- raster::getData(name = "GADM", country = "THA", level = 0)
lao <- raster::getData(name = "GADM", country = "LAO", level = 0)
khm <- raster::getData(name = "GADM", country = "KHM", level = 0)
vnm <- raster::getData(name = "GADM", country = "VNM", level = 0)
mmr <- raster::getData(name = "GADM", country = "MMR", level = 0)
plot(tha, add=TRUE)
plot(lao, add=TRUE)
plot(khm, add=TRUE)
plot(vnm, add=TRUE)
plot(mmr, add=TRUE)
}

# Check parameters
args = commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  stop("Parameters needed: dayfile.nc", call.=FALSE)
}

dayfile = args[1]

# Load
library("raster")
library("manipulate")
library("dplyr")
library("leaflet")
library("caliver")
library("stringr")


# bounding box (find dimensions by boundingbox.klokantech.com)
seabox <- as(raster::extent(89.25,110.38,1.89,28.84), "SpatialPolygons")
proj4string(seabox) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# Load global FRP layer and rotate longitude to be in the range [-180, +180]
frp <- raster::rotate(raster::brick(dayfile, varname="frpfire"))

# Load global PM2.5 layer and rotate longitude to be in the range [-180, +180]
pm2p5 <- raster::rotate(raster::brick(dayfile, varname="pm2p5fire"))

# Load global OC layer and rotate longitude to be in the range [-180, +180]
OC <- raster::rotate(raster::brick(dayfile, varname="ocfire"))

# Load global co2 layer and rotate longitude to be in the range [-180, +180]
co2 <- raster::rotate(raster::brick(dayfile, varname="co2fire"))

# Crop frp, pm2p5. co2 and C over SEA
frp_sea <- raster::crop(frp, seabox)
pm2p5_sea <- raster::crop(pm2p5, seabox)
OC_sea <- raster::crop(OC, seabox)
co2_sea <- raster::crop(co2, seabox)

# Calculate the area of each cell of raster, applies a correction for latitude -> m2
area_raster <- raster::area(pm2p5_sea[[1]])*1000000

mydate <- str_replace(dayfile, ".nc", "")

mainlabel = paste("FRP in W/m2", mydate)

# Plot the FRP to frp.jpg
jpeg(makefilename(dayfile, "frp.jpg"))
plot(frp_sea, main = mainlabel,
     xlab = "Lon", ylab = "Lat")
plotmap()
dev.off()

# Plot the FRP to frp.svg
svg(makefilename(dayfile, "frp.svg"))
plot(frp_sea, main = mainlabel,
     xlab = "Lon", ylab = "Lat")
plotmap()
dev.off()

mainlabel = paste("PM 2.5", mydate)
label <- expression(paste("kg m"^"-2","s"^"-1"))

# Plot the PM2.5 to jpg
jpeg(makefilename(dayfile,"pm25.jpg"))

plot(pm2p5_sea, main = mainlabel,
     xlab = "Lon", ylab = "Lat")
mtext(label, side=3)
plotmap()
dev.off()

# Plot the PM2.5 to svg
svg(makefilename(dayfile,"pm25.svg"))

plot(pm2p5_sea, main = mainlabel,
     xlab = "Lon", ylab = "Lat")
plotmap()
mtext(label, side=3)
dev.off()

mainlabel = paste("Organic Carbon ", mydate)
# Plot the Organic Carbon to jpg
jpeg(makefilename(dayfile,"oc.jpg"))
plot(log(OC_sea), main = mainlabel,
     xlab = "Lon", ylab = "Lat", log="x")
plotmap()
dev.off()

# Plot the Organic Carbon to svg
svg(makefilename(dayfile,"oc.svg"))
plot(log(OC_sea), main = mainlabel,
     xlab = "Lon", ylab = "Lat", log="x")
plotmap()
dev.off()

#mainlabel = paste("co2 kg m^-2 s^-1", mydate)
mainlabel <- paste("co2 ",mydate)
label <- expression(paste("kg m"^"-2","s"^"-1"))
#mainlabel <- paste(mydate, main)

# Plot the co2 to co2.jpg
jpeg(makefilename(dayfile,"co2.jpg"))

plot(co2_sea, main = mainlabel,
     xlab = "Lon", ylab = "Lat")
mtext(label, side=3)
plotmap()
dev.off()

# Plot the FRP to frp.svg
svg(makefilename(dayfile,"co2.svg"))

plot(frp_sea, main = mainlabel,
     xlab = "Lon", ylab = "Lat")
mtext(label, side=3)
plotmap()
dev.off()

