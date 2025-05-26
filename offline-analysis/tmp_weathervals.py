import sys
import xarray as xr
import numpy as np

def compute_averages(nc_file):
    ds = xr.open_dataset(nc_file)

    # List of 2D variables to average (from your screenshot)
    vars_to_avg = ['d2m', 'sp', 't2m', 'u10', 'u100', 'v10', 'v100']

    time_dim = 'valid_time' if 'valid_time' in ds.dims or 'valid_time' in ds.coords else 'time'

    if time_dim not in ds:
        print("Time dimension not found in the dataset.")
        return

    times = ds[time_dim]

    for i in range(len(times)):
        print(f"\nTime: {str(times[i].values)}")
        for var in vars_to_avg:
            if var in ds:
                # Select single time slice and compute mean over lat/lon
                data = ds[var].isel({time_dim: i})
                mean_val = float(data.mean().values)
                print(f"{var}: {mean_val:.2f}")
            else:
                print(f"{var}: not found in dataset")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python avg_netcdf.py <path_to_netcdf_file>")
    else:
        compute_averages(sys.argv[1])

