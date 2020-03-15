# forestfires
Daily production of forest fire related data.

1. Getting the data 

The Python scripts produce the NetCDF files needed for visualizations. Following steps needed:

Register at ECMWF

Get API key https://api.ecmwf.int/v1/key/
https://confluence.ecmwf.int/display/WEBAPI/Sample+client+scripts

pip install ecmwf-api-client

Now you can run:
python frp-day.py
python pm25-day.py

2. Running visualizations

The R scripts will produce a visualizations:

Rscript work.r "frpfile" "pm 2.5 file"

