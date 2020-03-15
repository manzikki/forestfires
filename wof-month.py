#This script downloads last month's "wildfire overall flux of burned carbon"
#Marko Niinimaki 2020
#!/usr/bin/env python
from datetime import datetime
from calendar import monthrange
from ecmwfapi import ECMWFDataServer

def last_day_of_month(date_value):
    return date_value.replace(day = monthrange(date_value.year, date_value.month)[1])

lastmonth = datetime.now().month - 1
year = datetime.now().year

if lastmonth == 0:
    lastmonth = 12
    year = year - 1

mdate = datetime(year=year, month=lastmonth, day=1).date()
lastday = last_day_of_month(mdate)

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
    "param": "92.210",
    "step": "0-24",
    "stream": "gfas",
    "time": "00:00:00",
    "type": "ga",
    "target": "output",
})
