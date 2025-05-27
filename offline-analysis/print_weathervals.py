import sys
import os
import glob
import xarray as xr
import numpy as np
import pandas as pd

def compute_averages(nc_file):
    ds = xr.open_dataset(nc_file)

    # List of 2D variables to average
    vars_to_avg = ['d2m', 'sp', 't2m', 'u10', 'u100', 'v10', 'v100']
    time_dim = 'valid_time' if 'valid_time' in ds.dims or 'valid_time' in ds.coords else 'time'

    if time_dim not in ds:
        print(f"\nSkipping {nc_file}: Time dimension not found.")
        return

    #print(f"\nFile: {os.path.basename(nc_file)}")
    #print("time," + ",".join(vars_to_avg))

    times = ds[time_dim]
    times_pd = pd.to_datetime(times.values)

    for i, t in enumerate(times_pd):
        if t.hour == 12 and t.minute == 0 and t.second == 0:
            #row = [str(times[i].values)]
            row = [str(times[i].values).split("T")[0]]
            for var in vars_to_avg:
                if var in ds:
                    data = ds[var].isel({time_dim: i})
                    mean_val = float(data.mean().values)
                    row.append(f"{mean_val:.2f}")
                else:
                    row.append("NA")
            print(",".join(row))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python avg_netcdf.py <path_to_directory>")
        sys.exit(1)

    directory = sys.argv[1]

    if not os.path.isdir(directory):
        print(f"Error: {directory} is not a valid directory.")
        sys.exit(1)

    nc_files = sorted(glob.glob(os.path.join(directory, "*instant.nc")))

    if not nc_files:
        print(f"No '*instant.nc' files found in directory: {directory}")
        sys.exit(0)

    #header
    print("time,d2m,sp,t2m,u10,u100,v10,v100")
    for nc_file in nc_files:
        compute_averages(nc_file)
