#can be called by cron daily
cd "$(dirname "$0")"
#remove old daily data files (not months)
rm -f 202?-??-??.nc

#get today's nc file. Will be needed by root's script
python3 day3.py

year=`date +"%Y"`
month=`date +"%m"`

#get this month's nc file
python3 month3.py THIS

if [ -f $year-$month.nc ]
then
    #we got it? run the script that builds the bar charts
    #Rscript month-simple.r $year-$month.nc
    #and SEA maps
    Rscript  Extract_ECWMF_vars_SEAdaily.R $year-$month.nc
    #and Thai/Viet/Lao/Myan/Camb FRP maps
    #Rscript Extract_ECWMF_FRP_thailanddaily.R $year-$month.nc
    #Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $year-$month.nc VNM
    #Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $year-$month.nc LAO
    #Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $year-$month.nc KHM
    #Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $year-$month.nc MMR
    #exprimental: PM25 maps
    #Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $year-$month.nc THA
    #Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $year-$month.nc VNM
    #Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $year-$month.nc LAO
    #Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $year-$month.nc KHM
    #Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $year-$month.nc MMR
    #run the script to generate bar charts of emissions for the days of the current month
    Rscript month-simple.r $year-$month.nc
else
    #the month has changed so the data is from the previous month
    echo foo > /dev/null
    python3 month3.py
    #take the last changed month file
    lastfile=`ls -tr 202?-??.nc | tail -1`
    Rscript month-simple.r $lastfile
    Rscript  Extract_ECWMF_vars_SEAdaily.R $lastfile
    #Rscript Extract_ECWMF_FRP_thailanddaily.R $lastfile
    #Rscript Extract_ECWMF_FRP_Vietdaily.R $lastfile VNM
    #Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $lastfile LAO
    #Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $lastfile KHM
    #Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $lastfile MMR
    #exprimental: PM25 maps
    #Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $lastfile THA
    #Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $lastfile VNM
    #Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $lastfile.nc LAO
    #Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $lastfile.nc KHM
    #Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $lastfile.nc MMR
fi
chmod +x *.jpg
#run the 12 last month and month AVG graph generation
bash makecvs_and_year_graphs.sh

