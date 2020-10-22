#can be called by cron daily
cd "$(dirname "$0")"
rm -f 202?-??-??.nc

#get this month's nc file
python thismonth.py

year=`date +"%Y"`
month=`date +"%m"`

if [ -f $year-$month.nc ]
then
    #we got it? run the script that builds the bar charts
    Rscript month-simple.r $year-$month.nc
    Rscript  Extract_ECWMF_vars_SEAdaily.R $year-$month.nc
else
    #the month has changed so the data is from the previous month
    echo foo > /dev/null
    python month.py
    #take the last changed month file
    lastfile=`ls -tr 2020-??.nc | tail -1`
    Rscript month-simple.r $lastfile
    Rscript  Extract_ECWMF_vars_SEAdaily.R $lastfile
fi
#trim images
for i in *.jpg
do
    /usr/bin/convert -trim $i o.jpg
    if [ -f o.jpg ]
    then
        mv o.jpg $i
    fi
done
