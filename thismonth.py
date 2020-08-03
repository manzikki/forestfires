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
    "class": "mc",
    "dataset": "cams_gfas",
    "date": dstr,
    "expver": "0001",
    "levtype": "sfc",
    "param": "80.210/81.210/87.210/88.210/92.210/99.210",
#    "param": "92.210",
    "step": "0-24",
    "format"    : "netcdf",
    "stream": "gfas",
    "time": "00:00:00",
    "type": "ga",
    "target": str(year)+"-"+monthstr+".nc",
})
