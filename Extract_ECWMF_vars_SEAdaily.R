#To install R, please see here: https://cran.r-project.org. You do not need to install R studio (the GUI package), just R.
#To install the required packages:
#R
#install.packages(c('ncdf4','raster','ggplot2'))
#By Dr. Praphatsorn Punsompong 2020.
#Small adjustments by Marko Niinimaki.
#This program gets a NetCFD file from the command line and creates maps of upper SEA for each of the
#dates for variables frp, co2fire and pm25fire that should be found in the NetCDF file.
#It produces files datefrp.jpg, dateco2.jpg, datepm25.jpg

#For truncating very long label numbers
scalef <- function(x) sprintf("%.2f", x)

#Draws the maps
draw_map_with_data <- function(title, unit, maxlim, daydata, breaks, labels, col) {
    ThaiBound <- raster::getData(name = "GADM", country = "THA", level = 0)
    LaoBound <- raster::getData(name = "GADM", country = "LAO", level = 0)
    KhmBound <- raster::getData(name = "GADM", country = "KHM", level = 0)
    VnmBound <- raster::getData(name = "GADM", country = "VNM", level = 0)
    MyaBound <- raster::getData(name = "GADM", country = "MMR", level = 0)
    aPlot = ggplot()+
          geom_raster(data=daydata,aes(x,y,fill=col))+
          scale_fill_gradient(low = "white",
                              high = "red",
                              na.value = NA,
                              limits = c(0,maxlim),
                              breaks = breaks,
                              labels = labels) +
          scale_x_continuous(name=expression(paste("Longitude")),
                             limits=c(90,111),
                             expand=c(0,0)) +
          scale_y_continuous(name=expression(paste("Latitude")),
                             limits=c(5,30),
                             expand=c(0,0)) +
          geom_polygon(data=ThaiBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          geom_polygon(data=LaoBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          geom_polygon(data=MyaBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          geom_polygon(data=KhmBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          geom_polygon(data=KhmBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          geom_polygon(data=VnmBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          ggtitle(title,
                  subtitle = paste0("Date : ", aMapDate))+
          labs(fill = unit)+
          theme(panel.ontop=FALSE,
                panel.background=element_blank(),
                panel.border = element_rect(colour = "black", fill=NA, size=0.1),
                legend.title = element_text(color = "black", size = 10)) +
          coord_equal()
          print(aPlot)
          dev.off()
}

library(ncdf4) 
library(raster) 
#library(rgdal) 
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
aPM25_data = brick(aNCfile, var="pm2p5fire")
aCO2_data = brick(aNCfile, var="co2fire")

crs(aFRP_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
crs(aPM25_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
crs(aCO2_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

aFRP_SEA = mask(aFRP_data,seabox)

aPM25_SEA = mask(aPM25_data,seabox)
aPM25_SEAmg = aPM25_SEA * 1000000000 #mg/m^2

aCO2_SEA = mask(aCO2_data,seabox)
aCO2_SEAmg = aCO2_SEA * 1000000000 #mg/m^2

#plot daily maps
aNumDay = nlayers(aFRP_SEA) #number of days in Month

for (aDay in (1:aNumDay)) {
  aDate = ifelse(aDay < 10,paste0("0",aDay),aDay)
  aMapDate = paste0(aDataDate,".",aDate)
  aMapDate = str_replace(aMapDate,"-",".")
  aFileDate = paste0(aDataDate,"-",aDate)
  #print(aMapDate)
  print(aFileDate)

  atR = subset(aFRP_SEA,aDay) #extract time:day in nc data
  aFRP_D = as.data.frame(atR, xy = TRUE) #change raster to dataframe
  atR = subset(aPM25_SEAmg,aDay)
  aPM25_D = as.data.frame(atR, xy = TRUE)
  atR = subset(aCO2_SEAmg,aDay)
  aCO2_D = as.data.frame(atR, xy = TRUE)

  names(aFRP_D)[3]="FRP"
  names(aPM25_D)[3]="PM25"
  names(aCO2_D)[3]="CO2"

  summary(aFRP_D)

  aMaxF = max(aFRP_D$FRP, na.rm = TRUE)
  FRP_breaks = seq(0,aMaxF,0.2)
  if (aMaxF > 2) { FRP_breaks = seq(0,aMaxF,0.5) }
  if (aMaxF > 6) { FRP_breaks = seq(0,aMaxF,1) }
  aMaxF = ifelse(aMaxF < 1,1,aMaxF)
  #print(FRP_breaks)
  #force uniform scale
  FRP_breaks = c(0, 1, 2, 3, 4)
  jpeg(paste0(aFileDate , "frp.jpg"), width = 1442 , height = 1442 , res = 200)
  draw_map_with_data("FRP in Upper SEA", "FRP (W/m2)", 4.0, aFRP_D, FRP_breaks, FRP_breaks, aFRP_D$FRP)

  aMaxP = max(aPM25_D$PM25, na.rm = TRUE)
  #print("Max PM2.5")
  #print(aMaxP) #3.841185e-09
  #aMaxP = ifelse(aMaxP < 1,1,aMaxP)
  #these breaks should be hardcoded for consistency
  #PM25_breaks = seq(0,aMaxP,length.out=5)
  PM25_breaks = c(0.0, 5.0, 10.0, 15.0, 20.0, 25.0)
  PM25_labels = PM25_breaks
  jpeg(paste0(aFileDate , "pm25.jpg"), width = 1442 , height = 1442 , res = 200)
  #PM25_labels = scalef(PM25_breaks)

  draw_map_with_data("PM 2.5 from fires", expression(paste("PM 2.5 mg m"^"-2","s"^"-1")), 
                      25.0, aPM25_D, PM25_breaks, PM25_labels, aPM25_D$PM25)

  aMaxC = max(aCO2_D$CO2, na.rm = TRUE)
  #print("Max CO2")
  #print(aMaxC) #3.841185e-09
  #aMaxC = ifelse(aMaxC < 1,1,aMaxC)
  #CO2_breaks = seq(0,aMaxC,length.out=10)
  #CO2_labels = scalef(CO2_breaks)
  #force scaling
  CO2_breaks = c(0,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000)
  CO2_labels = CO2_breaks
  jpeg(paste0(aFileDate , "co2.jpg"), width = 1442 , height = 1442 , res = 200)
  draw_map_with_data("Fire CO2 in Upper SEA", expression(paste("CO2 mg m"^"-2","s"^"-1")), 10000, aCO2_D, CO2_breaks, CO2_labels, aCO2_D$CO2)

}










