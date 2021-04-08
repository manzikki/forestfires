#By Dr. Praphatsorn Punsompong 2020.
#Small adjustments by Marko Niinimaki.
#This program gets a NetCFD file from the command line and creates maps of upper SEA for each of the
#dates for variables frp, co2fire and pm25fire that should be found in the NetCDF file.
#It produces files datefrp.jpg, dateco2.jpg, datepm25.jpg

source("myfunctions.r")

library(ncdf4) 
library(raster) 
library(rgdal) 
library(ggplot2) 
library(stringr)

#get the parameter
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 1) {
  stop("Parameters needed: monthly file in the form 2020-XX.nc", call.=FALSE)
}
aNCfile = args[1]

#read date from filename
aDataDate = str_replace(aNCfile, ".nc", "")

#upper South East Asia is here
seabox <- as(raster::extent(89.25,110.38,1.89,28.84), "SpatialPolygons")

#extraction
aPM25_data = brick(aNCfile, var="pm2p5fire")

crs(aPM25_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

aPM25_SEA = mask(aPM25_data,seabox)
aPM25_SEAmg = aPM25_SEA * 1000000000 #mg/m^2

#plot daily maps
aNumDay = nlayers(aPM25_SEA) #number of days in Month

for (aDay in (1:aNumDay)) {
  aDate = ifelse(aDay < 10,paste0("0",aDay),aDay)
  aMapDate = paste0(aDataDate,".",aDate)
  aMapDate = str_replace(aMapDate,"-",".")
  aFileDate = paste0(aDataDate,"-",aDate)
  if (aNumDay == 1) {
      aDataDate = str_replace(aNCfile, "pm25.nc", "")
      aMapDate = str_replace(aDataDate,"-",".")
      aMapDate = str_replace(aMapDate,"-",".")
      aFileDate = str_replace(aNCfile, "pm25.nc", "")
  }
  #print(aMapDate)
  print(aFileDate)

  atR = subset(aPM25_SEAmg,aDay)
  aPM25_D = as.data.frame(atR, xy = TRUE)

  names(aPM25_D)[3]="PM25"

  aMaxP = max(aPM25_D$PM25, na.rm = TRUE)
  #print("Max PM2.5")
  #print(aMaxP) #3.841185e-09
  #aMaxP = ifelse(aMaxP < 1,1,aMaxP)
  #these breaks should be hardcoded for consistency
  PM25_breaks = seq(0,aMaxP,length.out=5)

  jpeg(paste0(aFileDate , "pm25.jpg"), width = 1442 , height = 1442 , res = 200)
  PM25_labels = scalef(PM25_breaks)

  draw_map_with_data("PM 2.5 from fires", expression(paste("PM 2.5 mg m"^"-2","s"^"-1")), 
                      aMaxP, aPM25_D, PM25_breaks, PM25_labels, aPM25_D$PM25)

}










