#pip3 install rioxarray geopandas cftime
import rioxarray
import geopandas
import xarray
import matplotlib.pyplot as plt

fname = "fire_rad_feb8_2019.nc"

xds = rioxarray.open_rasterio(fname)
rds = xarray.open_dataset(fname, decode_coords="all")
xds.rio.write_crs("EPSG:4326",inplace=True)
geodf = geopandas.read_file("THA_adm0.shp")
clipped = xds.rio.clip(geodf.geometry.values, geodf.crs, drop=True)
clipped = clipped.where(clipped > -32767)
print(clipped)
print(clipped.mean(skipna=True))
print(clipped.min(skipna=True))
clipped.plot()
plt.savefig('plot.png')
