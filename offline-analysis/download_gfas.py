import cdsapi
import sys
from datetime import datetime

def download_gfas_data(date_str):
    # Validate date
    try:
        date = datetime.strptime(date_str, "%Y-%m-%d")
    except ValueError:
        print("Invalid date format. Use YYYY-MM-DD.")
        sys.exit(1)

    year = date.strftime("%Y")
    month = date.strftime("%m")
    day = date.strftime("%d")
    filename = f"gfas_{date_str}.nc"

    c = cdsapi.Client()

    c.retrieve(
        'cams-global-fire-emissions',
        {
            'date': date_str,
            'format': 'netcdf',
            'type': 'analysed',
            'variable': [
                'carbon_monoxide_emissions',
                'carbon_dioxide_emissions',
                'particulate_matter_2.5um_emissions',
                'total_fire_radiative_power'
            ],
            'area': [
                20.0, 97.0, 17.0, 100.0,  # N, W, S, E
            ],
            'time': '00:00'
        },
        filename
    )

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python download_gfas.py YYYY-MM-DD")
    else:
        download_gfas_data(sys.argv[1])

