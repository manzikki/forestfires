#This script builds a CSV file from txt files generated by monthly barchart builder
#Then it calls the R script that builds a graph SEA-pm25-12m.jpg from the CSV file
#The CVS file will contain:
#Month,AVG
#2020-12,40
#over the last 12 months
#How to call this script:
#If no parameters, will use 12 months back from the current month
#or 12-month-barchart-pm25.sh 2021 12
year=$1
month=$2
if [ "$#" -eq 0 ]
then
    year=`date +%Y`
    month=`date +%m`
fi
month=`echo $month | sed 's/^0//'`
lastyear=$(( $year -1 ))
#echo $lastyear
#iterate
m=$month
echo "Month,AVG" > twelve.csv
while [ $m -lt 13 ]
do
    pm=$lastyear-${m}.nc-SEA
    if [ $m -lt 10 ]
    then
        pm=$lastyear-0${m}.nc-SEA
    fi
    cat $pm*txt | grep PM | sed 's/\[1\] "//' | sed 's/ SEA Average fire PM2.5 emissions per day: /,/' | sed 's/ .*//' >> twelve.csv
    ((m++))
done
m=1
while [ $m -lt $month ]
do
    pm=$year-${m}.nc-SEA
    if [ $m -lt 10 ]
    then
        pm=$year-0${m}.nc-SEA
    fi
    cat $pm*txt | grep PM | sed 's/\[1\] "//' | sed 's/ SEA Average fire PM2.5 emissions per day: /,/' | sed 's/ .*//' >> twelve.csv
    ((m++))
done
#call the script
Rscript 12-month-barchart-pm25.r twelve.csv "Fire related PM2.5 last 12 months"
