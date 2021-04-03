#By Dr. Praphatsorn Punsompong 2020.
#Small adjustments by Marko Niinimaki.
#This program gets a NetCFD file from the command line and creates FRP maps of the given country for each of the
#dates.
#Countries supported: THA, LAO, KHM, MMR, VNM
library(ncdf4) 
library(raster) 
library(rgdal) 
library(ggplot2) 
library(stringr)

#get the parameter
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 2) {
  stop("Parameters needed: 1: monthly frpfile in the form 2020-XX.nc 2: country ISO3", call.=FALSE)
}
aNCfile = args[1]
aISO3 = args[2]
afileE = "frp-viet.jpg"
#get the date from the filename
aDataDate = str_replace(aNCfile, ".nc", "")

#Vietnam
longlimits = c(102,110)
latlimits = c(5,25)

if (aISO3 == "LAO") {
longlimits = c(100,108)
latlimits = c(13,24)
afileE = "frp-laos.jpg"
}
if (aISO3 == "KHM") {
longlimits = c(102,108)
latlimits = c(10,15)
afileE = "frp-camb.jpg"
}
if (aISO3 == "THA") {
longlimits = c(97,106)
latlimits = c(5,21)
afileE = "frp-thai.jpg"
}
if (aISO3 == "MMR") {
longlimits = c(92,102)
latlimits = c(9,30)
afileE = "frp-myan.jpg"
}
# Get country administrative boundary
CountryBound <- raster::getData(name = "GADM", country = aISO3, level = 0)

crs(CountryBound) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0" 
aTHext = extent(CountryBound)

#extraction
#PM25_data = brick(paste0(ws,aNCfile), var="pm2p5fire")
aFRP_data = brick(aNCfile, var="frpfire")
#aPM25_data = brick(aNCfile, var="pm2p5fire")

#crs(aPM25_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
crs(aFRP_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"


#aPM25_TH = mask(aPM25_data,CountryBound)
aFRP_TH = mask(aFRP_data,CountryBound)

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
  
#  atP = subset(aPM25_TH,aDay)
#  aPM25_D = as.data.frame(atP, xy = TRUE)

  names(aFRP_D)[3]="FRP"
#  names(aPM25_D)[3]="PM25"

  summary(aFRP_D)
  #summary(aPM25_D)

  aMax = max(aFRP_D$FRP, na.rm = TRUE)
  aMax = ifelse(aMax < 1,1,aMax)
  FRP_breaks = seq(0,aMax,0.2)
  
#  aPM25Max = max(aPM25_D$PM25, na.rm = TRUE)
#  aPM25Max = ifelse(aPM25Max < 1,1,aPM25Max)
  
  fname = paste0(aFileDate , afileE)
  if (!file.exists(fname)) {
      jpeg(fname, width = 1442 , height = 1442 , res = 200)
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
                             limits=longlimits,
                             expand=c(0,0)) +
          scale_y_continuous(name=expression(paste("Latitude")),
                             limits=latlimits,
                             expand=c(0,0)) +
          geom_polygon(data=CountryBound, 
                       aes(x=long, y=lat, group=group), 
                       fill=NA,
                       color="black", 
                       size=0.1)+
          ggtitle("FRP in W/m2",
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
}










