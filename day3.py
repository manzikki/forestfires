#Download fire radiative power, pm2.5, carbon variables for 1 day.
#Either that day is given as parameter or it's today - 2.
#The optional parameter's format is 2020-01-30
#The output file is date.nc like 2020-01-30.nc
#Variable codes (like 99.210 for frp) can be found at https://apps.ecmwf.int/datasets/data/cams-gfas/. Log in and check the request.
#Marko Niinimaki, marko.n@chula.ac.th 2024
#!/usr/bin/env python
import datetime
import sys
import cdsapi

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

#print (dstr)

c = cdsapi.Client()
c.retrieve(
    'cams-global-fire-emissions-gfas',
    {
    "date": dstr,
    'variable': [ 'wildfire_flux_of_total_carbon_in_aerosols', 'wildfire_flux_of_carbon_dioxide', 'wildfire_flux_of_particulate_matter_d_2_5_µm', 'wildfire_radiative_power' ],
    "format": "netcdf"},
    str(dstr)+".nc"  
)
