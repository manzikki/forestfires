#By Dr. Praphatsorn Punsompong 2020.
#Small adjustments by Marko Niinimaki.
#This program gets a NetCFD file from the command line and creates FRP maps of Vietnam for each of the
#dates.
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
#get the date from the filename

#read data
aDataDate = str_replace(aNCfile, ".nc", "")

# Get Viet administrative boundary
VietBound <- raster::getData(name = "GADM", country = "VNM", level = 0)

#VietBound = shapefile(paste0(ws,"gadm36_THA_0_wgs84.shp"))
crs(VietBound) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0" 
aTHext = extent(VietBound)

#extraction
#PM25_data = brick(paste0(ws,aNCfile), var="pm2p5fire")
aFRP_data = brick(aNCfile, var="frpfire")
aPM25_data = brick(aNCfile, var="pm2p5fire")

crs(aPM25_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
crs(aFRP_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"


aPM25_TH = mask(aPM25_data,VietBound)
aFRP_TH = mask(aFRP_data,VietBound)

#plot FRP map
aNumDay = nlayers(aFRP_TH) #number of day in Month

for (aDay in (1:aNumDay)) {
  aDate = ifelse(aDay < 10,paste0("0",aDay),aDay)
  aMapDate = paste0(aDataDate,".",aDate)
  aMapDate = str_replace(aMapDate,"-",".")
  print(aMapDate)
  aFileDate = paste0(aDataDate,"-",aDate)

  atR = subset(aFRP_TH,aDay) #extract time:day in nc data
  aFRP_D = as.data.frame(atR, xy = TRUE) #change raster to dataframe
  
  atP = subset(aPM25_TH,aDay)
  aPM25_D = as.data.frame(atP, xy = TRUE)

  names(aFRP_D)[3]="FRP"
  names(aPM25_D)[3]="PM25"

  summary(aFRP_D)
  summary(aPM25_D)

  aMax = max(aFRP_D$FRP, na.rm = TRUE)
  aMax = ifelse(aMax < 1,1,aMax)
  FRP_breaks = seq(0,aMax,0.2)
  
  aPM25Max = max(aPM25_D$PM25, na.rm = TRUE)
  aPM25Max = ifelse(aPM25Max < 1,1,aPM25Max)
  jpeg(paste0(aFileDate , "frp-viet.jpg"), width = 1442 , height = 1442 , res = 200)
  #png(paste0("THFRP." , aMapDate , ".png"), width = 2018 , height = 1442 , res = 200)
  
  aPlot = ggplot()+
          geom_raster(data=aFRP_D,aes(x,y,fill=FRP))+
          scale_fill_gradient(low = "white",
                              high = "red", 
                              na.value = NA,
                              limits = c(0,aMax),
                              breaks = FRP_breaks, 
                              labels = FRP_breaks) + 
          scale_x_continuous(name=expression(paste("Longitude")),
                             limits=c(102,110),
                             expand=c(0,0)) +
          scale_y_continuous(name=expression(paste("Latitude")),
                             limits=c(5,25),
                             expand=c(0,0)) +
          geom_polygon(data=VietBound, 
                       aes(x=long, y=lat, group=group), 
                       fill=NA,
                       color="black", 
                       size=0.1)+
          ggtitle("Vietnam FRP in W/m2", 
                  subtitle = paste0("Date : ", aMapDate))+
          labs(fill = "FRP (W/m2)")+
          theme(panel.ontop=FALSE, 
                panel.background=element_blank(),
                panel.border = element_rect(colour = "black", fill=NA, size=0.1),
                legend.title = element_text(color = "black", size = 10)) + 
          coord_equal() 
  
  print(aPlot)
  dev.off()
}










