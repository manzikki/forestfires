# Creates barchart visualizations of monthly data for upper SEA. Use month3.py to get the data.
# Usage: Rscript month-simple.r monthfile.nc
# Output: jpg files year-month-variable.jpg
# Example: Rscript month-simple.r 2021-05.nc
# produces: 2021-05-frp.jpg 2021-05-pm25.jpg 2021-05-co.jpg 2021-05-co2.jpg 2021-05-wof.jpg
# Based on ECMWF examples, only small tuning by Marko Niinimaki 2020-
# install.packages(c("raster", "mapview","ncdf4"))

library("raster")
# library("mapview")
library("ncdf4")
#library("ncdf.tools")
library("stringr")

args = commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  stop("Parameters needed: monthfile.nc", call.=FALSE)
}

#copied forom source because of install problems
convertDateNcdf2R  =  function(
##title<< Convert netCDF time vector to POSIXct R date object
        time.source ##<< numeric vector or netCDF connection: either a number of time units since
                    ##   origin or a netCDF file connection, In the latter case, the time 
                    ##   vector is extracted from the netCDF file, This file, and especially the 
                    ##   time variable, has to follow the CF netCDF conventions.
        , units = 'days' ##<< character string: units of the time source. If the source
                    ##   is a netCDF file, this value is ignored and is read from that file.
        , origin = as.POSIXct('1800-01-01', tz = 'UTC') ##<< POSIXct object:
                    ##   Origin or day/hour zero of the time source. If the source
                    ##   is a netCDF file, this value is ignored and is read from that file.
  , time.format =  c('%Y-%m-%d', '%Y-%m-%d %H:%M:%S', '%Y-%m-%d %H:%M', '%Y-%m-%d %Z %H:%M', '%Y-%m-%d %Z %H:%M:%S')
)
  ##description<< This function converts a time vector from a netCDF file or a vector of Julian days (or seconds, minutes, hours)
  ##              since a specified origin into a POSIXct R vector.
{
  close.file =  FALSE
  if (class(time.source) ==  'character') {
    if (file.exists(time.source)) {
      time.source = open.nc(time.source)
    } else {
      stop(paste('File ', time.source, ' is not existent!', sep = ''))
    }
  }
  if (class(time.source) == 'NetCDF') {
    attget.result <- try({
      units.file      <- infoNcdfAtts(time.source, 'time')[, 'value'][infoNcdfAtts(time.source, 'time')[, 'name'] == 'units']
      origin.char     <- sub('^.*since ', '', units.file)
      units <-  sub(' since.*', '', units.file)
    }, silent = TRUE)
    for (formatT in time.format) {
      origin <- strptime(origin.char, format = formatT,  tz =  'UTC')
      if (!is.na(origin))
        break
    }
    if (is.na(origin))
      stop('Not possible to determine origin. Wrong format supplied?')

    date.vec     <- as.numeric(var.get.nc(time.source, 'time')) 
  } else {
    if (!is.numeric(time.source))
      stop('time.source needs to be numeric if not a netCDF file connection!')
    date.vec  <- time.source
  }

  
  if (!is.element(units, c('seconds', 'minutes', 'hours', 'days')))
    stop(paste('Unit ', units, ' is not implemented.', sep  =  ''))
  multiplicator      <- switch(units, days = 60 * 60 * 24, hours = 60 * 60, minutes = 60, seconds = 1)
  time.out <- origin + date.vec * multiplicator
  if (origin <  as.POSIXct('1582-10-30', tz = 'UTC')) 
    time.out <- time.out + 10 * 24 * 60 * 60
  if (close.file)
    close.nc(time.source)
  ##value<<
  ## POSIXct vector: time vector in native R format
  return(time.out)
}

woffile = args[1]


thai <- raster::getData(name = "GADM", country = "Thailand", level = 0)
laos <- raster::getData(name = "GADM", country = "Laos", level = 0)
viet <- raster::getData(name = "GADM", country = "Vietnam", level = 0)
myan <- raster::getData(name = "GADM", country = "Myanmar", level = 0)
camb <- raster::getData(name = "GADM", country = "Cambodia", level = 0)


country <- bind(thai, laos, viet, myan, camb)

# Load the climatology
gfas_data_mean <- brick("gfas_0001_cfire_climatology_2003_2018.nc",
                        varname = "gfas_data_mean")

# Load current emissions: Wildfire Overall flux
current_emissions <- brick(woffile, varname="tcfire")
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- labels_current

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-3

#open the file to read the time dimension for the first day
ncin <- nc_open(woffile)
time <- ncvar_get(ncin,'time')
times <- convertDateNcdf2R(time, units = "hours", origin = as.POSIXct("1900-01-01",  tz = "UTC"))
times_no <- str_replace(times[1], "UTC", "")
#print(times_no) 2020-08-01
times_no <- str_replace(times_no, "-01", "")
#print(times_no) 2020-08
ylabt <- expression(paste("Tonnes per day per m"^"2"))
fname = paste(times_no, "-wof.jpg", sep="")
jpeg(fname)

meanc = mean(current_sum)
meanc = round(meanc)
maxc  = max(current_sum)
maxc = round(maxc)
tmptext = paste("Average burnt carbon emissions per day:", meanc, "max:", maxc)
print(tmptext)

barplot(current_sum, names.arg=idx, main=paste("Wildfire Overall Flux of Burnt Carbon", times_no), ylab=ylabt, 
        sub=tmptext)


# Load current emissions: CO2
current_emissions <- brick(woffile, varname="co2fire")
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- labels_current

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-3

fname = paste(times_no, "-co2.jpg", sep="")
jpeg(fname)
meanc = mean(current_sum)
meanc = round(meanc)
maxc  = max(current_sum)
maxc = round(maxc)
tmptext = paste("Average fire CO2 emissions per day:", meanc, "max:", maxc)
print(tmptext)
options(scipen=5)
barplot(current_sum, names.arg=idx, main=paste("Wildfire flux of Carbon Dioxide", times_no),  ylim=c(0, 3000000), ylab=ylabt,
        sub=tmptext)

# Load current emissions: CO
#current_emissions <- brick(woffile, varname="cofire")
#labels_current <- substr(names(current_emissions), 7, 11)
#aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
#current_area <- raster::area(current_emissions) * 1000000 # in m2
#current <- raster::mask(current_emissions * current_area, aoi)
#current <- mask(current, country)

# Find indices in common
#idx <- labels_current

# Compute sum over the area
#current_sum <- cellStats(current, sum) * 86400 * 1E-3

#fname = paste(times_no, "-co.jpg", sep="")
#jpeg(fname)
#meanc = mean(current_sum)
#meanc = round(meanc)
#maxc  = max(current_sum)
#maxc = round(maxc)
#tmptext = paste("Average fire carbon emissions per day:", meanc, "max:", maxc)
#barplot(current_sum, names.arg=idx, main=paste("Wildfire flux of Carbon Monoxide", times_no),  ylab=ylabt,
#        sub=tmptext)

# Load current emissions: PM2.5
current_emissions <- brick(woffile, varname="pm2p5fire")
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- labels_current

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-3

fname = paste(times_no, "-pm25.jpg", sep="")
jpeg(fname)
meanc = mean(current_sum)
meanc = round(meanc)
maxc  = max(current_sum)
maxc = round(maxc)

tmptext = paste("Average fire PM2.5 emissions per day:", meanc, "max:", maxc)
print(paste(times_no, tmptext))
barplot(current_sum, names.arg=idx, ylim=c(0, 2000), main=paste("Wildfire flux of Particulate Matter PM2.5", times_no), ylab=ylabt,
        sub=tmptext)

# Load current emissions: FRF
current_emissions <- brick(woffile, varname="frpfire")
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- labels_current

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-3

fname = paste(times_no, "-frp.jpg", sep="")
jpeg(fname)
#scaling: use MW instead of W
summillionth <- current_sum %/% 1000000
meanc = mean(current_sum)
meanc = round(meanc)
maxc  = max(current_sum)
maxc = round(maxc)
tmptext = paste("Average FRP per day:", meanc, "max:", maxc)
dtext = paste(times_no, "Average FRP per day:", round(mean(summillionth)), "max:", max(summillionth))
print(paste(times_no, tmptext))
#print(debugtext)
options(scipen=5)
barplot(summillionth, names.arg=idx, main=paste("Fire Radiative Power", times_no), ylab="FRP in MW/m2",
        sub=dtext, ylim=c(0, 1000000))


# Load current emissions: co2
current_emissions <- brick(woffile, varname="co2fire")
labels_current <- substr(names(current_emissions), 7, 11)
aoi <- as(extent(gfas_data_mean), "SpatialPolygons")
current_area <- raster::area(current_emissions) * 1000000 # in m2
current <- raster::mask(current_emissions * current_area, aoi)
current <- mask(current, country)

# Find indices in common
idx <- labels_current

# Compute sum over the area
current_sum <- cellStats(current, sum) * 86400 * 1E-3
ylabt <-  expression(paste("kg m"^"-2","s"^"-1"))
fname = paste(times_no, "-co2.jpg", sep="")
meanc = mean(current_sum)
meanc = round(meanc)
maxc  = max(current_sum)
maxc = round(maxc)
tmptext = paste("Average emissions per day:", meanc, "max:", maxc)
print(tmptext)
jpeg(fname)
barplot(current_sum, names.arg=idx, main=paste("CO2", times_no), ylab=ylabt, sub=tmptext)



# Create a map of emissions for the first day of the month
#Emissions <- current[[1]]
#mapview(Emissions, alpha.regions = 0.3)
