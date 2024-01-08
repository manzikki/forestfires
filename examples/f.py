import rioxarray
import geopandas
import xarray

xds = rioxarray.open_rasterio("simple.nc")
rds = xarray.open_dataset("simple.nc", decode_coords="all")
#print(rds.coords)
xds.rio.write_crs("EPSG:4326",inplace=True)
#co2fire = rds['co2fire']
geodf = geopandas.read_file("THA_adm0.shp")
clipped = xds.rio.clip(geodf.geometry.values, geodf.crs, drop=True)
print(clipped.mean())
#clipped.rio.to_raster("clipped.tif")
#print(clipped['co2fire'])
