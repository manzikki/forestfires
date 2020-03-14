#Print sum of FRP from a netcfd file limited by Thai borders.
#Marko Niinimaki niinimakim@webster.ac.th 2020
import rioxarray
import xarray
import sys
from rasterstats import zonal_stats

if len(sys.argv) != 2:
    print("Required paramtemer: filename of daily frp missing")
else:
    fname = sys.argv[1]
    xds = xarray.open_dataset(fname)
    xds['frpfire'].rio.to_raster("frpmonth.tif")
    stats = zonal_stats("THA_adm0.shp","frpmonth.tif", stats=['sum'])
    #remove the frp.nc to get a date string
    dstr  = fname[:-6]
    print(dstr," ",stats[0]['sum'])
