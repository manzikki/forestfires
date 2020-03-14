#Download fire radiative power for one day. Either that day is given as parameter or it's today - 2.
#The optional paramter's format is 2020-01-30
#The output file is datefrp.nc, for example 2020-01-30frp.nc
#Marko Niinimaki, niinimakim@webster.ac.th 2020
#!/usr/bin/env python
import datetime
import sys
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

if len(sys.argv) == 2:
    dstr = sys.argv[1]
else:
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
    "param": "99.210",
    "step": "0-24",
    "stream": "gfas",
    "time": "00:00:00",
    "type": "ga",
    "target": "output",
    "format": "netcdf",
    "type": "ga",
    "target": dstr+"frp.nc",
})
