#can be called by cron daily
cd "$(dirname "$0")"
rm -f 202?-??-??.nc

#get today's nc file. Will be needed by root's script
python day.py

#get this month's nc file
python thismonth.py

year=`date +"%Y"`
month=`date +"%m"`

if [ -f $year-$month.nc ]
then
    #we got it? run the script that builds the bar charts
    Rscript month-simple.r $year-$month.nc
    #and SEA maps
    Rscript  Extract_ECWMF_vars_SEAdaily.R $year-$month.nc
    #and Thai/Viet/Lao/Myan/Camb FRP maps
    Rscript Extract_ECWMF_FRP_thailanddaily.R $year-$month.nc
    Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $year-$month.nc VNM
    Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $year-$month.nc LAO
    Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $year-$month.nc KHM
    Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $year-$month.nc MMR
    #exprimental: Thai PM25 maps
    Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $year-$month.nc THA
else
    #the month has changed so the data is from the previous month
    echo foo > /dev/null
    python month.py
    #take the last changed month file
    lastfile=`ls -tr 202?-??.nc | tail -1`
    Rscript month-simple.r $lastfile
    Rscript  Extract_ECWMF_vars_SEAdaily.R $lastfile
    Rscript Extract_ECWMF_FRP_thailanddaily.R $lastfile
    Rscript Extract_ECWMF_FRP_Vietdaily.R $lastfile VNM
    Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $lastfile LAO
    Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $lastfile KHM
    Rscript Extract_ECWMF_FRP_SEA_countries_daily.R $lastfile MMR
    #exprimental: Thai PM25 maps
    Rscript Extract_ECWMF_PM25_SEA_countries_daily.R $lastfile THA
fi
chmod +x *.jpg
