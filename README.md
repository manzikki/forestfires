# forestfires
Daily production of forest fire related data.

1. Getting the data 

The Python scripts day.py and month.py produce the NetCDF files needed for visualizations. Following steps needed:

Register at ECMWF

Get API key https://api.ecmwf.int/v1/key/
https://confluence.ecmwf.int/display/WEBAPI/Sample+client+scripts

pip install ecmwf-api-client

Now you can run:
python day.py
-> dayfile like 2020-03-01.pm
python month.py
-> monthfile like 2020-01.pm

2. Running visualizations

The R scripts will produce a visualizations:

Rscript day.r dayfile
Rscript month-simple.r monthfile

NB: for future purposes, running month.r still requires a history file gfas_0001_cfire_climatology_2003_2018.nc


