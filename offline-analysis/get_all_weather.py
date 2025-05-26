import subprocess
from datetime import datetime, timedelta
import os.path

start_date = datetime(2000, 1, 1)
end_date = datetime.today()

current_date = start_date

while current_date <= end_date:
    date_str = current_date.strftime("%Y-%m-%d")
    print(f"Downloading data for {date_str}")
    if not os.path.isfile(date_str+".nc"):
        try:
            subprocess.run(["python3", "download_era5.py", date_str], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error downloading {date_str}: {e}")
    current_date += timedelta(days=1)
