#By Dr. Praphatsorn Punsompong 2020.
#Small adjustments by Marko Niinimaki.
#This program gets a NetCFD file from the command line and creates maps of upper SEA for CO2

source("myfunctions.r")

library(ncdf4) 
library(raster) 
library(rgdal) 
library(ggplot2) 
library(stringr)

#get the parameter
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 1) {
  stop("Parameters needed: CO2 file in the form 2020-XX.nc", call.=FALSE)
}
aNCfile = args[1]

#read date from filename
aDataDate = str_replace(aNCfile, ".nc", "")

#upper South East Asia is here
seabox <- as(raster::extent(89.25,110.38,1.89,28.84), "SpatialPolygons")

#extraction
aCO2_data = brick(aNCfile, var="co2fire")

crs(aCO2_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

aCO2_SEA = mask(aCO2_data,seabox)
aCO2_SEAmg = aCO2_SEA * 1000000000 #mg/m^2

#plot daily maps
aNumDay = nlayers(aCO2_SEA) #number of days in Month

for (aDay in (1:aNumDay)) {
  aDate = ifelse(aDay < 10,paste0("0",aDay),aDay)
  aMapDate = paste0(aDataDate,".",aDate)
  aMapDate = str_replace(aMapDate,"-",".")
  aFileDate = paste0(aDataDate,"-",aDate)
  if (aNumDay == 1) {
      aDataDate = str_replace(aNCfile, "co2.nc", "")
      aMapDate = str_replace(aDataDate,"-",".")
      aMapDate = str_replace(aMapDate,"-",".")
      aFileDate = str_replace(aNCfile, "co2.nc", "")
  }
  #print(aMapDate)
  print(aFileDate)

  atR = subset(aCO2_SEAmg,aDay)
  aCO2_D = as.data.frame(atR, xy = TRUE)

  names(aCO2_D)[3]="CO2"

  aMaxP = max(aCO2_D$CO2, na.rm = TRUE)
  print(paste("Max CO2", aMaxP))
  #these breaks should be hardcoded for consistency
  CO2_breaks = seq(0,aMaxP,length.out=5)

  jpeg(paste0(aFileDate , "co2.jpg"), width = 1442 , height = 1442 , res = 200)
  CO2_labels = scalef(CO2_breaks)

  draw_map_with_data("CO2 from fires", "Milligrams per square meter per s", 
                      aMaxP, aCO2_D, CO2_breaks, CO2_labels, aCO2_D$CO2)

}










