import cdsapi
import sys
from datetime import datetime

def download_era5_data(date_str):
    # Validate and parse the date
    try:
        date = datetime.strptime(date_str, "%Y-%m-%d")
    except ValueError:
        print("Invalid date format. Please use YYYY-MM-DD.")
        sys.exit(1)

    year = date.strftime("%Y")
    month = date.strftime("%m")
    day = date.strftime("%d")
    filename = f"{date_str}.nc"

    # Initialize the CDS API client
    c = cdsapi.Client()

    # Request data from ERA5
    c.retrieve(
        'reanalysis-era5-single-levels',
        {
            'product_type': 'reanalysis',
            'format': 'netcdf',
            'variable': [
                '2m_temperature', '2m_dewpoint_temperature', 'surface_pressure',
                'total_precipitation', '10m_u_component_of_wind',
                '10m_v_component_of_wind', '100m_u_component_of_wind',
                '100m_v_component_of_wind'
            ],
            'year': year,
            'month': month,
            'day': day,
            'time': [
                '00:00', '06:00', '12:00', '18:00'
            ],
            'area': [
                20.0, 97.0, 17.0, 100.0,  # North, West, South, East
            ],
        },
        filename)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python download_era5.py YYYY-MM-DD")
    else:
        download_era5_data(sys.argv[1])

