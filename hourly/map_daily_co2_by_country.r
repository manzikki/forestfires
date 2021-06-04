#By Dr. Praphatsorn Punsompong 2020.
#Small adjustments by Marko Niinimaki.
#This program gets a co2 NetCFD file (day or month) from the command line and creates co2 maps of the
#given country for each of the dates.
#Countries supported: THA LAO KHM MMR VNM

scalef <- function(x) sprintf("%.2f", x)

library(ncdf4) 
library(raster) 
library(rgdal) 
library(ggplot2) 
library(stringr)

#get the parameter
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 2) {
  stop("Parameters needed: 1: monthly co2file in the form 2020-XX.nc 2: country ISO3", call.=FALSE)
}
aNCfile = args[1]
aISO3 = args[2]
afileE = "co2-viet.jpg"
#get the date from the filename
aDataDate = str_replace(aNCfile, ".nc", "")

#Vietnam
longlimits = c(102,110)
latlimits = c(5,25)

if (aISO3 == "LAO") {
longlimits = c(100,108)
latlimits = c(13,24)
afileE = "co2-laos.jpg"
}
if (aISO3 == "KHM") {
longlimits = c(102,108)
latlimits = c(10,15)
afileE = "co2-camb.jpg"
}
if (aISO3 == "THA") {
longlimits = c(97,106)
latlimits = c(5,21)
afileE = "co2-thai.jpg"
}
if (aISO3 == "MMR") {
longlimits = c(92,102)
latlimits = c(9,30)
afileE = "co2-myan.jpg"
}
# Get country administrative boundary
CountryBound <- raster::getData(name = "GADM", country = aISO3, level = 0)

crs(CountryBound) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0" 
aTHext = extent(CountryBound)

#extraction
aCO2_data = brick(aNCfile, var="co2fire")

crs(aCO2_data) = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
aCO2_TH = mask(aCO2_data,CountryBound)
aCO2_THmg = aCO2_TH * 1000000000 #mg/m^2

#plot map
aNumDay = nlayers(aCO2_THmg) #number of day in Month

for (aDay in (1:aNumDay)) {
  aDate = ifelse(aDay < 10,paste0("0",aDay),aDay)
  aMapDate = paste0(aDataDate,".",aDate)
  aMapDate = str_replace(aMapDate,"-",".")
  #print(aMapDate)
  aFileDate = paste0(aDataDate,"-",aDate)


  if (aNumDay == 1) {
      aDataDate = str_replace(aNCfile, "co2.nc", "")
      aMapDate = str_replace(aDataDate,"-",".")
      aMapDate = str_replace(aMapDate,"-",".")
      aFileDate = str_replace(aNCfile, "co2.nc", "")
  }

  atR = subset(aCO2_THmg,aDay) #extract time:day in nc data
  aCO2_D = as.data.frame(atR, xy = TRUE) #change raster to dataframe
  names(aCO2_D)[3]="CO2"

  #summary(aCO2_D)

  aMax = max(aCO2_D$CO2, na.rm = TRUE)
  print(paste("Max CO2",aMax))
  CO2_breaks = seq(0,aMax,length.out=10)
  CO2_labels = scalef(CO2_breaks)

  fname = paste0(aFileDate , afileE)
  print(fname)

  if (!file.exists(fname)) {
      jpeg(fname, width = 1442 , height = 1442 , res = 200)
  
      aPlot = ggplot()+
          geom_raster(data=aCO2_D,aes(x,y,fill=CO2))+
          scale_fill_gradient(low = "white",
                              high = "red", 
                              na.value = NA,
                              limits = c(0,aMax),
                              breaks = CO2_breaks, 
                              labels = CO2_labels) + 
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
          ggtitle("CO2 in milligrams per square meter per s",
                  subtitle = paste0("Date : ", aMapDate))+
          labs(fill = "CO2")+
          theme(panel.ontop=FALSE, 
                panel.background=element_blank(),
                panel.border = element_rect(colour = "black", fill=NA, size=0.1),
                legend.title = element_text(color = "black", size = 10)) + 
          coord_equal() 
  
      print(aPlot)
      dev.off()
   }
}
