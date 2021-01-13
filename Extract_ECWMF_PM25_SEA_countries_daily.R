#By Dr. Praphatsorn Punsompong 2020.
#Small adjustments by Marko Niinimaki.
#This program gets a NetCFD file from the command line and creates maps of upper SEA for each of the
#dates for variable pm25 that should be found in the NetCDF file.
#It produces file: datepm25.jpg

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
library(rgdal) 
library(ggplot2) 
library(stringr)

#get the parameter
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 1) {
  stop("Parameters needed: monthly file in the form 2020-XXpm25.nc", call.=FALSE)
}
aNCfile = args[1]

#read date from filename
aDataDate = str_replace(aNCfile, ".nc", "")

#upper South East Asia is here
seabox <- as(raster::extent(89.25,110.38,1.89,28.84), "SpatialPolygons")

#extraction
aPM25_data = brick(aNCfile, var="pm2p5")
#dates
tatt = attributes(aPM25_data)[2]
firstdate = names(tatt$data)[1]
print(firstdate)
myyear = substr(firstdate, 2, 5)
print(myyear)
mymon = substr(firstdate, 7, 8)
print(mymon)

crs(aPM25_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

aPM25_SEA = mask(aPM25_data,seabox)
aPM25_SEAmg = aPM25_SEA * 1000000000 #mg/m^2

#plot daily maps
aNumDay = nlayers(aPM25_SEA) #number of days in Month

for (aDay in (1:aNumDay)) {
  aDate = ifelse(aDay < 10,paste0("0",aDay),aDay)
  aMapDate = paste0(myyear,".",mymon,".",aDate)
  aFileDate = paste0(myyear,"-",mymon,"-",aDate)
  #print(aMapDate)
  print(aFileDate)

  atR = subset(aPM25_SEAmg,aDay)
  aPM25_D = as.data.frame(atR, xy = TRUE)

  names(aPM25_D)[3]="PM25"

  summary(aPM25_D)

  #print(FRP_breaks)

  aMaxP = max(aPM25_D$PM25, na.rm = TRUE)
  #print("Max PM2.5")
  #print(aMaxP) #3.841185e-09
  #aMaxP = ifelse(aMaxP < 1,1,aMaxP)
  #these breaks should be hardcoded for consistency
  PM25_breaks = seq(0,aMaxP,length.out=5)

  jpeg(paste0(aFileDate , "pm25a.jpg"), width = 1442 , height = 1442 , res = 200)
  PM25_labels = scalef(PM25_breaks)

  draw_map_with_data("PM 2.5 emissions in general", expression(paste("PM 2.5 mg m"^"-2","s"^"-1")), 
                      aMaxP, aPM25_D, PM25_breaks, PM25_labels, aPM25_D$PM25)


}










