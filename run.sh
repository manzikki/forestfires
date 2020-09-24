#can be called by cron daily
cd "$(dirname "$0")"
rm -f 202?-??-??.nc

python day.py

Rscript day.r 202?-??-??.nc
Rscript day-thaionly.r 202?-??-??.nc

python thismonth.py

year=`date +"%Y"`
month=`date +"%m"`

if [ -f $year-$month.nc ]
then
    Rscript month-simple.r $year-$month.nc
fi
