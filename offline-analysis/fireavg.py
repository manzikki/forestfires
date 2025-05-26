import xarray as xr
import numpy as np
import sys
import pandas as pd

def main(nc_file):
    try:
        ds = xr.open_dataset(nc_file)
    except FileNotFoundError:
        print(f"File not found: {nc_file}")
        return

    # Variables of interest
    variables = ["co2fire", "frpfire", "pm2p5fire", "tcfire"]

    # Print averages of the variables
    for var in variables:
        if var in ds:
            mean_val = ds[var].mean(skipna=True).item()
            desc = ds[var].attrs.get('long_name', 'No description')
            print(f"Average of {var} ({desc}): {mean_val}")
        else:
            print(f"Variable {var} not found in the dataset.")

    # Print valid_time if available
    if "valid_time" in ds:
        try:
            time_val = ds["valid_time"].values
            # If it's an array with one or more elements, extract the first one
            if isinstance(time_val, (np.ndarray, list)) and time_val.size > 0:
                readable_time = pd.to_datetime(time_val[0]).strftime("%Y-%m-%d %H:%M:%S")
                print(f"Valid time: {readable_time}")
            else:
                print("valid_time is empty or not in a recognized format.")
        except Exception as e:
            print(f"Could not convert valid_time: {e}")
    else:
        print("valid_time variable not found in the dataset.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python process_nc.py <path_to_nc_file>")
    else:
        main(sys.argv[1])
