import xarray as xr
import numpy as np
import pandas as pd
import sys
import os
from glob import glob

def process_file(nc_file):
    try:
        ds = xr.open_dataset(nc_file)
    except Exception as e:
        print(f"Error opening {nc_file}: {e}")
        return None

    result = {}

    # Extract valid_time
    if "valid_time" in ds:
        try:
            time_val = ds["valid_time"].values
            if isinstance(time_val, (np.ndarray, list)) and time_val.size > 0:
                readable_time = pd.to_datetime(time_val[0]).strftime("%Y-%m-%d %H:%M:%S")
            else:
                readable_time = "NA"
        except Exception:
            readable_time = "NA"
    else:
        readable_time = "NA"

    result["time"] = readable_time

    # Extract average values
    variables = ["co2fire", "frpfire", "pm2p5fire", "tcfire"]
    for var in variables:
        if var in ds:
            try:
                result[var] = ds[var].mean(skipna=True).item()
            except Exception:
                result[var] = "NA"
        else:
            result[var] = "NA"

    return result

def main(directory):
    # Find all .nc files in the directory
    nc_files = sorted(glob(os.path.join(directory, "*.nc")))
    if not nc_files:
        print(f"No .nc files found in directory: {directory}")
        return

    header = ["time", "co2fire", "frpfire", "pm2p5fire", "tcfire"]
    print(",".join(header))

    for nc_file in nc_files:
        row = process_file(nc_file)
        if row:
            print(",".join(str(row[h]) for h in header))

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python process_nc_dir.py <directory_with_nc_files>")
    else:
        main(sys.argv[1])
