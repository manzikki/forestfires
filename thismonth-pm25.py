#This script downloads this month's forest fire variables' data up to day before yesterday.
#Output: month.nc like 2020-01.nc
#Marko Niinimaki 2020
#!/usr/bin/env python
from datetime import datetime
from calendar import monthrange
from ecmwfapi import ECMWFDataServer
import sys

month = datetime.now().month
year = datetime.now().year


mdate = datetime(year=year, month=month, day=1).date()
lastday = datetime.now().day - 2

if datetime.now().day < 3:
    sys.exit("Cannot call this when day is less than 3.")

monthstr = str(month)
if month < 10:
    monthstr = "0"+monthstr
if lastday < 10:
    lastday = "0"+str(lastday)

dstr = str(year)+"-"+monthstr+"-01/to/"+str(year)+"-"+monthstr+"-"+str(lastday)

print(dstr)


#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
server = ECMWFDataServer()
server.retrieve({
    "grid" : "0.5/0.5",
    "class": "mc",
    "dataset": "cams_nrealtime",
    "date": dstr,
    "expver": "0001",
    "levtype": "sfc",
    "param": "73.210",
    "step": "0",
    "stream": "oper",
    "time": "00:00:00",
    "type": "fc",
    "format": "netcdf",
    "target": monthstr+"-"+str(year)+"pm25.nc",
})
