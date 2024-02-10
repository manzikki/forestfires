#This script downloads last month's forest fire variables' data.
#Output: month.nc like 2020-01.nc
#Optional parameters: month year <- will download this
#Marko Niinimaki 2020
#!/usr/bin/env python
from datetime import datetime
from calendar import monthrange
from ecmwfapi import ECMWFDataServer
import sys

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

monthstr = str(lastmonth)
if lastmonth < 10:
    monthstr = "0"+monthstr

dstr = str(year)+"-"+monthstr+"-01/to/"+str(lastday)

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
