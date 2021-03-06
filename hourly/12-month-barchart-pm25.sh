#This script builds a CSV file from txt files generated by monthly barchart builder
#The CVS file will contain:
#Month,AVG
#2020-12,40
#over the last 12 months
year=$1
month=$2
lastyear=$(( $year -1 ))
#echo $lastyear
#iterate
m=$month
echo "Month,AVG" > twelve.csv
while [ $m -lt 13 ]
do
    pm=$lastyear-${m}-SEA
    if [ $m -lt 10 ]
    then
        pm=$lastyear-0${m}-SEA
    fi
    cat $pm*txt | sed 's/\[1\] "//' | sed 's/ Average fire PM2.5 emissions per day: /,/' | sed 's/ .*//' >> twelve.csv
    ((m++))
done
m=1
while [ $m -lt $month ]
do
    pm=$year-${m}-SEA
    if [ $m -lt 10 ]
    then
        pm=$year-0${m}-SEA
    fi
    cat $pm*txt | sed 's/\[1\] "//' | sed 's/ Average fire PM2.5 emissions per day: /,/' | sed 's/ .*//' >> twelve.csv
    ((m++))
done
