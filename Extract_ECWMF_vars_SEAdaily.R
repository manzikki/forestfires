#By Dr. Praphatsorn Punsompong 2020.
#Small adjustments by Marko Niinimaki.
#This program gets a NetCFD file from the command line and creates FRP maps of upper SEA for each of the
#dates.

draw_map_with_data <- function(title, unit, maxlim, daydata, breaks, col) {
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
                              labels = breaks) +
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
library(rgdal) 
library(ggplot2) 
library(stringr)

#get the parameter
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 1) {
  stop("Parameters needed: monthly frpfile in the form 2020-XX.nc", call.=FALSE)
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
aCO2_SEA = mask(aCO2_data,seabox)

#plot FRP map
aNumDay = nlayers(aFRP_SEA) #number of days in Month

for (aDay in (1:aNumDay)) {
  aDate = ifelse(aDay < 10,paste0("0",aDay),aDay)
  aMapDate = paste0(aDataDate,".",aDate)
  aMapDate = str_replace(aMapDate,"-",".")
  print(aMapDate)
  
  atR = subset(aFRP_SEA,aDay) #extract time:day in nc data
  aFRP_D = as.data.frame(atR, xy = TRUE) #change raster to dataframe
  atR = subset(aPM25_SEA,aDay)  
  aPM25_D = as.data.frame(atR, xy = TRUE)
  atR = subset(aCO2_SEA,aDay)
  aCO2_D = as.data.frame(atR, xy = TRUE)

  names(aFRP_D)[3]="FRP"
  names(aPM25_D)[3]="PM25"
  names(aCO2_D)[3]="CO2"

  summary(aFRP_D)

  aMaxF = max(aFRP_D$FRP, na.rm = TRUE)
  aMaxF = ifelse(aMaxF < 1,1,aMaxF)
  FRP_breaks = seq(0,aMaxF,0.2)
    
  png(paste0("SEAFRP." , aMapDate , ".png"), width = 2018 , height = 1442 , res = 200)
  draw_map_with_data("FRP in Upper SEA", "FRP (W/m2)", aMaxF, aFRP_D, FRP_breaks, aFRP_D$FRP)

  aMaxP = max(aPM25_D$PM25, na.rm = TRUE)
  aMaxP = ifelse(aMaxP < 1,1,aMaxP)
  PM25_breaks = seq(0,aMaxP,0.2)

  png(paste0("SEAPM25." , aMapDate , ".png"), width = 2018 , height = 1442 , res = 200)
  draw_map_with_data("PM 2.5", expression(paste("PM 2.5 kg m"^"-2","s"^"-1")), aMaxP, aPM25_D, PM25_breaks, aPM25_D$PM25)

  aMaxC = max(aCO2_D$CO2, na.rm = TRUE)
  aMaxC = ifelse(aMaxC < 1,1,aMaxC)
  CO2_breaks = seq(0,aMaxC,0.2)

  png(paste0("SEACO2." , aMapDate , ".png"), width = 2018 , height = 1442 , res = 200)
  draw_map_with_data("Forest fire CO2 in Upper SEA", expression(paste("PM 2.5 kg m"^"-2","s"^"-1")), aMaxC, aCO2_D, CO2_breaks, aCO2_D$CO2)

}










