# forestfires
Daily production of forest fire related data.

1. Getting the data 

The Python scripts day3.py and month3.py produce the NetCDF files needed for visualizations. Following steps needed:

Register at ECMWF

Get API key https://api.ecmwf.int/v1/key/
https://confluence.ecmwf.int/display/WEBAPI/Sample+client+scripts

pip3 install cdsapi

Now you can run:

python3 month3.py 10 2020
-> produces a data file containing variables for days in this month, format 2020-10.nc. 
Note: you cannot run this during the first days of the month.


2. Running visualizations

2.1 Bar charts
Rscript month-simple.r $year-$month.nc
Builds a bar chars of the a variable like FRP over days in the month file.

2.1 Maps
Rscript  Extract_ECWMF_vars_SEAdaily.R $year-$month.nc
Builds maps for each variable and day in the month file.

the directory ui contains the web interface.

3 Detailed instructions for each type of visualizations

.. can be found at https://github.com/manzikki/forestfires/wiki

