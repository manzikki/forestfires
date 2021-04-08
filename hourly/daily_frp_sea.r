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
aFRP_data = brick(aNCfile, var="frpfire")
crs(aFRP_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
aFRP_SEA = mask(aFRP_data,seabox)

#plot daily maps
aNumDay = nlayers(aFRP_SEA) #number of days in Month

for (aDay in (1:aNumDay)) {
  aDate = ifelse(aDay < 10,paste0("0",aDay),aDay)
  aMapDate = paste0(aDataDate,".",aDate)
  aMapDate = str_replace(aMapDate,"-",".")
  aFileDate = paste0(aDataDate,"-",aDate)
  #print(aMapDate)
  if (aNumDay == 1) {
      aDataDate = str_replace(aNCfile, "frp.nc", "")
      aMapDate = str_replace(aDataDate,"-",".")
      aMapDate = str_replace(aMapDate,"-",".")
      aFileDate = str_replace(aNCfile, "frp.nc", "")
  }
  print(aFileDate)

  atR = subset(aFRP_SEA,aDay) #extract time:day in nc data
  aFRP_D = as.data.frame(atR, xy = TRUE) #change raster to dataframe
  names(aFRP_D)[3]="FRP"
  summary(aFRP_D)

  aMaxF = max(aFRP_D$FRP, na.rm = TRUE)
  FRP_breaks = seq(0,aMaxF,0.2)
  if (aMaxF > 2) { FRP_breaks = seq(0,aMaxF,0.5) }
  if (aMaxF > 6) { FRP_breaks = seq(0,aMaxF,1) }
  aMaxF = ifelse(aMaxF < 1,1,aMaxF)
  #print(FRP_breaks)
  jpeg(paste0(aFileDate , "frp.jpg"), width = 1442 , height = 1442 , res = 200)
  draw_map_with_data("FRP in Upper SEA", "FRP (W/m2)", aMaxF, aFRP_D, FRP_breaks, FRP_breaks, aFRP_D$FRP)
}










