#This script downloads last month's forest fire variables' data or the data from the designated month like this:
#python3 month3.py #By default get all of the previous month's data
#python3 month3.py 01 2023 #Specfic month
#python3 month3.py THIS #Tries to get the current month's data
#BEFORE YOU RUN, INSTALL:
#pip3 install cdsapi
#Output: year-month.nc like 2020-01.nc
#Variables: see https://ads.atmosphere.copernicus.eu/cdsapp#!/dataset/cams-global-fire-emissions-gfas?tab=form
#Marko Niinimaki 2023
#!/usr/bin/env python
from datetime import datetime
from calendar import monthrange
import cdsapi
import sys

#the day range parameter for the download is e.g 2020-01-01/2020-01-31

def last_day_of_month(date_value):
    return date_value.replace(day = monthrange(date_value.year, date_value.month)[1])

lastmonth = datetime.now().month - 1
year = datetime.now().year

if lastmonth == 0:
    lastmonth = 12
    year = year - 1


if len(sys.argv) == 3:
    lastmonth = int(sys.argv[1])
    year = int(sys.argv[2])

mdate = datetime(year=year, month=lastmonth, day=1).date()
lastday = last_day_of_month(mdate)

#if lastmonth is "THIS", try to get this month's data but modify the date string
#note: you cannot run this during the 2 first days of the month
if len(sys.argv) == 2 and sys.argv[1] == "THIS":
    year = datetime.now().year
    lastmonth = datetime.now().month
    lastday = datetime.now().day - 2
    padm = ""
    padd = ""
    if lastmonth < 10:
        padm = "0"
    if lastday < 10:
        padd = "0"
    if lastday < 1:
        quit()
    lastday = str(year)+'-'+padm+str(lastmonth)+'-'+padd+str(lastday)    

monthstr = str(lastmonth)
if lastmonth < 10:
    monthstr = "0"+monthstr

dstr = str(year)+"-"+monthstr+"-01/"+str(lastday)

print(dstr)

c = cdsapi.Client()

c.retrieve(
    'cams-global-fire-emissions-gfas',
    {
    "date": dstr,
    "format": "netcdf",
    'variable': [ 'wildfire_flux_of_total_carbon_in_aerosols', 'wildfire_flux_of_carbon_dioxide', 'wildfire_flux_of_particulate_matter_d_2_5_µm', 'wildfire_radiative_power' ]
    },
    str(year)+"-"+monthstr+".nc")
#dstr+".nc")

#from ecmwfapi import ECMWFDataServer
#server = ECMWFDataServer()
#server.retrieve({
#    "class": "mc",
#    "dataset": "cams_gfas",
#    "date": dstr,
#    "expver": "0001",
#    "levtype": "sfc",
#    "param": "80.210/81.210/87.210/88.210/92.210/99.210",
#    "param": "92.210",
#    "step": "0-24",
#    "format"    : "netcdf",
#    "stream": "gfas",
#    "time": "00:00:00",
#    "type": "ga",
#    "target": str(year)+"-"+monthstr+".nc",
#})
