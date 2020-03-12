#Cumulative FRP from a netcfd file
#Marko Niinimaki niinimakim@webster.ac.th 2020
import netCDF4
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from pylab import *

fh = netCDF4.Dataset("frpmonth.nc", mode='r')

frp = fh.variables['frpfire'][:]

frps = []

ntimes, ny, nx = shape(frp)
for i in range(ntimes):
    frps.append(sum(frp[i,:,:].data))


days = fh.variables['time'][:]
time_unit = fh.variables["time"].getncattr('units')

dates = []
for a in days.data:
    dates.append(netCDF4.num2date(a, units=time_unit))

fig = plt.figure()
plt.plot(dates, frps)
fig.autofmt_xdate()
plt.savefig('testplot.png')
