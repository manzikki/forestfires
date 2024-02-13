# Print daily values of pm2.5 in the Chiang Mai province
# Based on ECMWF examples, tuning by Marko Niinimaki niinimakim@webster.ac.th 2021
# install.packages(c("raster", "mapview", "ncfd4"))

#copied from tools to avoid dependency
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


library("raster")
# library("mapview")
library("ncdf4")
#library("ncdf.tools")
library("stringr")

args = commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  stop("Parameters needed: monthfile.nc", call.=FALSE)
}

woffile = args[1]

country <- raster::getData(name = "GADM", country = "Thailand", level = 0)

#country <- bind(thai)

# Load the climatology
gfas_data_mean <- brick("gfas_0001_cfire_climatology_2003_2018.nc",
                        varname = "gfas_data_mean")


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

meanc = mean(current_sum)
meanc = round(meanc)
maxc  = max(current_sum)
maxc = round(maxc)
tmptext = paste("Average fire PM2.5 emissions per day:", meanc, "max:", maxc)
print(tmptext)
