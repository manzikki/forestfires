import xarray as xr
import numpy as np

# Path to your NetCDF file
file_path = "2003-01-01.nc"  # Replace with the actual path if needed

# Open the NetCDF dataset
ds = xr.open_dataset(file_path)

# Define variables of interest (based on your screenshot)
variables = ["co2fire", "frpfire", "pm25fire", "tcfire"]

# Calculate and print means
for var in variables:
    if var in ds:
        mean_value = ds[var].mean(skipna=True).item()
        print(f"Average of {var} ({ds[var].attrs.get('long_name', 'No description')}): {mean_value}")
    else:
        print(f"Variable {var} not found in the dataset.")
