#!/usr/bin/env python
import datetime

from ecmwfapi import ECMWFDataServer

now = datetime.datetime.now()

today = datetime.date.today()
yday = today - datetime.timedelta(days=2)

year = yday.year
month = yday.month
day = yday.day

monthstr = str(month)
daystr = str(day)

if month < 10:
    monthstr = "0" + str(month)

if day < 10:
    daystr = "0" + str(day)

dstr = str(year)+"-"+monthstr+"-"+daystr

print dstr

#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
server = ECMWFDataServer()
server.retrieve({
    "class": "mc",
    "dataset": "cams_gfas",
    "date": dstr,
    "expver": "0001",
    "levtype": "sfc",
    "param": "87.210",
    "step": "0-24",
    "stream": "gfas",
    "time": "00:00:00",
    "format": "netcdf",
    "type": "ga",
    "target": dstr+"pm25.nc",
})
